cd "C:\Users\Jrxz12\Desktop\School\Research_Module\Code"
*cd "C:\Users\japak\Research_Module"
do main_file.do

********************************************************************************
** MECHANISMS ******************************************************************
********************************************************************************
* agea
* i.country 
* i.male 
* i.edu_cat 
* i.hinctnta

* i.child_home 
* i.rlgdnm: religion denom. (make controls for religions which are relevant.)


** To control for the channel of: people are more "free to trust"
* i.stfdem: satisfied with democracy 
* i.psppipla: political system allows people to have an influence in politics 

* i.lrscale: political ideology (we can probably discretize this)

// gen really_young = (agea<25)
// gen old =(agea>64)
// gen young = (agea>24 & agea<40)
// gen midage = (agea>39 & agea<65)
// foreach var in really_young old young midage{
// replace `var' =. if agea==.a|agea==.b|agea==.c|agea==.d
// }
// foreach var in really_young old young midage{
// svy: mean ppltrst if `var'==1
// }
*-------------------------------------------------------------------------------
** making sure controls are correlated with PEB
*-------------------------------------------------------------------------------
foreach var in agea i.male i.edu_cat i.hinctnta i.child_home ///
i.stfdem i.psppipla i.lrscale cath prot east_orth jew islam rlgdgr{
eststo: svy, subpop(climate_believers ): reg z45 `var' 
}

*-------------------------------------------------------------------------------
** seeing how controls affect trust estimate
*-------------------------------------------------------------------------------

eststo clear

foreach var in agea age2 i.male i.edu_cat i.hinctnta ///
i.child_home i.stfdem i.psppipla i.lrscale cath prot east_orth jew islam{
eststo: svy, subpop(climate_believers ): quietly reg z45 trust i.country `var'
}
eststo: svy, subpop(climate_believers ): quietly reg z45 trust i.country

suest est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11 ///
est12 est13 est14, robust

