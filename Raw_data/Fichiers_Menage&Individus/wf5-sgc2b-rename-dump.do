capture log close
log using wf5-sgc2b-rename-dump, replace text

//  program:    wf5-sgc2b-rename-dump.do \ for stata 9
//  task:       create dummy rename commands
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

use wf-sgc01, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #2
//  drop the source variables that will not be renamed & sort names

* drop S(ource) variables since they will not be renamed
drop S*

* create an alphabetized list of the non-S varaibles
aorder

//  #3
//  loop through the names and create baseline rename commands

unab varlist : _all
file open myfile using wf5-sgc2b-rename-dummy.doi, write replace

foreach varname in `varlist' {
    file write myfile "*rename  `varname'" _col(22) "`varname'" _newline
}
file close myfile

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
