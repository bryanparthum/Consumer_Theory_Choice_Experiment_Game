** Written by: Bryan Parthum; bparthum@gmail.com ; September 2020

********************************************************************************
****************************       CLEAN DATA     ******************************
********************************************************************************

** Script: 3_clean_qualtrics_data.do
** Input:  qualtrics_data.csv
** Output: cleaned_data.dta

clear all
set more off

***********************************************
**************************************** IMPORT 
***********************************************

** IMPORT RAW DATA FROM QUALTRICS
import delimited store/qualtrics_data.csv, varnames(1) clear

** CLEAN
drop startdate enddate status ipaddress recordeddate userlanguage ///
     distributionchannel progress locationlatitude locationlongitude responseid finished
	
rename (durationinseconds p1 p2 p3) ///
	   (seconds agriculture rural_urban past_visits)

drop if _n<3

** RECODE
replace past_visits = "5" if past_visits=="more than 5"
replace past_visits = "0" if past_visits==""
destring(past_visits), replace 

replace agriculture = "1" if agriculture=="Yes"
replace agriculture = "0" if agriculture=="No"
destring(agriculture), replace 

replace rural_urban = strtrim(rural_urban)
gen rural = rural_urban=="Rural"

replace externalreference = subinstr(externalreference, ",", "",.) 
replace externalreference = subinstr(externalreference, "$", "",.) 
destring(externalreference), gen(income) force 
drop externalreference

destring(seconds), replace

gen id = _n
order id seconds income agriculture past_visits rural q*

** RESHAPE
reshape long q, i(id) j(card)

** EXAPAND TO ALTERNATIVES
expand 3
bys id card: gen alt = _n
order id card alt

** CREATE CHOICE
gen choice = (alt==1 & q=="Scenario A") | (alt==2 & q=="Scenario B") | (alt==3 & q=="No Change")
order id card alt choice
rename q card_choice

** CREATE INDICATORS OF ATTRIBUTES
** NO CHANGE
gen fish = 5 if alt == 3
gen birds = 50 if alt == 3
gen water = "boatable" if alt == 3
gen asc = alt==1 | alt==2
gen cost = 0 if alt==3

replace fish  = 10 if card == 1 & alt == 1
replace fish  = 20 if card == 1 & alt == 2
replace birds = 125 if card == 1 & alt == 1
replace birds = 75 if card == 1 & alt == 2
replace water = "boatable" if card == 1 & alt == 1
replace water = "swimable" if card == 1 & alt == 2
replace cost  =  100 if card == 1 & alt == 1
replace cost  =  75 if card == 1 & alt == 2

replace fish  = 20 if card == 2 & alt == 1
replace fish  = 10 if card == 2 & alt == 2
replace birds = 150 if card == 2 & alt == 1
replace birds = 125 if card == 2 & alt == 2
replace water = "drinkable" if card == 2 & alt == 1
replace water = "boatable" if card == 2 & alt == 2
replace cost  =  200 if card == 2 & alt == 1
replace cost  =  100 if card == 2 & alt == 2

replace fish  = 30 if card == 3 & alt == 1
replace fish  = 20 if card == 3 & alt == 2
replace birds = 150 if card == 3 & alt == 1
replace birds = 100 if card == 3 & alt == 2
replace water = "drinkable" if card == 3 & alt == 1
replace water = "swimable" if card == 3 & alt == 2
replace cost  = 150 if card == 3 & alt == 1
replace cost  = 200 if card == 3 & alt == 2

replace fish  = 20 if card == 4 & alt == 1
replace fish  = 20 if card == 4 & alt == 2
replace birds = 75 if card == 4 & alt == 1
replace birds = 150 if card == 4 & alt == 2
replace water = "swimable" if card == 4 & alt == 1
replace water = "drinkable" if card == 4 & alt == 2
replace cost  = 75 if card == 4 & alt == 1
replace cost  = 200 if card == 4 & alt == 2

replace fish  = 50 if card == 5 & alt == 1
replace fish  = 50 if card == 5 & alt == 2
replace birds = 200 if card == 5 & alt == 1
replace birds = 200 if card == 5 & alt == 2
replace water = "swimable" if card == 5 & alt == 1
replace water = "drinkable" if card == 5 & alt == 2
replace cost  = 250 if card == 5 & alt == 1
replace cost  = 600 if card == 5 & alt == 2

