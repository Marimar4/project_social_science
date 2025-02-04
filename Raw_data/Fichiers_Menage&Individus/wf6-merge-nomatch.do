capture log close
log using wf6-merge-nomatch, replace text

//  program:    wf6-merge-nomatch.do \ for stata 9
//  task:       Example of botched match merging
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  check datasets

use wf-mergebio, clear
* in stata 10 and later: datasignature confirm
use wf-mergebib, clear
* in stata 10 and later: datasignature confirm

//  #2
//  incorrect merging

use wf-mergebio, clear
merge using wf-mergebib
tab1 _merge
drop _merge

* check new data
codebook, compact
pwcorr job fem phd ment art cit

//  #3
//  correct merging

use  wf-mergebio, clear
merge id using wf-mergebib, sort
tab1 _merge
drop _merge
pwcorr job fem phd ment art cit

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
