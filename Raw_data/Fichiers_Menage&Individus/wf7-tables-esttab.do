capture log close
log using wf7-tables-esttab, replace text

//  pgm:        wf7-tables-esttab.do \ for stata 9
//  task:       using eststo and esttab to format tables
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
//  nested models predicting tenure

//  #3a - baseline gender only model

logit tenure female, nolog or
eststo

//  #3b + time

logit tenure female `Vtime', nolog or
eststo

//  #3c + department

logit tenure female `Vtime' `Vdept', nolog or
eststo

//  #4
//  esttab options

//  #4a - default

esttab

//  #4b - near final table

esttab, eform nostar bic label varwidth(33) ///
    title("Table 7.1: Workflow Example of Jann's esttab Command.") ///
    mtitles("Model A" "Model B" "Model C") ///
    addnote("Source: wf7-tables-esttab.do")

//  #4c - for latex

esttab using wf7-estout.tex, eform nostar bic label varwidth(33) ///
    mtitles("Model A" "Model B" "Model C") ///
    addnote("Source: wf7-tables-esttab.do") replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
