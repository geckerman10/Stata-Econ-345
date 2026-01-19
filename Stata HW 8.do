clear
cd "C:\Users\EckermanGM10\Documents\Data"
import excel using "Childcare01", sheet("Sheet1") firstrow clear

*save as a Stata file
save "childcare", replace

*opening a stata file
use "childcare", clear

drop if CensusYearTractBNAMedianFamilyIn==.
sum

gen lnPop=ln(TractBNAPopulation)
reg TractCapacity lnPop TractBNAMinority MedianHouseAgeYears BelowPovertyLine InsidePrincCity

kdensity TractCapacity

predict e, residual
predict y, xb
kdensity e
kdensity y

gen lnCap=ln(TractCapacity)
reg lnCap lnPop TractBNAMinority MedianHouseAgeYears BelowPovertyLine InsidePrincCity

kdensity lnCap
predict i, residual
predict t, xb
kdensity i
kdensity t

reg TractCapacity lnPop TractBNAMinority MedianHouseAgeYears BelowPovertyLine InsidePrincCity

reg lnCap lnPop TractBNAMinority MedianHouseAgeYears BelowPovertyLine InsidePrincCity

gen Magesqu=MedianHouseAgeYears^2
reg TractCapacity lnPop TractBNAMinority MedianHouseAgeYears Magesqu BelowPovertyLine InsidePrincCity

gen magebpovl=MedianHouseAgeYears*BelowPovertyLine
reg TractCapacity lnPop TractBNAMinority MedianHouseAgeYears BelowPovertyLine InsidePrincCity magebpovl

gen mageicity=TractBNAMinority*InsidePrincCity
reg TractCapacity TractBNAMinority MedianHouseAgeYears  InsidePrincCity mageicity

gen icityvacunitdum=InsidePrincCity*VacantUnits
reg TractCapacity MedianHouseAgeYears VacantUnits icityvacunitdum 