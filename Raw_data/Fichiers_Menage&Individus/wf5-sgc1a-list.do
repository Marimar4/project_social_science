capture log close
log using wf5-sgc1a-list, replace text

//  program:    wf5-sgc1a-list.do \ for stata 9
//  task:       step 1a: list current names and labels
//  project:    workflow chapter 5 - sgc renaming and relabeling example
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data and describe with default linesize

use wf-sgc-source, clear
* in stata 10 and later: datasignature confirm
notes _dta

//  #2
//  create macro with the names of all varaibles in dataset

unab varlist : _all
display "`varlist'"

//  #3
//  list names and labels with a loop

* long line size to prevent wrapping of long labels
set linesize 120

* counter to number each variable
local counter = 1

* start the loop through all variables
foreach varname in `varlist' {

    * retrieve variable label
    local varlabel : variable label `varname'
    * retrieve name of value label
    local vallabel : value label `varname'
    * print the information
    display "`counter'." _col(6) "`varname'" _col(19) ///
        "`vallabel'" _col(32) "`varlabel'"
    local ++counter

}

//  #4
//  send list to a file for editing

* open a file that will hold the names and labels
capture file close myfile
file open myfile using wf5-sgc1a-list.txt, write replace

* write header row with ; delimiters
file write myfile "Number;Name;Value label;Variable labels" _newline

* counter to number each variable
local counter = 1

* start the loop through all variables
foreach varname in `varlist' {

    * retrieve current labels
    local varlabel : variable label `varname'
    local vallabel : value label `varname'

    * write a ; delimited row of data
    file write myfile "`counter';`varname';`vallabel';`varlabel'" _newline

        *> for a tab delimited file, you can use this:
        *> file write myfile "`counter'" _tab "`varname'" ///
        *>       _tab "`vallabel'" _tab "`varlabel'" _newline

    local ++counter
}

file close myfile

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
