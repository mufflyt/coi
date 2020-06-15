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


#load files from prior processing (StudyGroup and PCND)

StudyGroup <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/StudyGroupR3.csv", stringsAsFactors=FALSE)

PCND <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/PCND.csv", stringsAsFactors=FALSE)

# Load GOBA - consolidate on NPI and files we need (to remove dups)

GOBA_unique <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/GOBA_unique.csv", stringsAsFactors=FALSE)
GOBA_unique <- GOBA_unique[!duplicated(GOBA_unique$NPI_Match),]

Prescriber <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)

paymentSummary <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/paymentSummary.csv", stringsAsFactors=FALSE)

# summarize prescriber and payment data
T1_pre <- sqldf('select npi,sum(bene_count), sum(total_claim_count),sum(total_day_supply), sum(total_drug_cost) from Prescriber group by npi')

T1_pay <- sqldf('select Physician_Profile_ID, sum(Total_Amount_of_Payment_USDollars) as "PaySum" from paymentSummary group by  Physician_Profile_ID')


# merge data


T1 <- sqldf('select PCND.*, GOBA_unique.[GOBA_Certification.1] as "GOBACert",  GOBA_unique.[GOBA_Degree.1] as "GOBADegree" from PCND left outer join GOBA_unique on PCND.npi = GOBA_unique.NPI_Match')

T1 <- sqldf('select T1.* , T1_pre.[sum(bene_count)], T1_pre.[Sum(total_claim_count)],T1_pre.[sum(total_day_supply)], T1_pre.[sum(total_drug_cost)] from T1 left outer join T1_pre on T1.NPI = T1_pre.npi')

T1 <- sqldf('select T1.*, T1_pay.PaySum from T1 left outer join T1_pay on T1.PPI = T1_pay.Physician_Profile_ID')

T1$Age <- "NA"
T1[!is.na(T1$GraduationYear),"Age"] = 2019 - T1[!is.na(T1$GraduationYear),"GraduationYear"]+ 26

write.csv(T1, "T1.csv")
