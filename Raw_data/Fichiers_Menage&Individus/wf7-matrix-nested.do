capture log close
log using wf7-matrix-nested, replace text

//  pgm:        wf7-matrix-nested.do \ for stata 9
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

local Vtime "year yearsq"      // time in rank
local Vdept "select prestige"  // characteristics of departments
local Vprod "articles"         // research productivity

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
matrix b = e(b) // get betas
matrix list b
matrix v = e(V) // get covariance of betas
matrix list v
* put results in matrix
matrix stats[1,1] = exp(b[1,1]) // compute OR for female
matrix stats[1,2] = b[1,1]/sqrt(v[1,1]) // compute z
estat ic // get BIC
matrix temp = r(S)
matrix stats[1,3] = temp[1,6]

//  #4b + time

logit tenure female `Vtime', or
matrix b = e(b) // get betas
matrix v = e(V) // get covariance of betas
matrix stats[2,1] = exp(b[1,1]) // compute OR for female
matrix stats[2,2] = b[1,1]/sqrt(v[1,1]) // compute z
estat ic // get BIC
matrix temp = r(S)
matrix stats[2,3] = temp[1,6]

//  #4c + department

logit tenure female `Vtime' `Vdept', or
matrix b = e(b) // get betas
matrix v = e(V) // get covariance of betas
matrix stats[3,1] = exp(b[1,1]) // compute OR for female
matrix stats[3,2] = b[1,1]/sqrt(v[1,1]) // compute z
estat ic // get BIC
matrix temp = r(S)
matrix stats[3,3] = temp[1,6]

//  #4d + time

logit tenure female `Vtime' `Vdept' `Vprod', or
matrix b = e(b) // get betas
matrix v = e(V) // get covariance of betas
matrix stats[4,1] = exp(b[1,1]) // compute OR for female
matrix stats[4,2] = b[1,1]/sqrt(v[1,1]) // compute z
estat ic // get BIC
matrix temp = r(S)
matrix stats[4,3] = temp[1,6]

//  #5
//  print results

matrix list stats, format(%9.3f)

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
