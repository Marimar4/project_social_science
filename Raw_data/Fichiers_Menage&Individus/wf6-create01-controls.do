capture log close
log using wf6-create01-controls, replace text

//  program:    wf6-create01-controls.do \ for stata 9 - step 1 of 3
//  task:       Create control variables for ISSP Russian data
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  define local

local date "2008-10-24"
local tag "wf6-create01.do jsl `date'."

//  #2
//  load data

use wf-russia01, replace
* in stata 10 and later: datasignature confirm

//  #3
//  create controls for demographic variables

gen female = gender - 1
label var female "Female?"
label def female 0 0_male 1 1_female
label val female female
note female: based on gender \ `tag'
tab gender female, miss

gen male = 1 - female
label var male "Male?"
label def male 1 1_male 0 0_female
label val male male
note male: based on gender \ `tag'
tab gender male, miss

recode marstat (1 2 3 4=1) (5=0), gen(married)
label def married 1 1_married 0 0_never
label val married married
label var married "Ever married?"
note married: recoding of marstat \ married includes married, ///
widowed, divorced, separated \ `tag'

tab marstat married, miss

recode edlevel (1 2 3 4 5=0) (6 7=1) (99=.n), gen(hidegree)
label var hidegree "Any higher education?"
label def hidegree 0 0_not 1 1_high_ed
label val hidegree hidegree
note hidegree: recode of edlevel \ `tag'
tab edlevel hidegree, miss

recode empstat (1 7=1) (2 3 5 6 8 9 10=0) (98=.d) (99=.n), gen(fulltime)
label def fulltime 1 1_fulltime 0 0_not
label val fulltime fulltime
label var fulltime "Ever worked full time?"
note fulltime: recoding of empstat; includes fulltime & retired \ `tag'
tab empstat fulltime, miss

//  #4
//  check new variables

codebook female-fulltime, compact

//  #5
//  cleanup and save

sort id
quietly compress
label data "Workflow example of adding analysis variables \ `date'"
note: wf-russia02.dta \ `tag'
* in stata 10 and later: datasignature set, reset
save wf-russia02, replace

* verify data that was saved
use wf-russia02, clear
* in stata 10 and later: datasignature confirm
notes
codebook, compact
cf _all using wf-russia01

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
