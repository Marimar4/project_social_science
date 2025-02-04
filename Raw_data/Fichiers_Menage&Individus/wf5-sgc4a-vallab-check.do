capture log close
log using wf5-sgc4a-vallab-check, replace text

//  program:    wf5-sgc4a-vallab-check.do \ for stata 9
//  task:       check the value labels currently being used
//  project:    workflow chapter 5 - sgc renaming and relabeling example
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-sgc03, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #2
//  inventory of existing value labels

labelbook `valdeflist', length(10)

//  #3 - not in book
//  get list of value labels

* get list of non-S variables
drop S*
unab varlist : _all

* define local to hold list of label definitions
local valdeflist ""

* loop through variables and add value label names to valdeflist
foreach varname in `varlist' {
    local vallabel : value label `varname'
    local valdeflist "`valdeflist' `vallabel'"
}

* list of value labels with duplicates
display "`valdeflist'"

* remove duplicates
local valdeflist : list uniq valdeflist
display "`valdeflist'"

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
