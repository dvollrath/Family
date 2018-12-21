////////////////////////////////////////////////////////////////////////////
// Go through all DHS folders - one for each Country/Phase
// -- Process household records, create variables
// -- Merge cluster level geographic data with household records
// -- Merge spatial data produced by R
// -- Process women's records, create variables
// -- Merge household data with women's records
// -- Produces two files - household and female
////////////////////////////////////////////////////////////////////////////

local ct_survey = 0 // to count total surveys processed
local miss_IR "" // to capture surveys w/o female records
local miss_CSV "" // to capture surveys w/o spatial CSV file
local miss_SPAT "" // to capture surveys w/o spatial R file

// Get the name of all DHS folders in data directory for DHS
local folderList : dir "./Data/CollectDHS/" dirs "DHS*" 

////////////////////////////////////////////////////////////////////////////
// For each folder/survey found
////////////////////////////////////////////////////////////////////////////
foreach folder of local folderList { // loop through every folder 
//foreach folder in DHSTG31 { // test directory
	di "`folder'" // folder names are DHSCCVV, CC is country code, VV is version
	local ct_survey = `ct_survey' + 1
	quietly {
	////////////////////////////////////////////////////////////////////////////
	// Process cluster level geographic data
	////////////////////////////////////////////////////////////////////////////
	local fileList : dir "./Data/CollectDHS/`folder'" files "??GC??FL.csv" // get cluster geography CSV
	local CSV_file_exists = 0
	
	foreach file of local fileList { // for each of the CSV files (should be only one, this is for safety)
		insheet using "./Data/CollectDHS/`folder'/`file'", names clear // read in the CSV file
		local CSV_file_exists = 1		
		quietly do "./Code/Fert_DHS_Build_Cluster.do" // script to generate cluster variables for matching
		save "./Work/`folder'-all-cluster.dta", replace // save cluster info using CCVV term
	}

	////////////////////////////////////////////////////////////////////////////
	// Process cluster level spatial data from R
	////////////////////////////////////////////////////////////////////////////
	local SPAT_file_exists = 0
	capture confirm file "./Work/`folder'-all-spatial.csv" // check that spatial file exists
	if _rc==0 { // if file is there
		local SPAT_file_exists = 1
		insheet using "./Work/`folder'-all-spatial.csv", names clear // pull in spatial csv file
		save "./Work/`folder'-all-spatial.dta", replace // save Stata version
	}
	
	////////////////////////////////////////////////////////////////////////////	
	// Process household level records
	////////////////////////////////////////////////////////////////////////////	
	local fileList : dir "./Data/CollectDHS/`folder'" files "??HR????.dta" // get HR file name
	local HR_file_exists = 0 // norm to zero
	
	foreach file of local fileList { // for each of those HR files (should only be one, this is just a safety)
		use "./Data/CollectDHS/`folder'/`file'", clear // open file
		local HR_file_exists = 1 // flag that HR record is there
		quietly do "./Code/Fert_DHS_Build_Head.do" // script to generate variables of interest
		gen folder = "`folder'" // add a field with actual folder name to be clear on origin
		move folder hh_id // move to earlier position
		save "./Work/`folder'-all-hh.dta", replace // save HR file using CCVV term
	} // end foreach household file
	
	////////////////////////////////////////////////////////////////////////////
	// Merge household with cluster data
	////////////////////////////////////////////////////////////////////////////	
	if `CSV_file_exists'==1 & `HR_file_exists'==1 { // if you have both CSV and HR files
		use "./Work/`folder'-all-hh.dta", clear
		merge m:1 ccode cluster using "./Work/`folder'-all-cluster.dta", ///
			keep(match master) // only keep matched HH records
		drop _merge
		save "./Work/`folder'-all-hh.dta", replace
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Merge household with spatial data
	////////////////////////////////////////////////////////////////////////////	
	if `SPAT_file_exists'==1 & `HR_file_exists'==1 { // if you have both CSV and HR files
		use "./Work/`folder'-all-hh.dta", clear
		merge m:1 folder cluster using "./Work/`folder'-all-spatial.dta", ///
			keep(match master) // only keep matched HH records
		drop _merge
		save "./Work/`folder'-all-hh.dta", replace
	}
	
	////////////////////////////////////////////////////////////////////////////	
	// Process female level records
	////////////////////////////////////////////////////////////////////////////	
	local fileList : dir "./Data/CollectDHS/`folder'" files "??IR????.dta" // get IR file name
	local IR_file_exists = 0 // norm to zero
	
	foreach file of local fileList { // for each of those HR records (should only be one, this is just a safety)
		use "./Data/CollectDHS/`folder'/`file'", clear // open file
		local IR_file_exists = 1 // norm to zero
		quietly do "./Code/Fert_DHS_Build_Female.do" // script to generate variables of interest
		gen folder = "`folder'" // add a field with actual file name to make source clear
		move folder hh_id // move to earlier position
		save "./Work/`folder'-all-female.dta", replace // save IR file using CCVV term
	}

	////////////////////////////////////////////////////////////////////////////	
	// Merge female with household data
	////////////////////////////////////////////////////////////////////////////	
	if `HR_file_exists' == 1 & `IR_file_exists'==1 { // if the HR record actually existed
		use "./Work/`folder'-all-female.dta", clear
		merge m:1 ccode phase cluster hh_id using "./Work/`folder'-all-hh.dta", ///
			keep(match master) // keep only the female records with hh matches
		save "./Work/`folder'-all-female.dta", replace
	}
	
	if `IR_file_exists' == 0 { // add name of folder if female folder does not exist
		local miss_IR "`miss_IR'" "`folder'"
	}
	
	if `CSV_file_exists' == 0 { // add name of folder if spatial CSV file does not exist
		local miss_CSV "`miss_CSV'"  "`folder'"
	}
	if `SPAT_file_exists' ==0 { // add name of folder if spatial CSV file does not exist
		local miss_SPAT "`miss_SPAT'" "`folder'"
	}
	
	} // end quietly
} // end foreach folder

di "Total surveys: " (`ct_survey')
di "Missing IR file: `miss_IR'"
di "Missing CSV file: `miss_CSV'"
di "Missing SPAT file: `miss_SPAT'"
