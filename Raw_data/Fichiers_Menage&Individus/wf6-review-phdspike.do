capture log close
log using wf6-review-phdspike, replace text

//  program:    wf6-review-phdspike.do \ for stata 9
//  task:       Substantive review of PhD prestige
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-acjob, clear
* in stata 10 and later: datasignature confirm

//  #2
//  check descriptives

summarize phd
codebook, compact

//  #3
//  check specific values

stem phd
dotplot phd
graph export wf6-review-phdspike.eps, replace

//  #4
//  check phd prestige to explain spike

tab1 phd if phd>4 & phd<4.5

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
