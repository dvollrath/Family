
gen head_ed_level = .
capture confirm variable hv106_01
if !_rc {
	replace head_ed_level = hv106_01
}
gen head_ed_years = .
capture confirm variable hv107_01
if !_rc {
	replace head_ed_years = hv107_01
}

rename hv005 dhs_weight // as a mental check
qui replace dhs_weight = dhs_weight/1000000 // scale the hh weight
rename hv001 cluster // meaningful name		
rename hv002 hh_id // household ID

gen ccode = substr(hv000,1,2) // pull country code
gen phase = substr(hv000,3,1) // pull DHS phase
move ccode cluster // move to lead position
move phase cluster // move to lead position

gen head_age = hv220 // create new variable for clarity
gen hh_mem_dejure = hv012 // usual number of hh members
gen hh_mem_defact = hv013 // number who slept in hh last night

gen hh_flush = (inlist(hv205,10,11,12,13,14,15)) // flush toilet of some kind
gen hh_elec  = (hv206==1) // electricity
gen hh_tv    = (hv208==1) // TV
gen hh_frig  = (hv209==1) // refrigerator
gen hh_floor = (inlist(hv213,30,31,32,33,34,35)) // floor (finished)

gen hh_land = .
gen hh_hect = .
capture confirm variable hv244 // check for variable
if !_rc { // if exists
	replace hh_land = (hv244==1) // owns land suitable for agriculture
	replace hh_hect = hv245 if hv245<998 
}

gen hh_bank = .
capture confirm variable hv247 // check for variable
if !_rc {
	replace hh_bank  = (hv247==1) // bank account
}

gen hh_live = .
gen hh_cattle_dum = .
gen hh_cattle_num = .
gen hh_draft_dum = .
gen hh_draft_num = .
gen hh_sheep_dum = .
gen hh_sheep_num = .
capture confirm variable hv246 // check for variable on livestock
if !_rc { // if exists
	replace hh_live  = (hv246==1) // owns livestock, herds, farm animals
	replace hh_cattle_dum = (hv246a>0 & hv246a<98) // owns cattle at all
	replace hh_cattle_num = hv246a if hv246a<98 // count of cattle owned (incl 0)
	replace hh_draft_dum = (hv246c>0 & hv246c<98) // owns draft animal
	replace hh_draft_num = hv246c if hv246c<98 //  count of draft animal (incl 0)
	replace hh_sheep_dum = (hv246e>0 & hv246e<98) // owns sheep at all
	replace hh_sheep_num = hv246e if hv246e<98 // count of sheep (incl 0)
}

gen hh_urban = .
capture confirm variable hv025
if !_rc {
	replace hh_urban = (hv025==1) // is in an urban area
}
