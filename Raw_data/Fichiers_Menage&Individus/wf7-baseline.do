capture log close
log using wf7-baseline, replace text

//  pgm:        wf7-baseline.do \ for stata 9
//  task:       tenure - baseline statistics
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data and select sample

use wf-tenure, clear
* in stata 10 and later: datasignature confirm
tabulate sampleis
keep if sampleis

//  #2
//  desc statistics for men & women combined

codebook female male tenure year yearsq select articles prestige, compact

//  #3
//  desc statistics for women

codebook female male tenure year yearsq select articles prestige ///
    if female, compact

//  #4
//  desc statistics for men

codebook female male tenure year yearsq select articles prestige ///
    if male, compact

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
