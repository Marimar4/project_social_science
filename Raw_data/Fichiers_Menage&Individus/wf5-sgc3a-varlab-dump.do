capture log close
log using wf5-sgc3a-varlab-dump, replace text

//  program:    wf5-sgc3a-varlab-dump.do \ for stata 9
//  task:       step 3a: create dummy commands for variable labels
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

use wf-sgc02, clear
* in stata 10 and later: datasignature confirm

//  #2
//  drop S variables since they will not be relabeled

drop S*

//  #3
//  create list of all variables and dump var label commands

* get a sorted list of names
aorder
unab varlist : _all

file open myfile using wf5-sgc3a-varlab-dummy.doi, write replace

foreach varname in `varlist' {
    local varlabel : variable label `varname'
    file write myfile "label var  `varname' " ///
        _col(24) `""`varlabel'""' _newline
}

file close myfile

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
