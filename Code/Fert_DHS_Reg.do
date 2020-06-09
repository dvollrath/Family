
use "./Work/DHS-all-hh.dta", clear
gen dmsp_light_mean_dum = (dmsp_light_mean>0)
gen suit_whe_only_dum = (suit_rcw==0 & suit_whe>0)
gen suit_rcw_only_dum = (suit_rcw>0 & suit_whe==0)
gen suit_whe_dum = (suit_whe>0)
gen suit_rcw_dum = (suit_rcw>0)
gen suit_both_dum = (suit_whe>0 & suit_rcw>0)
gen frost_dum = (agro_lt3<330)

qui reghdfe head_dum_nuclear i.hh_urban##(i.ea_nuclear_dum_close1##(ib35.head_age_group) ///
	i.ea_neolocal_dum_close1##(ib35.head_age_group) ///
	i.ea_bilateral_dum_close1##(ib35.head_age_group) ///
	i.ea_nocous1marr_dum_close1##(ib35.head_age_group) ///
	i.ea_monogamy_dum_close1##(ib35.head_age_group) ///
	i.suit_rcw_dum##(ib35.head_age_group) ///
	i.suit_whe_dum##(ib35.head_age_group) ///
	i.frost_dum##(ib35.head_age_group) ///
	hh_elec hh_flush hh_tv hh_frig head_ed_level dmsp_light_mean_dum) ///
	if ea_dist_close1<200000 [aweight = dhs_weight], absorb(survey_id) cluster(cluster_id)
 
estimates store reg1
 
coefplot (reg1, label(Urban)), ///
	keep(1.ea_*_dum_close1 1.*_dum dmsp_light_mean_dum) ciopts(recast(rcap))

coefplot (reg1, label(Urban)), ///
	keep(1.fem_urban#1.suit_rcw_dum 1.fem_urban#1.suit_whe_dum 1.fem_urban#1.frost_dum 1.fem_urban#1.dmsp_light_mean_dum) ciopts(recast(rcap))

	
coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.suit_rcw_dum#??.fem_age_group) ///
	rename(^1.suit_rcw_dum#([0-9]+).fem_age_group$ = \1, regex)

coefplot (reg1, label(Nuclear dummy)), ///
	vertical keep(1.suit_whe_dum#??.fem_age_group) ///
	rename(^1.suit_whe_dum#([0-9]+).fem_age_group$ = \1, regex)

coefplot (reg1, label(Urban)) (reg2, label(Rural)), ///
	vertical keep(1.frost_dum#??.fem_age_group) ///
	rename(^1.frost_dum#([0-9]+).fem_age_group$ = \1, regex)
				
coefplot (reg1, label(Urban)) (reg2, label(Rural)), ///
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

