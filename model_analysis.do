********************************************************************************
** FACTOR ANALYSIS *************************************************************
********************************************************************************
* factor analysis: looking for uni-dimensionality and internal consistency * measure- omega
factor rdcenr eneffap ccrdprs, pcf 
* omega coef
di (.7490+.7466+.6128)^2/((.4390+.4425+.6245)+(.7490+.7466+.6128)^2)
di ".7469482"
estat kmo 
di "0.5879" 


********************************************************************************
** Performing tests on model specification *************************************
********************************************************************************

*-------------------------------------------------------------------------------
* To check: (1) heteroskedasticity (2) specification error (3) multicollinearity
*-------------------------------------------------------------------------------
* (1) 
* Using the svy functionality, this is covered 

* (2)
* The linktest for "link-error" - to see if a link function is needed 
* can be ran with svy 
** result: passes, no non-linearities
linktest 

* omitted variable bias test 
* cannot be ran with svy
* ran with [pweight=weight], robust
foreach var in z45{
quietly reg `var' trust  $xbase [pweight=weight] if climate_believers==1, robust
ovtest 
quietly reg `var' trust $channel_1 [pweight=weight] if climate_believers==1, robust
ovtest
quietly reg `var' trust $channel_2 [pweight=weight] if climate_believers==1, robust
ovtest 
quietly reg `var' trust $channel_3 [pweight=weight] if climate_believers==1, robust
ovtest
quietly reg `var' trust $channel_4 [pweight=weight] if climate_believers==1, robust
ovtest 
}

* (3)
* result: shows no signs of multicollinearity (except for age, but thats obvious)
estat vif 

*-------------------------------------------------------------------------------
* To check: (4) Normality of errors (5) Independence of errors 
*-------------------------------------------------------------------------------

* (4)
* generate full model
svy: reg z45 trusting_group $all_channels
predict z45_residual, resid
predict z45_hat

* results on normality: visually ok, tails deviate slightly on qnorm, midrange 
* deviates slightly for pnorm 
kdensity z45_residual, norm
pnorm z45_residual
qnorm z45_residual

* iqr stands for inter-quartile range and assumes the symmetry of the distribution
* 3 inter-quartile-ranges below the first quartile or 3 inter-quartile-ranges above the third quartile
* get more info on the symmetry component of iqr
* reveals there are 11 severe outliers, but will not be removed since we lose 
* information and there's a reason why they are there.
iqr z45_residual

* (5)
* we cluster at the PSU given some indvidual level information

