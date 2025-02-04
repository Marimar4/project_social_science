capture log close
log using wf5-sgc2c-rename, replace text

//  program:    wf5-sgc2c-rename.do \ for stata 9
//  include:    wf5-sgc2b-rename-revised.doi
//  task:       rename variables using commands generated in step3a.
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
local tag "wf5-sgc2c.do jsl `date'."

//  #2
//  load the data

use wf-sgc01, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #3
//  include the edited rename commands

include wf5-sgc2b-rename-revised.doi

//  #4
//  closeup and save data

quietly compress
note: wf-sgc02.dta \ rename source variables \ `tag'
label data "Workflow data for SGC renaming example \ `date'"
* in stata 10 and later: datasignature set, reset
save wf-sgc02, replace

* check data
use wf-sgc02, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #5
//  check new names

set linesize 120
nmlab

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
