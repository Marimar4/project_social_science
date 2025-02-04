capture log close
log using wf6-merge-match, replace text

//  program:    wf6-merge-match.do \ for stata 9
//  task:       Example of match merging
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  define local

local date "2008-10-24"
local tag "wf6-merge-match.do jsl `date'."

//  #2
//  check signatures ande load the master dataset

use wf-nls-flim05, clear
* in stata 10 and later: datasignature confirm

use wf-nls-cntrl07, clear
* in stata 10 and later: datasignature confirm

//  #3
//  merge in the flim dataset and check variables

merge id using wf-nls-flim05
tab1 _merge
drop _merge
codebook, compact

//  #4
//  check variables and save merged file

quietly compress
label data "Workflow merged NLS flim & control variables \ `date'"
note: wf-nls-combined01.dta \ workflow data for chapter 6 \ `tag'
* in stata 10 and later: datasignature set, reset
save wf-nls-combined01, replace

use wf-nls-combined01, clear
* in stata 10 and later: datasignature confirm
notes
codebook, compact
* in stata 10 and later: datasignature confirm

//  #5
//  sorting before merging

use wf-nls-cntrl07, clear
* in stata 10 and later: datasignature confirm
merge id using wf-nls-flim05, sort

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
