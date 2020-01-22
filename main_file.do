* Adjust path to read file in 
* Luis 
use "C:\Users\Jrxz12\Desktop\School\Research_Module\Datasets_RM\ESS8e02_1.dta", clear
merge 1:1 cntry idno using "C:\Users\Jrxz12\Desktop\School\Research_Module\Datasets_RM\ESS8_psustuff.dta", force

* survey weight
gen weight = pspwght*pweight

* VCE is linearized. Without surveyset, we assume simple random sampling. 
* generate cstrata = floor(sqrt(2*stratum-1))
* egen upsu = group(stratum psu)
svyset psu [pweight=weight], strata(stratum) single(cen) 
svydescribe 

* Variables of interest 

* Trust and sub-population groups of environmentally-concerned inds.
gen trust_plus7 = (ppltrst==7|ppltrst==8|ppltrst==9|ppltrst==10)
replace trust_plus7=. if ppltrst==.a|ppltrst==.b|ppltrst==.c|ppltrst==.

gen climate_believers = (impenv ==1|impenv ==2) 
gen climate_believers2 = (wrclmch>=3)


* Generate variables  
gen age2 = agea*agea
gen male = gndr
replace male=0 if gndr==2
egen edu_cat = cut(eduyrs), at(6, 9, 12, 16, 20, 54)
replace edu_cat=1 if edu_cat==6
replace edu_cat=2 if edu_cat==9
replace edu_cat=3 if edu_cat==12
replace edu_cat=4 if edu_cat==16
replace edu_cat=5 if edu_cat==20


* country, child at home, trust in gov
encode(cntry), gen(country)
gen child_home = (chldhm==1)

gen religious = (rlgdgr>=8)

* dependent variables to consider: PEB, belief in cooperation individual and gov
gen country_action = (gvsrdcc>=8)
gen ind_coop = (lklmten>7)
replace ind_coop=. if lklmten==.

gen responsibility = (ccrdprs==10|ccrdprs==9)
gen energy_reduce = (rdcenr==4|rdcenr==5|rdcenr==6)
gen buy_eco = (eneffap==8|eneffap==9|eneffap==10)

replace rdcenr=. if rdcenr==55
foreach var in responsibility{
replace `var'=. if ccrdprs==.d
replace `var'=. if ccrdprs==.c
replace `var'=. if ccrdprs==.b
replace `var'=. if ccrdprs==.a
}

foreach var in energy_reduce{
replace `var'=. if rdcenr==.a
replace `var'=. if rdcenr==.b
replace `var'=. if rdcenr==.c
replace `var'=. if rdcenr==.d
replace `var'=. if rdcenr==55
}

foreach var in buy_eco{
replace `var'=. if eneffap==.a
replace `var'=. if eneffap==.b
replace `var'=. if eneffap==.c
replace `var'=. if eneffap==.d
}


* Make PEB index #1
replace rdcenr=. if rdcenr==55
svy: mean rdcenr eneffap ccrdprs
estat sd

gen z_rdcenr= (rdcenr - 4.145593)/1.232023
gen z_eneffap= (eneffap - 7.61587)/2.375479
gen z_ccrdprs= (ccrdprs - 5.632649)/2.678477

gen z_proxysum45 = z_rdcenr + z_eneffap + z_ccrdprs
svy: mean z_proxysum45
estat sd

gen z45 = z_proxysum45/2.178053


* Label Variables 

la var agea "Age"
la var age2 "Age-squared"
la var country "Country"
la var male "Male"
la var hinctnta "Household Income"
la var eduyrs "Years of Education"
la var edu_cat "Categorical Education"

la var child_home "Child at home"
la var ind_coop "Belief in Individual Cooperation"
la var country_action "Belief in Government Cooperation"


gen married = (marsts==1)
gen cath = (rlgdnm==1)
gen prot = (rlgdnm==2)
gen east_orth = (rlgdnm==3)
gen jew = (rlgdnm==5)
gen islam = (rlgdnm==6)

foreach var in cath prot east_orth jew islam{
replace `var' =. if rlgdnm==.a|rlgdnm==.b|rlgdnm==.c|rlgdnm==.d
}
replace married=. if marsts==.a|marsts==.b|marsts==.c|marsts==.d


foreach var in climate_believers{
replace `var'=. if impenv==.d
replace `var'=. if impenv==.c
replace `var'=. if impenv==.b
replace `var'=. if impenv==.a
}

foreach var in child_home{
replace `var'=. if chldhm==.d
replace `var'=. if chldhm==.c
replace `var'=. if chldhm==.b
replace `var'=. if chldhm==.a
}

foreach var in eduyrs{
replace `var'=. if eduyrs==.d
replace `var'=. if eduyrs==.c
replace `var'=. if eduyrs==.b
replace `var'=. if eduyrs==.a
} 

foreach var in edu_cat{
replace `var'=. if eduyrs==.d
replace `var'=. if eduyrs==.c
replace `var'=. if eduyrs==.b
replace `var'=. if eduyrs==.a
}


foreach var in age2{
replace `var'=. if agea==.d
replace `var'=. if agea==.c
replace `var'=. if agea==.b
replace `var'=. if agea==.a
}

foreach var in agea{
replace `var'=. if agea==.d
replace `var'=. if agea==.c
replace `var'=. if agea==.b
replace `var'=. if agea==.a
}

foreach var in male{
replace `var'=. if gndr==.d
replace `var'=. if gndr==.c
replace `var'=. if gndr==.b
replace `var'=. if gndr==.a
}

foreach var in hinctnta{
replace `var'=. if hinctnta==.d
replace `var'=. if hinctnta==.c
replace `var'=. if hinctnta==.b
replace `var'=. if hinctnta==.a
}

foreach var in country_action{
replace `var'=. if gvsrdcc==.d
replace `var'=. if gvsrdcc==.c
replace `var'=. if gvsrdcc==.b
replace `var'=. if gvsrdcc==.a
}

foreach var in religious{
replace `var'=. if rlgdgr==.d
replace `var'=. if rlgdgr==.c
replace `var'=. if rlgdgr==.b
replace `var'=. if rlgdgr==.a
}

foreach var in climate_believers2{
replace `var'=. if wrclmch==.d
replace `var'=. if wrclmch==.c
replace `var'=. if wrclmch==.b
replace `var'=. if wrclmch==.a
}


