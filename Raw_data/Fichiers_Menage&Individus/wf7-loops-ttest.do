capture log close
log using wf7-loops-ttest, replace text

//  pgm:        wf7-loops-ttest.do \ for stata 9
//  task:       using loops for t-tests
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
//  ttest gender differences without a loop

ttest tenure,   by(female)
ttest year,     by(female)
ttest select,   by(female)
ttest articles, by(female)
ttest prestige, by(female)

//  #3
//  ttest gender differences using a loop with no header

local varlist "tenure year select articles prestige"
foreach var in `varlist' {
    ttest `var', by(female)
}

//  #4
//  ttest gender differences using a loop with a header

local varlist "tenure year select articles prestige"
foreach var in `varlist' {
    * echo command
    di _new ". ttest `var', by(female)"
    ttest `var', by(female)
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
