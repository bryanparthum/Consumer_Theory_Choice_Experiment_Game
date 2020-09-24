** Written by: Bryan Parthum; bparthum@gmail.com ; September 2020

********************************************************************************
******************  Generate Incomes and Contact list for Qualtrics Distribution
********************************************************************************

** Script: 1_generate_incomes.do
** Input:  student_roster.xlsx
** Output: student_incomes.csv
  
clear all
set more off

** IMPORT CLASS ROSTER
import excel store/student_roster.xlsx, sheet("student_roster") firstrow clear

** PREPARE EMAIL FOR QUALTRICS CONTACT LIST DISTRIBUTION
rename (Email) (PrimaryEmail)
// replace PrimaryEmail = PrimaryEmail + "@illinois.edu" ** DEPENDING ON HOW YOUR ROSTER IMPORTS, YOU CAN MAKE ADJUSTMENTS HERE

** GENERATE DISTRIBUTION
gen rbeta = rbeta(1,1000)
sort rbeta
gen n = _n
plot rbeta n
sum rbeta, detail 

** CREATE MORE REALISTIC INCOME DISTRIBUTION (THIS MAY TAKE SOME TWEAKING)
replace rbeta = rbeta *1.1 if n>35
replace rbeta = rbeta *1.1 if n>55
replace rbeta = rbeta *1.1 if n>60
replace rbeta = rbeta *1.5 if n>63

** GENERATE ANNUAL INCOME VARIABLE
gen Income = rbeta * 100000000
replace Income = round(Income, 1000) 
replace Income = 10000 if Income < 10000
sum Income, detail 
format Income %13.0fc

** GENERATE ExternalDataReference FOR QUALTRICS CONTACTS LIST 
tostring Income, gen(ExternalDataReference) u force
replace ExternalDataReference = "$" + ExternalDataReference

** KEEP ONLY VARIABLES YOU NEED
keep FirstName LastName PrimaryEmail Income ExternalDataReference

** EXPORT
export delimited using store/student_incomes.csv, replace

** END OF SCRIPT. Have a nice day!!
