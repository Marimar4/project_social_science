capture log close
log using wf6-review-timetophd, replace text

//  program:    wf6-review-timetophd.do \ for stata 9
//  task:       simulating the effects of mis-labeled enrolled time
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  note:       data was simulated to illustrate propoerties of real data

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-acpub, replace
* in stata 10 and later: datasignature confirm

//  #2
//  estimate model with supposedly correct data

nbreg pub enrol phd female, nolog irr

//  #3
//  check enrol

tabulate enrol
pwcorr pub enrol

//  #4
//  estimate model with corrected variable for enrolled time

nbreg pub enrol_fixed phd female, nolog irr

//  #4
//  compare distributions

sum enrol_*
label var enrol_fixed "enroll_fixed: enrolled time"
label var enrol "enrol: elapsed time"
dotplot enrol_fixed enrol, ///
    ytitle("Years",size(medium)) xlabel(,labsize(medium))
graph export wf6-review-timetophd.eps, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
