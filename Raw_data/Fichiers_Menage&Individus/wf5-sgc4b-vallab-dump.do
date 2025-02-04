capture log close
log using wf5-sgc4b-vallab-dump, replace text

//  program:    wf5-sgc4b-vallab-dump.do \ for stata 9
//  task:       dump label define commands to be edited
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
drop S*

//  #2
//  get list of value labels

quietly labelbook
local valdeflist = r(names)

//  #3 - approach 1 - easy to produce list but harder to edit
//  create label define commands to edit

label save `valdeflist' using ///
    wf5-sgc4b-vallab-labelsave-dummy.doi, replace

//  #3 - approach 2 - harder to produce list but easier to edit
//  create label define commands to edit

* create a dataset with value labels
uselabel `valdeflist' , clear

* here is what the uselabel dataset looks like
list in 1/4, clean

* open file to contain label define commands
capture file close myfile
file open myfile using wf5-sgc4b-vallab-labdef-dummy.doi, write replace

* loop through dataset of value labels and save label define commands
local rownum = 0        // counter for current row
local priorlbl ""       // name of prior label that was printed

while `rownum' <= _N {  // loop through all rows of dataset

    local ++rownum
    * retrieve information from current row
    local lblnm  = lname[`rownum']  // name of value label
    local lblval = value[`rownum']  // specific value being labeled
    local lbllbl = label[`rownum']  // name assigned to that value

    * get first letter of label to determine if it is a missing value label
    local startletter = substr("`lblval'",1,1)

    * if name of label has changed, write header
    if "`priorlbl'"!="`lblnm'" {
        file write myfile "//" _col(30) `""1234567890""' _newline
    }

    * only write a label define command if the value is not a missing value
    if "`startletter'"!="." {

        file write myfile ///
            "label define N`lblnm' " _col(25) "`lblval'" ///
            _col(30) `""`lbllbl'""' ", modify" _newline
    }

    * before starting with a new label, the prior label becomes the current label
    local priorlbl "`lblnm'"

}

file close myfile

//  #4
//  create label value commands

* reload data and get list of non-source variables
use wf-sgc03, clear
drop S*
aorder
unab varlist : _all

* open file to contain label value commands
file open myfile using wf5-sgc4b-vallab-labval-dummy.doi, write replace

* loop through variable list and create label value commands
foreach varname in `varlist' {

    * get the label assigned to the current variable
    local lblnm : value label `varname'

    * if a label is defined, write a label value command
    if "`lblnm'"!="" {
        file write myfile ///
            "label value  `varname'" _col(27) "N`lblnm'" _newline
    }
}

file close myfile

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
