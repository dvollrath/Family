////////////////////////////////////////////////////////////////////////////
// Merge the individual DHS summary files into a single cluster-level file
////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
// Merge female-level files
////////////////////////////////////////////////////////////////////////////
local fileList : dir "./Work/" files "DHS????-all-female.dta" // get list of all file name

clear
save "./Work/DHS-all-female.dta", emptyok replace // create empty dataset

foreach file of local fileList { // for each of the cluster average DHS files found
	di "`file'"
	append using "./Work/`file'" // add to the base file
}

save "./Work/DHS-all-female.dta", replace // save the base file

egen survey_id = group(folder) // identify separate surveys with numeric ID
egen cluster_id = group(survey_id cluster) // identify separate clusters across all surveys

bysort survey_id: egen dhs_weight_survey = sum(dhs_weight) // get summation of dhs weights
replace dhs_weight = dhs_weight/dhs_weight_survey // set weight relative to own DHS survey
qui tabulate survey_id // tabulate to count number of actual surveys
replace dhs_weight = dhs_weight/r(r) // scale all weights by 1/number of surveys (treats all surveys equally)

save "./Work/DHS-all-female.dta", replace // save the new base file
