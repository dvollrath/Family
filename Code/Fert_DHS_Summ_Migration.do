////////////////////////////////////////////////////////////////////////////
// Go through all DHS folders - one for each Country/Phase
////////////////////////////////////////////////////////////////////////////
cd "~/dropbox/project/family" // set master location, all folders reference this

local ct_survey = 0 // to count total surveys processed

capture file close f
file open f using "/users/dietz/dropbox/project/crops/work/DHS-summ-migration.csv", write replace
file write f "folder,count,c_always,c_visit,c_movers,c_mover5,c_mover5_2550,c_mover_samereg, c_mover_diffreg,"
file write f "c_urb_city,c_urb_town,c_urb_country,c_rur_city,c_rur_town,c_rur_country,c_2550,c_mover_2550, , , IR, MR, n_dhs_regions, country, year, n_gadm_states" _n

// Get the name of all DHS folders in data directory for DHS
local folderList : dir "./Data/CollectDHS/" dirs "DHS*" 

////////////////////////////////////////////////////////////////////////////
// For each folder/survey found
////////////////////////////////////////////////////////////////////////////
foreach folder of local folderList { // loop through every folder 
//foreach folder in DHSTZ72 DHSAL51 DHSTZ51 DHSBD61 { // test directory
	di "`folder'" // folder names are DHSCCVV, CC is country code, VV is version
	local ct_survey = `ct_survey' + 1
	
	////////////////////////////////////////////////////////////////////////////
	// Grab summary stats on migration from IR and MR records 
	////////////////////////////////////////////////////////////////////////////
	local fileList : dir "./Data/CollectDHS/`folder'" files "??IR????.dta" // get IR file name
	local femcount = 0
	mat F = J(18,1,.) // load results matrix with missing values
	
	foreach file of local fileList { // for each of those IR files (should only be one, this is just a safety)
		di "--`file' found"
		
		quietly {
		use "./Data/CollectDHS/`folder'/`file'", clear // open file
		count
		mat F[1,1] = r(N)		
		local femcount = r(N) // separate count of females
		
		capture confirm variable v104
		if !_rc {
			qui summ v104
			if r(mean)~=. { // if values of v104 are not all missing
				count if v104==95 // always lived there
				mat F[2,1] = r(N)
				count if v104==96 // visitors
				mat F[3,1] = r(N)
				count if inrange(v104,0,50) // movers 
				mat F[4,1] = r(N)
				count if inrange(v104,0,5) // movers in last 5 years
				mat F[5,1] = r(N)
				count if inrange(v104,0,5) & inrange(v012,25,50) // movers in last 5 years who are 25-50
				mat F[6,1] = r(N)
				count if inrange(v104,0,50) & inrange(v012,25,50) // movers who are 25-50
				mat F[16,1] = r(N)
			}
		}
		
		capture confirm variable v105a
		if !_rc {
			count if inrange(v104,0,50) & v101==v105a // movers who stayed in same region
			mat F[7,1] = r(N)
			count if inrange(v104,0,50) & v101!=v105a // movers who left region
			mat F[8,1] = r(N)
		}
	
		mat C = J(2,3,.)
		capture confirm variable v102 v105
		if !_rc {	
			tabulate v102 v105, matcell(C) // tabulate movers by current and previous location
			mat F[9,1] = el(C,1,1)	
			mat F[10,1] = el(C,1,2)
			mat F[11,1] = el(C,1,3)
			mat F[12,1] = el(C,2,1)
			mat F[13,1] = el(C,2,2)
			mat F[14,1] = el(C,2,3)
		}
		
		local numregion = 0
		capture confirm variable v101
		if !_rc {
			tabulate v101
			local numregion = r(r) // capture number of rows (regions) reported in survey
		}
		
		count if inrange(v012,25,50)
		mat F[15,1] = r(N)
		} // end quietly
	} // end foreach IR file
	
	local fileList : dir "./Data/CollectDHS/`folder'" files "??MR????.dta" // get MR file name
	local malecount = 0
	mat M = J(18,1,0) // load male results with zeros, so they add to female appropriately
	
	foreach file of local fileList { // for each of those MR files (should only be one, this is just a safety)
		di "--`file' found"
		
		quietly {
		use "./Data/CollectDHS/`folder'/`file'", clear // open file
		count
		mat M[1,1] = r(N)
		local malecount = r(N) // separate count of males
		
		capture confirm variable mv104
		if !_rc {
			qui summ mv104
			if r(mean)~=. { // if values of v104 are not all missing
				count if mv104==95 // always lived there
				mat M[2,1] = r(N)
				count if mv104==96 // visitors
				mat M[3,1] = r(N)
				count if inrange(mv104,0,50) // movers 
				mat M[4,1] = r(N)
				count if inrange(mv104,0,5) // movers in last 5 years
				mat M[5,1] = r(N)
				count if inrange(mv104,0,5) & inrange(mv012,25,100) // movers in last 5 years who are 25+
				mat M[6,1] = r(N)
				count if inrange(mv104,0,50) & inrange(mv012,25,50) // movers who are 25-50
				mat M[16,1] = r(N)
			}
		}
		
		capture confirm variable mv105a
		if !_rc {
			count if inrange(mv104,0,50) & mv101==mv105a // movers who stayed in same region
			mat M[7,1] = r(N)
			count if inrange(mv104,0,50) & mv101!=mv105a // movers who left region
			mat M[8,1] = r(N)
		}
		
		mat C = J(2,3,.)
		capture confirm variable mv102 mv105
		if !_rc {			
			tabulate mv102 mv105, matcell(C) // tabulate movers by current and previous location
			mat M[9,1] = el(C,1,1)	
			mat M[10,1] = el(C,1,2)
			mat M[11,1] = el(C,1,3)
			mat M[12,1] = el(C,2,1)
			mat M[13,1] = el(C,2,2)
			mat M[14,1] = el(C,2,3)
		}
		
		count if inrange(mv012,25,50)
		mat M[15,1] = r(N)

		} // end quietly
	} // end foreach MR file
		
	di ""
	if `malecount'~=0 { // if both female and male records were found
		mat T = F + M // add together totals from female and male records
	}
	else {
		mat T = F
	}
	
	// Open and capture country name and year from GADM file
	capture confirm file "./Work/`folder'-gadm.csv" // check that spatial file exists
	if _rc==0 { // if file is there
		qui insheet using "./Work/`folder'-gadm.csv", names clear // pull in spatial csv file
		qui gen year = substr(dhsid,3,4) // pull the four char year from DHS id
		qui destring year, replace
		local surveyyear = year[1] // pull the year of survey
		qui tabulate name_1 // tabulate all state names
		local surveystate = r(r) // count number of GADM states		
		qui capture drop if name_0=="" // drop if blank country name (some clusters don't match)
		local surveycountry = name_0[1] // pull the country name
	}
	
	// Write counts from IR and MR records to output file
	file write f "`folder'"
	forvalues i = 1(1)18 {
		file write f ","  (el(T,`i',1)) 
	}
	// Write separate counts of male/female
	file write f "," (`femcount')
	file write f "," (`malecount')
	file write f "," (`numregion')
	
	// Write survey information to output file
	file write f ", `surveycountry', `surveyyear', `surveystate'"
	file write f _n
	
} // end foreach folder

di "Surveys processed: " (`ct_survey')
capture file close f
