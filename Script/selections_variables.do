global chemin "C:\Users\gnint\OneDrive\Bureau\project_social_science\Raw_data\Fichiers_Menage&Individus\"


**********************Chargez la section 0 *********************************
****************************************************************************

 
use "$chemin\s00_me_SEN2021.dta" , clear

** creer l'identifiant unique des ménages
egen menage_id = group(grappe menage)
duplicates list menage_id // vérifier l'existence des doublons

** voir si un menage est enqueté sur deux vagues
gen vague1 = (vague == 1)
gen vague2 = (vague == 2)
tab vague1 vague2  // c'est bon

** Combien y a-t-il d'observations ? 

tab grappe // nbre de grappe

tab s00q08 // nbre de ménage + ménage de remplacement

tab s00q09 // motif de perte

tab s00q07d // menage enqueté en 2019

tab s00q08 s00q07d // menage enqueté en 2019 sans remplacement

** milieu de residence
codebook s00q04




**********************Chargez la section 1; caractéristique sociodémagraphiques des ménages *********************************
**************************************************************

use "$chemin\s01_me_SEN2021.dta" , clear

describe

** creer l'identifiant unique des individus
egen menage_id = group(grappe menage)
egen individu_id = group(grappe menage s01q00a)
duplicates list individu_id

** variable age


*** age à partir de la date de naissance

codebook s01q03c // on a 20,046 NA

count if s01q03c==. & s01q04a==. // dont 15202 n'ont pas déclaré leur age

// en effet ces individus (15202) sont ceux qui n'ont plus dans le ménages au moments de l'enquête:

 tab s01q00aa, missing

// on les supprime car aucune info par la suite dans cette section
 
 drop if s01q00aa==2
 
 // traitement des 4844 restants : on fait fois à la date de naissance
		
		// pour les NA de date de naissance on remplace par l'info de l'age


gen age= s01q04a 

replace age= 2022- s01q03c +1 if s01q03c!=.  

codebook age 
 
*** recherche de la coherence de l'age



 
**** en utilisant le lien avec le CM

//Étape 1 : Créer une variable qui garde l'âge du CM
gen age_cm = . 
bysort s01q02: replace age_cm = age if s01q02 == 1

//Étape 2 : Propager l'âge du CM aux enfants (lienn == 3)
bysort menage_id (s01q02): replace age_cm = age_cm[_n-1] if s01q02 == 3

// Étape 3 : Vérifier si l'âge de l'enfant est supérieur à celui du CM
gen enfant_plus_age = (age > age_cm) & s01q02 == 3

//Étape 4 : Filtrer les résultats

codebook enfant_plus_age // il n'ya pas d'enfnat du CM qui soit plus agé que le CM




**** en regardant si son père est dans le ménage s01q22 s01q23 

codebook s01q22 // 24103 vivent avec leur père

* Étape 1 : Créer une copie de la base pour l'auto-jointure
preserve

* Ne garder que les individus qui sont des pères (c'est-à-dire ceux dont l'ID peut être utilisé pour lier aux enfants)
keep if s01q22 == 1  // Ne garder que ceux dont le père est présent
keep menage_id s01q00a age  // Garder seulement les variables nécessaires

* Renommer pour préparer la jointure
rename s01q00a s01q23   // On renomme pour que s01q23 corresponde à l'ID du père
rename age age_pere        // On renomme l'âge pour éviter les conflits lors du merge

* Sauvegarder temporairement cette base des pères
tempfile fathers
save `fathers'

restore  // Revenir à la base initiale

* Étape 2 : Faire une jointure pour récupérer l'âge du père

preserve
merge m:1 menage_id s01q23 using `fathers', keep(match master) nogen

* Étape 3 : Comparer l'âge de l'enfant avec celui du père
*drop enfant_plus_age_pere
gen enfant_plus_age_pere = (age > age_pere) if s01q29 == 1

* Étape 4 : Afficher les cas où l'enfant est plus âgé que son père
codebook enfant_plus_age_pere // il n'ya pas d'enfant avec son père dans le ménage qui le dépasse en age

/// le plus jeune papa à 15 ans 
restore







**** en regardant si sa mère est dans le ménage s01q29 s01q30

codebook s01q29 // 24103 vivent avec leur mère


* Étape 1 : Créer une copie de la base pour l'auto-jointure
preserve

* Ne garder que les individus qui sont des mères (c'est-à-dire ceux dont l'ID peut être utilisé pour lier aux enfants)
keep if s01q29 == 1  // Ne garder que ceux dont le mère est présent
keep menage_id s01q00a age  // Garder seulement les variables nécessaires

