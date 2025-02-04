capture log close
log using wf7-matrix-arttran, replace text

//  pgm:        wf7-matrix-arttran.do \ for stata 9
//  task:       use matrix to collect results from different transformations
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
//  create art_root# = (articles)^(1/#)

local artvars "" // list of variables to test

forvalues root = 1(1)9 { // loop through each root
    * take to the 1/root power
    gen art_root`root' = articles^(1/`root')
    label var art_root`root' "articles^(1/`root')"
    * add new variable to the list
    local artvars "`artvars' art_root`root'"
}

//  #3
//  matrix to hold results

local nvars : word count `artvars'
matrix stats = J(`nvars',5,-99)
matrix rownames stats = `artvars'
matrix colnames stats = root sd b_std exp_b_std bic

//  #4
//  loop through models

local irow = 0
foreach avar in `artvars' {
    local ++irow
    * add root number to the matrix
    matrix stats[`irow',1] = `irow'
    * sd of avar
    sum `avar'
    local sd = r(sd)
    matrix stats[`irow',2] = `sd'
    * logit with avar
    logit tenure `avar' female year yearsq select prestige, nolog
    * save b*sd and exp(b*sd) for avar
    matrix temp = e(b)
    matrix stats[`irow',3] = temp[1,1]*`sd'
    matrix stats[`irow',4] = exp(temp[1,1]*`sd')
    * save bic
    estat ic
    matrix temp = r(S)
    matrix stats[`irow',5] = temp[1,6]
}

//  #5
//  print summary of results

local header "Comparing root transformations of articles in logit"
* NOTE: model also includes female year yearsq select prestige
matrix list stats, format(%9.3f) title(`header')

//  #6
//  add z-test and prob

* create the matrix
local nvars : word count `artvars'
matrix stats = J(`nvars',7,-99)
matrix rownames stats = `artvars'
matrix colnames stats = root sd b_std exp_b_std bic z prob

* loop through articles
local irow = 0
foreach avar in `artvars' {
    local ++irow
    matrix stats[`irow',1] = `irow'
    sum `avar'
    local sd = r(sd)
    matrix stats[`irow',2] = `sd'
    qui logit tenure `avar' female year yearsq select prestige, nolog
    matrix b = e(b)
    matrix stats[`irow',3] = b[1,1]*`sd'
    matrix stats[`irow',4] = exp(b[1,1]*`sd')
    estat ic
    matrix temp = r(S)
    matrix stats[`irow',5] = temp[1,6]
    * compute the z and p
    matrix vc = e(V)
    local ztest = b[1,1]/sqrt(vc[1,1])
    local prval = 2*normal(-abs(`ztest'))
    matrix stats[`irow',6] = `ztest'
    matrix stats[`irow',7] = `prval'
}

* print results

local header "Comparing root transformations of articles in logit"
* NOTE: model also includes female year yearsq select prestige
matrix list stats, format(%9.3f) title(`header')
* add more decimal digits
matrix list stats, format(%12.9f) title(`header')

log close
exit

2008-10-24 \ initial version for wf09-part1.pkg
