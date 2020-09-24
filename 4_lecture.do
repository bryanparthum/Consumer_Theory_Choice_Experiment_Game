** Written by: Bryan Parthum; bparthum@gmail.com ; September 2020

********************************************************************************
****************************        ANALYZE      *******************************
********************************************************************************

** Script: 4_analyze.do
** Input:  cleaned_data.csv

clear all
set more off

**********************************************
**************************  IN CLASS SUMMARIES 
**********************************************

** LOAD FILE FROM GENERATE.DO
use store\cleaned_data, clear 

** INCOME DISTRIBUTION
sum income, d
// replace income = income/1000
sort income
cumul income, gen(cu_income)
line cu_income income, title("Cumulative Distribution of Income") xlab(#7, format(%12.0gc) angle(45)) xti("Income ($)") c(J) 

** TRANSITIVE	 
tempfile trans
save `trans'
duplicates drop id, force 
sum transitive
use `trans', clear

** TRANSITIVE COVARIATES (LPM)
tempfile trans2
save `trans2', replace
duplicates drop id, force 
replace income = income/1000
reg transitive income, r
use `trans2', clear

** DOMINATED
tempfile dominated
save `dominated'
duplicates drop id, force 
sum dominated
use `dominated', clear 

** DOMINATED COVARIATES (LPM)
tempfile dominated2
save `dominated2'
duplicates drop id, force 
replace income = income/1000
replace seconds = seconds/1000
reg dominated income seconds, r 
use `dominated2', clear 

** DRINK THE RIVER BY INCOME (LPM)
tempfile drink
save `drink'
duplicates drop id, force 
replace income = income/1000
reg drink_the_river income past_visits, r
use `drink', clear 

*******************************
************  UTILITY FUNCTIONS
*******************************

** Install mixlogit
// ssc install mixlogit 

** MIXL
global randvars "fish birds swimable drinkable"
mixlogit choice cost, rand($randvars) group(g_id) id(id) nrep(50)

** RECOVER INDIVIDUAL MARGINAL UTILITIES (CONDITIONAL EXPECTATIONS)
mixlbeta cost fish birds swimable drinkable, sav(store/wtp) replace

** MIXL WITH RURAL
gen rural_fish = rural*fish
global randvars "fish rural_fish birds swimable drinkable"
mixlogit choice cost, rand($randvars) group(g_id) id(id) nrep(50)

*******************************
************************ DEMAND
*******************************

** LOAD ESTIMATES FROM ABOVE
use store/wtp, clear 

** GENERATE WTP
gen wtp_fish = -fish/cost
gen wtp_birds = -birds/cost
gen wtp_swim = -swimable/cost
gen wtp_drink = -drinkable/cost

** SIMPLE SUMMARY OF WTP
sum wtp_fish wtp_birds wtp_swim wtp_drink

** PLOT THE DISTRIBUTION OF WTP FOR FISH AND BIRDS
kdensity wtp_fish, generate(x0 y0) nograph
kdensity wtp_birds , generate(x1 y1) nograph
sum wtp_fish
sca mean_wtp_fish = round(r(mean),0.01)
sum wtp_birds
sca mean_wtp_birds = round(r(mean),0.01)
twoway 	(area y0 x0, color(blue%30)) ///
		(area y1 x1, color(green%30)), ///
		title("Willingness to Pay for Biodiversity") ///
		xtitle("WTP") xtick(#4) xmtick(#8,grid) xline(`=mean_wtp_fish', lcolor(blue%70)) xline(`=mean_wtp_birds', lcolor(green%70)) ///
		ytitle("Percent") ytick(#3) ///
		legend(order(1 "Fish" 2 "Birds") pos(6) r(1)) ///
		text(0.05 `=mean_wtp_fish' "`=mean_wtp_fish'", color(blue)) ///
		text(0.05 `=mean_wtp_birds' "`=mean_wtp_birds'", color(green))

** PLOT THE DISTRIBUTION OF WTP FOR WATER QUALITY
kdensity wtp_swim, generate(x00 y00) nograph
kdensity wtp_drink , generate(x11 y11) nograph
sum wtp_swim
sca mean_wtp_swim = round(r(mean),1)
sum wtp_drink
sca mean_wtp_drink = round(r(mean),1)
twoway 	(area y00 x00, color(blue%30)) ///
		(area y11 x11, color(green%30)), ///
		title("Willingness to Pay for Water Quality") ///
		xtitle("WTP") xtick(#4) xmtick(#8,grid) xline(`=mean_wtp_swim', lcolor(blue%70)) xline(`=mean_wtp_drink', lcolor(green%70)) ///
		ytitle("Percent") ytick(#3) ///
		legend(order(1 "Swimable" 2 "Drinkable") pos(6) r(1)) ///
		text(0.002 `=mean_wtp_swim' "`=mean_wtp_swim'", color(blue)) ///
		text(0.002 `=mean_wtp_drink' "`=mean_wtp_drink'", color(green))
		
** DEMAND CURVES

** PLOT DEMAND CURVE FOR FISH
gsort -wtp_fish
gen q_fish = _n
line wtp_fish q_fish if wtp_fish>0, xti("Quantity (# of Fish)") yti("Price ($)") ti("Willingness to Pay for Fish")

** PLOT DEMAND CURVE FOR BIRDS
gsort -wtp_birds
gen q_birds = _n
line wtp_birds q_birds if wtp_birds>0, xti("Quantity (# of Birds)") yti("Price ($)") ti("Willingness to Pay for Birds")

** PLOT DEMAND CURVE FOR SWIMMING IN THE RIVER
gsort -wtp_swim
gen q_swim = _n
line wtp_swim q_swim if wtp_swim>0, xti("Quantity (# of Donations)") yti("Price ($)") ti("Willingness to Pay to Swim in the River")

** PLOT DEMAND CURVE FOR DRINKING THE RIVER
gsort -wtp_drink
gen q_drink = _n
line wtp_drink q_drink if wtp_drink>0, xti("Quantity (# of Donations)") yti("Price ($)") ti("Willingness to Pay to Drink the River")
		
** END OF SCRIPT. Have a nice day! 
