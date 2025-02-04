capture log close
log using wf7-replicate-bootstrap, replace text

//  pgm:        wf7-replicate-bootstrap.do \ for stata 9
//  task:       replication and the random number seed
//  project:    workflow chapter 7
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data and estimate the model

use wf-lfp, clear
* in stata 10 and later: datasignature confirm
logit lfp k5 k618 age wc hc lwg inc

//  #2
//  bootstrap CI for prediction with seed 11020
//  note: 100 reps is used for purposes to illustrate a point.
//        For real world applications, 1000 reps is needed!

set seed 11020
prvalue, boot reps(100)

* run prvalue again, without setting the seed
prvalue, boot reps(100)

//  #3
//  bootstrap CI for prediction with seed 1121212
//  note: 100 reps is used for purposes to illustrate a point.
//        For real world applications, 1000 reps is needed!

set seed 1121212
prvalue, boot reps(100)

//  #4
//  bootstrap CI for prediction with seed 1121212
//  same seed, same results
//  note: 100 reps is used for purposes to illustrate a point.
//        For real world applications, 1000 reps is needed!

prvalue, boot reps(100)

//  #5
//  with 1000 replications, results are much more similar but it
//  takes ten times longer to run
/*
set seed 11020
prvalue, boot reps(1000)
set seed 1121212
prvalue, boot reps(1000)
*/

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
