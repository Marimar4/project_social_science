capture log close
log using wf5-master02-logit, replace text

//  program:    wf5-master02-logit.do \ for stata 9
//  task:       Logit of lfp for wf-lfp
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load data

use wf-lfp, replace
* in stata 10 and later: datasignature confirm

//  #2
//  run logit model M1

logit lfp k5 k618 age wc hc lwg inc
predict prM1

* in stata 10 and later: datasignature set, reset
label data "temporary file used by wf5-master02.do & wf5-master03.do"
save x-wf5-master02, replace

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
