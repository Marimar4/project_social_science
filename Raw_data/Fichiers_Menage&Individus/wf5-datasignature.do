capture log close
log using wf5-datasignature, replace text

//  program:    wf5-datasignature.do \ for stata 9
//  task:       using datasignature
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  note:       The datasignature command in Stata 9 is was undocumented and
//              difficult to use effectively for data management. The revised
//              datasignature command in Stata 10 is an essential part of an
//              effective workflow. For details, see the Workflow book.

//  note:       This example only works in Stata 10.

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
