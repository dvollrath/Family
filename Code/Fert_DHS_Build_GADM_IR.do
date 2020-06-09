rename v005 dhs_weight // as a mental check
qui replace dhs_weight = dhs_weight/1000000 // scale the hh weight
rename v001 cluster // meaningful name		
rename v002 id // women ID

gen ccode = substr(v000,1,2) // pull country code
gen phase = substr(v000,3,1) // pull DHS phase
move ccode cluster // move to lead position
move phase cluster // move to lead position

gen ir_constant = 1 // creates a variable with name ir_* for collapsing,
gen count = 1 // will give count of surveyed women in district

capture confirm variable v104
if !_rc {
	gen ir_move_never = (v104==95) // dummy for never moved (always lived there)
	gen ir_move_visit = (v104==96) // dummy for visitor
	gen ir_move_ever = (inrange(v104,0,50)) // dummy for ever moved
	gen ir_move_last5 = (inrange(v104,0,5)) // dummy for moved in last 5 years
	gen ir_move_last1 = (inrange(v104,0,1)) // dummy for moved in last 1 year
	gen ir_move_age2550 = (inrange(v104,0,50) & inrange(v012,25,50)) // ever moved and 25-50
	gen ir_move_age2550_last5 = (inrange(v104,0,5) & inrange(v012,25,50)) // moved last 5 years and 25-50 (recent economic migrants?)
}		

capture confirm variable v102 v105
if !_rc {
	gen ir_urbres_fromcity = (v102==1 & v105==1) // urban resident moved from city
	gen ir_urbres_fromtown = (v102==1 & v105==2) // urban resident moved from town
	gen ir_urbres_fromcountry = (v102==1 & v105==3) // urban resident moved from country
	gen ir_urbres_fromsame = (v102==1 & v105==.) // urban resident who did not move there

	gen ir_rurres_fromcity = (v102==2 & v105==1) // rural resident moved from city
	gen ir_rurres_fromtown = (v102==2 & v105==2) // rural resident moved from town
	gen ir_rurres_fromcountry = (v102==2 & v105==3) // rural resident moved from country
	gen ir_rurres_fromsame = (v102==2 & v105==.) // rural resident who did not move there
}
