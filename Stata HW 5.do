clear
cd "C:\Users\EckermanGM10\Documents\Data"
import excel using "Childcare01", sheet("Sheet1") firstrow clear

*save as a Stata file
save "childcare", replace

*opening a stata file
use "childcare", clear

histogram TotFacilities
kdensity TotFacilities, normal

sum CensusYearTractBNAMedianFamilyIn TractBNAPopulation TractBNAMinority MedianHouseAgeYears BelowPovertyLine TotFacilities InsidePrincCity

sum TotFacilities
return list
gen meanTotFacilities=r(mean)
gen ZTotFacilities=(TotFacilities-r(mean))/r(sd)

kdensity ZTotFacilities,normal

gen TotFacilitiesPerCap=TotFacilities/TractBNAPopulation
kdensity TotFacilitiesPerCap,normal

tab TotFacilities
gen TotFacilitiesLOG=ln(TotFacilities)
kdensity TotFacilitiesLOG, normal

gen TotFacilitiesLOGperCap=ln(TotFacilitiesPerCap)
kdensity TotFacilitiesLOGperCap, normal

gen Big=.
replace Big=0 if TractBNAPopulation<=4000
replace Big=1 if TractBNAPopulation>4000

reg TotFacilities CensusYearTractBNAMedianFamilyIn Big InsidePrincCity MedianHouseAgeYears BelowPovertyLine TractBNAMinority
