#####
#Load library and datasets
library(tidyverse)
library(Hmisc)
library(ggplot2)
library(car)
setwd("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018")
Fields = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/FieldstoKeep.csv")
Age.Sex = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/AgeandSex.csv")
Ancestry = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Ancestry.csv")
Counts = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Counts.csv")
Disabled = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Disabled.csv")
Earnings = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Earnings.csv")
Education = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Education.csv")
Employed = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Employed.csv")
Ethnicity = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Ethnicity.csv")
FoodStamps = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/FoodStamps.csv")
ForeignBorn = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/ForeignBorn.csv")
HomeLang = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/HomeLang.csv")
Housing = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Housing.csv")
Income = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Income.csv")
Poverty = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Poverty.csv")
Race = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/RawCensusDataFiles/Race.csv")
cases07_15 = read.csv("MCCD FULL Case list of addresses 07-15.csv")
spatial_data = read.csv("~/DuvalCountyCensusTracts.csv")
ParcelData = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/DuvalPAOGISData/Duval_PAO_GIS_Data_2018_06_07/ParcelPoints.csv")
CasesbyTract = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/CensusTractCaseCounts.csv")
CasesbyTract$GEOID = factor(CasesbyTract$GEOID)
CasesbyTract.SingleAddress = read.csv("~/Documents/MCCDCases/Investigations/PossibleDiscrimination_2018/SingleAddressCaseCounts.csv")

#### Processing of Census data ####
#Combine and Process Census Data
Combined = Reduce(function(x,y) merge(x=x, y=y, by = "GEOID"), list(Age.Sex, Ancestry, Counts, Disabled, Earnings, Education, 
                                                         Employed, Ethnicity, FoodStamps, ForeignBorn, HomeLang, 
                                                         Housing, Income, Poverty, Race))
Fields$ShortName[1:70]
Selected = subset(Combined, select = c("GEOID","B00001e1","B00001m1","B02001e1","B02001m1","B02001e2",
                                       "B02001m2","B02001e3","B02001m3","B02001e4","B02001m4","B02001e5",
                                       "B02001m5","B02001e6","B02001m6","B02001e7","B02001m7","B02001e8",
                                       "B02001m8","B03001e1","B03001m1","B03001e2","B03001m2","B03001e3","B03001m3",
                                       "B19326e1","B19326m1","B23006e1","B23006m1","B23006e2","B23006m2","B23006e9",
                                       "B23006m9","B23006e16","B23006m16","B23006e23","B23006m23","B23025e1","B23025m1",
                                       "B23025e2","B23025m2","B23025e3","B23025m3","B23025e4","B23025m4","B23025e5",
                                       "B23025m5","B23025e6","B23025m6","B23025e7","B23025m7","B23024e1","B23024m1",
                                       "B23024e2","B23024m2","B25001e1","B25001m1","B25002e1","B25002m1","B25002e2",
                                       "B25002m2","B25002e3","B25002m3","B25003e1","B25003m1","B25003e2","B25003m2",
                                       "B25003e3","B25003m3"))
DuvalCountyCensus = Selected[784:957,]

#Process Spatial Data
GEOIDS = factor(spatial_data$GEOID)
spatial_data2 = spatial_data
spatial_data2$GEOID = GEOIDS

#Merge Spatial and Census Data
merged.Data = merge(DuvalCountyCensus, spatial_data2, by.x = "GEOID", by.y = "GEOID_Data", sort = TRUE)

#Rename Columns in final demograpahic dataset based on Fields file
colnames(merged.Data)<- Fields$FullName

#NOTE: Always ensure the number of names in Fields is the same as the number of vars in merged.Data

#Start data analysis, extract percentages for each ethnic/racial population
Tract.Demogs = merged.Data
Tract.Demogs$TotalEst = Tract.Demogs$`RACE: Total: Total population -- (Estimate)`
Tract.Demogs$PercentWhite = Tract.Demogs$`RACE: White alone: Total population -- (Estimate)`/Tract.Demogs$`RACE: Total: Total population -- (Estimate)`
Tract.Demogs$PercentBlack = Tract.Demogs$`RACE: Black or African American alone: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PercentAIAN = Tract.Demogs$`RACE: American Indian and Alaska Native alone: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PercAsian = Tract.Demogs$`RACE:,Asian alone: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PercNHOPA = Tract.Demogs$`RACE: Native Hawaiian and Other Pacific Islander alone: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PercOtherRace = Tract.Demogs$`RACE: Some other race alone: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PercMultiRace = Tract.Demogs$`RACE: Two or more races: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PercLatinx = Tract.Demogs$`HISPANIC OR LATINO ORIGIN BY SPECIFIC ORIGIN: Hispanic or Latino: Total population -- (Estimate)`/Tract.Demogs$TotalEst
Tract.Demogs$PerentWhiteHigh = (Tract.Demogs$`RACE: White alone: Total population -- (Estimate)`+Tract.Demogs$`RACE: White alone: Total population -- MoE`)/Tract.Demogs$`RACE: Total: Total population -- (Estimate)`
Tract.Demogs$PercentWhiteLow= (Tract.Demogs$`RACE: White alone: Total population -- (Estimate)`-Tract.Demogs$`RACE: White alone: Total population -- MoE`)/Tract.Demogs$`RACE: Total: Total population -- (Estimate)`


