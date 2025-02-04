capture log close
log using wf6-review-consistent, replace text

//  program:    wf6-review-consistent.do \ for stata 9
//  task:       Check consistency in science data
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

use wf-acjob, clear
* in stata 10 and later: datasignature confirm

//  #2
//  check citations and publications

* is no articles, there should be no citations
assert cit==0 if art==0

* if there are not citations, there might be articles
* assert art==0 if cit==0    // this would halt execution
assert art==0 if cit==0, rc0 // will not halt execution

* check citations when articles are 0
tabulate cit if art==0, miss

//  #3
//  check if job is more prestigious than doctorate

* how do distributions compare?
compare job phd

* look at difference between phd and job
generate job_phd = job - phd
label var job_phd "job-phd: >0 if better job"

* crude comparisons
inspect job_phd

* list large differences
sort job_phd
list job_phd art ment fem cit fel job phd if job_phd>.6, clean
list job_phd art ment fem cit fel job phd if job_phd<-2, clean

* aside: you can round the differences so that fewer decimal
* digits clutter the output
generate job_phdV2 = round(job - phd,.1)
sort job_phdV2
label var job_phdV2 "job - phd with rounding"
list job_phdV2 `varlist' if job_phd>.5, clean
list job_phdV2 `varlist' if job_phd<-2, clean

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
