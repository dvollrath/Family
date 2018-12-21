////////////////////////////////////////////////////////////////////////////
// Build single file of cluster-leve spatial data
// - Do this for each type of spatial data prepared in R
////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
// For each type of spatial data, create single file
////////////////////////////////////////////////////////////////////////////
foreach d in dmsp csi suit atlas { // four types of spatial data prepared in R
	local fileList : dir "./Work" files "*-`d'.csv"
	
	clear
	save "./Work/DHS-all-`d'.dta", emptyok replace
	
	foreach file of local fileList { // for each of the CSV files with that spatial data
		insheet using "./Work/`file'", names clear // read in the CSV file
		append using "./Work/DHS-all-`d'.dta"
		save "./Work/DHS-all-`d'.dta", replace
	}
}

