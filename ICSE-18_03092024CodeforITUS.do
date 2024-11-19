*-------------------------------------------------------------------------------
********************************BASIC COMMANDS**********************************
*-------------------------------------------------------------------------------

*TUS Data, Steps to merging:

	*Step 1. Generate time in minutes
	*Step 2. Since, 30 minutes time is given to an activity if in 30 minute slot it is performed with other activities. 
	*		 We need to equally divide time between the number of activities performed in that 30 minute slot. Oe else we can allot entire time
	*		in the slot to the major activity. We have created data using All Activities. 
	*Step 3. Collapse to arrive at the total time spent on the activity by a person in a day.
	*Step 4. Reshape to arrive at the individual level data.
	*Step 5. Merge the data to get the final file. 

	
*Activity File (Level 5)

*Common ID------

gen hhid = fsu+hh_no
isid hhid
duplicates list hhid

gen psnid= fsu+hh_no+psn
isid psnid

gen act_id= fsu+hh_no+psn+srl_activity
isid act_id


*State------

gen state=substr(NSS_Region,1,2)


*Weight------

gen weight= mult/100

gen weight2=round(weight1,1)


*Activity File (Level 5)

*Time------

	*note 1: time in TUS data is in the hh:mm format
	*note 2: we generate a variable in double format to increase accuracy
	*note 3: there are 1440 minutes in a day (24 hours*60 minutes)

gen double start = clock(time_from, "hm")

format start %tcHH:MM

gen double end = clock(time_to, "hm")

format end %tcHH:MM

gen time= minutes(end-start)

replace time= time+ 1440 if end<start


*Multiple Activities------

duplicates tag psnid time_from time_to, gen(multiple_acts)
replace multiple_acts=1 if multiple_acts==2

egen no_of_activities=total(multiple_acts), by (psnid time_from time_to)
replace no_of_activities=1 if no_of_activities==0

gen new_time = time/no_of_activities


*International Classification of Activities for Time Use Statistics 2016 (ICATUS 2016)------

recode activity_code (110=1 "emp_gov 1")(121/129=2 "emp_goods 2")(131/139=3 "emp_ser 3")(141/142=4 "emp_break 4")(150=5 "emp_training 5") ///
(160=6 "emp_seek 6")(170=7 "emp_busi 7")(181=8 "emp_travel 8")(182=9 "emp_commute 9")(211/218=10 "own_primary 10")(221/229=11 "own_process 11") ///
(230=12 "own_cons 12")(241=13 "own_fuel 13")(242=14 "own_water 14")(250=15 "own_travel 15")(311/319=16 "do_food 16")(321/329=17 "do_clean 17") ///
(341/349=18 "do_laundry 18")(331/339=19 "do_diy 19")(351/359=20 "do_bills 20")(361/369=21 "do_pet 21")(371/372=22 "do_shop 22")(380=23 "do_travel 23") ///
(390=24 "do_other 24")(411/412=25 "child_phy 25")(413 417=26 "child_teach 26")(414/415=27 "child_play 27")(416=28 "child_passive 28") ///
(419 442=29 "child_other 29")(421/429=30 "care_dep 30")(431/439=31 "care_nondep 31")(441 443/444=32 "care_travel 32")(490=33 "care_other 33") ///
(515 524 530=34 "vol_trainee 34")(511/514 519/523 529=35 "vol_nec 35")(590=36 "vol_other 36")(540=37 "vol_travel 37")(611/619=38 "school_formal 38") ///
(620=39 "school_hw 39")(630=40 "school_nformal 40")(640=41 "school_travel 41")(690=42 "school_other 42")(711/790=43 "socialize 43") ///
(811/890=44 "leisure 44")(911/919=45 "sleep 45")(921/990=46 "self_care 46"), g(activity)

recode activity (1/5 8=1 "paidt 1")(6/7=2 "unemployedt 2")(9=3 "commutet 3")(10/12 15=4 "own_uset 4")(13=5 "own_fuelt 5")(14=6 "own_watert 6") ///
(16=7 "foodt 7")(17=8 "cleaningt 8")(18=9 "laundryt 9")(19/24=10 "do_othert 10")(25/29=11 "care_childt 11")(30/33=12 "care_othert 12") ///
(34/37=13 "volt 13")(38/42=14 "learningt 14")(43=15 "socializet 15")(44=16 "leisuret 16")(45/46=17 "self_caret 17"), g(activity1)


**SNA (Without considering commute time for employment)

*paid-unpaid activity status is a variable in Block 6, col. 12 in schedule 10.6

g activity_paid_unpaid2 = 1 if activity_paid_unpaid==6|activity_paid_unpaid==12

g sna_noc = activity_code if activity1==1
replace sna_noc = activity_code if activity_code>=211 & activity_code<=250
replace sna_noc = activity_code if activity_code>=511 & activity_code<=529 & activity_paid_unpaid2!=1
replace sna_noc = activity_code if activity_code==540 & activity_paid_unpaid2!=1
replace sna_noc = activity_code if activity_code==530|activity_code==590

**NON-SNA (GENERAL PRODUCTION BOUNDARY)

g nsna = activity_code if activity_code>=311 & activity_code<=490
replace nsna = activity_code if activity_code>=511 & activity_code<=529 & activity_paid_unpaid2==1
replace nsna = activity_code if activity_code==540 & activity_paid_unpaid2==1

