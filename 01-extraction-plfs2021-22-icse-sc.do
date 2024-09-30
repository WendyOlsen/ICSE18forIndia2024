/*------------------------------------------------------
File: 01-extraction-plfs2021-22-icse-sc.do
Purpose: To Extract PLFS 2021-22
Author: Sarika Chaudhary 
Date: 23/07/2024
------------------------------------------------------*/

/*------------------------------------------------------
Download data and documents:  													    						
http://microdata.gov.in/nada43/index.php/catalog  											
------------------------------------------------------*/

capture log close
clear all
set more off

global path  "/Users/sarika/Library/CloudStorage/OneDrive-Personal/01-projects/01-research-work/02-icse18/sarika/"

log using "$path/2-code/extraction-plfs2021-22-icse-sc.txt", text replace

/*------------------------------------------------------
Extraction - Household Level Data (First Visit)
------------------------------------------------------*/

drop _all

infix str file_id 1-4 str schedule 5-7 str quarter 8-9 str visit 10-11 str sector 12-12 str state_ut 13-14 str district_code 15-16 str nss_region 17-19 str stratum 20-21 str sub_stratum 22-23 str sub_round 24-24 str fod 25-28 str fsu 29-33 str hg_sb 34-34 str sss 35-35 str hh 36-37 str month_survey 38-39 str response_code 40-40 str survey_code   41-41 str reason_sub 42-42 str hh_size 43-44 str hh_type 45-45 str religion 46-46 str social_group 47-47 str umce1 48-55 str umce2 56-63 str umce3 64-71 str umce4 72-79 str umce5 80-87 str umce_hh 88-95 str info_slno 96-97 str survey_date 98-105 str time_survey 106-109 str nss 110-112 str nsc 113-115 str mlt 116-125 str no_qtr 126-126 using "$path/1-raw/hhfv.txt"


label variable file_id "file identification"
label variable schedule "schdule ﻿number"
label variable quarter "quarter"
label variable visit "visit"
label variable sector "sector"
label variable state_ut "state/ut code"
label variable district_code "district code"
label variable nss_region "nss region"
label variable stratum "stratum"
label variable sub_stratum "sub-stratum"
label variable sub_round "sub-sample"
label variable fod "fod sub-region"
label variable fsu "﻿first stage units"
label variable hg_sb "sample hg/sb no."
label variable sss "second stage stratum no."
label variable hh "sample household number"
label variable month_survey "month of survey"
label variable response_code "response code"
label variable survey_code "survey code"
label variable reason_sub "reason for substitution of original household"
label variable hh_size "household size"
label variable hh_type "household type"
label variable religion "religion"
label variable social_group "social group"
label variable umce1 "household's usual consumer expenditure in a month for purposes out of goods and services(rs.)"
label variable umce2 "imputed value of usual consumption in a month out of home grown stock (rs.)"
label variable umce3 "imputed value of usual consumption in a month from wages in kind,free collection, gifts etc. (rs.)"
label variable umce4 "household's annual expenditure on purchase of items like clothing, footwear etc.(rs.)"
label variable umce5 "household's annual expenditure on purchase of durables like bedstead, tv, fridge etc.(rs.)"
label variable umce_hh "household's usual consumer expenditure in a month (rs.)"
label variable info_slno "informant serial no."
label variable survey_date "survey date"
label variable time_survey "total time taken to canvass sch. 10.4"
label variable nss "ns count for sector x stratum x substratum x sub-sample"
label variable nsc "ns count for sector x stratum x substratum"
label variable mlt "sub-sample wise multiplier"
label variable no_qtr "occurance of state x sector x stratum x substratum in 4 quarters"

gen hhid = quarter + visit + fsu + hg_sb + sss + hh
isid hhid

//final weight for generating subsample wise estimates: quarter-wise multipliers.

destring nss-no_qtr, replace
gen weight = mlt/100 if nss==nsc
replace weight=mlt/200 if nss!=nsc 

//combined estimate for the entire year
gen a_weight = weight/no_qtr 

sort hhid
save "$path/3-data/hhfv.dta", replace

//Extraction - Individual Level Data (First Visit)

drop _all

