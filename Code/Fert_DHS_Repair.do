////////////////////////////////////////////////////////////////////////////
// Repair identifiers for selected surveys
// - Needs to be run once only
////////////////////////////////////////////////////////////////////////////

// In each case, there is a backup of original file in the same folder

////////////////////////////////////////////////////////////////////////////
// For TG31
use "./Data/CollectDHS/DHSTG31/TGHR31FL.dta", clear

duplicates drop hv000 hv001 hv002, force // very few duplicates, drop

save "./Data/CollectDHS/DHSTG31/TGHR31FL.dta", replace


////////////////////////////////////////////////////////////////////////////
// For NG21
use "./Data/CollectDHS/DHSNG21/NGIR21FL.dta", clear

duplicates drop v000 v001 v002 v003, force // very few duplicates, drop

save "./Data/CollectDHS/DHSNG21/NGIR21FL.dta", replace


////////////////////////////////////////////////////////////////////////////
// For SN4H
use "./Data/CollectDHS/DHSSN42/SNHR4HFL.dta", clear

duplicates drop hv000 hv001 hv002, force // very few duplicates, drop

save "./Data/CollectDHS/DHSSN42/SNHR4HFL.dta", replace


////////////////////////////////////////////////////////////////////////////
// For NI31
use "./Data/CollectDHS/DHSNI31/NIHR31FL.dta", clear

duplicates drop hv000 hv001 hv002, force // very few duplicates, drop

save "./Data/CollectDHS/DHSNI31/NIHR31FL.dta", replace

use "./Data/CollectDHS/DHSNI31/NIIR31FL.dta", clear

duplicates drop v000 v001 v002 v003, force // very few duplicates, drop

save "./Data/CollectDHS/DHSNI31/NIIR31FL.dta", replace

////////////////////////////////////////////////////////////////////////////
// For NI22
// Coding of ID variables appears to just be wrong
// Some remaining duplicates on respondent ID, let Stata drop them
use "./Data/CollectDHS/DHSNI21/NIHR22FL.dta", clear

capture drop resp_id
gen resp_id = substr(hhid,11,2) // extract respondent ID
destring resp_id, replace // destring resp ID to a numeric
replace hv003 = resp_id // replace hv003 with correct numeric resp ID

capture drop household_id
gen household_id = substr(hhid,8,3) // extract household ID
destring household_id, replace // destring household ID to numerica
replace hv002 = household_id // replace hv002 with correct household ID

duplicates drop hv000 hv001 hv002, force // drop few remaining dupes

save "./Data/CollectDHS/DHSNI21/NIHR22FL.dta", replace

use "./Data/CollectDHS/DHSNI21/NIIR22FL.dta", clear

capture drop household_id
gen household_id = substr(caseid,8,3) // extract household ID
destring household_id, replace // destring household ID to numerica
replace v002 = household_id // replace hv002 with correct household ID

duplicates drop v000 v001 v002 v003, force // drop few remaining duplicates

save "./Data/CollectDHS/DHSNI21/NIIR22FL.dta", replace

////////////////////////////////////////////////////////////////////////////
// For ML41
// Coding of id variables appears to just be wrong
// Remains duplicates on reporting w/in household that look suspicious (data doesn't match)
// Let Stata remove those duplicates
use "./Data/CollectDHS/DHSML41/MLHR41FL.dta", clear

capture drop resp_id
gen resp_id = substr(hhid,11,2) // extract respondent ID
destring resp_id, replace // destring resp ID to a numeric
replace hv003 = resp_id // replace hv003 with correct numeric resp ID

capture drop household_id
gen household_id = substr(hhid,8,3) // extract household ID
destring household_id, replace // destring household ID to numerica
replace hv002 = household_id // replace hv002 with correct household ID

duplicates drop hv000 hv001 hv002, force 

save "./Data/CollectDHS/DHSML41/MLHR41FL.dta", replace

use "./Data/CollectDHS/DHSML41/MLIR41FL.dta", clear

capture drop household_id
gen household_id = substr(caseid,8,3) // extract household ID
destring household_id, replace // destring household ID to numerica
replace v002 = household_id // replace hv002 with correct household ID

duplicates drop v000 v001 v002 v003, force // remaining reported duplicates

save "./Data/CollectDHS/DHSML41/MLIR41FL.dta", replace


////////////////////////////////////////////////////////////////////////////
// For ML32
// The duplicates are for multiple respondents per househould - and data does not match
// Several hundred out of 8000-ish observations
// Without clear way to choose, let Stata drop them, keeping lowest respondent ID
use "./Data/CollectDHS/DHSML31/MLHR32FL.dta", clear

duplicates report hv000 hv001 hv002 // confirm that hv001-hv003 now identify unique households

duplicates drop hv000 hv001 hv002, force

save "./Data/CollectDHS/DHSML31/MLHR32FL.dta", replace


use "./Data/CollectDHS/DHSML31/MLIR32FL.dta", clear

duplicates report v000 v001 v002 v003

duplicates drop v000 v001 v002 v003, force 

save "./Data/CollectDHS/DHSML31/MLIR32FL.dta", replace


////////////////////////////////////////////////////////////////////////////
// For CM22
// Missing ID variables
// Several duplicates remain on respondent ID
use "./Data/CollectDHS/DHSCM21/CMHR22FL.dta", clear

capture drop resp_id
gen resp_id = substr(hhid,11,2) // extract respondent ID
destring resp_id, replace // destring resp ID to a numeric
replace hv003 = resp_id // replace hv003 with correct numeric resp ID

capture drop household_id
gen household_id = substr(hhid,8,3) // extract household ID
destring household_id, replace // destring household ID to numerica
replace hv002 = household_id // replace hv002 with correct household ID

duplicates drop hv000 hv001 hv002, force // remain some duplicates based on respondents, drop those

save "./Data/CollectDHS/DHSCM21/CMHR22FL.dta", replace

use "./Data/CollectDHS/DHSCM21/CMIR22FL.dta", clear

capture drop household_id
gen household_id = substr(caseid,8,3) // extract household ID
destring household_id, replace // destring household ID to numerica
replace v002 = household_id // replace hv002 with correct household ID

duplicates drop v000 v001 v002 v003, force // drop the 7 remaining duplicates

save "./Data/CollectDHS/DHSCM21/CMIR22FL.dta", replace
