/*------------------------------------------------------
File: 03-female-labour-force.do
Purpose: To Plot Female LFPR using EUS and PLFS between 1993-94 and 2022-23 for ICSE paper
Author: Sarika Chaudhary 
Date: 20/08/2024
------------------------------------------------------*/

capture log close
clear all
set more off

global path  "/Users/sarika/Library/CloudStorage/OneDrive-Personal/01-projects/icse/"

* Step 1: Input the data
clear
input str10 Survey_Year Rural Urban All_India
"1993-94"  92.1	16.6 108.7
"1999-00"  95.9	17.9 113.8
"2004-05"  115.0 25.3 140.2
"2011-12"  97.7 27.6 125.3
"2017-18"  75.8 34.1 109.9
"2022-23"  134.2 48.7 182.9
end

* Step 2: Set Survey_Year as a numeric variable if needed for sorting
gen year = .
replace year = 1993 in 1
replace year = 1999 in 2
replace year = 2004 in 3
replace year = 2011 in 4
replace year = 2017 in 5
replace year = 2022 in 6

* Step 3: Generate the line graph
twoway (line Rural year,  lwidth(thick)) ///
       (line Urban year,  lwidth(thick)) ///
       (line All_India year,  lwidth(thick)) ///
       (scatter Rural year if year == 2022, msymbol(i) mlabel(Rural) mlabcolor(navy)) ///
       (scatter Urban year if year == 2022, msymbol(i) mlabel(Urban) mlabcolor(maroon)) ///
       (scatter All_India year if year == 2022, msymbol(i) mlabel(All_India) mlabcolor(forest_green)), ///
       xlabel(1993 "1993-94" 1999 "1999-00" 2004 "2004-05" 2011 "2011-12" 2017 "2017-18" 2022 "2022-23") ///
       xtitle("Survey Year") ytitle("Labour Force (in Millions)") ///
       legend(order(1 "Rural" 2 "Urban" 3 "All India") cols(3) size(medsmall)) ///
	   graphregion(margin(large)) ///
	   scheme(s2color) 
	   
graph export "$path/4-results/female-labour-force.pdf", replace
