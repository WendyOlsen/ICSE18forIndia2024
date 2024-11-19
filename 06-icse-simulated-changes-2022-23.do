/*------------------------------------------------------
File: 06-icse-simulated-changes.do
Purpose: To plot simulated-changes with Three Adjustments using PLFS 2022-23 for ICSE paper
Author: Sarika Chaudhary 
Date: 20/08/2024
------------------------------------------------------*/

* Input the data
clear

global path  "/Users/sarika/Library/CloudStorage/OneDrive-Personal/01-projects/icse/"

input byte icse_category byte sex float proportion
1 1 3.6
1 2 0.2
2 1 29.9
2 2 11.2
3 1 41.6
3 2 18.9
4 1 5.8
4 2 12.7
5 1 2.8
5 2 1.2
6 1 8
6 2 52.9
7 1 5.2
7 2 2.1
end

label define icse_order 1 "Employers" 2 "Independent workers w/o employees" 3 "Employees" 4 "Contributing family workers" 5 "Unemployed" 6 "Inactive" 7 "Dependent contractors"

label values icse_category icse_order

label define sex_cat 1 "Male" 2 "Female"
label values sex sex_cat

* Create the bar graph
graph bar (asis) proportion, over(icse_category) over(sex) asyvars scheme(s2color) ///
blabel(bar, format(%3.1fc)) ///
ytitle(" Percentage of Adult Population- India ") ///
legend(cols(2)) ///
xsize(12) ysize(8)
	
graph export "$path/4-results/icse-simulated-changes.pdf", replace


