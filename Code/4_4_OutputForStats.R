
# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("tidyverse")

# Loading
library(sqldf)
library(qdapRegex)
library(readr)
library(tidyverse)
library(Hmisc)

Prescriber <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)

PaySum <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)

StudyGroup <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_Final.csv", stringsAsFactors=FALSE)

OP_Names <- read.csv("~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01172020.csv", header=TRUE, stringsAsFactors=FALSE)

Physician_Compare_National_Downloadable_File <- read.csv("~/Dropbox/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)

# removed dups from PCND

Physician_Compare_National_Downloadable_File <- sqldf(' select NPI from Physician_Compare_National_Downloadable_File group by NPI')

# remove non US doctors

StudyGroup <- sqldf('select StudyGroup.*, OP_Names.Physician_Profile_State from StudyGroup left outer join OP_Names on StudyGroup.PPI = OP_Names.Physician_Profile_ID')

StudyGroup <- filter(StudyGroup, Physician_Profile_State %nin% c("GU", "VI", "ZZ", "AP", "AE"))
StudyGroup$Physician_Profile_State <- NULL

# remove non medicaid Drs

StudyGroup <- sqldf('select StudyGroup.*, Physician_Compare_National_Downloadable_File.NPI as "PCNPI" from StudyGroup left outer join Physician_Compare_National_Downloadable_File on StudyGroup.NPI = Physician_Compare_National_Downloadable_File.NPI')

StudyGroup<- StudyGroup[!is.na(StudyGroup$PCNPI),]
StudyGroup$PCNPI <- NULL

PaySum <- sqldf('select PaySum.*, StudyGroup.NPI from PaySum left outer join StudyGroup  on PaySum.Physician_Profile_ID = StudyGroup.PPI')
PaySum <- PaySum[!is.na(PaySum$NPI),]
PaySum$NPI <- NULL

Prescriber <- sqldf('select Prescriber.*, StudyGroup.PPI from Prescriber left outer join StudyGroup on Prescriber.npi = StudyGroup.NPI')
Prescriber <- Prescriber[!is.na(Prescriber$PPI),]
Prescriber$PPI <- NULL

#normalize column names, change drug names to lower case
names(PaySum) <- c("PPI", "ManName", "ManID","TotalPay","DrugName", "DrugNDC", "Year", "DrugCount" )
PaySum$DrugName <- tolower(PaySum$DrugName)

Prescriber <- Prescriber[,c(1,5,8,9,13,22)]
names(Prescriber) <- c("NPI","State", "DrugName", "GenericName", "TotalDaySupply", "Year")
Prescriber$DrugName <- tolower(Prescriber$DrugName)
Prescriber$GenericName <- tolower(Prescriber$GenericName)

#Load Class Data
Payment_Class <- read.csv("~/Dropbox/Pharma_Influence/Data/Category_Data/Payment_Class.csv", stringsAsFactors=FALSE)

Prescription_Class <- read.csv("~/Dropbox/Pharma_Influence/Data/Category_Data/Prescription_Class.csv", stringsAsFactors=FALSE)

ClassList <- sqldf('select Payment_Class.Class from Payment_Class group by Payment_Class.Class')

#Load Class Strings (for column titles in cross tabs)

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]
PaySum <- sqldf('select PaySum.*, StudyGroup.NPI from PaySum left outer join StudyGroup on PaySum.PPI = StudyGroup.PPI')

Prescriber <- sqldf('select Prescriber.*, Prescription_Class.Class, Prescription_Class.Drug from Prescriber left outer join Prescription_Class on Prescriber.DrugName = Prescription_Class.DrugName')
Prescriber <- Prescriber[!is.na(Prescriber$Class),]

write_rds(StudyGroup, "~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup.rds")
write_rds(PaySum, "~/Dropbox/Pharma_Influence/Guido_Working_file/PaySum.rds"  )
write_rds(Prescriber, "~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber.rds")

rm(list=ls()) 
gc()
