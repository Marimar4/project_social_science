capture log close
log using wf6-create, replace text

//  program:    wf6-create.do \ for stata 9
//  task:       Examples of creating new variables
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10 all
macro drop _all

//  #1
//  load data and define tag

local date "2008-10-24"
local tag "wf6-create.do jsl `date'."

use wf-lfp, clear
* in stata 10 and later: datasignature confirm

//  #2
//  changing the meaning of a variable

* estimate a model with lwg equal to the log of wages
logit lfp k5 k618 age wc hc lwg inc
estimates store model_1

* estimate a model with lwg equal to wages
replace lwg = exp(lwg)
logit lfp k5 k618 age wc hc lwg
estimates store model_2

* compare models
estimates table _all, stats(N bic) eform b(%9.3f) t(%6.2f)

//  #3
//  the log of a negative number

generate inclog = log(inc)
label var inclog "log(inc)"
list inc inclog if inc<0, clean

//  #4
//  documenting new variables

generate inc_log5 = ln(inc+.5) if !missing(inc)
label var inc_log5 "Log(inc+.5)"
note inc_log5: log(inc+.5) \ `tag'

//  #5
//  the generate command

use wf-lfp, clear
* in stata 10 and later: datasignature confirm

* transform all values of age
generate agesqrt = sqrt(age)
label var agesqrt "Sqrt(age)"
drop agesqrt

* transform only values of age greater than 5
generate agesqrt = sqrt(age) if age>5
label var agesqrt "Sqrt(age) if age>5"

//  #6
//  clonevar

use wf-lfp, clear
* in stata 10 and later: datasignature confirm

* create a copy of lfp using generate
generate lfp_gen = lfp

* create a copy using clonevar
clonevar lfp_clone = lfp

* comparing the two variables
summarize lfp*
describe lfp*
compare lfp lfp_gen
compare lfp lfp_clone

//  #7
//  replace

use wf-russia01, clear
* in stata 10 and later: datasignature confirm

generate educcat = edyears
label var educcat "Categorized years of education"
replace educcat = 1 if edyears>=0  & edyears<=8   // no HS
replace educcat = 2 if edyears>=9  & edyears<=11  // some HS
replace educcat = 3 if edyears==12                // HS
replace educcat = 4 if edyears>=13 & edyears<=15  // some college
replace educcat = 5 if edyears>=16 & edyears<=24  // college plus

label def educcat 1 1_NoHS 2 2_someHS 3 3_HS 4 4_someCol 5 5_ColPlus ///
     .b b_Refused .c c_DontKnow .d d_AtSchool .e e_AtCollege ///
     .f f_NoFrmlSchl
label val educcat educcat
tab1 edyears educcat, missing

//  #8
//  indicator variable problem with missing values

use wf-russia01, clear
* in stata 10 and later: datasignature confirm

tab1 marstat, miss

* incorrect
generate ismar_wrong = (marstat==1)
label var ismar_wrong "Is married created incorrectly"
label def Lyesno 0 0_no 1 1_yes
label val ismar_wrong Lyesno
tabulate marstat ismar_wrong, miss

* correct
generate ismar_right = (marstat==1) if !missing(marstat)
label var ismar_right "Is married?"
label val ismar_right Lyesno
tabulate marstat ismar_right, miss

* fixing the extended missing value
replace ismar_right = .b if marstat==.b
tabulate marstat ismar_right, miss

//  #9
//  recode

* using recode
recode marstat 1=1 2/5=0, gen(ismar2_right)
label var ismar2_right "Is married?"
tabulate marstat ismar2_right, miss

* reproduce what was done with replace commands in last example
recode edyears 0/8=1 9/11=2 12=3 13/15=4 16/24=5, gen(educcat2)
compare educcat educcat2
tabulate educcat educcat2, miss

* recode 1 to 0 and change all other values (including missing) to 1
recode edyears 1=0 *=1, gen(edtest1)
tabulate edyears edtest1, miss

* recode 1 to 0, else 1 except for missing
recode edyears 1=0 *=1 if !missing(edyears), gen(edtest2)
tabulate edyears edtest2, miss

* keep 1, 2, 3, 4, 5 the same; recode 6-24 to 6, except missing
recode edyears 6/24=6 if !missing(edyears), gen(edtest3)
tabulate edyears edtest3, miss

* recode 1 3 5 7 9 to -1, others unchanged
recode edyears 1 3 5 7 9=-1, gen(edtest4)
tabulate edyears edtest4, miss

* recode 6 to max to 6, others unchanged
recode edyears 6/max=6, gen(edtest5)
tabulate edyears edtest5, miss

//  #10
//  egen to standardize age

use wf-lfp, clear
* in stata 10 and later: datasignature confirm

* standardize using generate and summarize
summarize age
generate agestd = (age - r(mean)) / r(sd)
label var agestd "Age standardized using generate"

* use egenerate std
egen agestdV2 = std(age)
label var agestdV2 "Age standardized using egen"

* compare
compare agestd agestdV2
summarize agestd agestdV2
regress agestdV2 agestd

//  #11
//  egen anycount

* anycount(varlist), values(integer numlist): returns the number of
*   variables in varlist for which values are equal to any of the integer
*   values in a supplied numlist. Values for any observations excluded
*   by either [if] or [in] are set to 0 (not missing).

egen count0 = anycount(lfp k5 k618 age wc hc lwg inc), values(0)
label var count0 "# of 0's in lfp k5 k618 age wc hc lwg inc"
tabulate count0, miss

* computing the same thing with a foreach loop
generate count0v2 = 0
label var count0v2 "v2:# of 0's in lfp k5 k618 age wc hc lwg inc"
foreach var in lfp k5 k618 age wc hc lwg inc {
    replace count0v2 = count0v2 + 1 if `var'==0
}

