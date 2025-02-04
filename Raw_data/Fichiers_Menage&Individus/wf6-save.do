capture log close
log using wf6-save, replace text

//  program:    wf6-save.do \ for stata 9
//  task:       Saving datasets
//  project:    Workflow - Chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  dropping variables without variations

use wf-isspru01, clear
* in stata 10 and later: datasignature confirm
codebook, problems
* place variables without variation in local and drop them
local dropvars = r(cons)
drop `dropvars'
describe
codebook, compact

//  #2
//  keeping variables needed in analysis

use wf-isspru01, clear
* in stata 10 and later: datasignature confirm
keep v2 v4 v5 v6 v7 v8 v9 v200 v201 v202 v204 v232 v239 v249
describe
codebook, compact

//  #3
//  adding metadata to a dataset

label data "Workflow ISSP 2002 Russian data \ 2008-10-24"
note: wf-isspru02.dta \ workflow ch 6 - can delete file \ wf6-save.do jsl 2008-10-24.
* reset signature since one is already stored with the data
* in stata 10 and later: datasignature set, reset
save wf-isspru02, replace

* check the metadata
use wf-isspru02, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #4
//  check problems with codebook

* load the data
use wf-diagnostics, clear
* in stata 10 and later: datasignature confirm

* check for problems
codebook, problems

* check variable without variation
tab1 v3, miss
tab1 v256, miss

* check missing labels
describe v7
tab1 v7, miss

* check incomplete labels
tab1 v37, miss
tab1 v37, miss nol

//  #5
//  check for duplicates

* isid is commented out since it generates an error that stops the program
*   use wf-diagnostics, clear
*   isid id

* check duplicates with duplicates command
duplicates report id
duplicates examples id, clean

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
