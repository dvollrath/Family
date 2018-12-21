////////////////////////////////////////////////////////////////////////////
// Create cluster variables
////////////////////////////////////////////////////////////////////////////

rename dhscc ccode // rename to match HH/IR records
rename dhsclust cluster // rename to match HH/IR records

gen phase = substr(gps_dataset,5,1) // pull phase number to match HH/IR records

duplicates tag cluster, gen(dupe) // check for duplicate clusters

summ dupe // summarize the duplicate variable
if r(mean)>0 { // no dupes means a zero average, if not, clean up cluster ID's
	gen cluster_text = substr(dhsid,7,8) // extract cluster id from dhsid
	rename cluster cluster_bkup // save off the reported cluster id
	destring cluster_text, gen(cluster) // generate new cluster variable using extracted text
}

foreach var of varlist _all { // go through every variable to check for missing
	capture confirm numeric variable `var' // check if a string
	if !_rc { // for numeric variables
		replace `var' = . if `var'==-9999 // replace missing -9999 values with .
	}
}


