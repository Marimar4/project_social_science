capture log close
log using wf5-varnames, text replace

//  program:    wf5-varnames.do \ for stata 9
//  task:       naming variables
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  if something is new, give it a new name

* do NOT do it this way
use wf-names, clear
sum var27
replace var27 = 100 if var27>100 & var27<.
sum var27


//  #2
//  cloning versus generating variables

use wf-names, clear
generate lfp_gen = lfp
clonevar lfp_clone = lfp
codebook lfp*, compact
describe lfp*

//  #3
//  lookfor

lookfor race

//  #4
//  recoding a variable by creating a new variable

* do it this way
use wf-names, clear
gen      var27trunc = var27
replace  var27trunc = 100 if var27trunc>100 & var27trunc<.

* or this way
use wf-names, clear
clonevar var27trunc = var27
replace  var27trunc = 100 if var27trunc>100 & var27trunc<.

* recoding a missing value
clonevar educV2 = educ
replace  educV2 = . if educV2==99

//  #5
//  leading 0's are ignored with aorder

use wf-names, clear
keep vs*
aorder
codebook, compact

//  #6
//  use simple, unambiguous names

* long names
clear
set obs 100
set seed 20070323
generate  a2345678901234567890123456789012 = uniform() // renamed runiform() in stata 10
label var a2345678901234567890123456789012 "Long name 1."
generate  a23456789012345678901234567890_1 = uniform() // renamed runiform() in stata 10
label var a23456789012345678901234567890_1 "Long name 2."
generate  a23456789012345678901234567890_2 = uniform() // renamed runiform() in stata 10
label var a23456789012345678901234567890_2 "Long name 3."
summarize
describe

* changing long names
use wf-names, clear
rename socialdistance socdist
label var socdist "socialdistance-Social distance from a person with MI."
describe socdist

//  #7
//  be careful with capitalization

summarize ed Ed ED

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
