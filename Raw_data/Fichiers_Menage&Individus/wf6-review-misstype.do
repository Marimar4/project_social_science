capture log close
log using wf6-review-misstype, replace text

//  program:    wf6-review-misstype.do \ for stata 9
//  include:    requires wf6-review-misstype-refused.doi
//              & wf6-review-misstype-ifsxrel.doi
//  task:       recoding and checking missing data
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data and define tag

local tag "wf6-review-misstype.do jsl 2008-10-24."
use wf-misstype, clear
* in stata 10 and later: datasignature confirm

//  #2
//  define missing value codes for V2 variables

    label def missdat           ///
            .c "c_catskip"      /// categorical answer not needed
            .d "d_nodebrief"    /// declined to be debriefed.
            .f "f_femskip"      /// not asked since R is female.
            .m "m_maleskip"     /// not asked since R is male.
            .p "p_priorref"     /// not asked since R refused prelim question.
            .r "r_refused"      /// refused to answer question.
            .s "s_single"       /// not asked since single.
            .x "x_nosxrel"      /// not asked since no sexual relationships.
            .z "z_prior_0"      /// not asked since reported 0 on lead-in question.

//  #3
//  missing values for simple refusals

clonevar acttvV2 = acttv
tab1 acttvV2, missing
tab1 acttvV2, missing nolabel
recode acttvV2 .a=.r
* or you can use: replace acttvV2 = .r if acttvV2==.a
tabulate acttvV2 acttv, missing
label val acttvV2 missdat

//  #4
//  multiple causes of missing data

* years married
clonevar maryearV2 = maryear
replace maryearV2 = .r if maryear==.a  // refused question
replace maryearV2 = .s if married==2   // single
replace maryearV2 = .p if married==.a  // married question refused
label val maryearV2 missdat
tab1 maryearV2 if !missing(maryearV2)

* months married
clonevar marmthV2 = marmth
recode marmthV2 .a=.r
replace marmthV2 = .s if married==2  // single
replace marmthV2 = .p if married==.a // married question refused
label val marmthV2 missdat
tab1 marmthV2 if !missing(marmthV2)

//  #5
//  missing values that are not missing

* years plus months married
generate martotal = (maryearV2*12) + marmthV2
label var martotal "Total months married"
replace martotal = .s if married==2     // single
replace martotal = .p if married==.a    // married question refused
replace martotal = .r if marmthV2==.r | maryearV2==.r
label val martotal missdat
tab1 martotal if missing(martotal), missing

* check the refusals
list martotal maryearV2 marmthV2 if martotal==.r, clean

* years plus months married - corrected
generate martotalV2 = .
label var martotalV2 "Total months married"
note martotalV2: marmthV2+(12*maryearV2) if both parts answered; ///
marmthV2 if year is missing; maryearV2 if month is missing \ `tag'

* replace valid year and month if both are nonmissing
replace martotalV2 = (12*maryearV2) + marmthV2 ///
    if !missing(maryearV2) & !missing(marmthV2)

* replace with year if only years is valid
replace martotalV2 = 12*maryearV2 ///
    if !missing(maryearV2) & marmthV2==.r

* replace month if only month is valid
replace martotalV2 = marmthV2 if maryearV2==.r & !missing(marmthV2)

* add missing codes for single or prior question refusal
replace martotalV2 = .s if married==2     // single
replace martotalV2 = .p if married==.a      // married question refused
label val martotalV2 missdat

* check results
tab1 martotalV2 if missing(martotalV2), miss
tab1 maryearV2  if missing(maryearV2), miss
tab1 marmthV2   if missing(marmthV2), miss

* list all cases - to be certain, you can check all cases
    * sort martotalV2
    * list martotalV2 maryearV2 marmthV2, clean

//  #6
//  missing data indicator variables

clonevar acttvV2M = acttvV2
*replace acttvV2M = 0 if acttvV2>=0 & acttvV2<=9999999
replace acttvV2M = 0 if !missing(acttvV2)
label var acttvV2M "acttvV2 is missing"
label val acttvV2M missdat
tabulate PPGENDER acttvV2M, exact missing

//  #7
//  use include files to recode missing values

* acttalk
local varnm acttalk
include wf6-review-misstype-refused.doi
* actexer
local varnm actexer
include wf6-review-misstype-refused.doi
* acthby
local varnm acthby
include wf6-review-misstype-refused.doi
* sxrelin
local varnm sxrelin
include wf6-review-misstype-refused.doi

* sxrel4w
local varnm sxrel4w
include wf6-review-misstype-refused.doi
include wf6-review-misstype-ifsxrel.doi

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
