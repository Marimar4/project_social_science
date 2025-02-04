capture log close
log using wf6-verify, replace text

//  program:    wf6-verify.do \ for stata 9
//  task:       Verifying your variables
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  note:       uniform() was replaced be runiform() in Stata 10.1

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-verify, clear
* in stata 10 and later: datasignature confirm

//  #2
//  listing values

*create var that recodes fincome to the midpoint of the range
generate finc_mid = fincome
label var finc_mid "Income coded at the midpoint"
note finc_mid: midpoints for fincome \ wf6-verify.do jsl 2008-10-24.
note finc_mid: high value is 1.25X truncation point \ wf6-verify.do jsl 2008-10-24.
recode finc_mid ///
     1=1.5   2=4     3=6     4=8     5=9.5   6=10.5  7=11.5  8=12.5   ///
     9=13.5 10=14.5 11=16   12=18.5 13=21   14=23.5 15=23.5 16=32.5   ///
    17=37.5 18=42.5 19=47.5 20=55   21=67.5 22=82.5 23=97.5 24=131.25

*create a random variable
set seed 1951
generate xselect = int( (uniform()*_N)+ 1 ) // renamed to runiform() in stata 10.1
label var xselect "Random numbers from 1 to _N"
summarize xselect // verify range

*look at a random selection of observations
sort fincome
list fincome finc_mid if xselect<20, clean

//  #3
//  a continuous variable plot

generate inc_sqrt = sqrt(inc) if !missing(inc)
label var inc_sqrt "Square root of inc"

scatter inc_sqrt inc, msymbol(circle_hollow)
graph export wf6-verify-scatter.eps, replace

//  #4
//  recoding midpoints

use wf-verify, clear
* in stata 10 and later: datasignature confirm

tabulate fincome, miss
generate finc_mid = fincome
label var finc_mid "Income coded at the midpoint"
note finc_mid: midpoints for fincome; upper range is 1.25X ///
truncation point \ wf6-verify.do jsl 2008-10-24.

recode finc_mid ///
     1=1.5   2=4     3=6     4=8     5=9.5   6=10.5  7=11.5  8=12.5    ///
     9=13.5 10=14.5 11=16   12=18.5 13=21   14=23.5 15=23.5 16=32.5    ///
    17=37.5 18=42.5 19=47.5 20=55   21=67.5 22=82.5 23=97.5 24=131.25

scatter finc_mid fincome, msymbol(circle_hollow)
graph export wf6-verify-xyscatter.eps, replace

scatter fincome finc_mid, msymbol(circle_hollow)
graph export wf6-verify-yxscatter.eps, replace

//  #5
//  checking missing values with tabulate

generate inc_sqrt = sqrt(inc)
label var inc_sqrt "Square root family income excluding wife's"
tabulate inc inc_sqrt if missing(inc) | missing(inc_sqrt), miss

//  #6
//  compare two ways of creating the same variable

* use recode
recode edyears 0/8=1 9/11=2 12=3 13/15=4 16/24=5, gen(educcat)

* create variable with gen and replace
generate educcatV2 = edyears
replace educcatV2 = 1 if edyears>=0  & edyears<=8   // no HS
replace educcatV2 = 2 if edyears>=9  & edyears<=11  // some HS
replace educcatV2 = 3 if edyears==12                // HS
replace educcatV2 = 4 if edyears>=13 & edyears<=15  // some college
replace educcatV2 = 5 if edyears>=16 & edyears<=24  // college plus
label var educcatV2 "categorize educ using replace"

compare educcat educcatV2

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
