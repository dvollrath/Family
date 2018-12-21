
use "./Work/DHS-all-female.dta", clear
gen dmsp_light_mean_dum = (dmsp_light_mean>0)
gen suit_whe_only_dum = (suit_rcw==0 & suit_whe>0)
gen suit_rcw_only_dum = (suit_rcw>0 & suit_whe==0)
gen suit_whe_dum = (suit_whe>0)
gen suit_rcw_dum = (suit_rcw>0)
gen suit_both_dum = (suit_whe>0 & suit_rcw>0)
gen frost_dum = (agro_lt3<330)

qui reghdfe fem_age_first_birth i.ea_nuclear_dum_close1##(ib35.fem_age_group) ///
	i.ea_neolocal_dum_close1##(ib35.fem_age_group) ///
	i.ea_bilateral_dum_close1##(ib35.fem_age_group) ///
	i.ea_cous1marr_dum_close1##(ib35.fem_age_group) ///
	i.ea_monogamy_dum_close1##(ib35.fem_age_group) ///
	i.suit_rcw_dum##(ib35.fem_age_group) ///
	i.suit_whe_dum##(ib35.fem_age_group) ///
	i.frost_dum##(ib35.fem_age_group) ///
	hh_elec hh_flush hh_tv hh_frig head_ed_level fem_years_ed dmsp_light_mean_dum ///
	if ea_dist_close1<200000 & fem_urban==0 [aweight = dhs_weight], absorb(survey_id) cluster(cluster_id)

estimates store reg1
 
coefplot (reg1, label(Nuclear dummy)), ///
	keep(1.ea_*_dum_close1 1.hh_urban 1.*_dum) 

coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.suit_rcw_dum#??.fem_age_group) ///
	rename(^1.suit_rcw_dum#([0-9]+).fem_age_group$ = \1, regex)

coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.suit_whe_dum#??.fem_age_group) ///
	rename(^1.suit_whe_dum#([0-9]+).fem_age_group$ = \1, regex)

coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.frost_dum#??.fem_age_group) ///
	rename(^1.frost_dum#([0-9]+).fem_age_group$ = \1, regex)
				
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(??.fem_age_group) ///
	rename(^([0-9]+).fem_age_group$ = \1, regex)	
	
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.ea_neolocal_dum_close1#??.fem_age_group) ///
	rename(^1.ea_neolocal_dum_close1#([0-9]+).fem_age_group$ = \1, regex)
	
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.ea_nuclear_dum_close1#??.fem_age_group) ///
	rename(^1.ea_nuclear_dum_close1#([0-9]+).fem_age_group$ = \1, regex)
		
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.ea_bilateral_dum_close1#??.fem_age_group) ///
	rename(^1.ea_bilateral_dum_close1#([0-9]+).fem_age_group$ = \1, regex)
		
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.ea_cous1marr_dum_close1#??.fem_age_group) ///
	rename(^1.ea_cous1marr_dum_close1#([0-9]+).fem_age_group$ = \1, regex)
		
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.ea_monogamy_dum_close1#??.fem_age_group) ///
	rename(^1.ea_monogamy_dum_close1#([0-9]+).fem_age_group$ = \1, regex)
				
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.hh_urban#??.fem_age_group) ///
	rename(^1.hh_urban#([0-9]+).fem_age_group$ = \1, regex)

	
	
*/

