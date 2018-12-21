////////////////////////////////////////////////////////////////////////////
// Create female record variables
////////////////////////////////////////////////////////////////////////////

gen fem_current_age = v012
label variable fem_current_age "Current age of female"
egen fem_age_group = cut(fem_current_age), at(5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90) // create age groups
label variable fem_age_group "Age group (minimum threshold)"


gen fem_years_ed = v133 if inrange(v133,0,20) // years of education, excl missing/unknown
label variable fem_years_ed "Years of education of female"

capture confirm variable v140
if !_rc {
	gen fem_urban = (v140==1) // specific urban
	gen fem_rural = (v140==2) // specific rural
	label variable fem_urban "=1 if urban, =0 if other"
	label variable fem_rural "=1 if rural, =0 if other"
}
capture confirm variable v150
if !_rc {
	gen fem_head_wife = (v150==2) // is listed as a wife
	gen fem_head_daughter = (inlist(v150,3,4)) // listed as a duaghter or d-in-law
	gen fem_head_mother = (inlist(v150,6,7)) // listed as mom of head, or mom-in-law
	gen fem_head_sister = (inlist(v150,8)) // listed as sister of head
	gen fem_head_head = (inlist(v150,1)) // listed as head
	
	label variable fem_head_wife "Female is wife of head"
	label variable fem_head_daughter "Female is daughter of head"
	label variable fem_head_mother "Female is mother of head"
	label variable fem_head_sister "Female is sister of head"
	label variable fem_head_head "Female is head"	
}
capture confirm variable v152
if !_rc {
	gen fem_head_age = v152 if inrange(v152,0,96) // age of head
	label variable fem_head_age "Age of HH head"
}

// Basic fertility counts
gen fem_num_ever_born = v201
gen fem_num_sons_home = v202
gen fem_num_daug_home = v203
gen fem_num_sons_else = v204
gen fem_num_daug_else = v205
gen fem_num_birth_last_five = v208

label variable fem_num_ever_born "Children ever born"
label variable fem_num_birth_last_five "Birth in last five years"
label variable fem_num_sons_home "Sons at home"
label variable fem_num_daug_home "Daughters at home"
label variable fem_num_sons_else "Sons elsewhere"
label variable fem_num_daug_else "Daughters elsewhere"

capture confirm variable v221
if !_rc {
	gen fem_int_marr_first_birth = v221
	label variable fem_int_marr_first_birth "Interval from marr to 1st birth" 
}
capture confirm variable v212
if !_rc {
	gen fem_age_first_birth = v212
	label variable fem_age_first_birth "Age at first birth"
}


// Marriage status
capture confirm variable v501
if !_rc {
	gen fem_ever_married = (inlist(v501,1,3,4,5)) // married/widow/divorced/separated
	gen fem_ever_union = (inlist(v501,1,2,3,4,5)) // plus living with partner
	gen fem_never_union = (inlist(v501,0)) // never in a union
	label variable fem_ever_married "=1 if ever married, =0 if other"
	label variable fem_ever_union "=1 if ever in union, =0 if other"
	label variable fem_never_union "=1 if never in union, =0 if other"
}
capture confirm variable v501
if !_rc {
	gen fem_now_union = (inlist(v502,1)) // currently in union
	gen fem_form_union = (inlist(v502,2)) // was in union
	label variable fem_now_union "=1 if now in union, =0 if other"
	label variable fem_form_union "=1 if formerly in union, =0 if other"
}

capture confirm variable v504
if !_rc {
	gen fem_partner_cohab = (inlist(v504,1)) // partner in residence
	label variable fem_partner_cohab "=1 if partner cohabits, =0 if other"
}
capture confirm variable v505
if !_rc {
	gen fem_only_wife = (inlist(v505,0)) // is only wife of partner
	label variable fem_only_wife "=1 if only wife of partner, =0 if other"
}
capture confirm variable v511
if !_rc {
	gen fem_age_first_cohab = v511 // age at first cohabitation
	label variable fem_age_first_cohab "Age of first cohabitation"
}
capture confirm variable v512
if !_rc {
	gen fem_years_from_first_cohab = v512 // years of cohabitation
}
capture confirm variable v525
if !_rc {
	gen fem_age_first_sex = v525 if inrange(v525,7,49) // age of first sex
	label variable fem_age_first_sex "Age of first sex"
	gen fem_union_first_sex = (v525==96) // first sex at first union
	label variable fem_union_first_sex "First sex at first union"
}

capture confirm variable v714
if !_rc {
	gen fem_working = (v714==1) // is working currently
	label variable fem_working "=1 if any working, =0 if other"
}
capture confirm variable v719
if !_rc {
	gen fem_self_employ = (v719==3)
	gen fem_fam_employ = (v719==1)
	gen fem_outside_employ = (v719==2)
	label variable fem_self_employ "=1 if self-employed, =0 if other"
	label variable fem_fam_employ "=1 if family employed, =0 if other"
	label variable fem_outside_employ "=1 if employed outside fam, =0 if other"
}

capture confirm variable v740
if  !_rc {
	gen fem_land_own = (v740==0) // works own land
	gen fem_land_family = (v740==1) // works family land
	gen fem_land_others = (v740==2) // works others land
	gen fem_land_rented = (v740==3) // works rented land
	label variable fem_land_own "=1 if works own land, =0 if other"
	label variable fem_land_family "=1 if works family land, =0 if other"
	label variable fem_land_others "=1 if works out-fam land, =0 if other"
	label variable fem_land_rented "=1 if works rented land, =0 if other"
}

// Household facility dummies 
gen fem_flush = (inlist(v116,10,11,12,13,14,15)) // flush toilet of some kind
gen fem_elec  = (v119==1) // electricity
gen fem_tv    = (v121==1) // TV
gen fem_frig  = (v122==1) // refrigerator
gen fem_floor = (v127==1) // floor (finished)

gen fem_i_religion = v130 

// Partner information
capture confirm variable v715
if !_rc {
	gen fem_partner_ed = v715 if inrange(v715,0,20)
}
capture confirm variable v730
if !_rc {
	gen fem_partner_age = v730 if inrange(v730,15,95)
}

rename v001 cluster // cluster id
rename v002 hh_id // household ID
rename v003 fem_id // specific ID for woman

gen ccode = substr(v000,1,2) // pull country code
gen phase = substr(v000,3,1) // pull DHS phase
move ccode cluster // move to lead position
move phase cluster // move to lead position

rename v005 dhs_weight // as a mental check
qui replace dhs_weight = dhs_weight/1000000 // scale the hh weight
		
// Labels

	
	

// Save dataset of all household records
keep ccode phase cluster hh_id fem_* dhs_weight // limit the variables to save space
	