#### Basic processing ####
#Remove junk cases
cases07_15.actual = subset(cases07_15, cases07_15$Ordinances != "No violations")
nrow(cases07_15.actual)
CaseParcels = merge(cases07_15.actual, ParcelData, by.x = "RENumber", by.y = "RE")

Tract.Demogs$MajorityMinority = FALSE
Tract.Demogs$MajorityMinority = ifelse(Tract.Demogs$PercentWhite<=0.5, TRUE, FALSE)

#Create unique ID variables before merging
Tract.Demogs$TractID = Tract.Demogs$` GEOID_SHORT`
CasesbyTract$Tract = CasesbyTract$GEOID
Test = merge(Tract.Demogs, CasesbyTract, by.x = "TractID", by.y = "Tract")
#Merge and Subset Demographics and Case Counts for use in correlation
CaseDemogs = subset(merge(Tract.Demogs, CasesbyTract, by.x = "TractID", by.y = "Tract"), select = c(1:69, 85:97, 115))

#### Stats ####
#Plot cases by race
ggplot(CaseDemogs, aes(x=PercentWhite, y=Cases))+
  geom_errorbarh(aes(xmin=CaseDemogs$PercentWhiteLow, xmax=CaseDemogs$PerentWhiteHigh))+
  geom_point()

#Take linear regression of cases by white versus nonwhite
CasesbyRace.lm = lm(CaseDemogs$PercentWhite~CaseDemogs$Cases)
CasesbyRacelm.summary = summary(CasesbyRace.lm); CasesbyRacelm.summary

#Plot distribution of case counts
ggplot(CaseDemogs, aes(x=Cases))+
  geom_density()

#Test statistical assumptions
shapiro.test(CaseDemogs$Cases) #Data does not fit a normal distribution, switch to a non-parametric test
leveneTest(CaseDemogs$Cases, CaseDemogs$MajorityMinority)


#Use a wilcox test for differences between minority and white areas
wilcox.test(CaseDemogs$Cases~CaseDemogs$MajorityMinority)

#Conduct a kruskal-wallis test for race in general


#Run stats for median income
#Plot median income
ggplot(CaseDemogs, aes(x=CaseDemogs$`MEDIAN INCOME IN THE PAST 12 MONTHS (IN 2016 INFLATION-ADJUSTED DOLLARS) BY SEX BY WORK EXPERIENCE IN THE PAST 12 MONTHS FOR THE POPULATION 15 YEARS AND OVER WITH INCOME: Total (dollars) (Estimate)`))+
  geom_density()

shapiro.test(CaseDemogs$`MEDIAN INCOME IN THE PAST 12 MONTHS (IN 2016 INFLATION-ADJUSTED DOLLARS) BY SEX BY WORK EXPERIENCE IN THE PAST 12 MONTHS FOR THE POPULATION 15 YEARS AND OVER WITH INCOME: Total (dollars) (Estimate)`)
#Data are not normal, must use non-parametric alternatives

ggplot(CaseDemogs, aes(x=CaseDemogs$`MEDIAN INCOME IN THE PAST 12 MONTHS (IN 2016 INFLATION-ADJUSTED DOLLARS) BY SEX BY WORK EXPERIENCE IN THE PAST 12 MONTHS FOR THE POPULATION 15 YEARS AND OVER WITH INCOME: Total (dollars) (Estimate)`, y=Cases))+
  geom_point()

IncomeData = subset(CaseDemogs, select= c(`MEDIAN INCOME IN THE PAST 12 MONTHS (IN 2016 INFLATION-ADJUSTED DOLLARS) BY SEX BY WORK EXPERIENCE IN THE PAST 12 MONTHS FOR THE POPULATION 15 YEARS AND OVER WITH INCOME: Total (dollars) (Estimate)`, Cases))
cor(IncomeData, method="")
##### Stats II ####

#Create unique ID variables before merging
CasesbyTract.SingleAddress$Tract = CasesbyTract$GEOID

#Merge and Subset Demographics and Case Counts for use in correlation
CaseDemogs.SingleAddress = subset(merge(Tract.Demogs, CasesbyTract.SingleAddress, by.x = "TractID", by.y = "Tract"), select = c(1:69, 85:95, 113))

#Plot distribution of Single Address counts
ggplot(CaseDemogs.SingleAddress, aes(x=Cases))+
  geom_density()

#Conduct Wilcox test for cases by race when single addresses
wilcox.test(CaseDemogs.SingleAddress$Cases~CaseDemogs$MajorityMinority)


#Plot cases by year
ggplot(cases07_15.actual, aes(x=CaseYear))+
  geom_bar()

#Group Cases by Income

#Plot cases by income

