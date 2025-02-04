capture log close
log using wf7-graphs-fontsize, replace text

//  pgm:        wf7-graphs-fontsize.do \ for stata 9
//  task:       fontsize when graphs are resized
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all
set scheme s2manual

//  #1
//  load data

use wf-tenure, clear
* in stata 10 and later: datasignature confirm
sort male
by male: sum tenure

//  #2
//  get mean data to plot

* set up variables
gen Mbg = .
label var Mbg "Men"
gen Wbg = .
label var Wbg "Women"
gen Vbg = .
label var Vbg "Variable"
label def Vbg 0 "Not Distinguished" 1 "Distinguished"
label val Vbg Vbg

* tenure rates for men / high prestige
sum tenure if male==1 & presthi==1
matrix mn = r(mean)
local mn = mn[1,1]*100
replace Mbg = `mn' in 2
replace Vbg = 1 in 2

* tenure rates for men / low prestige
sum tenure if male==1 & presthi==0
matrix mn = r(mean)
local mn = mn[1,1]*100
replace Mbg = `mn' in 1
replace Vbg = 0 in 1

* tenure rates for women / high prestige
sum tenure if male==0 & presthi==1
matrix mn = r(mean)
local mn = mn[1,1]*100
replace Wbg = `mn' in 2
replace Vbg = 1 in 2

* tenure rates for women / low prestige
sum tenure if male==0 & presthi==0
matrix mn = r(mean)
local mn = mn[1,1]*100
replace Wbg = `mn' in 1
replace Vbg = 0 in 1

//  #3
//  bar chart - default font size

set scheme s2manual
graph bar (mean) Mbg (mean) Wbg, over(Vbg) ///
    legend(label(1 Men) label(2 Women)) ytitle("Percent Tenured") ///
    ylabel(0(3)15) legend(label(1 Men) label(2 Women)) ///
    bar(1,fcolor(gs4)) bar(2,fcolor(gs13))
graph export wf7-graphs-fontsize-default.eps, replace

//  #3
//  bar chart - larger font size

graph bar (mean) Mbg (mean) Wbg, over(Vbg, label(labsize(vlarge))) ///
    legend(label(1 Men) label(2 Women)) ytitle("Percent Tenured", size(vlarge)) ///
    ylabel(0(3)15, labsize(large)) legend(label(1 Men) label(2 Women)) ///
    bar(1,fcolor(gs4)) bar(2,fcolor(gs13))
graph export wf7-graphs-fontsize-vlarge.eps, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
