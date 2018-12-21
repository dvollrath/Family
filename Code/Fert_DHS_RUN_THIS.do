////////////////////////////////////////////////////////////////////////////
// Master script
////////////////////////////////////////////////////////////////////////////

// Set preferences
cd "~/dropbox/project/family" // set master location, all folders reference this

graph set window fontface "Garamond" // change font in figures
set scheme plotplain // change figure style

// Data preparation scripts
//do "./Code/Fert_DHS_Repair.do" // repairs duplicates, etc.. in several DHS files

do "./Code/Fert_DHS_Build_Master.do" // create HH and Female files for each survey from raw DHS files

do "./Code/Fert_DHS_Merge_Female.do" // merge survey level Female files to single master file, reweight
do "./Code/Fert_DHS_Merge_Head.do" // merge survey level HH files to single master file, reweight
do "./Code/Fert_DHS_EthAtlas.do" // process Eth Atlas data, then merge to female and HH files

 // Regression analysis scripts
