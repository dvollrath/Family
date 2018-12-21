////////////////////////////////////////////////////////////////////////////
// Merge the individual DHS summary files into a single cluster-level file
////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
// Merge hh-level files
////////////////////////////////////////////////////////////////////////////
local fileList : dir "./Work/" files "DHS????-all-hh.dta" // get list of all file name

clear
save "./Work/DHS-all-hh.dta", emptyok replace // create empty dataset

foreach file of local fileList { // for each of the cluster average DHS files found
	di "`file'"
	append using "./Work/`file'" // add to the base file
}

save "./Work/DHS-all-hh.dta", replace // save the base file

// Create index values and age groups
egen survey_id = group(folder) // identify separate surveys with numeric ID
egen cluster_id = group(survey_id cluster) // identify separate clusters across all surveys
egen hh_tag = tag(cluster_id) // tag a single hh within cluster for use in cluster-level work


bysort survey_id: egen dhs_weight_survey = sum(dhs_weight) // get summation of dhs weights
replace dhs_weight = dhs_weight/dhs_weight_survey // set weight relative to own DHS survey
qui tabulate survey_id // tabulate to count number of actual surveys
replace dhs_weight = dhs_weight/r(r) // scale all weights by 1/number of surveys (treats all surveys equally)

save "./Work/DHS-all-hh.dta", replace // save the new base file
