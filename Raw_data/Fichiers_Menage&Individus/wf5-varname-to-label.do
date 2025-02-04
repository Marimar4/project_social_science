capture log close
log using wf5-varname-to-label, replace text

//  program:    wf5-varname-to-label.do \ for stata 9
//  task:       add the variable name to the variable label
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-lfp, clear

//  #2
//  check names and labels

nmlab
tabulate wc hc, missing

//  #3
//  loop through variables and add names to labels

unab varlist : _all
display "varlist is: `varlist'"

foreach varname in `varlist' {
    local varlabel : variable label `varname'
    label var `varname' "`varname': `varlabel'"
}

//  #4
//  check the results

nmlab
tabulate wc hc, missing

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
