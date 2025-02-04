capture log close
log using wf5-language, replace text

//  program:    wf5-language.do \ for stata 9
//  task:       multiple languages
//  project:    workflow chapter 5
//  author:     scott long \ 2008-10-24

//  #0
//  setup

version 9.2
set linesize 80
clear // changed to clear all in stata 10
macro drop _all

//  #1
//  managing languages

use wf-languages-spoken, clear
label language
label language english
tabulate male, missing
label language french
tabulate male, missing
label language spanish
tabulate male, missing

//  #2
//  add new languages

* english   french      spanish
* Men       Hommes      Hombres
* Women     Femmes      Mujeres

use wf-languages-single, clear

* english
label language english, new
label define male 0 "0_Women" 1 "1_Men"
label val male male
label var male "Gender of respondent"
* french
label language french, new
label define male_fr 0 "0_Femmes" 1 "1_Hommes"
label val male male_fr
label var male "Genre de répondant"
* spanish
label language spanish, new
label define male_es 0 "0_Mujeres" 1 "1_Hombres"
label val male male_es
label var male "Género del respondedor"

//  #4
//  shorter and long labels // source and analysis languages

use wf-languages-analysis, clear
label language source
describe male warm
tabulate male warm, missing

label language analysis
describe male warm
tabulate male warm, missing

//  #5
//  adding short and long labels

use wf-languages-single, clear
label language analysis, new

log close
exit

2008-10-24 \ initial version for wf09-part#.pkg
