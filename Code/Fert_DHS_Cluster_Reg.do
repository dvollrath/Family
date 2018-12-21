////////////////////////////////////////////////////////////////////////////
// Cluster level regressions
////////////////////////////////////////////////////////////////////////////

use "./Work/DHS-all-hh.dta", clear

// Run HH level regression of family outcome on age and assets, save cluster fixed effects
capture drop cluster_fe
reghdfe head_dum_nuclear i.head_age_group i.head_ed_level hh_flush hh_elec hh_floor ///
	[aweight = dhs_weight] ///
	, absorb(cluster_fe = cluster_id) cluster(cluster_id)

egen tag = tag(cluster_id) if e(sample)==1
	
reg cluster_fe agro_et0 agro_lt2 agro_lt3 agro_prc agro_n2c agro_ric hh_urban dmsp_light_mean csi_plowpot csi_optimal if tag==1, cluster(survey_id)
