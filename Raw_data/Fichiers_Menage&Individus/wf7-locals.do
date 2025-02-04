capture log close
log using wf7-locals, replace text

//  pgm:        wf7-locals.do \ for stata 9
//  task:       automation - locals
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

//  CODEBOOK WITHOUT USING A LOCAL

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

//  CODEBOOK USING A LOCAL

local varset "female male tenure year yearsq select articles prestige"

//  #5
//  desc statistics for men & women combined

codebook `varset', compact

//  #6
//  desc statistics for women

codebook `varset' if female, compact

//  #7
//  desc statistics for men

codebook `varset' if male, compact

//  #8
//  nested models predicting tenure - without using locals

//  #8a = baseline gender only model

logit tenure female, nolog or

//  #8b + time

logit tenure female year yearsq, nolog or

//  #8c + department

logit tenure female year yearsq select prestige, nolog or

//  #8d + productivity

logit tenure female year yearsq select prestige articles, nolog or


//  #9
//  nested models predicting tenure - with locals

//  define groups of variables

local Vtime "year yearsq"      // time in rank
local Vdept "select prestige"  // characteristics of departments
local Vprod "articles"         // research productivity

//  #9a = baseline gender only model

logit tenure female, nolog or

//  #9b + time

logit tenure female `Vtime', nolog or

//  #9c + department

logit tenure female `Vtime' `Vdept', nolog or

//  #9d + productivity

logit tenure female `Vtime' `Vdept' `Vprod', nolog or

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
