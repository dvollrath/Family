////////////////////////////////////////////////////////////////////////////
// Estimate age profiles for being head of HH, by type of head
////////////////////////////////////////////////////////////////////////////
graph set window fontface "Garamond"
set scheme plotplain 

// Set work directory where all folders are located
cd "~/dropbox/project/family"

// Set control variables to include
local control0 head_ed_level
local control1 hh_elec hh_flush hh_tv hh_frig head_ed_level
local control2 hh_elec hh_flush hh_tv hh_frig head_ed_level hh_land hh_live
local x hh_cattle_dum

////////////////////////////////////////////////////////////////////////////
// Estimates for three-generation household heads, by livestock
////////////////////////////////////////////////////////////////////////////
// For each of the listed dependent variables, run the regressions
foreach d in head_dum_polygamy /// 
			 head_dum_three_gen ///
			 head_dum_any_adult_kid ///
			 head_dum_patrilocal ///
			 head_dum_patri_strong ///
			 hh_mem_dejure {
	use "./Work/DHS-all-hh.dta", clear
	keep if head_age>19 // only use heads who are plausibly adults
	keep if !missing(`x') // keep only if they have livestock variable
	keep if hh_urban==0 // keep only rural residents
	local lab: variable label `d' // save the label of the dependent variable		 

	estimates clear

	display "Using dep variable: `d'"
	foreach c in control0 control1 control2 {
		display "--Reg with controls: `c'"
		qui reghdfe `d' i.`x'##(i.head_age_group ``c'') [aweight = dhs_weight], absorb(survey_id) cluster(cluster_id)	

		qui gen sample_`c' = e(sample)
		mat R = r(table)
		mat M = R[1..2,colnumb(R,"25.head_age_group")..colnumb(R,"85.head_age_group")] // get just columns with coef for main age effects
		mat I = R[1..2,colnumb(R,"1.`x'#25.head_age_group")..colnumb(R,"1.`x'#85.head_age_group")] // get just columns with coef for interaction effects
		mat B`c' = [M', I'] // combine transposes
		mat colnames B`c' = b_none se_none b_live se_live // name columns for use later

		qui tabulate survey_id if e(sample)==1
		qui estadd scalar N_survey = r(r)
		qui count if e(sample)==1
		qui estadd scalar N_obs = r(N)
		estimates store est_`c'
	} // end foreach control
		
	// Produce table of results
	display "--Produce table of results"
	esttab est_control? using "./Drafts/tab_reg_`d'.tex", replace label fragment ///
		booktabs nomtitles b(3) se(3) noobs /// 
		keep(1.`x'#??.head_age_group) ///
		indicate("Education = *ed_leve*" "HH wealth = *h_flus*" "HH land = *h_lan*") ///
		scalars("r2 R-squared" "N_survey No. of surveys" "N_obs No. of obs.") ///
		sfmt(%9.3f %9.0g %9.0fc)
	
	// Produce plot of coefficients on age group interactions
	display "--Produce coefficient plot"
	coefplot (est_control0, label(Control for educ.)) (est_control1, label(plus HH wealth)) (est_control2, label(plus HH land)), ///
		vertical keep(1.`x'#??.head_age_group) yline(0) ///
		rename(^1.`x'#([0-9]+).head_age_group$ = \1, regex) /// renames interaction terms to juse just age
		ytitle("`lab'" "Rel. probability for HH w/ livestock") xtitle("Age group of HH head (lower bound)")
	graph export "./Drafts/fig_coef_`d'.png", as(png) replace
	
	// Produce figure of raw averages by age group
	display "--Collapse and produce raw average figure"
	collapse (mean) `d', by(`x' head_age_group)
	
	twoway (scatter `d' head_age_group if `x'==1, connect(l) color(black) clpattern(solid) msymbol(o)) ///
		(scatter `d' head_age_group if `x'==0, connect(l) color(black) clpattern(dash)), ///
		ytitle("`lab'" "Percent of household heads") xtitle("Age group of HH head (lower bound)") ///
		xlabel(20(5)85) legend(label(1 "HH with livestock") label(2 "HH w/o livestock"))
	graph export "./Drafts/fig_raw_`d'.png", as(png) replace
	
	// Produce figure showing relative effects of age with and without livestock
	display "--Plot estimated age effects"
	clear // wipe out the actual data
	svmat Bcontrol2, names(col) // create variables from the matrix of coefficient estimates

	qui gen head_age_group = 20 + _n*5 // generate variable to label graph axis

	label variable b_live "HH with livestock" // label coefficient estimates
	label variable b_none "HH w/o livestock" // label coefficient estimates
	replace b_live = b_live + b_none // create actual levels, not difference
	gen b_live_max = b_live + 1.96*se_live // create CI limits
	gen b_live_min = b_live - 1.96*se_live
	gen b_none_max = b_none + 1.96*se_live
	gen b_none_min = b_none - 1.96*se_live
	
	twoway (rarea b_live_min b_live_max head_age_group, color(gs14)) (rarea b_none_min b_none_max head_age_group, color(gs14)) ///
		(scatter b_live head_age_group, connect(l) color(black) clpattern(solid) msymbol(o)) (scatter b_none head_age_group, connect(l) color(black) clpattern(dash)), ///
		ytitle("`lab'" "Likelihood rel to 20-24 y.o") xtitle("Age group of HH head (lower bound)") ///
		xlabel(25(5)85) legend(order(3 4))
	graph export "./Drafts/fig_`d'.png", as(png) replace
	
} // end foreach dependent variable


	
