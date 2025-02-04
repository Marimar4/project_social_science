capture log close
log using wf5-varnotes, replace text

//  program:    wf5-varnotes.do \ for stata 9
//  task:       adding notes to varaibles
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

use wf-names, clear

//  #2
//  example of notes

generate pub9trunc = pub9
replace pub9trunc = 20 if pub9trunc>20 & !missing(pub9trunc)
label var pub9trunc "Pub 9 truncated at 20: PhD yr 7 to 9"
note pub9trunc: pubs>20 recoded to 20 \ wf5-varnotes.do jsl 2008-10-24.
note pub9trunc

//  #3
//  long notes

note pub9trunc: Earlier analyses (pubreg04a.do 2006-09-20) showed  ///
that cases with a large number of articles were outliers. Program  ///
pubreg04b.do 2006-09-21 examined different transformations of pub9 ///
and found that truncation at 20 was most effective at removing     ///
the outliers. \ jsl 2008-10-24.
note pub9trunc

//  #4
//  using TS                                           |  |
//                               You need spaces here  V  V

note pub9trunc: pub9 truncated at 20 \ wf5-varnotes.do jsl TS .
note pub9trunc

//  #5
//  listing selected notes

note list vignum in 2/3

//  #6
//  dropping notes

notes drop vignum in 2/3 // drop some notes
notes drop vignum // drop all notes

//  #7
//  using tags for notes and listing notes with codebook

use wf-names, clear

* create the variables for the example
foreach varname in pub1 pub3 pub6 pub9 {
    clonevar `varname'trunc = `varname'
    replace  `varname'trunc = 20 if `varname'trunc>20 ///
        & !missing(`varname'trunc)
}

* add notes using a local tab
local tag "pub# truncated at 20 \ wf5-varnotes.do jsl 2008-10-24."
note pub1trunc: `tag'
note pub3trunc: `tag'
note pub6trunc: `tag'
note pub9trunc: `tag'
note pub*

* codebook
codebook pub1trunc, notes

//  #9
//  notes in loops

use wf-names, clear
local tag "wf5-varnotes.do jsl 2008-10-24."

foreach varname in pub1 pub3 pub6 pub9 {
    clonevar  `varname'trunc = `varname'
    replace   `varname'trunc = 20 if `varname'trunc>20 ///
        & !missing(`varname'trunc)
    label var `varname'trunc "`varname' truncated at 20"
    note      `varname'trunc: `varname' truncated at 20 \ `tag'
}

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
