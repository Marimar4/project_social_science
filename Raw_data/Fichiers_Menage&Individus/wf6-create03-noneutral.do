capture log close
log using wf6-create03-noneutral, replace text

//  program:    wf6-create03-noneutral.do \ for stata 9 - step 3 of 3
//  task:       Create variables for ISSP data
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

local tag "wf6-create03-noneutral.do jsl 2008-10-24."

//  #2
//  load data

use x-wf6-create02-binary, replace
* in stata 10 and later: datasignature confirm

//  #3
//  create ordinal outcomes without neutral
//  note: this shows how to use local macros for this

* new labels
label def Lsa_sd 1 1_SA_Pos 2 2_A_Pos 3 3_D_Neg ///
    4 4_SD_Neg .a a_Unsure .b b_Refused .n n_Neutral

* momwarm: 1=SA working mom can have warm relationship
* C4warm:  1=SA (not reversed)
local vin momwarm
local vout C4warm
recode `vin' (1=1) (2=2) (3=.n) (4=3) (5=4), gen(`vout')
label var `vout' "Working mom can have warm relations?"
label val `vout' Lsa_sd
note `vout': 3=neutral in source was coded .n \ `tag'
tab `vin' `vout', m

* kidsuffer: 1=SA preschool child suffers with working mom
* C4kids:    1=SA don't suffer (reverse coding)
local vin kidsuffer
local vout C4kids // reverse coding
recode `vin' (1=4) (2=3) (3=.n) (4=2) (5=1), gen(`vout')
label var `vout' "Kids don't suffer with working mom?"
label val `vout' Lsa_sd
note `vout': 3=neutral in source was coded .n \ `tag'
tab `vin' `vout', m

* famsuffer: 1=SA family suffers with working mom
* C4family:  1=SA don't suffer (reverse coding)
local vin famsuffer
local vout C4family
recode `vin' (1=4) (2=3) (3=.n) (4=2) (5=1), gen(`vout')
label var `vout' "Family life doesn't suffer?"
label val `vout' Lsa_sd
note `vout': 3=neutral in source was coded .n \ `tag'
tab `vin' `vout', m

* wanthome: 1=SA really wants to stay home
* C4nohome: 1=SA don't want home (reverse coding)
local vin wanthome
local vout C4nohome
recode `vin' (1=4) (2=3) (3=.n) (4=2) (5=1), gen(`vout')
label var `vout' "Agree women don't want home and kids?"
label val `vout' Lsa_sd
note `vout': 3=neutral in source was coded .n \ `tag'
tab `vin' `vout', m

* housesat: 1=SA house just as satisfying
* C4jobsat: 1=SA job is satisfying (reverse coding)
local vin  housesat
local vout C4jobsat
recode `vin' (1=4) (2=3) (3=.n) (4=2) (5=1), gen(`vout')
label var `vout' "Agree paid job satisfies more?"
label val `vout' Lsa_sd
note `vout': 3=neutral in source was coded .n \ `tag'
tab `vin' `vout', m

* workbest: 1=SA work is best for independence
* C4indep:  1=SA job gives indep (not reversed)
local vin  workbest
local vout C4indep
recode `vin' (1=1) (2=2) (3=.n) (4=3) (5=4), gen(`vout')
label var `vout' "Agree work creates independence?"
label val `vout' Lsa_sd
note `vout': 3=neutral in source was coded .n \ `tag'
tab `vin' `vout', m

//  #4
//  check new variables

* descriptives
codebook C4*, compact
* correlations
pwcorr C4*, obs
* binary compared to 4 category scales
foreach s in warm kids family nohome jobsat indep {
    pwcorr B`s' C4`s', obs
}
* 4 category and 5 category correlations
pwcorr momwarm C4warm, obs      // not reversed
pwcorr kidsuffer C4kids, obs    // reversed
pwcorr famsuffer C4family, obs  // reversed
pwcorr wanthome C4nohome, obs   // reversed
pwcorr housesat C4jobsat, obs   // reversed
pwcorr workbest C4indep, obs    // not reversed

//  #5
//  cleanup and save

sort id
qui compress
label data "Workflow example using ISSP 2002 Russia \ 2008-10-24"
note: wf-russia03.dta `tag'
* in stata 10 and later: datasignature set, reset
save wf-russia03, replace

//  #6
//  check the changes

use wf-russia03, clear
* in stata 10 and later: datasignature confirm
notes
codebook, compact
cf _all using wf-russia02.dta

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