** BUNDLES FOR TRANSITIVITY
gen bundle = "A" if (card==1 & alt==1) | (card==2 & alt==2)
replace bundle = "B" if (card==1 & alt==2) | (card==4 & alt==1)
replace bundle = "C" if (card==2 & alt==1) | (card==4 & alt==2)
replace bundle = "D" if (card==3 & alt==1)
replace bundle = "E" if (card==3 & alt==2)
replace bundle = "F" if (card==5 & alt==2)
replace bundle = "G" if (card==5 & alt==2)

** TRANSITIVITY 
gen AB = card==1 & choice==1 & alt==1
bys id: egen temp = max(AB)
replace AB = temp
drop temp

gen BA = card==1 & choice==1 & alt==2
bys id: egen temp = max(BA)
replace BA = temp
drop temp

gen AC = card==2 & choice==1 & alt==2
bys id: egen temp = max(AC)
replace AC = temp
drop temp

gen CA = card==2 & choice==1 & alt==1
bys id: egen temp = max(CA)
replace CA = temp
drop temp

gen BC = card==4 & choice==1 & alt==1
bys id: egen temp = max(BC)
replace BC = temp
drop temp

gen CB = card==4 & choice==1 & alt==2
bys id: egen temp = max(CB)
replace CB = temp
drop temp

gen SQA = card==1 & choice==1 & alt==3
bys id: egen temp = max(SQA)
replace SQA = temp
drop temp

gen SQB = card==1 & choice==1 & alt==3
bys id: egen temp = max(SQB)
replace SQB = temp
drop temp

gen SQC = card==4 & choice==1 & alt==3
bys id: egen temp = max(SQC)
replace SQC = temp
drop temp

gen ASQ = card==1 & choice==1 & alt==1
bys id: egen temp = max(ASQ)
replace ASQ = temp
drop temp

gen BSQ = card==1 & choice==1 & alt==2
bys id: egen temp = max(BSQ)
replace BSQ = temp
drop temp

gen CSQ = card==4 & choice==1 & alt==2
bys id: egen temp = max(CSQ)
replace CSQ = temp
drop temp
sum AB BA AC CA BC CB SQA SQB SQC ASQ BSQ CSQ

gen transitive = (AB==1 & BC==1 & AC==1) | ///
				 (AC==1 & CB==1 & AB==1) | ///
                 (BA==1 & AC==1 & BC==1) | ///
				 (BC==1 & CA==1 & BA==1) | ///
				 (CA==1 & AB==1 & CB==1) | ///
				 (CB==1 & BA==1 & CA==1) | ///
				 (SQA==1 & AB==1 & SQB==1) | ///
				 (SQA==1 & AC==1 & SQC==1) | ///
				 (SQB==1 & BA==1 & SQA==1) | ///
				 (SQB==1 & BC==1 & SQC==1) | ///
				 (SQC==1 & CA==1 & SQA==1) | ///
				 (SQC==1 & CB==1 & SQB==1) | ///
				 (ASQ==1 & SQB==1 & AB==1) | ///
				 (ASQ==1 & SQC==1 & AC==1) | ///
				 (BSQ==1 & SQA==1 & BA==1) | ///
				 (BSQ==1 & SQC==1 & BC==1) | ///
				 (CSQ==1 & SQA==1 & CA==1) | ///
				 (CSQ==1 & SQB==1 & CB==1)		

** CODE FOR LOGIT
gen boatable = water=="boatable"
gen swimable = water=="swimable"
gen drinkable = water=="drinkable"
egen g_id = group(id card)

** DOMINATED
gen dominated = card==3 & choice==1 & alt==2
bys id: egen temp1 = max(dominated)
replace dominated = temp1
drop temp1

** DRINK THE RIVER
gen drink_the_river = card==5 & alt==2 & choice==1
bys id: egen temp2 = max(drink_the_river)
replace drink_the_river = temp2
drop temp2

** CLEAN IDENTIFIERS
drop recipientemail recipientfirstname recipientlastname

** LABELS 
lab var income "Income"
lab var agriculture "Works in Agriculture"
lab var past_visits "Past visits"

** EXPORT 
save store\cleaned_data, replace

** END OF SCRIPT. Have a nice day! 
