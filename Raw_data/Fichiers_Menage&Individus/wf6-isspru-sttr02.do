capture log close
log using wf6-isspru-sttr02, replace text

//  program:    wf6-isspru-sttr02.do \ for stata 9
//  task:       Checking ISSP Russian data converted with Stat/Transfer
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

use wf6-isspru-sttr02, clear

//  #2
//  check all variables

codebook, compact

//  #3
//  check frequencies with missing data

tab1 _all, miss

//  #4
//  examine frequencies with missing data w/o value labels

tab1 _all, miss nolabel

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
