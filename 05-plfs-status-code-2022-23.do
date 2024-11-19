/*------------------------------------------------------
File: 05-plfs-status-code-2022-23.do
Purpose: To calculate Distribution of Labour Force and Out of Labour Force using PLFS 2022-23 for ICSE paper
Author: Sarika Chaudhary 
Date: 20/08/2024
------------------------------------------------------*/

capture log close
clear all
set more off

global path  "/Users/sarika/Library/CloudStorage/OneDrive-Personal/01-projects/icse/"


drop _all

use "$path/3-data/plfs2022-23.dta"

destring age sector status_code_ps status_code_ss, replace

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss

gen icse_code_2 = .
replace icse_code_2 = 1 if upss == 12 
replace icse_code_2 = 2 if upss == 11
replace icse_code_2 = 3 if upss == 31 
replace icse_code_2 = 3 if upss == 41
replace icse_code_2 = 3 if upss == 51 
replace icse_code_2 = 4 if upss == 21
replace icse_code_2 = 5 if upss == 81 
replace icse_code_2 = 6 if upss > 81

la def icse_label 1 "Employers" 2 "Independent workers w/o employees" 3 "Employees" 4 "Contributing family workers" 5 "Unemployed" 6 "Inactive" 
la val icse_code_2 icse_label

tab icse_code sex if age >= 18 & age <= 67 [iwe = i_weight ], col nofreq

catplot icse_code_2 sex  [aweight = weight] if age >= 18 & age <= 67, percent(sex) blabel(bar, format(%3.1fc)) asyvars scheme(s2color) yscale(r(0,40)) ytitle(" Percentage of Adult Population- India ") legend(cols(2)) recast (bar)

graph export "$path/4-results/actual.pdf", replace






