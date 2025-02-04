capture log close
log using wf7-replicate-stepwise, replace text

//  pgm:        wf7-replicate-stepwise.do \ for stata 9
//  task:       effect of seed on results when using a training and
//              confirmation sample
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  note:       uniform() was replaced by uniform() in Stata 10.1

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-articles, clear
* in stata 10 and later: datasignature confirm

//  #2
//  random selection 1: randomly select half of the cases

set seed X57c74068e0f7a3200d5b8463f279bb82065a
generate train1 = (uniform() < .5) // renamed to runiform() in stata 10.1
label var train1 "Training sample?"
label def trainlbl 0 "0Confirm" 1 "1Train"
label val train1 trainlbl

* full model with EXPLORATION sample
quietly nbreg art fem mar kid5 phd ment if train1==1
estimates store train1full

* trim model with stepwise procedures with EXPLORATION sample
quietly stepwise, pr(.05): nbreg art fem mar kid5 phd ment if train1==1
estimates store train1trim

* estimate trimmed model with CONFIRMATION sample
quietly nbreg art fem kid5 ment if train1==0
estimates store confirm1trim

* estimate full model with CONFIRMATION sample
quietly nbreg art fem mar kid5 phd ment if train1==0
estimates store confirm1full

* Compare results from EXPLORATION AND CONFIRMATION SAMPLES
* They match quite well.
estimates table train1trim confirm1trim, ///
    stats(N chi2) b(%9.3f) star
estimates table train1full confirm1full train1trim confirm1trim, ///
    stats(N chi2) b(%9.3f) star

//  #3
//  random selection 2: randomly select half of the cases

set seed 11051951
generate train2 = (uniform() < .5) // renamed to runiform() in stata 10.1
    label var train2 "Training sample?"
    label val train2 trainlbl

* full model with EXPLORATION sample with EXPLORATION sample
quietly nbreg art fem mar kid5 phd ment if train2==1
estimates store train2full

* trim model with stepwise procedures with EXPLORATION sample
quietly stepwise, pr(.05): nbreg art fem mar kid5 phd ment ///
    if train2==1
estimates store train2trim

* estimate trimmed model with CONFIRMATION sample
quietly nbreg art fem mar kid5 ment if train2==0
estimates store confirm2trim

* estimate full model with CONFIRMATION sample
quietly nbreg art fem mar kid5 phd ment if train2==0
estimates store confirm2full

* Compare results from EXPLORATION AND CONFIRMATION SAMPLES
* They match poorly.
estimates table train2trim confirm2trim, ///
    stats(N chi2) b(%9.3f) star
estimates table train2full confirm2full train2trim confirm2trim, ///
    stats(N chi2) b(%9.3f) star

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
