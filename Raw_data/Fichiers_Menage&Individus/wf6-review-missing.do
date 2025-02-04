capture log close
log using wf6-review-missing, replace text

//  program:    wf6-review-missing.do \ for stata 9
//  task:       Operations with missing values
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-missing, clear
* in stata 10 and later: datasignature confirm

//  #2
//  look at the distribution of articles

tabulate art, missing
tabulate art
summarize art

//  #3
//  recode large numbers to 5

generate art_tr5 = art
replace art_tr5 = 5 if art>5
label var art_tr5 "trunc at 5 # of articles published"
summarize art art_tr5
set linesize 100
tabulate art art_tr5, missing

* selecting valid cases with comparisons
generate art_tr5V2 = art
replace art_tr5V2 = 5 if art>5 & art<.
label var art_tr5V2 "trunc at 5 # of articles published"
note art_tr5V2: created using art<.
tabulate art_tr5V2, missing

* selecting valid cases with the missing function
generate art_tr5V3 = art
replace art_tr5V3 = 5 if art>5 & !missing(art)
label var art_tr5V3 "trunc at 5 # of articles published"
note art_tr5V3: created using !missing(art)
tabulate art_tr5V3, missing

//  #4
//  create a missing value indicator

generate art_ismiss = missing(art)
label var art_ismiss "art is missing?"
label def Lismiss 0 0_valid 1 1_missing
label val art_ismiss Lismiss
tabulate art art_ismiss, missing

//  #5
//  listing only missing values

tab1 phd if missing(phd), miss
tab1 phd art cit if missing(phd), missing

foreach varname in phd art cit {
    tab1 `varname' if missing(`varname'), missing
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
