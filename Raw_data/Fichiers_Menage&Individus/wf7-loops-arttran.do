capture log close
log using wf7-loops-arttran, replace text

//  pgm:        wf7-loops-arttran.do \ for stata 9
//  task:       using loops for logits with root transformations of articles
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

* local to hold list of variables with transformed articles
local artvars ""

* loop through roots 1 through 9
forvalues root = 1(1)9 {
    * take to the 1/root power
    gen art_root`root' = articles^(1/`root')
    label var art_root`root' "articles^(1/`root')"
    * add new variable to the list
    local artvars "`artvars' art_root`root'"
}

//  #4
//  loop through models

foreach avar in `artvars' {
    logit tenure `avar' female year yearsq select prestige, nolog
}

//  #5
//  loop through models with a description

foreach avar in `artvars' {
    display _new "== logit with `avar'"
    logit tenure `avar' female year yearsq select prestige, nolog
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