forvalues i = 1/13{
lincom _b[est`i':trust] - _b[est14:trust]
}

*-------------------------------------------------------------------------------
** seeing how controls affect trust as DV
*-------------------------------------------------------------------------------
foreach var in i.country agea i.male edu_cat hinctnta rlgdgr ///
i.child_home stfdem psppipla lrscale cath prot east_orth jew islam{
eststo: svy, subpop(climate_believers): logit trust_plus7 `var'
margins, dydx(*)
}
foreach var in agea i.male edu_cat hinctnta rlgdgr married ///
i.child_home stfdem psppipla lrscale cath prot east_orth jew islam{
eststo: svy, subpop(climate_believers): logit ppltrst `var'
margins, dydx(*)
}
*-------------------------------------------------------------------------------
** seeing how controls affect PEB
*-------------------------------------------------------------------------------
foreach var in trust_plus7 ppltrst agea age2 i.male edu_cat hinctnta ///
i.child_home stfdem psppipla lrscale cath prot east_orth jew islam{
eststo: svy, subpop(climate_believers): reg z45 `var'
}

*-------------------------------------------------------------------------------
** Making table
*-------------------------------------------------------------------------------
global xbase i.country 
global demo $xbase agea age2 male i.edu_cat i.hinctnta 
global channel_1 $demo cath prot east_orth jew islam rlgdgr
global channel_2 $demo i.child_home 
global channel_3 $demo i.stfdem i.psppipla 
global channel_4 $demo i.lrscale 
global channel_5 $demo i.child_home i.stfdem i.psppipla i.lrscale cath prot east_orth jew islam rlgdgr 

local demographics control_dem
local religion control_rel
local child control_ch
local freedom control_free
local pol_ideology control_pol
local all control_all

*sub-pop 1
eststo clear
eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $xbase 
estadd local base "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $demo 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $channel_1 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local religion "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $channel_2 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local child "Yes", replace
estadd ysumm


eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $channel_3 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local freedom "Yes", replace
estadd ysumm  

eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $channel_4 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local pol_ideology "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 trust_plus7 $channel_5 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local all "Yes", replace
estadd ysumm

esttab using "trust.tex", label b(3) /// 
se stats(base demographics religion child freedom pol_ideology all ymean N r2, labels("\hspace{2mm} Base Control" "\hspace{2mm} Demographics" "\hspace{2mm} Religion" "\hspace{2mm} Family" "\hspace{2mm} Democracy" "\hspace{2mm} Political Ideology" "\hspace{2mm} All Mechanisms" "Mean dep. var." "Observations" "$ R^2$") ///
fmt(0 0 0 0 0 0 0 3 0 3)) noconstant compress starlevels(* 0.1 ** 0.05 *** 0.01) replace 

* sub-pop 2. To avoid a large table as an output, we split the code this way.
eststo clear
eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $xbase 
estadd local base "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $demo 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $channel_1 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local religion "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $channel_2 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local child "Yes", replace
estadd ysumm


eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $channel_3 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local freedom "Yes", replace
estadd ysumm  

eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $channel_4 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local pol_ideology "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers2 ): reg z45 trust_plus7 $channel_5 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local all "Yes", replace
estadd ysumm

esttab using "trust2.tex", label b(3) /// 
se stats(base demographics religion child freedom pol_ideology all ymean N r2, labels("\hspace{2mm} Base Control" "\hspace{2mm} Demographics" "\hspace{2mm} Religion" "\hspace{2mm} Family" "\hspace{2mm} Democracy" "\hspace{2mm} Political Ideology" "\hspace{2mm} All Mechanisms" "Mean dep. var." "Observations" "$ R^2$") ///
fmt(0 0 0 0 0 0 0 3 0 3)) noconstant compress starlevels(* 0.1 ** 0.05 *** 0.01) replace 
********************************************************************************
** TRUST AND COOPERATION *******************************************************
********************************************************************************

eststo clear
eststo: svy, subpop(climate_believers): logit ind_coop trust_plus7 i.country agea age2 i.male i.edu_cat i.hinctnta  
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd ysumm
eststo: svy, subpop(climate_believers): logit country_action trust_plus7 i.country agea age2 i.male i.edu_cat i.hinctnta 
estadd local base "Yes", replace 
estadd local demographics "Yes", replace
estadd ysumm

esttab using "cooperation.tex", label b(3) /// 
se stats(base demographics ymean N r2, labels("\hspace{2mm} Base Control" "\hspace{2mm} Demographics" "Mean dep. var." "Observations" "$ R^2$") ///
fmt(0 0 3 0 3)) noconstant compress starlevels(* 0.1 ** 0.05 *** 0.01) replace 

********************************************************************************
** MEDIATION EFFECTS ***********************************************************
********************************************************************************

eststo clear
foreach var in climate_believers climate_believers2{
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $xbase 
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $demo 
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $channel_1 
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $channel_2 
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $channel_3 
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $channel_4 
eststo: svy, subpop(`var'): quietly reg z45 trust_plus7  $channel_5
}
quietly suest est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11 est12 est13 est14, robust 

forvalues i = 1(1)7{
lincom _b[est1:trust_plus7] - _b[est`i':trust_plus7]
}
forvalues i = 8(1)14{
lincom _b[est8:trust] - _b[est`i':trust]
}

********************************************************************************
** RESET -p-values *************************************************************
********************************************************************************
* sub-pop 1
quietly reg z45 trust_plus7  $xbase [pweight=weight] if climate_believers==1, robust
ovtest
quietly reg z45 trust_plus7  $channel_5 [pweight=weight] if climate_believers==1, robust 
ovtest 

*sub-pop 2
quietly reg z45 trust_plus7  $xbase [pweight=weight] if climate_believers==1, robust
ovtest
quietly reg z45 trust_plus7  $channel_5 [pweight=weight] if climate_believers==1, robust 
ovtest 

********************************************************************************
** Using other Trust Measures **************************************************
********************************************************************************

eststo clear
foreach var in ppltrst{
eststo: svy, subpop(climate_believers ): reg z45 `var' $xbase 
estadd local base "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 `var' $demo 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 `var' $channel_1 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local religion "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 `var' $channel_2 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local child "Yes", replace
estadd ysumm


eststo: svy, subpop(climate_believers ): reg z45 `var' $channel_3 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local freedom "Yes", replace
estadd ysumm  

eststo: svy, subpop(climate_believers ): reg z45 `var' $channel_4 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local pol_ideology "Yes", replace
estadd ysumm

eststo: svy, subpop(climate_believers ): reg z45 `var' $channel_5 
estadd local base "Yes", replace
estadd local demographics "Yes", replace
estadd local all "Yes", replace
estadd ysumm
}
esttab using "trust_C.tex", label b(3) /// 
se stats(base demographics religion child freedom pol_ideology all ymean N r2, labels("\hspace{2mm} Base Control" "\hspace{2mm} Demographics" "\hspace{2mm} Religion" "\hspace{2mm} Family" "\hspace{2mm} Democracy" "\hspace{2mm} Political Ideology" "\hspace{2mm} All Mechanisms" "Mean dep. var." "Observations" "$ R^2$") ///
fmt(0 0 0 0 0 0 0 3 0 3)) noconstant compress starlevels(* 0.1 ** 0.05 *** 0.01) replace 

* sub-pop 1 
foreach var in ppltrst{
quietly reg z45 `var'  $xbase [pweight=weight] if climate_believers==1, robust
ovtest
quietly reg z45 `var'  $channel_5 [pweight=weight] if climate_believers==1, robust 
ovtest 
}