infix str file_id 1-4 str schedule 5-7 str quarter 8-9 str visit 10-11 str sector 12-12 str	state_ut 13-14 str	district_code 15-16 str	nss_region 17-19 str stratum 20-21 str sub_stratum 22-23 str sub_round 24-24 str fod 25-28 str fsu 29-33 str hg_sb 34-34 str sss 35-35 str hh 36-37 str	per_no 38-39 str relation_head 40-40 str sex 41-41 str	age	42-44 str marital_status 45-45 str	general_edu_level	46-47 str	tech_edu_level	48-49 str	year_edu	50-51 str	current_attendance	52-53 str	vocational_training	54-54 str	training_completed	55-55 str	field_training	56-57 str	duration_training	58-58 str	type_training	59-59 str	source_funding	60-60 str	status_code_ps	61-62 str	nic_ps	63-67 str	nco_ps	68-70 str	whether_subsidiary_work	71-71 str	location_ps	72-73 str	enterprise_ps	74-75 str	workers_num_ps	76-76 str	job_contract_type_ps	77-77 str	eligible_paid_leave_ps	78-78 str	social_security_ps	79-79 str	economic_activities_ps	80-80 str	status_code_ss	81-82 str	nic_ss	83-87 str	nco_ss	88-90 str	location_ss	91-92 str	enterprise_ss	93-94 str	workers_num_ss	95-95 str	job_contract_type_ss	96-96 str	eligible_paid_leave_ss	97-97 str	social_security_ss	98-98 str	economic_activities_ss	99-99 str	worked_prior_365	100-100 str	duration_ps	101-101 str	duration_ss	102-102 str	efforts_to_search_work	103-103 str	duration_spell_unemployment	104-104 str	whether_ever_worked	105-105 str	reason_unemploy_365	106-107 str	reason_fo_being_in_code91_97	108-108 str	status_71	109-110 str	nic_71	111-112 str	hours_worked_71	113-114 str	wage_71	115-119 str	status_72	120-121 str	nic_72	122-123 str	hours_worked_72	124-125 str	wage_72	126-130 str	total_hours_7	131-132 str	aditional_work_7	133-134 str	status_61	135-136 str	nic_61	137-138 str	hours_worked_61	139-140 str	wage_61	141-145 str	status_62	146-147 str	nic_62	148-149 str	hours_worked_62	150-151 str	wage_62	152-156 str	total_hours_6	157-158 str	aditional_work_6	159-160 str	status_51	161-162 str	nic_51	163-164 str	hours_worked_51	165-166 str	wage_51	167-171 str	status_52	172-173 str	nic_52	174-175 str	hours_worked_52	176-177 str	wage_52	178-182 str	total_hours_5	183-184 str	aditional_work_5	185-186 str	status_41	187-188 str	nic_41	189-190 str	hours_worked_41	191-192 str	wage_41	193-197 str	status_42	198-199 str	nic_42	200-201 str	hours_worked_42	202-203 str	wage_42	204-208 str	total_hours_4	209-210 str	aditional_work_4	211-212 str	status_31	213-214 str	nic_31	215-216 str	hours_worked_31	217-218 str	wage_31	219-223 str	status_32	224-225 str	nic_32	226-227 str	hours_worked_32	228-229 str	wage_32	230-234 str	total_hours_3	235-236 str	aditional_work_3	237-238 str	status_21	239-240 str	nic_21	241-242 str	hours_worked_21	243-244 str	wage_21	245-249 str	status_22	250-251 str	nic_22	252-253 str	hours_worked_22	254-255 str	wage_22	256-260 str	total_hours_2	261-262 str	aditional_work_2	263-264 str	status_11	265-266 str	nic_11	267-268 str	hours_worked_11	269-270 str	wage_11	271-275 str	status_12	276-277 str	nic_12	278-279 str	hours_worked_12	280-281 str	wage_12	282-286 str	total_hours_1	287-288 str	aditional_work_1	289-290 str	cws_code	291-292 str	nic_cws	293-294 str	nco_cws	295-297 str	monthly_earnings_regular	298-305 str	monthly_earnings_self_employment	306-313 str	nss	314-316 str	nsc	317-319 str	mlt	320-329 str	no_qtr	330-330 using "$path/1-raw/perfv.txt"