* Renommer pour préparer la jointure
rename s01q00a s01q30   // On renomme pour que s01q30 corresponde à l'ID du père
rename age age_mere        // On renomme l'âge pour éviter les conflits lors du merge

* Sauvegarder temporairement cette base des mères
tempfile mothers
save `mothers'

restore  // Revenir à la base initiale

* Étape 2 : Faire une jointure pour récupérer l'âge du père

preserve
merge m:1 menage_id s01q30 using `mothers', keep(match master) nogen

* Étape 3 : Comparer l'âge de l'enfant avec celui du père
//drop enfant_plus_age_mere
gen enfant_plus_age_mere = (age > age_mere) if s01q29 == 1

* Étape 4 : Afficher les cas où l'enfant est plus âgé que sa mère
codebook enfant_plus_age_mere // il n'ya pas d'enfant avec sa mère dans le ménage qui le dépasse en age

/// la plus jeune maman à 13 ans 
restore




















********************************************************************************************************************************************
********************************************************************

** selection des individus dans la base
********************************************************************************************************************************************
*********************************************************************



 
 
 
 
 **********************Chargez la section 1*********************************

*********************** recuperer les variables dans la section 0 *****
preserve  // Sauvegarde temporaire de l'état initial

use "$chemin\s00_me_SEN2021.dta", clear
* Créer menage_id
egen menage_id = group(grappe menage)

* Garder uniquement les variables nécessaires pour le merge

keep menage_id s00q01 s00q02 s00q04 s00q07b s00q08  // region, dept, milieu de residence,  y vivre depuis moins de 5 ans, resultat interview

* Sauvegarde temporaire
tempfile section0_temp
save `section0_temp'

restore  // Retourne à l'état initial



/***** recuperer les infos sur le pere dans la section 2 et section emploi (4a)pour completer son niveau d'instruction et sa csp dans la section 1

rester dans la section 1 et recuper la situation mat du pere quand il est dans le foyer ainsi que celui de la mère. et aussi une variable de controle est ce que le conjoint vit il dans le ménage pour chaque conjoint. Aussi recuperer ces information pour le CM  
****/




preserve

/////////////////////////// PERE SECTION 2

use "$chemin\s02_me_SEN2021.dta",clear
keep grappe menage s01q00a s02q29 s02q33
* Sauvegarde temporaire de la base de la section 2
tempfile section2_temp
save `section2_temp', replace

use "$chemin\s01_me_SEN2021.dta", clear
keep grappe menage s01q00a s01q07 s01q08 s01q23 s01q25


merge m:1 grappe menage s01q00a using `section2_temp'
// pour merger les deux bases

drop _merge

tempfile section1_info_pere_temp
save `section1_info_pere_temp'


* Dupliquer la base pour isoler les pères

use `section1_info_pere_temp', clear
keep grappe menage s01q00a s01q07 s01q08 s02q29  s02q33 // On garde seulement les variables nécessaires
rename s01q00a s01q23  // Renommer pour fusionner correctement
rename s01q07 s01q07_pere   // Renommer pour éviter conflits
rename s01q08 s01q08_pere   // Renommer pour éviter conflits
rename s02q29 s02q29_pere   // Renommer pour éviter conflits
rename s02q33 s02q33_pere // pour controle apres
save "$chemin\temp_pere.dta", replace


use `section1_info_pere_temp', clear
* Fusionner pour récupérer le niveau d'étude du père
merge m:1 grappe menage s01q23 using "$chemin\temp_pere.dta"

decode s01q25, gen(s01q25_label)
decode s02q29_pere, gen(s02q29_pere_label)

* Mettre à jour s01q25 avec le niveau d’étude du père
replace s01q25_label = s02q29_pere_label if _merge == 3 & s02q29_pere != .

drop if missing(s01q00a)


//encode s01q25_label, gen(s01q25_corrected)
drop s01q25
rename s01q25_label s01q25

keep grappe menage s01q00a s01q07_pere s01q08_pere s01q25 s02q33_pere
tempfile section2_pere_temp
save `section2_pere_temp', replace





/////////////////////////// MERE SECTION 2



use "$chemin\s01_me_SEN2021.dta", clear
keep grappe menage s01q00a s01q07 s01q08 s01q30 s01q32


merge m:1 grappe menage s01q00a using `section2_temp'

drop _merge

tempfile section1_info_mere_temp
save `section1_info_mere_temp'

use `section1_info_mere_temp', clear

* Dupliquer la base pour isoler les mères

