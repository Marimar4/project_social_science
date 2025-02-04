log using wf6-review-gss, replace text

//  program:    wf6-review-gss.do \ for stata 9
//  task:       Review of GSS data for v4
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load dataset

use wf-gsswarm, clear
* in stata 10 and later: datasignature confirm

//  #2
//  check distribution of v4

* with value labels
tabulate v4, miss

* without value labels
tabulate v4, nolab

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
