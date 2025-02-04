capture log close
log using wf5-vallabels, replace text

//  program:    wf5-vallabels.do \ for stata 9
//  task:       value labels
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  note:       requires Stata 10 born on 25feb2008 or later for -label copy-

local date "2008-10-24"

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-names, clear

//  #2
//  tabulate with and without value labels

* no labels with values of 0 1
tabulate wc_v1 k5
* no labels with values of 1 2
tabulate wc_v2 k5
* yes no labels
tabulate wc_v3 k5

//  #3
//  the advantages of short labels

* alternative definitions of labels
label define sd_v1 1 "Definitely Willing" 2 "Probably Willing" ///
    3 "Probably Unwilling" 4 "Definitely Unwilling"
label define sd_v2 1 1Definite 2 2Probably 3 3ProbNot 4 4DefNot
label define sd_v3 1 Definite 2 Probably 3 ProbNot 4 DefNot

* assign labels to variables
clonevar sdchild_v1 = sdchild
clonevar sdchild_v2 = sdchild
clonevar sdchild_v3 = sdchild

label val sdchild_v1 sd_v1
label val sdchild_v2 sd_v2
label val sdchild_v3 sd_v3

* list each version of the labels
labelbook sd_v1 sd_v2  sd_v3

* tabulate with version 1 of labels
tabulate female sdchild_v1
tabulate female sdchild_v1, nolabel

* tabulate with version 2 of labels
tabulate female sdchild_v2
tabulate female sdchild_v2, nolabel

* tabulate with version 3 of labels
tabulate female sdchild_v3

* with and without labels
tabulate sdchild_v1
tabulate sdchild_v1, nolabel

//  #4
//  adding values to value labels

* adding values to labels the hard way
label define defnot 1 "1Definite" 2 "2Probably" 3 "3ProbNot" 4 "4DefNot"
label val sdchild defnot
tabulate sdchild

* adding values with numlabel - start with the labels that follow
label drop defnot
label define defnot 1 "Definite" 2 "Probably" 3 "ProbNot" 4 "DefNot"

//  make a copy - this requires Stata 10 which added the label copy command

/*
label copy defnot defnotN

* let numlabel add the values
numlabel defnotN, mask(#_) add
label val sdchild defnotN
tabulate sdchild

* returning to the original labels
label val sdchild defnot
tabulate sdchild

* and back again
label val sdchild defnotN
tabulate sdchild

* removing numbers from labels
numlabel defnotN, mask(#_) remove
label val sdchild defnotN
tabulate sdchild

* adding numbers such as 1. to labels
numlabel defnotN, mask(#. ) add
label val sdchild defnotN
tabulate sdchild
*/

//  #5
// listing and cleaning up value labes

use wf-names, clear

* problems when changing labels that affect multiple variables
label define twocat 0 0No 1 1Yes
* label val lfp female twocat // assigning two variables is only possible in Stata 10
label val lfp twocat
label val female twocat
tabulate female lfp

* change the label and problems occur
label define twocat 0 0Male 1 1Female, modify
tabulate female lfp

* labelbook
labelbook Ltenpt

use wf-names, clear

* labels associated with given variables
describe id vignum female serious opnoth opfam sdchild

* labels defined in dataset
label dir

* codebook problems
codebook, problems

//  #6
//  loops with value labels

* a simple version
label define Lagree 1 1_agree 0 0_disagree
foreach varname in sdneighb sdsocial sdchild sdfriend sdwork sdmarry {
    display     _newline "--> Recoding variable `varname'" _newline
    clonevar    B`varname' = `varname'
    recode      B`varname' 1/2=1 3/4=0
    label val   B`varname' Lagree
    tabulate    B`varname' `varname', miss
}

* modify for missing values
label define Lagree 1 1_agree 0 0_disagree .c .c_DK .d .d_NA_ref, modify

* more elaborate version
drop B*
local tag "wf5-vallabels.do jsl `date'."
foreach varname in sdneighb sdsocial sdchild sdfriend sdwork sdmarry {
    display     _newline "--> Recoding variable `varname'" _newline
    clonevar    B`varname' = `varname'
    recode      B`varname' 1/2=1 3/4=0
    label val   B`varname' Lagree
    note        B`varname': "Recode of `varname' \ `tag'"
    label var   B`varname' "Binary version of `varname'"
    tabulate    B`varname' `varname', miss
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
