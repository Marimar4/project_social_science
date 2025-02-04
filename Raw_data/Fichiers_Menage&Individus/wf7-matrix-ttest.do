capture log close
log using wf7-matrix-ttest, replace text

//  pgm:        wf7-matrix-ttest.do \ for stata 9
//  task:       use matrix to collect results from ttest
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
keep if sampleis

//  #2
//  ttest of gender differences w/o matrices

local varlist "tenure year select articles prestige"
foreach var in `varlist' {
    display _new ". ttest `var', by(female)"
    ttest `var', by(female)
}

//  #3
//  create the matrix (see below for a fancier method)

matrix stats = J(5,6,-99)
matrix list stats
* add row and column names
matrix colnames stats = FemMn FemSD MalMn MalSD t_test t_prob
matrix rownames stats = `varlist'
matrix list stats

//  #4
//  examine what ttest returns

ttest tenure, by(female)
return list

//  #5
//  collect t-test results in matrix

local irow = 0
foreach var of varlist `varlist' {
    local ++irow
    qui ttest `var', by(female)
    matrix stats[`irow',1] = r(mu_2) // female mean
    matrix stats[`irow',2] = r(sd_2) // female sd
    matrix stats[`irow',3] = r(mu_1) // male mean
    matrix stats[`irow',4] = r(sd_1) // male sd
    matrix stats[`irow',5] = r(t)    // t-value
    matrix stats[`irow',6] = r(p)    // p-value
}

//  #6
//  ways to list results

* the easiest way
matrix list stats

* creating a header
local n_men = r(N_1)
local n_women = r(N_2)
local header "t-tests: mean_women (N=`n_women') = mean_men (N=`n_men')"

* alternative formats
matrix list stats, format(%9.3f)
matrix list stats, format(%9.3f) title(`header')
matrix list stats, format(%9.2f) title(`header')

//  #7
//  a fancier way to create a matrix

local nvars : word count `varlist'
matrix stats2 = J(`nvars',6,-99)
matrix colnames stats2 = FemMn FemSD MalMn MalSD t_test t_prob
matrix rownames stats2 = `varlist'
matrix list stats2

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
