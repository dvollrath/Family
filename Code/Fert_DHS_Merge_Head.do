////////////////////////////////////////////////////////////////////////////
// Merge the individual DHS summary files into a single cluster-level file
////////////////////////////////////////////////////////////////////////////

// Set work directory where all folders are located
cd "~/dropbox/project/family"

// Set locals for control of process
local minage 50 // min age of HH heads to do this process for

////////////////////////////////////////////////////////////////////////////
// Merge hh-level files
////////////////////////////////////////////////////////////////////////////
local fileList : dir "./Work/" files "??HR??-all-hh.dta" // get list of all file name

clear
save "./Work/DHS-all-hh.dta", emptyok replace // create empty dataset

foreach file of local fileList { // for each of the cluster average DHS files found
	di "`file'"
	append using "./Work/`file'" // add to the base file
	save "./Work/DHS-all-hh.dta", replace // save the base file
}

// Create index values and age groups
egen survey = group(ccode phase) // identify separate surveys with numeric ID
egen cluster_id = group(survey cluster) // identify separate clusters across all surveys
egen head_age_group = cut(head_age), at(15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90) // create age groups

bysort survey: egen dhs_weight_survey = sum(dhs_weight) // get summation of dhs weights
replace dhs_weight = dhs_weight/dhs_weight_survey // set weight relative to own DHS survey
qui tabulate survey // tabulate to count number of actual surveys
replace dhs_weight = dhs_weight/r(r) // scale all weights by 1/number of surveys (treats all surveys equally)

label variable head_dum_three_gen "Three generations w/in HH"
label variable head_dum_nonlin "Non-lineal desc. w/in HH"
label variable head_dum_any_kin "Any kin of head w/in HH"
label variable head_dum_any_fam "Any family of head w/in HH"
label variable head_dum_any_desc "Any desc. of head w/in HH"
label variable head_dum_any_adult_kid "Any adult child of head w/in HH"
label variable head_dum_any_parent "Any parent of head w/in HH"
label variable hh_mem_dejure "Number of usual members w/in HH"
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
label variable hh_live "HH with livestock"
label variable head_age_group "HH head age"

save "./Work/DHS-all-hh.dta", replace // save the new base file
