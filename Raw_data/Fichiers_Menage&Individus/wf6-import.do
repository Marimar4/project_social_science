capture log close
log using wf6-import, replace text

//  program:    wf6-import.do \ for stata 9
//  task:       using insheet and fdause
//  project:    workflow chapter 6
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  load and look at data with insheet

insheet using wf6-import-free.txt, clear
list vid-vempstat in 1/7, clean

* clear memory
clear // changed to clear all in stata 10

//  #2
//  load and look at data in fda format

fdause wf6-import-fdause.xpt, clear
list  vid vmomwarm vkidsuff vfamsuff vwanthom in 1/7, clean

* clear memory
clear // changed to clear all in stata 10

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