**WORK (SNA + NON-SNA)

g work = sna_noc
replace work = nsna if sna_noc==.


**Collapse

use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\5c.dta"
keep if sna_noc!=.
collapse (sum) sna_noct=new_time, by(fsu hh_no psn)
sort fsu hh_no psn
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\sna.dta"


use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\5c.dta"
keep if nsna!=.
collapse (sum) nsnat=new_time, by(fsu hh_no psn)
sort fsu hh_no psn
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\nsna.dta"


use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\5c.dta"
keep if work!=.
collapse (sum) workt=new_time, by(fsu hh_no psn)
sort fsu hh_no psn
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\work.dta"

*All Activity (in level 5)

use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\5c.dta"
collapse (sum) new_time, by(fsu hh_no psn activity1)
reshape wide new_time, i(fsu hh_no psn) j(activity1)
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\all_17.dta"

rename new_time1	paidt
rename new_time2	unemployedt
rename new_time3	commutet
rename new_time4	own_uset
rename new_time5	own_fuelt
rename new_time6	own_watert
rename new_time7	foodt
rename new_time8	cleaningt
rename new_time9	laundryt
rename new_time10	do_othert
rename new_time11	care_childt
rename new_time12	care_othert
rename new_time13	volt
rename new_time14	learningt
rename new_time15	socializet
rename new_time16	leisuret
rename new_time17	self_caret
save, replace


use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\all_17.dta", clear

merge m:1 fsu hh_no psn using "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\sna.dta"
rename _merge mersna 
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\final.dta"

merge m:1 fsu hh_no psn using "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\nsna.dta"
rename _merge mernsna
save, replace

merge m:1 fsu hh_no psn using "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\work.dta"
rename _merge merwork
save, replace

drop mersna mernsna merwork 

replace    	paidt	=0      	if 	paidt	==.
replace    	unemployedt	=0     	if 	unemployedt	==.
replace    	commutet	=0	if 	commutet	==.
replace    	own_uset	=0	if 	own_uset	==.
replace    	own_fuelt	=0	if 	own_fuelt	==.
replace    	own_watert	=0	if 	own_watert	==.
replace    	foodt	=0	if 	foodt	==.
replace    	cleaningt	=0	if 	cleaningt	==.
replace    	laundryt	=0	if 	laundryt	==.
replace    	do_othert	=0	if 	do_othert	==.
replace    	care_childt	=0	if 	care_childt	==.
replace    	care_othert	=0	if 	care_othert	==.
replace    	volt	=0	if 	volt	==.
replace    	learningt	=0	if 	learningt	==.
replace    	socializet	=0	if 	socializet	==.
replace    	leisuret	=0	if 	leisuret	==.
replace    	self_caret	=0	if 	self_caret	==.

replace    	sna_noct	=0	if 	sna_noct	==.
replace    	nsnat	=0	if 	nsnat	==.
replace    	workt	=0	if 	workt	==.

save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\All\final0.dta"

use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\2.dta", clear
sort fsu hh_no psn
save, replace

use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\3.dta", clear
sort fsu hh_no
save, replace

use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\4.dta", clear
sort fsu hh_no psn
save, replace

*Merging All Files Together

use "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\2.dta"
merge 1:1 fsu hh_no psn using "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\4.dta"
rename _merge merge24
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\24.dta"

*note: Level 2 has 71494 more observations than level 4 because of the information on kids<=5 years of age


merge m:1 fsu hh_no using "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\3.dta"
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\243.dta"
rename _merge merge243

merge 1:1 fsu hh_no psn using "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\All\final0.dta"
rename _merge merge
save "D:\Surbhi Documents\PhD\Data\TUS 2019\FINAL\Final Data\Collapse\FINAL.dta"
sort fsu hh_no psn
save, replace

*note: merge==3 indicates 445299 individuals for whom data was collected on activity status


*Descriptive Statistics

*Check TUS 2019 Report p.68

* Average Time Spent per Person on Activity:

/*Total*/

mean sna_noct paidt nsnat workt [aw=weight] if age>=18 & age<=67 & sex==1
mean sna_noct paidt nsnat workt [aw=weight] if age>=18 & age<=67 & sex==2

/*Rural*/

mean sna_noct paidt nsnat workt [aw=weight] if age>=18 & age<=67 & sex==1 & sector==1
mean sna_noct paidt nsnat workt [aw=weight] if age>=18 & age<=67 & sex==2 & sector==1

/*Urban*/
mean sna_noct paidt nsnat workt [aw=weight] if age>=18 & age<=67 & sex==1 & sector==2
mean sna_noct paidt nsnat workt [aw=weight] if age>=18 & age<=67 & sex==2 & sector==2


*Proportion of people participating in an Activity

/*Total*/
table sector sex if age>=18 & age<=67 & sex!=3 [iw=weight]

/*In particular activity*/
table sector sex if sna_noct>0 & age>=18 & age<=67 & sex!=3 [iw=weight]
table sector sex if paidt>0 & age>=18 & age<=67 & sex!=3 [iw=weight]
table sector sex if nsnat>0 & age>=18 & age<=67 & sex!=3 [iw=weight]
table sector sex if workt>0 & age>=18 & age<=67 & sex!=3 [iw=weight]

**Participation Rate in activity A = (number of individuals participating in activity A)/(total number of individuals)×100