keep grappe menage s01q00a s01q07 s01q08 s02q29  s02q33 // On garde seulement les variables nécessaires
rename s01q00a s01q30  // Renommer pour fusionner correctement
rename s01q07 s01q07_mere   // Renommer pour éviter conflits
rename s01q08 s01q08_mere   // Renommer pour éviter conflits
rename s02q29 s02q29_mere   // Renommer pour éviter conflits
rename s02q33 s02q33_mere // pour controle apres
save "$chemin\temp_mere.dta", replace

use `section1_info_mere_temp', clear
* Fusionner pour récupérer le niveau d'étude du mère IIIIK
merge m:1 grappe menage s01q30 using "$chemin\temp_mere.dta"

decode s01q32, gen(s01q32_label)
decode s02q29_mere, gen(s02q29_mere_label)

* Mettre à jour s01q25 avec le niveau d’étude du père
replace s01q32_label = s02q29_mere_label if _merge == 3 & s02q29_mere != .

drop if missing(s01q00a)


//encode s01q25_label, gen(s01q25_corrected)
drop s01q32
rename s01q32_label s01q32

keep grappe menage s01q00a s01q07_mere s01q08_mere s01q32 s02q33_mere
tempfile section2_mere_temp
save `section2_mere_temp', replace


/////////////////////////// PERE SECTION 4A



use "$chemin\s04a_me_SEN2021.dta",clear
keep grappe menage s01q00a s04q18b // juste pour la CSP
* Sauvegarde temporaire
tempfile section4a_temp
save `section4a_temp', replace

use "$chemin\s01_me_SEN2021.dta", clear
keep grappe menage s01q00a s01q23 s01q27


merge m:1 grappe menage s01q00a using `section4a_temp'

drop _merge

tempfile section4_info_pere_temp
save `section4_info_pere_temp'


* Dupliquer la base pour isoler les pères

use `section4_info_pere_temp', clear
keep grappe menage s01q00a s04q18b // On garde seulement les variables nécessaires
rename s01q00a s01q23  // Renommer pour fusionner correctement
rename s04q18b s04q18b_pere   // Renommer pour éviter conflits

save "$chemin\temp_pere.dta", replace


use `section4_info_pere_temp', clear
* Fusionner pour récupérer le niveau d'étude du père
merge m:1 grappe menage s01q23 using "$chemin\temp_pere.dta"

decode s01q27, gen(s01q27_label)
decode s04q18b_pere, gen(s04q18b_pere_label)

* Mettre à jour s01q25 avec le niveau d’étude du père
replace s01q27_label = s04q18b_pere_label if _merge == 3 

drop if missing(s01q00a)


//encode s01q27_label, gen(s01q27_corrected)
drop s01q27
rename s01q27_label s01q27

keep grappe menage s01q00a s01q27 
tempfile section4a_pere_temp
save `section4a_pere_temp', replace


/////////////////////////// MERE SECTION 4



use "$chemin\s01_me_SEN2021.dta", clear
keep grappe menage s01q00a s01q30 s01q32 s01q34


merge m:1 grappe menage s01q00a using `section4a_temp'

drop _merge

tempfile section4_info_mere_temp
save `section4_info_mere_temp'

* Dupliquer la base pour isoler les mères

use `section4_info_mere_temp', clear
keep grappe menage s01q00a s04q18b // On garde seulement les variables nécessaires
rename s01q00a s01q30  // Renommer pour fusionner correctement
rename s04q18b s04q18b_mere   // Renommer pour éviter conflits

save "$chemin\temp_mere.dta", replace

use `section4_info_mere_temp', clear

* Fusionner pour récupérer le niveau d'étude du mère
merge m:1 grappe menage s01q30 using "$chemin\temp_mere.dta"

decode s01q34, gen(s01q34_label)
decode s04q18b_mere, gen(s04q18b_mere_label)

* Mettre à jour s01q34 avec le niveau d’étude du mère
replace s01q34_label = s04q18b_mere_label if _merge == 3 

drop if missing(s01q00a)


//encode s01q27_label, gen(s01q27_corrected)
drop s01q34
rename s01q34_label s01q34

