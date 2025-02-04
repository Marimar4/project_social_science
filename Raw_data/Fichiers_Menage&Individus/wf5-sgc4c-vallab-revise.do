capture log close
log using  wf5-sgc4c-vallab-revise, replace text

//  program:    wf5-sgc4c-vallab-revise.do \ for stata 9
//  include:    requires wf5-sgc4b-vallab-labdef-revised.doi
//              & wf5-sgc4b-vallab-labval-revised.doi
//  task:       step 4c: create new value labels
//  project:    workflow chapter 5 - sgc renaming and relabeling example
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
local tag "wf5-sgc4c.do jsl `date'."

//  #2
//  load data

use wf-sgc03, clear
* in stata 10 and later: datasignature confirm

//  #3
//  create new value label definitions and assign labels

include wf5-sgc4b-vallab-labdef-revised.doi
include wf5-sgc4b-vallab-labval-revised.doi

//  #4
//  save what I have and get the label definitions in noncloned variables

save x-temp, replace
drop S*
quietly labelbook
local valdeflist = r(names)
use x-temp, clear

//  #5
//  add label definitions for missing values

foreach valdef in `valdeflist' {
    label define `valdef' .a  `".a_NAP"'      , modify
    label define `valdef' .b  `".b_Refuse"'   , modify
    label define `valdef' .c  `".c_DK"'       , modify
    label define `valdef' .d  `".d_NA_ref"'   , modify
    label define `valdef' .e  `".e_DK_var"'   , modify
}

//  #5
//  closeup and save data

note: wf-sgc04.dta \ revise val labels with source & default languages \ `tag'
label data "Workflow data for SGC renaming example \ `date'"
* in stata 10 and later: datasignature set, reset
save wf-sgc04, replace

//  #6
//  verify data and check names

use wf-sgc04, clear
* in stata 10 and later: datasignature confirm
notes _dta

label language default
tabulate marital, missing
label language original
tabulate marital, missing

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
