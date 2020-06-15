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


#load files from prior processing (StudyGroup and PCND)

StudyGroup <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_Final.csv", stringsAsFactors=FALSE)
PCND <- read.csv("~/Dropbox/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)

PCND <- filter(PCND, PCND$st %nin% c("AP","AE", "AS", "FM", "GU", "MH","MP", "PR","PW","UM","VI", "ZZ"))
PCND <- filter(PCND, (PCND$pri_spec %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  | (PCND$sec_spec_1 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$sec_spec_2 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$sec_spec_3 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$sec_spec_4 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  ) 

PCND <- sqldf('select PCND.NPI, PCND.gndr, PCND.[Med_sch] as "MedSchool",PCND.st as "State", PCND.[Grd_yr] as "GraduationYear" from PCND group by PCND.NPI')
PCND <- sqldf('select PCND.*, StudyGroup.PPI from PCND left outer join StudyGroup on PCND.NPI = StudyGroup.NPI')

# Load GOBA - consolidate on NPI and files we need (to remove dups)

GOBA <- read.csv("~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_2.csv", stringsAsFactors=FALSE, strip.white = TRUE)
#GOBA_unique <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/GOBA_unique.csv", stringsAsFactors=FALSE)
#GOBA_unique <- GOBA_unique[!duplicated(GOBA_unique$NPI_Match),]

Prescriber <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)
paymentSummary <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)


# summarize prescriber and payment data
T1_pre <- sqldf('select npi,sum(bene_count), sum(total_claim_count),sum(total_day_supply), sum(total_drug_cost) from Prescriber group by npi')

T1_pay <- sqldf('select Physician_Profile_ID, sum(Total_Amount_of_Payment_USDollars) as "PaySum" from paymentSummary group by  Physician_Profile_ID')


# merge data

# no longer available in GOBA : GOBA_unique.[GOBA_Certification.1] as "GOBACert"
T1 <- sqldf('select PCND.*, GOBA.[Title] as "GOBADegree" from PCND left outer join GOBA on PCND.NPI = GOBA.NPI')

T1 <- sqldf('select T1.* , T1_pre.[sum(bene_count)], T1_pre.[Sum(total_claim_count)],T1_pre.[sum(total_day_supply)], T1_pre.[sum(total_drug_cost)] from T1 left outer join T1_pre on T1.NPI = T1_pre.npi')

T1 <- sqldf('select T1.*, T1_pay.PaySum from T1 left outer join T1_pay on T1.PPI = T1_pay.Physician_Profile_ID')

T1$Age <- "NA"
T1[!is.na(T1$GraduationYear),"Age"] = 2019 - T1[!is.na(T1$GraduationYear),"GraduationYear"]+ 26

write.csv(T1, "~/Dropbox/Pharma_Influence/Guido_Working_file/T1.csv")

rm(list=ls()) 
gc()