capture log close
log using wf6-merge-onetoone, replace text

//  program:    wf6-merge-onetoone.do \ for stata 9
//  task:       Example of one to one matching for
//              unrelated datasets
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
local tag "wf6-merge-onetoone.do jsl `date'."

//  #2
//  check the datasets

use wf-lfp, clear
* in stata 10 and later: datasignature confirm
summarize

use wf-acpub, clear
* in stata 10 and later: datasignature confirm
summarize

//  #3
//  load the master dataset and merge with the using dataset

use wf-lfp, clear
merge using wf-acpub
tabulate _merge
drop _merge

//  #4
//  clean up and save

quietly compress
label data "Workflow example of combining unrelated datasets \ `date'"
note: wf-merge01.dta \ workflow examples from chapter 6 \ `tag'

* in stata 10 and later: datasignature set, reset
save wf-merge01, replace

use wf-merge01, clear
* in stata 10 and later: datasignature confirm
notes
codebook, compact
* in stata 10 and later: datasignature confirm

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
