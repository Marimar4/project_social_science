capture log close
log using wf5-sgc5a-check, replace text

//  program:    wf5-sgc5a-check.do \ for stata 9
//  task:       step 5a: check new names and labels
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

use wf-sgc04, clear
* in stata 10 and later: datasignature confirm

//  #2
//  examine value labels using tabulate

drop id_iu cntry_iu age S*
unab varlist : _all

label language default

foreach varname in `varlist' {
    display "`varname':"
    tab gender `varname', missing
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