keep grappe menage s01q00a s01q34 
tempfile section4a_mere_temp
save `section4a_mere_temp', replace




******************* recupererles variables faut dans la section 1 ****




use "$chemin\s01_me_SEN2021.dta", clear
* Créer menage_id
egen menage_id = group(grappe menage)
egen individu_id = group(grappe menage s01q00a)

* suppression des ind qui ne sont pas dans le menages au moment de l'enquête : on les supprime car aucune info par la suite dans cette section
 
 drop if s01q00aa==2
 
* creation de la var age
 gen age= s01q04a 

replace age= 2022- s01q03c +1 if s01q03c!=.

* creation age du cm
gen age_cm = . 
bysort s01q02: replace age_cm = age if s01q02 == 1
bysort menage_id (s01q02): replace age_cm = age_cm[_n-1] if s01q02 != 1

* creation sit mat du cm
decode s01q07, gen(s01q07_label)
gen s01q07_cm = ""
bysort s01q02: replace s01q07_cm = s01q07_label if s01q02 == 1
bysort menage_id (s01q02): replace s01q07_cm = s01q07_cm[_n-1] if s01q02 != 1

* creation sit mat du cm
decode s01q08, gen(s01q08_label)
gen s01q08_cm = ""
bysort s01q02: replace s01q08_cm = s01q08_label if s01q02 == 1
bysort menage_id (s01q02): replace s01q08_cm = s01q08_cm[_n-1] if s01q02 != 1


//NB: ON REVIENDRA SI LA SIT MAT DU PERE OU DE LA MERE EST INTERESSANTE  s01q07 s01q08


* conserver les var qui interessent

keep grappe menage s01q00a menage_id individu_id s01q01 s01q02 age age_cm s01q05 s01q07 s01q08 s01q07_cm s01q08_cm s01q14 s01q15 s01q22 s01q23 s01q24 s01q26 s01q29 s01q30 s01q31 s01q33 




* Réaliser le merge avec la base des ménages
//merge m:1 menage_id using `section0_temp' `section2_mere_temp' `section4a_mere_temp' `section2_pere_temp' `section4a_pere_temp'
 
//mon pb commence ici essaye de voir comment tout lier
merge m:1 grappe menage s01q00a using `section2_mere_temp', nogen
merge m:1 grappe menage s01q00a using `section4a_mere_temp', nogen
merge m:1 grappe menage s01q00a using `section2_pere_temp', nogen
merge m:1 grappe menage s01q00a using `section4a_pere_temp', nogen
merge m:1 menage_id using `section0_temp', nogen

* Vérifier les résultats
//tab _merge

keep if inrange(age, 6, 25)

save "$chemin\sectionO1_select.dta", replace

restore  // Retourne à l'état initial


































/*
***** recuperer les infos sur le Mere dans la section 2 et section emploi pour complter son niveau d'instruction et sa csp dans la section 1****




/////////////////////////// MERE SECTION 2

preserve

use "$chemin\s02_me_SEN2021.dta",clear
keep grappe menage s01q00a s02q29 s02q33
* Sauvegarde temporaire
tempfile section2_temp
save `section2_temp', replace

use "$chemin\s01_me_SEN2021.dta", clear
keep grappe menage s01q00a s01q30 s01q32


merge m:1 grappe menage s01q00a using `section2_temp'

drop _merge

tempfile section1_info_mere_temp
save `section1_info_mere_temp'

use `section1_info_mere_temp', clear

* Dupliquer la base pour isoler les mères

keep grappe menage s01q00a s02q29  s02q33 // On garde seulement les variables nécessaires
rename s01q00a s01q30  // Renommer pour fusionner correctement
rename s02q29 s02q29_mere   // Renommer pour éviter conflits
rename s02q33 s02q33_mere // pour controle apres
save "$chemin\temp_mere.dta", replace

use `section1_info_mere_temp', clear
* Fusionner pour récupérer le niveau d'étude du mère IIIIK
merge m:1 grappe menage s01q30 using "$chemin\temp_mere.dta"

decode s01q32, gen(s01q32_label)
decode s02q29_mere, gen(s02q29_mere_label)

* Mettre à jour s01q25 avec le niveau d’étude du père
replace s01q32_label = s02q29_mere_label if _merge == 3 & s02q29_mere != .

drop if missing(s01q00a)


//encode s01q25_label, gen(s01q25_corrected)
drop s01q32
rename s01q32_label s01q32

keep grappe menage s01q00a s01q32 s02q33_mere
tempfile section2_mere_temp
save `section2_mere_temp', replace
restore



/////////////////////////// MERE SECTION 4


preserve

use "$chemin\s04a_me_SEN2021.dta",clear
keep grappe menage s01q00a s04q18b // juste pour la CSP
* Sauvegarde temporaire
tempfile section4a_temp
save `section4a_temp', replace

use "$chemin\s01_me_SEN2021.dta", clear
keep grappe menage s01q00a s01q30 s01q32 s01q34


merge m:1 grappe menage s01q00a using `section4a_temp'

drop _merge

tempfile section4_info_mere_temp
save `section4_info_mere_temp'

* Dupliquer la base pour isoler les mères

