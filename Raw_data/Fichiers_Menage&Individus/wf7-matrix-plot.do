capture log close
log using wf7-matrix-plot, replace text

//  pgm:        wf7-matrix-plot.do \ for stata 9
//  task:       plot results collected in a matrix
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
set scheme s2manual
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
    * what root is being analyzed?
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
//  create variables from matrix

matrix list stats
svmat stats, names(col)

//  #6
//  plot results

twoway (connected bic root, msymbol(circle)), ///
    ytitle(BIC statistic) ylabel(1700(10)1750) ///
    xtitle(Root transformation of articles) xlabel(1(1)9) ///
    caption("wf7-matrix-plot.do 2008-10-24",size(vsmall))
graph export wf7-matrix-plot.eps, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