label variable file_id "file identification"
label variable schedule "schdule ﻿number"
label variable quarter "quarter"
label variable visit "visit"
label variable sector "sector"
label variable state_ut "state/ut code"
label variable district_code "district code"
label variable nss_region "nss-region"
label variable stratum "stratum"
label variable sub_stratum "sub-stratum"
label variable sub_round "sub-sample"
label variable fod "fod sub-region"
label variable fsu "first stage units"
label variable hg_sb "sample hg/sb no."
label variable sss "second stage stratum no."
label variable hh "sample household number"
label variable per_no "person serial no."
label variable relation_head "relationship to head"
label variable sex "sex"
label variable age "age"
label variable marital_status "marital status"
label variable general_edu_level "general educaion level"
label variable tech_edu_level "technical educaion level"
label variable year_edu "no. of years in formal education"
label variable current_attendance "status of current attendance in educational institution"
label variable vocational_training "whether received any vocational/technical training"
label variable training_completed "whether training completed during last 365 days"
label variable field_training "field of training"
label variable duration_training "duration of training"
label variable type_training "type of training"
label variable source_funding "source of funding the training"
label variable status_code_ps "status code"
label variable nic_ps "industry code (nic)"
label variable nco_ps "occupation code (nco)"
label variable whether_subsidiary_work "whether engaged in any work in subsidiary capacity"
label variable location_ps "(principal)location of workplace code"
label variable enterprise_ps "(principal) enterprise type code"
label variable workers_num_ps "(principal) no. of workers in the enterprise"
label variable job_contract_type_ps "(principal)  type of job contract"
label variable eligible_paid_leave_ps "(principal) eligble of paid leave"
label variable social_security_ps "(principal) social security benefits"
label variable economic_activities_ps "(principal) usage of product of the economic activity"
label variable status_code_ss "status code"
label variable nic_ss "industry code (nic)"
label variable nco_ss "occupation code (nco)"
label variable location_ss "(subsidiary) location of workplace code"
label variable enterprise_ss "(subsidiary)  enterprise type code"
label variable workers_num_ss "(subsidiary)  no. of workers in the enterprise"
label variable job_contract_type_ss "(subsidiary)   type of job contract"
label variable eligible_paid_leave_ss "(subsidiary)  eligble of paid leave"
label variable social_security_ss "(subsidiary)  social security benefits"
label variable economic_activities_ss "(subsidiary) usage of product of the economic activity"
label variable worked_prior_365 "ever worked prior to last 365 days"
label variable duration_ps "duration of engagement in the economic activity in usual principal activity status"
label variable duration_ss "duration of engagement in the economic activity in subsidiary activity status"
label variable efforts_to_search_work "efforts undertaken to search work"
label variable duration_spell_unemployment "duration of spell of unemployment"
label variable whether_ever_worked "whether ever worked "
label variable reason_unemploy_365 " reason for not working in last 365 days"
label variable reason_fo_being_in_code91_97 "main reason for being in principal activity status (91 to 97) "
label variable status_71 "status code for activity 1"
label variable nic_71 "industry code (nic) for activity 1"
label variable hours_worked_71 "hours actuallly worked for activity 1 on 7 th day"
label variable wage_71 "wage earning for activity 1 on 7 th day"
label variable status_72 "status code for activity 2"
label variable nic_72 "industry code (nic) for activity 2"
label variable hours_worked_72 "hours actuallly worked for activity 2 on 7 th day"
label variable wage_72 "wage earning for activity 2 on 7 th day"
label variable total_hours_7 "total hours actually worked on 7th day"
label variable aditional_work_7 "hours available for aditional worked on 7th day"
label variable status_61 "status code for activity 1"
label variable nic_61 "industry code (nic) for activity 1"
label variable hours_worked_61 "hours actuallly worked for activity 1 on 6 th day"
label variable wage_61 "wage earning for activity 1 on 7 th day"
label variable status_62 "status code for activity 2"
label variable nic_62 "industry code (nic) for activity 2"
label variable hours_worked_62 "hours actuallly worked for activity 2 on 6 th day"
label variable wage_62 "wage earning for activity 2 on 6 th day"
label variable total_hours_6 "total hours actually worked on 6th day"
label variable aditional_work_6 "hours available for aditional worked on 6th day"
label variable status_51 "status code for activity 1"
label variable nic_51 "industry code (nic) for activity 1"
label variable hours_worked_51 "hours actuallly worked for activity 1 on5 th day"
label variable wage_51 "wage earning for activity 1 on 5 th day"
label variable status_52 "status code for activity 2"
label variable nic_52 "industry code (nic) for activity 2"
label variable hours_worked_52 "hours actuallly worked for activity 2 on 5 th day"
label variable wage_52 "wage earning for activity 2 on 5 th day"
label variable total_hours_5 "total hours actually worked on 5th day"
label variable aditional_work_5 "hours available for aditional worked on 5th day"
label variable status_41 "status code for activity 1"
label variable nic_41 "industry code (nic) for activity 1"
label variable hours_worked_41 "hours actuallly worked for activity 1 on 4th day"
label variable wage_41 "wage earning for activity 1 on 4th day"
label variable status_42 "status code for activity 2"
label variable nic_42 "industry code (nic) for activity 2"
label variable hours_worked_42 "hours actuallly worked for activity 2 on 4th day"
label variable wage_42 "wage earning for activity 2 on 4th day"
label variable total_hours_4 "total hours actually worked on 4th day"
label variable aditional_work_4 "hours available for aditional worked on 4th day"
label variable status_31 "status code for activity 1"
label variable nic_31 "industry code (nic) for activity 1"
label variable hours_worked_31 "hours actuallly worked for activity 1 on 3rd day"
label variable wage_31 "wage earning for activity 1 on 3rd day"
label variable status_32 "status code for activity 2"
label variable nic_32 "industry code (nic) for activity 2"
label variable hours_worked_32 "hours actuallly worked for activity 2 on 3rd day"
label variable wage_32 "wage earning for activity 2 on 3 rd day"
label variable total_hours_3 "total hours actually worked on 3rd day"
label variable aditional_work_3 "hours available for aditional worked on 3rd day"
label variable status_21 "status code for activity 1"
label variable nic_21 "industry code (nic) for activity 1"
label variable hours_worked_21 "hours actuallly worked for activity 1 on 2nd day"
label variable wage_21 "wage earning for activity 1 on 2nd day"
label variable status_22 "status code for activity 2"
label variable nic_22 "industry code (nic) for activity 2"
label variable hours_worked_22 "hours actuallly worked for activity 2 on 2nd day"
label variable wage_22 "wage earning for activity 2 on 2nd day"
label variable total_hours_2 "total hours actually worked on 2nd day"
label variable aditional_work_2 "hours available for aditional worked on 2nd day"
label variable status_11 "status code for activity 1"
label variable nic_11 "industry code (nic) for activity 1"
label variable hours_worked_11 "hours actuallly worked for activity 1 on 1st day"
label variable wage_11 "wage earning for activity 1 on 1st day"
label variable status_12 "status code for activity 2"
label variable nic_12 "industry code (nic) for activity 2"
label variable hours_worked_12 "hours actuallly worked for activity 2 on 1st day"
label variable wage_12 "wage earning for activity 2 on 1st day"
label variable total_hours_1 "total hours actually worked on 1st day"
label variable aditional_work_1 "hours available for aditional worked on 1st day"
label variable cws_code "current weekly status (cws)"
label variable nic_cws "industry code (cws)"
label variable nco_cws "occupation code (cws)"
label variable monthly_earnings_regular "earnings for regular salaried/wage activity"
label variable monthly_earnings_self_employment "earnings for self employed"
label variable nss "ns count for sector x stratum x substratum x sub-sample"
label variable nsc "ns count for sector x stratum x substratum"
label variable mlt "sub-sample wise multiplier"
label variable no_qtr "occurance of fsus in state x sector x stratum x substratum in 4 quarters"

gen hhid = quarter + visit + fsu + hg_sb + sss + hh
 
//final weight for generating subsample wise estimates: quarter-wise multipliers.

destring nss-no_qtr, replace
gen weight = mlt/100 if nss==nsc
replace weight=mlt/200 if nss!=nsc

//combined estimate for the entire year
gen a_weight = weight/no_qtr  

gen i_weight = round( a_weight,1)

sort hhid
save "$path/3-data/perfv.dta", replace


drop _all

use "$path/3-data/hhfv.dta"
merge 1:m hhid using "$path/3-data/perfv.dta" 

drop _merge
save "$path/3-data/plfs2022-23.dta", replace

sort hhid
by hhid : gen x = _n
tab state_ut sector if x == 1 // sample household from table 1

tab state_ut sector // sample person all ages from table 1

tab state_ut sector [iwe=a_weight] // estimated number of person from table 2

// cleaning

destring sex, replace 
drop if sex == 3

label define sex_label 1 "Male" 2 "Female"
label value sex sex_label
tab sex

save "$path/3-data/plfs2022-23.dta", replace
