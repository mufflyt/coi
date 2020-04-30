setwd("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file")

# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("tidyverse")

# Loading
library("sqldf", lib.loc="~/R/win-library/3.2")
library("qdapRegex", lib.loc="~/R/win-library/3.2")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("readr")
library(tidyverse)
library(Hmisc)

Prescriber <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)

PaySum <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)

StudyGroup <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/StudyGroupR1.csv", stringsAsFactors=FALSE)

OP_Names <- read.csv("D:/muffly/data/Originals/PHPRFL_P062918/OP_PH_PRFL_SPLMTL_P06292018.csv", header=TRUE, stringsAsFactors=FALSE)

Physician_Compare_National_Downloadable_File <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)

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
Payment_Class <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Payment_Class.csv", stringsAsFactors=FALSE)

Prescription_Class <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Prescription_Class.csv", stringsAsFactors=FALSE)

ClassList <- sqldf('select Payment_Class.Class from Payment_Class group by Payment_Class.Class')

#Load Class Strings (for column titles in cross tabs)

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]
PaySum <- sqldf('select PaySum.*, StudyGroup.NPI from PaySum left outer join StudyGroup on PaySum.PPI = StudyGroup.PPI')

Prescriber <- sqldf('select Prescriber.*, Prescription_Class.Class, Prescription_Class.Drug from Prescriber left outer join Prescription_Class on Prescriber.DrugName = Prescription_Class.DrugName')
Prescriber <- Prescriber[!is.na(Prescriber$Class),]

write_rds(StudyGroup, "StudyGroup.rds")
write_rds(PaySum, "PaySum.rds"  )
write_rds(Prescriber, "Prescriber.rds")
