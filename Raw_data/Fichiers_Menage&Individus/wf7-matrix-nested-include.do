capture log close
log using wf7-matrix-nested-include, replace text

//  pgm:        wf7-matrix-nested-include.do \ for stata 9
//  include:    requires wf7-matrix-nested-include.doi
//  task:       use matrix to collect results from nested models
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
//  define groups of variables

local Vtime "year yearsq"       // time in rank
local Vdept "select prestige"   // characteristics of department affiliations
local Vprod "articles"          // research productivity

//  #3
//  set up matrix for results

local modelnm "base plustime plusdept plusprod"
local statsnm "ORfemale zfemale BIC"
matrix stats = J(4,3,-99)
matrix rownames stats = `modelnm'
matrix colnames stats = `statsnm'
matrix list stats

//  #4
//  nested models predicting tenure

//  #4a - baseline gender only model

logit tenure female, or
include wf7-matrix-nested-include.doi

//  #4b + time

logit tenure female `Vtime', or
include wf7-matrix-nested-include.doi

//  #4c + department

logit tenure female `Vtime' `Vdept', or
include wf7-matrix-nested-include.doi

//  #4d + time

logit tenure female `Vtime' `Vdept' `Vprod', or
include wf7-matrix-nested-include.doi

//  #5
//  print results

matrix list stats, format(%9.3f)

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
