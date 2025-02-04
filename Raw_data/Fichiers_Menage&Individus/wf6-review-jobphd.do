capture log close
log using wf6-review-jobphd, replace text

//  program:    wf6-review-jobphd.do \ for stata 9
//  task:       Looking at pairs of variables
//  project:    workflow chapter 6
//  author:     scott long \ 2008-11-03

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
//  check range of values for phd and job

codebook phd job, compact

//  #3
//  compare job and phd histograms

label var phd "phd: PhD prestige"
label var job "job: Prestige of first job"
dotplot phd job, ///
    xlabel(,labsize(medium))
graph export wf6-review-jobphd-phdjob-hist.eps, replace

//  #4
//  simple scatter plot

scatter job phd
graph export wf6-review-jobphd-phdjob.eps, replace

//  #5
//  scatter plot spruced up

scatter job phd, msymbol(circle_hollow) ///
    ylabel(, grid) xlabel(, grid) aspectratio(1)
graph export wf6-review-jobphd-phdjob-nice.eps, replace

//  #6
//  scatter plot spruced up with jitter

scatter job phd, msymbol(circle_hollow) jitter(8) ///
    ylabel(, grid) xlabel(, grid) aspectratio(1)
graph export wf6-review-jobphd-phdjob-jitter.eps, replace

//  #7
//  all pairs

* reload data to reset labels that were changed in step #3
use wf-acjob, clear

//  #7a - scatter plot matrix

graph matrix phd job ment art cit fem fel, ///
    jitter(3) half msymbol(circle_hollow)
graph export wf6-review-jobphd-matrix.eps, replace

//  #7b - individual bivariate scatter plots

local varlist "job phd ment art cit fem fel"
local nvars : word count `varlist'

forvalues y_varnum = 1/`nvars' {
    * retrieve the name of variable for y axis
    local y_var : word `y_varnum' of `varlist'
    * get the variable label
    local y_lbl : variable label `y_var'
    * create label with var name and label combined
    label var `y_var' "`y_var': `y_lbl'"
    * loop through x variables
    local x_start = `y_varnum' + 1
    forvalues x_varnum = `x_start'/`nvars' {
        * create var labels for x variables
        local x_var : word `x_varnum' of `varlist'
        local x_lbl : variable label `x_var'
        label var `x_var' "`x_var': `x_lbl'"
        * create graph
        scatter `y_var' `x_var', msymbol(circle_hollow) jitter(8) ///
            ylabel(, grid) xlabel(, grid) aspectratio(1)
        graph export wf6-review-jobphd-`y_var'-`x_var'.eps, replace
        * reset variable label for x-var
        label var `x_var' "`x_lbl'"
    }
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