use `section4_info_mere_temp', clear
keep grappe menage s01q00a s04q18b // On garde seulement les variables nécessaires
rename s01q00a s01q30  // Renommer pour fusionner correctement
rename s04q18b s04q18b_mere   // Renommer pour éviter conflits

save "$chemin\temp_mere.dta", replace

use `section4_info_mere_temp', clear

* Fusionner pour récupérer le niveau d'étude du mère
merge m:1 grappe menage s01q30 using "$chemin\temp_mere.dta"

decode s01q34, gen(s01q34_label)
decode s04q18b_mere, gen(s04q18b_mere_label)

* Mettre à jour s01q34 avec le niveau d’étude du mère
replace s01q34_label = s04q18b_mere_label if _merge == 3 

drop if missing(s01q00a)


//encode s01q27_label, gen(s01q27_corrected)
drop s01q34
rename s01q34_label s01q34

keep grappe menage s01q00a s01q34 
tempfile section4a_mere_temp
save `section4a_mere_temp', replace
restore













******************* recupererles variables faut dans la section 1 ****






preserve  // Sauvegarde temporaire de l'état initial

use "$chemin\s01_me_SEN2021.dta", clear
* Créer menage_id
egen menage_id = group(grappe menage)
egen individu_id = group(grappe menage s01q00a)

* suppression des ind qui ne sont pas dans le menages au moment de l'enquête : on les supprime car aucune info par la suite dans cette section
 
 drop if s01q00aa==2
 
* creation de la var age
 gen age= s01q04a 

replace age= 2022- s01q03c +1 if s01q03c!=.

* creation age du cm
gen age_cm = . 
bysort s01q02: replace age_cm = age if s01q02 == 1
bysort menage_id (s01q02): replace age_cm = age_cm[_n-1] if s01q02 != 1

* creation sit mat du cm

gen sitmat_cm = . 
bysort s01q02: replace sitmat_cm = s01q07 if s01q02 == 1
bysort menage_id (s01q02): replace sitmat_cm = sitmat_cm[_n-1] if s01q02 != 1









//NB: ON REVIENDRA SI LA SIT MAT DU PERE OU DE LA MERE EST INTERESSANTE  s01q07 s01q08


* conserver les var qui interessent

keep menage_id individu_id s01q01 s01q02 age age_cm s01q05 s01q07 s01q08 s01q14 s01q15 s01q22 s01q23 s01q24 s01q26 s01q29 s01q30 s01q31 s01q33 




* Réaliser le merge avec la base des ménages
//merge m:1 menage_id using `section0_temp' `section2_mere_temp' `section4a_mere_temp' `section2_pere_temp' `section4a_pere_temp'
 
mon pb commence ici essaye de voir comment tout lier
merge m:1 grappe menage s01q00a using `section2_mere_temp', nogen
merge m:1 menage_id using section4a_mere_temp, nogen
merge m:1 menage_id using section2_pere_temp, nogen
merge m:1 menage_id using section4a_pere_temp, nogen
merge m:1 menage_id using `section0_temp', nogen

* Vérifier les résultats
tab _merge

keep if inrange(age, 6, 25)

save "$chemin\sectionO1_select.dta", replace

restore  // Retourne à l'état initial




*/




















 **********************Chargez la section 2*********************************
 
 

preserve  // Sauvegarde temporaire de l'état initial

use "$chemin\sectionO1_select.dta", clear

* Garder uniquement les variables nécessaires pour le merge

keep individu_id age // n'oubli pas d'enlever l'age apres

* Sauvegarde temporaire
tempfile section01_temp
save `section01_temp'

restore  // Retourne à l'état initial


 

preserve  // Sauvegarde temporaire de l'état initial
use "$chemin\s02_me_SEN2021.dta", clear
* Créer menage_id
egen menage_id = group(grappe menage)
egen individu_id = group(grappe menage s01q00a)

keep grappe menage s01q00a menage_id individu_id s02q00 s02q01__1 s02q01__2 s02q01__3 s02q02__1 s02q02__2 s02q02__3 s02q02a__1 s02q02a__2 s02q02a__3 s02q03 s02q04 s02q04_autre s02q04b s02q05 s02q06 s02q07 s02q08 s02q09 s02q09_autre s02q10 s02q11 s02q11_autre s02q12 s02q12a s02q13 s02q13_autre s02q14 s02q16 s02q20 s02q21 s02q22 s02q23 s02q24 s02q25 s02q26 s02q27 s02q28 s02q29 s02q30 s02q30_autre s02q31 s02q32 s02q33 s02q33


* Réaliser le merge avec la section 1 pour recuperer l'age
merge m:1 individu_id using `section01_temp'

keep if inrange(age, 6, 25)


save "$chemin\section2_select.dta", replace

restore