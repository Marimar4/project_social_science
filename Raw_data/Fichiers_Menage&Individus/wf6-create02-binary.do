capture log close
log using wf6-create02-binary, replace text

//  program:    wf6-create02-binary.do \ for stata 9 - step 2 of 3
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

local date "2008-10-24"
local tag "wf6-create02.do jsl `date'."

//  #2
//  load data

use wf-russia02, clear
* in stata 10 and later: datasignature confirm

//  #3
//  create binary indicators

codebook momwarm kidsuffer famsuffer wanthome housesat workbest, compact
nmlab momwarm kidsuffer famsuffer wanthome housesat workbest
sum momwarm kidsuffer famsuffer wanthome housesat workbest
tab1 momwarm, miss

* check direction of coding
pwcorr momwarm kidsuffer famsuffer wanthome housesat workbest, obs

* new value labels
label def Lagree 1 1_agree  0 0_not .a a_Unsure ///
    .b b_Refused .n n_Neutral
label def Lprowork 1 1_yesPos  0 0_noNeg .a a_Unsure ///
    .b b_Refused .n n_Neutral

* momwarm: 1=SA working mom can have warm relationship
* Bwarm:   1=agree (not reversed)
recode momwarm (1/2=1) (4/5=0) (3=.n), gen(Bwarm)
label var Bwarm "Working mom can have warm relations?"
label val Bwarm Lprowork
note Bwarm: 3=neutral in source was coded .n \ `tag'
tab Bwarm momwarm, miss

* kidsuffer: 1=SA preschool child suffers with working mom
* Bkids:     1=agree don't suffer (reverse coding)
recode kidsuffer (1/2=0) (4/5=1) (3=.n), gen(Bkids)
label var Bkids "Agree kids don't suffer with working mom?"
label val Bkids Lprowork
note Bkids: 3=neutral in source was coded .n \ `tag'
tab kidsuffer Bkids, miss

* famsuffer: 1=SA family suffers with working mom
* Bfamily:   1=agree don't suffer (reverse coding)
recode famsuffer (1/2=0) (4/5=1) (3=.n), gen(Bfamily)
label var Bfamily "Agree family life doesn't suffer?"
label val Bfamily Lprowork
note Bfamily: 3=neutral in source was coded .n \ `tag'
tab famsuffer Bfamily, miss

* wanthome: 1=SA really wants to stay home
* Bnohome:  1=agree don't want home (reverse coding)
recode wanthome (1/2=0) (4/5=1) (3=.n), gen(Bnohome)
label var Bnohome "Agree women don't want home and kids?"
label val Bnohome Lprowork
note Bnohome: 3=neutral in source was coded .n \ `tag'
tab wanthome Bnohome, miss

* housesat: 1=SA house just as satisfying
* Bjobsat:  1=agree job is satisfying (reverse coding)
recode housesat (1/2=0) (4/5=1) (3=.n), gen(Bjobsat)
label var Bjobsat "Agree paid job satisfies more?"
label val Bjobsat Lprowork
note Bjobsat: 3=neutral in source was coded .n \ `tag'
tab housesat Bjobsat, miss

* workbest: 1=SA work is best for independence
* Bindep:   1=agree job gives indep (not reversed)
recode workbest (1/2=1) (4/5=0) (3=.n), gen(Bindep)
label var Bindep "Agree work creates independence?"
label val Bindep Lprowork
note Bindep: 3=neutral in source was coded .n \ `tag'
tab workbest Bindep, miss

//  #4
//  check that all are coded in same direction

codebook B*, compact
pwcorr B*, obs

//  #5
//  cleanup and save

sort id
quietly compress
label data "Workflow example of adding analysis variables \ `date'"
note: x-wf6-create02-binary.dta \ `tag'
* in stata 10 and later: datasignature set, reset
save x-wf6-create02-binary, replace

clear
use x-wf6-create02-binary
* in stata 10 and later: datasignature confirm
notes
codebook, compact

//  #6
//  check the changes

cf _all using wf-russia02.dta

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
