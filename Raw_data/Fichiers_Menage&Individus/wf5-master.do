capture log close master
log using wf5-master, name(master) replace text

//  program:    wf5-master.do \ for stata 9
//  task:       Creating a master log file
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

do wf5-master01-desc.do
do wf5-master02-logit.do
do wf5-master03-tabulate.do

log close master
exit

2008-10-24 \ initial version for wf09-part#.pkg
