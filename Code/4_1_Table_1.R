# 1. Input

# 1.1 StudyGroup - NPI / PPI cross reference list of OBGYN's in study (from 3_1) "~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_Final.csv"
# 1.2 PCND (raw Physician compare file) 
#           "~/Dropbox/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv"
# 1.3 GOBA (goba file with matching NPI # added - (from 1_4) 
#           "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL_1.csv"
# 1.4 Prescriber compiled data from PartD_Prescriber_PUF_NPI_DRUG_13 - PartD_Prescriber_PUF_NPI_DRUG_17, filtered on Dr's in StudyGroup (from 3_1) 
#           "~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber.csv"
# 1.5 paymensummary compiled data (total of all drug payments) from OP_DTL_GNRL_PGYR2013_P01172020.csv - OP_DTL_GNRL_PGYR2017_P01172020.csv filtered on Dr's in StudyGroup (from 3_1)  
#           "~/Dropbox/Pharma_Influence/Guido_Working_file/paymentSummary.csv"


# 2. Functions - none

# 3. Processing Summary
# - payment and prescription data summed for each individual (collapses individual year, drug, manufacturer, etc)
# - starting with studygroup .. data from GOBA, PCND, Prescriber (sums), and PaymentSummary (sums) is added
# - Age field added based on medschool graduation year (+29)

# 4. Intermediate Files - none

# 5. Output

# 5.1 T1 -  final cross reference of study group data including demographics from GOBA and PCND, totals from Prescriber and payment summary
#					"~/Dropbox/Pharma_Influence/Guido_Working_file/T1.csv"


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

#load Data

StudyGroup <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_Final.csv", stringsAsFactors=FALSE)

PCND <- read.csv("~/Dropbox/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)
PCND$Name <- paste(PCND$frst_nm, PCND$mid_nm, PCND$lst_nm, PCND$suff)
PCND <- sqldf('select PCND.NPI, PCND.Name, PCND.gndr, PCND.[Med_sch] as "MedSchool",PCND.st as "State", PCND.[Grd_yr] as "GraduationYear" from PCND group by PCND.NPI')

GOBA <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL_1.csv", stringsAsFactors=FALSE, strip.white = TRUE)

Prescriber <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)

paymentSummary <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)

# summarize prescriber and payment data
T1_pre <- sqldf('select npi,sum(bene_count), sum(total_claim_count),sum(total_day_supply), sum(total_drug_cost) from Prescriber group by npi')

T1_pay <- sqldf('select Physician_Profile_ID as "PPI", sum(Total_Amount_of_Payment_USDollars) as "PaySum" from paymentSummary group by  Physician_Profile_ID')

# merge data
# pull in GOBA
T1 <- sqldf('select StudyGroup.*,GOBA.name as "GOBA_Name", GOBA.state as "GOBA_state", GOBA.Title as "GOBA_title", GOBA.Region as "GOBA_Region" from StudyGroup left outer join GOBA on StudyGroup.NPI = GOBA.NPI')

# pull in PCND
T1 <- sqldf('select T1.*, PCND.Name as "PCND_Name", PCND.gndr as "PCND_gender", PCND.MedSchool as "PCND_MedSchool", PCND.State as "PCND_State", PCND.GraduationYear as "PCND_GradYr" from T1 left outer join PCND on T1.NPI = PCND.NPI')

# pull in payments
T1 <- sqldf('select T1.*, T1_pay.PaySum as "OP_PaymentSum" from T1 left outer join T1_pay on T1.PPI = T1_pay.PPI')

# pull in prescription numbers
T1 <- sqldf('select T1.*, T1_pre.[sum(bene_count)] as "Pre_bene_count", T1_pre.[sum(total_claim_count)] as "Pre_TotalClaimCount", T1_pre.[sum(total_day_supply)] as "Pre_TotalDaySupply", T1_pre.[sum(total_drug_cost)] as "Pre_TotalDrugCost" from T1 left outer join T1_pre on T1.NPI = T1_pre.npi')


T1$Age <- "NA"
T1[!is.na(T1$PCND_GradYr),"Age"] = 2019 - T1[!is.na(T1$PCND_GradYr),"PCND_GradYr"]+ 26

write.csv(T1, "~/Dropbox/Pharma_Influence/Guido_Working_file/T1.csv")

rm(list=ls()) 
gc()