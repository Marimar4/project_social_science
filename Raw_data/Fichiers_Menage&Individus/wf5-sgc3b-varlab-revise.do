capture log close
log using wf5-sgc3b-varlab-revise, replace text

//  program:    wf5-sgc3b-varlab-revise.do \ for stata 9
//  include:    requires wf5-sgc3a-varlab-revised.doi
//  task:       create new variable labels
//  project:    workflow chapter 5 - sgc renaming and relabeling example
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  define locals

local date "2008-10-24"
local tag "wf5-sgc3b.do jsl `date'."

//  #2
//  load data

use wf-sgc02, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #3
//  create a new language for revised labels

label language original, new copy // copy of default language
label language default
note: language original uses the original, unrevised labels; language ///
    default uses revised labels \ `tag'

//  #4
//  include the edited file with variable labels

include wf5-sgc3a-varlab-revised.doi

//  #5
//  closeup and save data

quietly compress
note: wf-sgc03.dta \ revised var labels for source & default languages \ `tag'
label data "Workflow data for SGC renaming example \ `date'"
* in stata 10 and later: datasignature set, reset
save wf-sgc03, replace

//  #6
//  verify data and check names

use wf-sgc03, clear
* in stata 10 and later: datasignature confirm
notes _dta
drop S*

* default language
nmlab tcfam tcfriend vignum

* original language
label language original
nmlab tcfam tcfriend vignum

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
