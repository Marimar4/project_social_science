capture log close
log using wf5-sgc2a-clone, replace text

//  program:    wf5-sgc2a-clone.do \ for stata 9
//  task:       make clones of existing variables
//  project:    workflow chapter 5 - sgc renaming and relabeling example
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  create locals

local date "2008-10-24"
local tag "wf5-sgc2a.do jsl `date'"

//  #2
//  load data

use wf-sgc-source, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #3
//  loop through variables and create clones

unab varlist : _all
foreach varname in `varlist' {
    clonevar S`varname' = `varname'
    note S`varname': Source variable for `varname' \ `tag'
    note  `varname': Clone of source variable S`varname' \ `tag'
}

//  #4
//  check the variables

codebook, compact

//  #5
//  closeup and save data

quietly compress
note: wf-sgc01.dta \ create clones of source variables \ `tag'
label data "Workflow data for SGC renaming example \ `date'"
* in stata 10 and later: datasignature set, reset
save wf-sgc01, replace

* check the dataset
use wf-sgc01, clear
* in stata 10 and later: datasignature confirm
note _dta

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
