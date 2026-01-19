*this is the way to open an excel file
*other file formats will use other commands

clear
cd "C:\Data"
import excel using "SoccerAndConcussions", sheet("Sheet1") firstrow clear

*save as a Stata file
save "soccercon", replace

*opening a stata file
use "soccercon", clear

*lets look at those string variables
*we need to fix them to use them
describe
tab Hisp,missing
tab Black,missing
tab Soccer_W1,missing

*generate new numeric vairables for the string variables
*blank variable
gen H=.
replace H=0 if Hispanic=="(0) No"
replace H=1 if Hispanic=="(1) Yes"

gen B=.
replace B=0 if Black=="(0) Not marked"
replace B=1 if Black=="(1) Marked"

gen Soc=.
replace Soc=0 if Soccer_W1=="(0) Not marked"
replace Soc=1 if Soccer_W1=="(1) Marked"

* move these to the begining of the dataset
order AID nRecalledOnList90_W4 Soc H B

*lets look at how many observations are in our dataset
*~= means oesnt equal
count
count if nRecalledOnList90_W4~=.

*generate new variables, division, interaction, square...
gen HHIncome_W1Th=HHIncome_W1/1000
gen HHIncome_W1IntSoc=HHIncome_W1*Soc
gen HHIncome_W1Squ=HHIncome_W1^2

*logging HH income (natural log)
sum HHIncome_W1
*since the lowest value is 0 or below 0 we need to perform
* a linear transformation before we log
*We only need to do this because the lwoest value is <=0
gen HHIncome_W1LOG=ln(HHIncome_W1+1)

*descriptive statistics on all variables
sum 

*graphs of disctributions
histogram HHIncome_W1
histogram HHIncome_W1LOG
kdensity HHIncome_W1,normal
kdensity HHIncome_W1LOG,normal

*correlations
corr nRecalledOnList90_W4 Soc
pwcorr nRecalledOnList90_W4 Soc,star(.1)
reg nRecalledOnList90_W4 Soc

*multi variate regression (level dependatn variable)
*first variable id dependent rest are independent
reg nRecalledOnList90_W4 Soc B H P1Age_W1 HHIncome_W1 Pmarital ParentHS ParentsomeCol ParentCol ParentNoSchResp female
*can go ParentHS-ParentNoSchResp

*lets look at descriptive stats again
sum
*might want to lookat descriptive stats of just observaions used in the regression
sum if nRecalledOnList90_W4~=. & Soc~=. & B~=. & H~=. & P1Age_W1~=. & HHIncome_W1~=. & Pmarital~=. & ParentHS~=. & ParentsomeCol~=. & ParentCol~=. & ParentNoSchResp~=. & female~=. 
*~=. & this means not equal to missing and the next vairable

*defining a global so we dont have to put so much in
global Xs Soc B H P1Age_W1 HHIncome_W1 Pmarital ParentHS ParentsomeCol ParentCol ParentNoSchResp female
*to call global we use a $ 

reg nRecalledOnList90_W4 $Xs
sum $Xs

*more with kdensity
kdensity HHIncome_W1, title(Figure 1: Density of Household Income) xtitle(Household Income) normal

*look at a bunch of results side by side
*load in user written commands
ssc install estout
*run 3 regression and store results
reg nRecalledOnList90_W4 Soc 
estimates store corr
reg nRecalledOnList90_W4 Soc HHIncome_W1
estimates store two
reg nRecalledOnList90_W4 $Xs 
estimates store all

esttab corr two all, star(* 0.10 ** 0.05 *** 0.01) b(%10.3f) se scalars(N rd F II bic aic) mtitles

*can right click and copy regression results as picture for nice doc