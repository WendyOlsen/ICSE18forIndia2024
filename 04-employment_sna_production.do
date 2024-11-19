/*------------------------------------------------------
File: 04-femployment_sna_production.do
Purpose: To plot employment using TUS for ICSE paper
Author: Sarika Chaudhary 
Date: 20/08/2024
------------------------------------------------------*/


* Input the data into Stata
clear

global path  "/Users/sarika/Library/CloudStorage/OneDrive-Personal/01-projects/icse/"

input str15 Category str6 Area Male Female
"Employment" "Rural" 70.4 22.4
"Employment" "Urban" 73.5 19.4
"Employment" "All India" 71.4 21.5
"SNA Production" "Rural" 83.1 47.0
"SNA Production" "Urban" 75.7 28.2
"SNA Production" "All India" 80.8 41.2
end

* Sort data for graphing
sort Category Area

* Create a grouped bar graph for male and female
graph bar (asis) Male Female, over(Area) over(Category) asyvars scheme(s2color) ///
    blabel(bar, format(%9.1f)) ///
    ytitle("Percentage of Adult Population- India") ///
    legend(cols(2) order(1 "Male" 2 "Female")) ///
	xsize(12) ysize(8)


* Save the graph if needed
graph export "$path/4-results/employment_sna_production.pdf", replace
