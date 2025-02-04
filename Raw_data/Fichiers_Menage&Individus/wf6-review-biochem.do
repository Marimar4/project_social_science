capture log close
log using wf6-review-biochem, replace text

//  program:    wf6-review-biochem.do \ for stata 9
//  task:       Values review of biochemistry data
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-acjob, clear
* in stata 10 and later: datasignature confirm

//  #2
//  check range of values

summarize
codebook, compact

//  #3
//  check specific values

//  #3a - tab1 can produce too much output

tab1 art, missing
tab1 fem fel, missing

//  #3b - stem for each variable with a loop

foreach var in art cit phd job ment {
    stem `var'
}

//  #4
//  standard dotplot with stata 9 graphics

//  #4a - standard dotplot

dotplot cit

//  #4b - dotplots in stata 9 graphics with loop

foreach var in art cit phd job ment {
    dotplot `var'
    graph export wf6-review-biochem-`var'.eps, replace
}

//  #4c - dotplot in stata 7 graphics

version 7: dotplot cit
graph export wf6-review-biochem-cit-stata7.eps, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
