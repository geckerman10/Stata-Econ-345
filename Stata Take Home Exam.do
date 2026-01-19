clear
cd "C:\Users\EckermanGM10\Documents\Data"
import excel using "Weight.xlsx", sheet("Sheet1") firstrow clear
save "weight", replace
use "weight", clear

sum

reg read weight height woman black hisp raceothDK income hhedu married