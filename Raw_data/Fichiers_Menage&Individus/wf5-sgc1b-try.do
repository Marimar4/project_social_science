capture log close
log using wf5-sgc1b-try, replace text

//  program:    wf5-sgc1b-try.do \ for stata 9
//  task:       try current names and labels
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

use wf-sgc-source, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #2
//  use codebook to examine names and variable labels

codebook, compact

//  #3
//  use tabulate to examine variable and value labels

* drop variables that aren't appropriate for tabulate
drop id_iu cntry_iu age

* get a list of the remaining variables
unab varlist : _all

* loop through the variables
foreach varname in `varlist' {
    display "`varname':"
    tabulate gender `varname', miss
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
