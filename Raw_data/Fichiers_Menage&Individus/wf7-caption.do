capture log close
log using wf7-caption, replace text

//  pgm:        wf7-caption.do \ for stata 9
//  task:       adding a caption to show graph surce
//  project:    workflow chapter 7
//  author:     jsl / 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all
set scheme s2manual

//  #1
//  create data to plot

clear
set obs 51
generate articles = _n - 1
label var articles "Number of publications"

* art_root# = (articles)^(1/#)
forvalues r = 1(1)5 {
    * take to the 1/r power
    gen art_root`r' = articles^(1/`r')
    label var art_root`r' "articles^(1/`r')"
}
label var art_root2 "2nd root"
label var art_root3 "3rd root"
label var art_root4 "4th root"
label var art_root5 "5th root"

//  #2
//  plot results without caption

twoway (line art_root2 art_root3 art_root4 art_root5 articles,       ///
    lwidth(medium)), ytitle(Number of Publications to the k-th Root) ///
    yscale(range(0 8.)) legend(pos(11) rows(4) ring(0))
graph export wf7-caption-without.eps, replace

//  #3
//  plot results with caption

twoway (line art_root2 art_root3 art_root4 art_root5 articles,       ///
    lwidth(medium)), ytitle(Number of Publications to the k-th Root) ///
    yscale(range(0 8.)) legend(pos(11) rows(4) ring(0))              ///
    caption(wf7-caption.do jsl 2008-10-24, size(vsmall))
graph export wf7-caption-with.eps, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
