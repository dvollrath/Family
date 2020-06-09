////////////////////////////////////////////////////////////////////////////
// Go through all DHS folders - one for each Country/Phase
////////////////////////////////////////////////////////////////////////////
cd "~/dropbox/project/family" // set master location, all folders reference this

local ct_survey = 0 // to count total surveys processed

// Get the name of all DHS folders in data directory for DHS
local folderList : dir "./Data/CollectDHS/" dirs "DHS*" 

////////////////////////////////////////////////////////////////////////////
// For each folder/survey found
////////////////////////////////////////////////////////////////////////////
foreach folder of local folderList { // loop through every folder 
//foreach folder in DHSKM61 { // test directory
	di "`folder'" // folder names are DHSCCVV, CC is country code, VV is version
	local ct_survey = `ct_survey' + 1
	
	////////////////////////////////////////////////////////////////////////////
	// Create GADM stata file from CSV
	////////////////////////////////////////////////////////////////////////////
	capture confirm file "./Work/`folder'-gadm.csv" // check that spatial file exists
	if _rc==0 { // if file is there
		local GADM_file_exists = 1
		qui insheet using "./Work/`folder'-gadm.csv", names clear // pull in spatial csv file
		qui save "./Work/`folder'-gadm.dta", replace // save Stata version
	}

	////////////////////////////////////////////////////////////////////////////
	// Collapse the HH file down to GADM district level
	////////////////////////////////////////////////////////////////////////////
	local fileList : dir "./Data/CollectDHS/`folder'" files "??IR????.dta" // get HR file name
	foreach file of local fileList { // for each of those HR files (should only be one, this is just a safety)
		di "--`file' found"
		quietly {
		use "./Data/CollectDHS/`folder'/`file'", clear // open file
		do "./Code/Fert_DHS_Build_GADM_IR.do" // create hh variables to get summary data on
		
		merge m:1 ccode cluster using "./Work/`folder'-gadm.dta", ///
			keep(match master) // only keep matched HH records
		drop _merge
		
		// collapse down to GADM district level
		collapse (mean) ir_* ///
			(sum) count ///
			(first) name_0 name_1 name_2 dhsid folder ccode phase lat lon objectid regname ///
			[iw = dhs_weight], by(id_0 id_1 id_2)
			
		// eliminate any collapsed districts that lie *outside* of given country
		// -- this happens b/c the DHS villages are displaced 10km in a random direction, so border villages may be listed in another country
		// -- a bit of a fudge to compare id_0 numbers, and eliminate ones that appear infrequently
		summ id_0, det
		drop if id_0~=r(p50) // drop if id_0 is not equal to the median id_0, which would be dominant id_0
		drop if id_0==. // drop if there are districts that didn't match with GADM data
		} // end quietly
		
		qui count 
		di "--district count: " (r(N))
		if r(N)>0 { // only save if count is above 0, to avoid blank datasets
			qui save "./Work/`folder'-gadm-ir.dta", replace
		} // end if
	} // end foreach file in filelist
	di ""
} // end foreach folder

di "Total surveys: " (`ct_survey')

local fileList : dir "./Work/" files "DHS????-gadm-ir.dta" // get list of all file name

clear
save "./Work/DHS-all-gadm-ir.dta", emptyok replace // create empty dataset

foreach file of local fileList { // for each of the cluster average DHS files found
	di "`file'"
	append using "./Work/`file'" // add to the base file
}

gen year = substr(dhsid,3,4) // pull the four char year from DHS id
destring year, replace
bysort ccode: egen year_max = max(year)
keep if year==year_max

gen surveynum = substr(folder,7,1) // get number of survey in phase
destring surveynum, replace
bysort ccode: egen surveynum_max = max(surveynum)
keep if surveynum == surveynum_max
save "./Work/DHS-all-gadm-ir.dta", replace // save the base file

save "~/Dropbox/project/crops/data/dhs/DHS-all-gadm-ir.dta", replace
//save "~/Dropbox/project/crops/work/DHS-all-gadm-ir.dta", replace

