/*------------------------------------------------------
File: 02-labour-force-participation.do
Purpose: To Analyse LFPR using EUS and PLFS between 1993-94 and 2022-23 for ICSE paper
Author: Sarika Chaudhary 
Date: 20/08/2024
------------------------------------------------------*/

capture log close
clear all
set more off

global path  "/Users/sarika/Library/CloudStorage/OneDrive-Personal/01-projects/icse/"

drop _all

/*------------------------------------------------------
Labour Force 2022-23
------------------------------------------------------*/

use "$path/3-data/plfs2022-23.dta"

destring age sector status_code_ps status_code_ss sex, replace
drop if sex == 3
rename i_census_corrected_weight i_census_weight

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss

// Labour Force Participation Rate 

recode upss (min/81=1) (91/max=0), gen (lfpr_upss)

tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67, col nofreq
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67, col nofreq

// Labour Force in Absolute Numbers
tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67

/*------------------------------------------------------
Labour Force 2017-18
------------------------------------------------------*/

clear
use "$path/3-data/plfs2017-18.dta"

destring age sector status_code_ps status_code_ss sex, replace
drop if sex == 3
rename i_census_corrected_weight i_census_weight

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss


// Labour Force Participation Rate 
recode upss (min/81=1) (91/max=0), gen (lfpr_upss)

tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67, col nofreq
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67, col nofreq

// Labour Force in Absolute Numbers
tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if age >= 18 & age <= 67


/*------------------------------------------------------
Labour Force 2011-12
------------------------------------------------------*/

clear
use "$path/3-data/eus2011-12.dta"

destring age sector status_code_ps status_code_ss sex, replace
drop if sex == 3
rename i_census_adj_weight i_census_weight

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss

// Labour Force Participation Rate 

recode upss (min/81=1) (91/max=0), gen (lfpr_upss)

tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq

// Labour Force in Absolute Numbers
tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67


/*------------------------------------------------------
Labour Force 2004-05
------------------------------------------------------*/

clear
use "$path/3-data/eus2004-05.dta"

destring age sector status_code_ps status_code_ss sex, replace
drop if sex == 3
rename i_census_adj_weight i_census_weight

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss

// Labour Force Participation Rate 

recode upss (min/81=1) (91/max=0), gen (lfpr_upss)

tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq

// Labour Force in Absolute Numbers
tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67

/*------------------------------------------------------
Labour Force 1999-00
------------------------------------------------------*/

clear
use "$path/3-data/eus1999-00.dta"

destring age sector status_code_ps status_code_ss sex, replace
drop if sex == 3
rename i_census_adj_weight i_census_weight

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss

// Labour Force Participation Rate 

recode upss (min/81=1) (91/max=0), gen (lfpr_upss)

tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq

// Labour Force in Absolute Numbers
tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67

/*------------------------------------------------------
Labour Force 1993-94
------------------------------------------------------*/

clear
use "$path/3-data/eus1993-94.dta"

destring age sector status_code_ps status_code_ss sex, replace
drop if sex == 3
rename i_census_adj_weight i_census_weight

gen upss=.
replace upss=status_code_ps
replace upss=status_code_ss if status_code_ps>51 & status_code_ss<=51
tab upss

// Labour Force Participation Rate 

recode upss (min/81=1) (91/max=0), gen (lfpr_upss)

tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67, col nofreq

// Labour Force in Absolute Numbers
tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67
bysort sector : tab  lfpr_upss sex  [iwe= i_census_weight ] if y == 1 & age >= 18 & age <= 67

