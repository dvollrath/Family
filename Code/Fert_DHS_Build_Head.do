////////////////////////////////////////////////////////////////////////////
// Create household record variables
////////////////////////////////////////////////////////////////////////////

di "Create HR variables"

local id 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 // need string IDs for person variables

// Create variables to count family members
gen head_num_any_fam = 0
gen head_num_any_kin = 0
gen head_num_any_desc = 0
gen head_num_any_kids = 0
gen head_num_any_gkids = 0
gen head_num_any_nepnie = 0
gen head_num_any_other = 0
gen head_num_adult_kids = 0
gen head_num_any_nonlin = 0
gen head_num_any_parent = 0
gen head_num_all = 0
gen head_num_nuclear = 0
gen head_num_spouse = 0 
forvalues a = 9(10)99 {
	gen head_num_range_`a' = 0
}
gen head_male = (hv104_01==1) // create dummy for male head
gen head_num_daughter = 0
gen head_num_son = 0

// Counts of types of family members by relationship to head
foreach i in `id' { // for each listed member in household
	capture confirm variable hv101_`i' // check if the member variable exists
	if !_rc { // if no error code - variable exists - continue
		if !missing(hv101_`i') & hv102_`i'==1 { // if relationship is not missing, and a usual member of HH
			quietly {
			replace head_num_all = head_num_all + 1 // simple count of all reported members
			replace head_num_spouse = head_num_spouse + 1 if inlist(hv101_`i',2) // spouse
			replace head_num_nuclear = head_num_nuclear + 1 if inlist(hv101_`i',1,2,3) // nuclear members of head
			replace head_num_any_fam = head_num_any_fam + 1 if hv101_`i'>0 & hv101_`i'<98 & hv101_`i'~=12 // any family relation, excl. "Not related"
			replace head_num_any_kin = head_num_any_kin + 1 if inlist(hv101_`i',3,5,6,8,13) // clear blood kin only
			replace head_num_any_desc = head_num_any_desc + 1 if inlist(hv101_`i',3,5) // blood descendant
			replace head_num_any_kids = head_num_any_kids + 1 if inlist(hv101_`i',3,4) // kids of any relation
			replace head_num_any_gkids = head_num_any_gkids + 1 if inlist(hv101_`i',5) // grandkids of any relation
			replace head_num_any_nepnie = head_num_any_nepnie + 1 if inlist(hv101_`i',13,14) // nieces or nephews of any relation
			replace head_num_any_other = head_num_any_other + 1 if inlist(hv101_`i',10) // any other kind of relation
			replace head_num_adult_kids = head_num_adult_kids + 1 if inlist(hv101_`i',3,4) & hv105_`i'>17 // adult child
			replace head_num_any_nonlin = head_num_any_nonlin + 1 if inlist(hv101_`i',8,10,12,13,14) // anyone non-lineal desc
			replace head_num_any_parent = head_num_any_parent + 1 if inlist(hv101_`i',6,7) // any parent of HH head (inlaw or blood)
			replace head_num_daughter = head_num_daughter + 1 if inlist(hv101_`i',3) & hv104_`i'==2 // a daughter of head
			replace head_num_son = head_num_son + 1 if inlist(hv101_`i',3) & hv104_`i'==1 // a daughter of head
			forvalues a = 9(10)99 {
				replace head_num_range_`a' = head_num_range_`a' + 1 if inrange(hv105_`i',`a'-9,`a') // count by age group
			} // end forvalues
			} // end quietly
		} // end if not-missing and usual member
	} // end if !_rc
} // end foreach i

// Head of HH dummies for family type
gen head_dum_three_gen = (head_num_adult_kids>0 & head_num_any_gkids>0) // dummy for 3 gen household
gen head_dum_nonlin = (head_num_any_nonlin>0) // dummy for nonlin family in household
gen head_dum_any_fam = (head_num_any_fam>0) // dummy for any familiy in household
gen head_dum_any_kin = (head_num_any_kin>0) // dummy for any kin in household
gen head_dum_any_desc = (head_num_any_desc>0) // dummy for any descendant in household
gen head_dum_any_adult_kid = (head_num_adult_kids>0) // dummy for any adult kid
gen head_dum_any_parent = (head_num_any_parent>0) // dummy for any parent present
gen head_dum_one_adult_kid = (head_num_adult_kids==1) // dummy for ONE adult kid (stem family)
gen head_dum_any_other = (head_num_any_other>0) // dummy for any other kind of relation
gen head_dum_nuclear = (head_num_nuclear == head_num_all) // dummy for *only* nuclear members in HH
gen head_dum_nepnie = (head_num_any_nepnie>0) // dummy for any nieces or nephews
gen head_dum_daughter = (head_num_daughter>0) // dummy for a daughter in HH
gen head_dum_son = (head_num_son>0) // dummy for a son in HH
gen head_dum_matrilocal = (head_num_daughter>0 & head_male==0) // female head w/ daughter
gen head_dum_patrilocal = (head_num_son>0 & head_male==1) // male head w/ son
gen head_dum_matri_strong = (head_num_daughter>0 & head_num_son==0 & head_male==0) // strong matrilocal (no son)
gen head_dum_patri_strong = (head_num_son>0 & head_num_daughter==0 & head_male==1) // strong patrilocal (no daughter)
gen head_dum_polygamy = (head_num_spouse>1 & head_male==1) // polygamous household
gen head_dum_polygyny = (head_num_spouse>1 & head_male==0) // polygynous household

label variable head_dum_three_gen "Three generations w/in HH"
label variable head_dum_nonlin "Non-lineal desc. w/in HH"
label variable head_dum_any_kin "Any kin of head w/in HH"
label variable head_dum_any_fam "Any family of head w/in HH"
label variable head_dum_any_desc "Any desc. of head w/in HH"
label variable head_dum_any_adult_kid "Any adult child of head w/in HH"
label variable head_dum_any_parent "Any parent of head w/in HH"
label variable head_dum_one_adult_kid "One adult child of head w/in HH"
label variable head_dum_any_other "Any other kind of relative w/in HH"
label variable head_dum_nuclear "Only nuclear members in HH"
label variable head_dum_nepnie "Any niece/nephews w/in HH"
label variable head_dum_daughter "Any daughter w/in HH"
label variable head_dum_son "Any son w/in HH"
label variable head_dum_matrilocal "Female head w/ daughter in HH"
label variable head_dum_patrilocal "Male head w/ son in HH"
label variable head_dum_matri_strong "Female head w/ daug, no son in HH"
label variable head_dum_patri_strong "Male head w/ son, no daug in HH"
label variable head_dum_polygamy "Polygamous HH head"
label variable head_dum_polygyny "Polygynous HH head"


// Head of HH education variables
capture confirm variable hv106_01
if !_rc {
	gen head_ed_level = hv106_01
}
capture confirm variable hv107_01
if !_rc {
	gen head_ed_years = hv107_01
}

// Renaming id and weight variables
rename hv005 dhs_weight // as a mental check
qui replace dhs_weight = dhs_weight/1000000 // scale the hh weight
rename hv001 cluster // meaningful name		
rename hv002 hh_id // household ID

gen ccode = substr(hv000,1,2) // pull country code
gen phase = substr(hv000,3,1) // pull DHS phase
move ccode cluster // move to lead position
move phase cluster // move to lead position

// Household size measures and other variables
gen head_age = hv220 // create new variable for clarity
egen head_age_group = cut(head_age), at(15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90) // create age groups
label variable head_age_group "HH head age"

gen sum_hh = 1 // for use in counting up total HH within each cluster
gen hh_mem_dejure = hv012 // usual number of hh members
label variable hh_mem_dejure "Number of usual members w/in HH"
gen hh_mem_defact = hv013 // number who slept in hh last night

// Age structure
forvalues a = 9(10)99 {
	bysort cluster: egen cluster_range_`a' = total(head_num_range_`a') // add up numbers by age range
} // end forvalues		
egen cluster_range_total = rowtotal(cluster_range_*) // total number of people in age ranges
forvalues a = 9(10)99 {
	qui replace cluster_range_`a' = cluster_range_`a'/cluster_range_total // replace cluster numbers by percents of totals
} // end forvalues		
drop cluster_range_total

// Household facility dummies 
gen hh_flush = (inlist(hv205,10,11,12,13,14,15)) // flush toilet of some kind
gen hh_elec  = (hv206==1) // electricity
gen hh_tv    = (hv208==1) // TV
gen hh_frig  = (hv209==1) // refrigerator
gen hh_floor = (inlist(hv213,30,31,32,33,34,35)) // floor (finished)
capture confirm variable hv244 // check for variable
if !_rc { // if exists
	gen hh_land = (hv244==1) // owns land suitable for agriculture
	gen hh_hect = hv245 if hv245<998 
}
capture confirm variable hv247 // check for variable
if !_rc {
	gen hh_bank  = (hv247==1) // bank account
}

capture confirm variable hv246 // check for variable on livestock
if !_rc { // if exists
	gen hh_live  = (hv246==1) // owns livestock, herds, farm animals
	gen hh_cattle_dum = (hv246a>0 & hv246a<98) // owns cattle at all
	gen hh_cattle_num = hv246a if hv246a<98 // count of cattle owned (incl 0)
	gen hh_draft_dum = (hv246c>0 & hv246c<98) // owns draft animal
	gen hh_draft_num = hv246c if hv246c<98 //  count of draft animal (incl 0)
	gen hh_sheep_dum = (hv246e>0 & hv246e<98) // owns sheep at all
	gen hh_sheep_num = hv246e if hv246e<98 // count of sheep (incl 0)
	//gen hh_chick_dum = (hv247f>0 & hv247f<98) // owns chickens at all
	//gen hh_chick_num = hv247f if hv246f<98 // count of chickens (incl 0)
	
	label variable hh_live "HH with livestock"
}
capture confirm variable hv025
if !_rc {
	gen hh_urban = (hv025==1) // is in an urban area
}

// Labels for variables

// Save dataset of all household records
keep ccode phase cluster hh_* head_* sum_hh dhs_weight cluster_* // limit the variables to save space
	
