capture log close
log using wf5-master03-tabulate, replace text

//  program:    wf5-master03-tabulate.do \ for stata 9
//  task:       Tabulate data from wf-lfp
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-lfp, replace
* in stata 10 and later: datasignature confirm

//  #2
//  examine wc by children

tab wc k5, miss
tab wc k618, miss

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