compare count0 count0v2

//  #12
//  tabulate, generate

use wf-russia01, clear
* in stata 10 and later: datasignature confirm

tabulate marstat, gen(ms_is)

codebook ms_is*, compact
describe ms_is*
summarize ms_is*
tabulate marstat ms_is1, miss

* clean up the variables
label def Lyesno 0 0_no 1 1_yes

rename ms_is1 ms_married
note ms_married: Source var is marstat \ `tag'.
label var ms_married "Married?"
label val ms_married Lyesno
tabulate marstat ms_married, miss

rename ms_is2 ms_widowed
note ms_widowed: Source var is marstat \ `tag'.
label var ms_widowed "Widowed?"
label val ms_widowed Lyesno
tabulate marstat ms_widowed, miss

rename ms_is3 ms_divorced
note ms_divorced: Source var is marstat \ `tag'.
label var ms_divorced "Divorced?"
label val ms_divorced Lyesno
tabulate marstat ms_divorced, miss

rename ms_is4 ms_separated
note ms_separated: Source var is marstat \ `tag'.
label var ms_separated "Seperated?"
label val ms_separated Lyesno
tabulate marstat ms_separated, miss

rename ms_is5 ms_single
note ms_single: Source var is marstat \ `tag'.
label var ms_single "Single?"
label val ms_single Lyesno
tabulate marstat ms_single, miss

notes ms_*

* easy way to check for problems with the indicators
regress ms_married ms_widowed ms_divorced ms_separated ms_single

//  #13
//  estimate two models and compute predictions

use wf-lfp, clear
* in stata 10 and later: datasignature confirm

* model 1
logit lfp k5 k618 age wc hc lwg inc
predict prm1

* model 2
logit lfp age wc hc lwg inc
predict prm2

* check predictions
codebook prm*, compact
nmlab prm*
describe prm*
summarize prm*

//  #14
//  estimate and predict with better labels

use wf-lfp, clear
* in stata 10 and later: datasignature confirm

* model 1
logit lfp k5 k618 age wc hc lwg inc
predict prm1
label var prm1 "Pr(lfp|m1=k5 k618 age wc hc lwg inc)"
note prm1: m1=logit lfp k5 k618 age wc hc lwg inc \ `tag'.

* model 2
logit lfp age wc hc lwg inc
predict prm2
label var prm2 "Pr(lfp|m2=age wc hc lwg inc)"
note prm2: m2=logit age wc hc lwg inc \ `tag'.

* check predictions
codebook prm*, compact
notes prm*

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
