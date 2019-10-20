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


#load files from 'Load_Data Script Output'

StudyGroup <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/StudyGroupR1.csv", stringsAsFactors=FALSE)

Prescriber <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)
paymentSummary <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/paymentSummary.csv", stringsAsFactors=FALSE)

Physician_Compare_National_Downloadable_File <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)

StudyGroup <- sqldf('select StudyGroup.*, Physician_Compare_National_Downloadable_File.NPI as "PCNPI" from StudyGroup left outer join Physician_Compare_National_Downloadable_File on StudyGroup.NPI = Physician_Compare_National_Downloadable_File.NPI')

StudyGroup<- StudyGroup[!is.na(StudyGroup$PCNPI),]

# consolidate on NPI and files we need (to remove dups)

Physician_Compare_National_Downloadable_File <- sqldf('select Physician_Compare_National_Downloadable_File.NPI, Physician_Compare_National_Downloadable_File.Gender, Physician_Compare_National_Downloadable_File.[Medical.school.name] as "MedSchool",Physician_Compare_National_Downloadable_File.State, Physician_Compare_National_Downloadable_File.[Graduation.year] as "GraduationYear" from Physician_Compare_National_Downloadable_File group by Physician_Compare_National_Downloadable_File.NPI')

GOBA_unique <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/GOBA_unique.csv", stringsAsFactors=FALSE)

GOBA_unique <- GOBA_unique[!duplicated(GOBA_unique$NPI_Match),]

#Table one 
# - consolidate prescription on npi, sum(ben_count), sum(total_claim_count),sum(total_day_supply), sum(total_drup_cost)

T1 <- sqldf('select npi,sum(bene_count), sum(total_claim_count),sum(total_day_supply), sum(total_drug_cost) from Prescriber group by npi')

PaymentSummary_T1 <- sqldf('select Physician_Profile_ID, sum(Total_Amount_of_Payment_USDollars) as "PaySum" from paymentSummary group by  Physician_Profile_ID')

T1 <- sqldf('select T1.*, StudyGroup.PPI from T1 left outer join StudyGroup on T1.npi = StudyGroup.NPI')
T1 <- T1[!is.na(T1$PPI),]

T1 <- sqldf('select T1.*,PaymentSummary_T1.PaySum from T1 left outer join PaymentSummary_T1 on T1.PPI = PaymentSummary_T1.Physician_Profile_ID ')

T1 <- sqldf('select T1.*, Physician_Compare_National_Downloadable_File.Gender, Physician_Compare_National_Downloadable_File.MedSchool,Physician_Compare_National_Downloadable_File.State, Physician_Compare_National_Downloadable_File.GraduationYear from T1 left outer join Physician_Compare_National_Downloadable_File on T1.npi = Physician_Compare_National_Downloadable_File.NPI')


T1 <- sqldf('select T1.*, GOBA_unique.[GOBA_Certification.1] as "GOBACert", GOBA_unique.HG_Age, GOBA_unique.[GOBA_Degree.1] as "GOBADegree" from T1 left outer join GOBA_unique on T1.npi = GOBA_unique.NPI_Match')

write.csv(T1, "T1.csv")
