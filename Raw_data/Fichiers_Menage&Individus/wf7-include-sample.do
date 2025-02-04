capture log close
log using wf7-include-sample, replace text

//  program:    wf7-include-sample.do \ for stata 9
//  include:    requires wf7-include-sample.doi
//  task:       using include to select a sample
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data and select sample

use wf-tenure, clear
* in stata 10 and later: datasignature confirm
drop if year>=11 // drop cases with long time in rank
drop if prestige<1 // drop if unrated department

//  #2
//  compute descriptives

summarize

//  #3
//  load data and select sample with include file

include wf7-include-sample.doi

//  #4
//  compute descriptives

summarize

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
