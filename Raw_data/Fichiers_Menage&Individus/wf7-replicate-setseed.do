capture log close
log using wf7-replicate-setseed, replace text

//  pgm:        wf7-replicate-setseed.do \ for stata 9
//  task:       letting stata set the seed
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  note:       must be run immediately after starting Stata
//              uniform() was replaced by runiform() in Stata 10.1

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  set # of observations

set obs 100

//  #2
//  check the seed stata automatically set

creturn list
local seedis = c(seed)
di "`seedis'"

//  #3
//  generate random numbers with this seed

gen u1 = uniform() // renamed to runiform() in stata 10.1
sum u1

//  #4
//  generate random numbers based on seed set by stata initially

gen u2 = uniform() // renamed to runiform() in stata 10.1
sum u2

//  #5
//  generate random numbers with a seed I pick

set seed 1102
gen u3 = uniform() // renamed to runiform() in stata 10.1
sum u3

//  #6
//  generate random numbers with seed saved above

set seed `seedis'
gen u4 = uniform() // renamed to runiform() in stata 10.1
pwcorr u1 u2 u3 u3 u4

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
