////////////////////////////////////////////////////////////////////////////
// Ethnographic Atlas processing
////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
// Fix EA fields and merge with ID code used in R spatial processing
////////////////////////////////////////////////////////////////////////////
insheet using "./Data/ethatlas-id.csv", names clear // pull in the ID variables used in R processing
save "./Work/ethatlas-id.dta", replace // save copy of this for merging

use "./Data/ethatlas.dta", clear // pull in the full EA
save "./Work/ethatlas.dta", replace // save working version

rename V107 ea_name // change name to merge with IDs
rename V104 ea_latitude // change name to merge with IDs
rename V106 ea_longitude // change name to merge with IDs

duplicates drop ea_name ea_latitude ea_longitude, force // TOKELAU is duplicated, remove one instance

destring ea_latitude, replace // put in numeric format for merging
destring ea_longitude, replace
replace ea_longitude = -109 if ea_name=="EASTER. ." // fix longitude of Easter Island in original EA file

merge 1:1 ea_name ea_latitude ea_longitude using "./Work/ethatlas-id.dta" // merge in the numeric identifiers used in the DHS datasets

////////////////////////////////////////////////////////////////////////////
// Create family type variables for use
////////////////////////////////////////////////////////////////////////////
gen ea_monogamy_dum = 0
replace ea_monogamy_dum = 1 if inlist(V9,1) // dummy for monogamy
replace ea_monogamy_dum = . if inlist(V9,0) // missing

gen ea_nuclear_dum = 0
replace ea_nuclear_dum = 1 if inlist(V8,1,2) // dummy for independent nuclear families (monog or poly)
replace ea_nuclear_dum = . if inlist(V8,0)

gen ea_extended_dum = 0
replace ea_extended_dum = 1 if inlist(V8,6,7,8) // dummy for extended families
replace ea_extended_dum = . if inlist(V8,0) 

gen ea_neolocal_dum = 0
replace ea_neolocal_dum = 1 if inlist(V11,2) // dummy for neolocal (or either) location
replace ea_neolocal_dum = . if inlist(V11,0) 

gen ea_cous1marr_dum = 0
replace ea_cous1marr_dum = 1 if inlist(V24,1,2,3,4) // dummy for allowed 1st cousin marriage
replace ea_cous1marr_dum = . if inlist(V24,0)

gen ea_bilateral_dum = 0
replace ea_bilateral_dum = 1 if inlist(V43,4,5,6) // dummy for bilateral descent
replace ea_bilateral_dum = . if inlist(V43,0)

save "./Work/ethatlas.dta", replace // save working version

////////////////////////////////////////////////////////////////////////////
// Create separate files for use in merging to nearby EA cultures
////////////////////////////////////////////////////////////////////////////
forvalues i = 1(1)3 {
	use "./Work/ethatlas.dta", clear // save working version
	foreach v of varlist ea_* {
		rename `v' `v'_close`i'
	}
	keep ea_*

	save "./Work/ethatlas_close`i'.dta", replace // save working version
}

////////////////////////////////////////////////////////////////////////////
// Merge the EA data to the master HH and female datasets
////////////////////////////////////////////////////////////////////////////
use "./Work/DHS-all-hh.dta", clear
capture drop _merge
merge m:1 ea_id_close1 using "./Work/ethatlas_close1.dta"

capture drop _merge
merge m:1 ea_id_close2 using "./Work/ethatlas_close2.dta"

capture drop _merge
merge m:1 ea_id_close3 using "./Work/ethatlas_close3.dta"

save "./Work/DHS-all-hh.dta", replace

use "./Work/DHS-all-female.dta", clear
capture drop _merge
merge m:1 ea_id_close1 using "./Work/ethatlas_close1.dta"

capture drop _merge
merge m:1 ea_id_close2 using "./Work/ethatlas_close2.dta"

capture drop _merge
merge m:1 ea_id_close3 using "./Work/ethatlas_close3.dta"

save "./Work/DHS-all-female.dta", replace
