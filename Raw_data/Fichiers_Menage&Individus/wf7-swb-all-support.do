capture log close master
log using swb-all, name(master) replace text

//  program:    swb-all.do \ for stata 9
//  task:       swb revisons
//  project:    workflow - chapter 7
//  author:     scott long \ 2008-10-24

* task 01: descriptive statistics and data checking
do swb-01a-desc.do
do swb-01b-descmisc.do
do swb-01c-barchart.do

* task 02: logit - sexual relationships
do swb-02aV2-srlogit.do
do swb-02b-srlogit-checkage.do
do swb-02c-srlogit-ageplot.do

* task 03: logit - own sexuality
do swb-03a-os2logit.do
do swb-03b-os2Vos1logit.do

* task 04: logit - self attractiveness
do swb-04a-salogit.do

* task 05: logit - miscellaneous
do swb-05a-sr-os2-cor.do

log close master
exit

2008-10-24 \ initial version for wf09-part#.pkg
