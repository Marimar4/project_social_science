capture log close
log using wf5-varlabels, replace text

//  program:    wf5-varlabels.do \ for stata 9
//  task:       labelling variables
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

local date "2008-10-24"
local tag "wf5-varlabels.do \ jsl `date'."

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
//  simple example - add variable label to new variable

generate  artsqrt = sqrt(pub1)
label var artsqrt "Square root of # of articles"

//  #3
//  variable lists

use wf-names, clear

* codebook command
codebook id tc1fam tc2fam tc3fam vignum, compact

* describe command
describe id tc1fam tc2fam tc3fam vignum
describe, simple
describe id-opdoc, simple

* nmlab command
nmlab id tc1fam tc2fam tc3fam vignum
nmlab id tc1fam tc2fam tc3fam vignum, number
nmlab id tc1fam tc2fam tc3fam vignum, number col(20)

//  #2
//  order and aorder commands

* before ordering
nmlab

* after ordering
aorder
order id
nmlab

//  #3
//  truncated variable labels

* labels are too long with critical information at the end
set linesize 140 // the entire label will appear but run off the page
nmlab tc1*
set linesize 80 // only 80 columns will be shown
codebook tc1*, compact

* better labels
nmlab tc2*
codebook tc2*, compact

* labels we used
nmlab tc3*
codebook tc3*, compact

* what to include?
generate tcfamsqrt = sqrt(tcfam)
label var tcfamsqrt ///
    "Q43 Sqrt family help important? \ `tag'"
tabulate tcfamsqrt, missing

* checking labels
codebook tc3*, compact
tabulate tcfam, missing

* example of a label that is too long
clonevar tcfamV2 = tcfam
label var tcfamV2 ///
    " Question 43: How important is it to you to turn to the family for support?"
tabulate tcfamV2, missing

//  #4
//  temporarily changing variable labels

* tabulate with the original labels
foreach varname in pub1 pub3 pub6 pub9 {
    tabulate `varname', missing
}

* tabulate after removing the label
foreach varname in pub1 pub3 pub6 pub9 {
    label var `varname' ""
    tabulate `varname', missing
}

* labels in graphs
scatter phd pub1
graph export wf5-varlabels-original.eps, replace

* change the labels for the axes
label var pub1 "Articles at time of Ph.D."
label var phd "Ph.D. Prestige"
scatter phd pub1
graph export wf5-varlabels-revised.eps, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
