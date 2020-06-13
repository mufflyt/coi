# Input
# StudyGroupR3.csv [UPDATED 10/6/19]
# PartD_Prescriber_PUF_NPI_DRUG_13.txt -> PartD_Prescriber_PUF_NPI_DRUG_17.txt
# OP_DTL_GNRL_PGYR2013_P06292018.csv -> OP_DTL_GNRL_PGYR2017_P06292018.csv

# Output
# Prescriber.csv
# PaySum.csv

#setwd("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file")

# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("tidyverse")

# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("tidyverse")
library("Hmisc")

# Load matched data (study group - now R1 with addition of GOBA data)
#StudyGroup <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/StudyGroupR3.csv", stringsAsFactors=FALSE)
StudyGroup <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroupR3.csv", stringsAsFactors=FALSE)

#Load Prescriber
#Prescriber_13 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_13/PartD_Prescriber_PUF_NPI_DRUG_13.txt", stringsAsFactors=FALSE)
Prescriber_13 <- read.delim("/Volumes/Projects/Pharma_Influence/Data/Medicare_Part_D/PartD_Prescriber_PUF_NPI_DRUG_13/PartD_Prescriber_PUF_NPI_DRUG_13.txt", stringsAsFactors=FALSE)
Prescriber_13 <- sqldf('select Prescriber_13.* from Prescriber_13 join StudyGroup on Prescriber_13.NPI = StudyGroup.NPI')

#Prescriber_14 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_DRUG_14.txt", stringsAsFactors=FALSE)
Prescriber_14 <- read.delim("/Volumes/Projects/Pharma_Influence/Data/Medicare_Part_D/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_DRUG_14.txt", stringsAsFactors=FALSE)
Prescriber_14 <- sqldf('select Prescriber_14.* from Prescriber_14 join StudyGroup on Prescriber_14.NPI = StudyGroup.NPI')

#Prescriber_15 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_DRUG_15.txt", stringsAsFactors=FALSE)
Prescriber_15 <- read.delim("/Volumes/Projects/Pharma_Influence/Data/Medicare_Part_D/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_DRUG_15.txt", stringsAsFactors=FALSE)
Prescriber_15 <- sqldf('select Prescriber_15.* from Prescriber_15 join StudyGroup on Prescriber_15.NPI = StudyGroup.NPI')

#Prescriber_16 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_DRUG_16.txt", stringsAsFactors=FALSE)
Prescriber_16 <- read.delim("/Volumes/Projects/Pharma_Influence/Data/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_DRUG_16.txt", stringsAsFactors=FALSE)
Prescriber_16 <- sqldf('select Prescriber_16.* from Prescriber_16 join StudyGroup on Prescriber_16.NPI = StudyGroup.NPI')

#Prescriber_17 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_17/PartD_Prescriber_PUF_NPI_DRUG_17.txt", stringsAsFactors=FALSE)
Prescriber_17 <- read.delim("/Volumes/Projects/Pharma_Influence/Data/PartD_Prescriber_PUF_NPI_DRUG_17/PartD_Prescriber_PUF_NPI_DRUG_17.txt", stringsAsFactors=FALSE)
Prescriber_17 <- sqldf('select Prescriber_17.* from Prescriber_17 join StudyGroup on Prescriber_17.NPI = StudyGroup.NPI')

Prescriber_13$ProgramYear = 2013
Prescriber_14$ProgramYear = 2014
Prescriber_15$ProgramYear = 2015
Prescriber_16$ProgramYear = 2016
Prescriber_17$ProgramYear = 2017

Prescriber <- merge(Prescriber_13, Prescriber_14,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_15,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_16,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_17,all = TRUE)

rm(Prescriber_13)
rm(Prescriber_14)
rm(Prescriber_15)
rm(Prescriber_16)
rm(Prescriber_17)

write.csv(Prescriber, "prescriber.csv", row.names = FALSE)

#Load OP
#OP_13 <- read.csv("D:/muffly/data/Originals/PGYR13_P062918/OP_DTL_GNRL_PGYR2013_P06292018.csv",stringsAsFactors = FALSE)
OP_13 <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/PGYR13_P062918/OP_DTL_GNRL_PGYR2013_P01172020.csv", stringsAsFactors = FALSE)
OP_13 <- sqldf('select OP_13.* from OP_13 join StudyGroup on OP_13.Physician_Profile_ID = StudyGroup.PPI' )
OP_13 <- OP_13[OP_13$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

#OP_14 <- read.csv("D:/muffly/data/Originals/PGYR14_P062918/OP_DTL_GNRL_PGYR2014_P06292018.csv",stringsAsFactors = FALSE)
OP_14 <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/PGYR14_P062918/OP_DTL_GNRL_PGYR2014_P06292018.csv",stringsAsFactors = FALSE)
OP_14 <- sqldf('select OP_14.* from OP_14 join StudyGroup on OP_14.Physician_Profile_ID = StudyGroup.PPI' )
OP_14 <- OP_14[OP_14$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

#OP_15 <- read.csv("D:/muffly/data/Originals/PGYR15_P062918/OP_DTL_GNRL_PGYR2015_P06292018.csv",stringsAsFactors = FALSE)
OP_15 <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/PGYR15_P062918/OP_DTL_GNRL_PGYR2015_P06292018.csv",stringsAsFactors = FALSE)
OP_15 <- sqldf('select OP_15.* from OP_15 join StudyGroup on OP_15.Physician_Profile_ID = StudyGroup.PPI' )
OP_15 <- OP_15[OP_15$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

#OP_16 <- read.csv("D:/muffly/data/Originals/PGYR16_P062918/OP_DTL_GNRL_PGYR2016_P06292018.csv",stringsAsFactors = FALSE)
OP_16 <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/PGYR16_P062918/OP_DTL_GNRL_PGYR2016_P06292018.csv",stringsAsFactors = FALSE)
OP_16 <- sqldf('select OP_16.* from OP_16 join StudyGroup on OP_16.Physician_Profile_ID = StudyGroup.PPI' )
OP_16 <- OP_16[OP_16$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Drug" | OP_16$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Biological" ,]

#OP_17 <- read.csv("D:/muffly/data/Originals/PGYR17_P062918/OP_DTL_GNRL_PGYR2017_P06292018.csv",stringsAsFactors = FALSE)
OP_17 <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/PGYR17_P062918/OP_DTL_GNRL_PGYR2017_P06292018.csv",stringsAsFactors = FALSE)
OP_17 <- sqldf('select OP_17.* from OP_17 join StudyGroup on OP_17.Physician_Profile_ID = StudyGroup.PPI' )
OP_17 <- OP_17[OP_17$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Drug" | OP_17$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Biological",]

# reorder 16 and 17
OP_16 <- OP_16[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,52,57,62,67,72,53,58,63,68,73,52,57,62,67,72,74,75,49,50,51,54,55,56,59,60,61,64,65,66,69,70,71)]

names(OP_16)[c(49, 50, 51, 52, 53)] <- c("Name_of_Associated_Covered_Drug_or_Biological1","Name_of_Associated_Covered_Drug_or_Biological2", "Name_of_Associated_Covered_Drug_or_Biological3","Name_of_Associated_Covered_Drug_or_Biological4","Name_of_Associated_Covered_Drug_or_Biological5")

names(OP_16)[c(54,55,56,57,58)] <- c("NDC_of_Associated_Covered_Drug_or_Biological1", "NDC_of_Associated_Covered_Drug_or_Biological2","NDC_of_Associated_Covered_Drug_or_Biological3","NDC_of_Associated_Covered_Drug_or_Biological4","NDC_of_Associated_Covered_Drug_or_Biological5")

names(OP_16)[c(59, 60, 61, 62, 63)]<- c("Name_of_Associated_Covered_Device_or_Medical_Supply1","Name_of_Associated_Covered_Device_or_Medical_Supply2","Name_of_Associated_Covered_Device_or_Medical_Supply3","Name_of_Associated_Covered_Device_or_Medical_Supply4","Name_of_Associated_Covered_Device_or_Medical_Supply5")

OP_16$Name_of_Associated_Covered_Device_or_Medical_Supply1 <- ""
OP_16$Name_of_Associated_Covered_Device_or_Medical_Supply2 <- ""
OP_16$Name_of_Associated_Covered_Device_or_Medical_Supply3 <- ""
OP_16$Name_of_Associated_Covered_Device_or_Medical_Supply4 <- ""
OP_16$Name_of_Associated_Covered_Device_or_Medical_Supply5 <- ""

OP_16 <- OP_16[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65)]

# reorder 16 and 17

OP_17 <- OP_17[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,52,57,62,67,72,53,58,63,68,73,52,57,62,67,72,74,75,49,50,51,54,55,56,59,60,61,64,65,66,69,70,71)]

names(OP_17)[c(49, 50, 51, 52, 53)] <- c("Name_of_Associated_Covered_Drug_or_Biological1","Name_of_Associated_Covered_Drug_or_Biological2", "Name_of_Associated_Covered_Drug_or_Biological3","Name_of_Associated_Covered_Drug_or_Biological4","Name_of_Associated_Covered_Drug_or_Biological5")

names(OP_17)[c(54,55,56,57,58)] <- c("NDC_of_Associated_Covered_Drug_or_Biological1", "NDC_of_Associated_Covered_Drug_or_Biological2","NDC_of_Associated_Covered_Drug_or_Biological3","NDC_of_Associated_Covered_Drug_or_Biological4","NDC_of_Associated_Covered_Drug_or_Biological5")

names(OP_17)[c(59, 60, 61, 62, 63)]<- c("Name_of_Associated_Covered_Device_or_Medical_Supply1","Name_of_Associated_Covered_Device_or_Medical_Supply2","Name_of_Associated_Covered_Device_or_Medical_Supply3","Name_of_Associated_Covered_Device_or_Medical_Supply4","Name_of_Associated_Covered_Device_or_Medical_Supply5")

OP_17$Name_of_Associated_Covered_Device_or_Medical_Supply1 <- ""
OP_17$Name_of_Associated_Covered_Device_or_Medical_Supply2 <- ""
OP_17$Name_of_Associated_Covered_Device_or_Medical_Supply3 <- ""
OP_17$Name_of_Associated_Covered_Device_or_Medical_Supply4 <- ""
OP_17$Name_of_Associated_Covered_Device_or_Medical_Supply5 <- ""

OP_17 <- OP_17[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65)]

OP <- merge(OP_13, OP_14, all = TRUE)
OP <- merge(OP, OP_15, all = TRUE)
OP <- merge(OP, OP_16, all = TRUE)
OP <- merge(OP, OP_17, all = TRUE)

rm(OP_13)
rm(OP_14)
rm(OP_15)
rm(OP_16)
rm(OP_17)


OP$DrugCount = 0

OP[is.na(OP$Name_of_Associated_Covered_Drug_or_Biological5),"Name_of_Associated_Covered_Drug_or_Biological5"] <- ""
OP[OP$Name_of_Associated_Covered_Drug_or_Biological5 != "","DrugCount"] <- "5"

OP[is.na(OP$Name_of_Associated_Covered_Drug_or_Biological4),"Name_of_Associated_Covered_Drug_or_Biological4"] <- ""
OP[OP$Name_of_Associated_Covered_Drug_or_Biological4 != "" & OP$DrugCount== 0,"DrugCount"] <- 4

OP[is.na(OP$Name_of_Associated_Covered_Drug_or_Biological3),"Name_of_Associated_Covered_Drug_or_Biological3"] <- ""
OP[OP$Name_of_Associated_Covered_Drug_or_Biological3 != "" & OP$DrugCount== 0,"DrugCount"] <- 3

OP[is.na(OP$Name_of_Associated_Covered_Drug_or_Biological2),"Name_of_Associated_Covered_Drug_or_Biological2"] <- ""
OP[OP$Name_of_Associated_Covered_Drug_or_Biological2 != "" & OP$DrugCount== 0,"DrugCount"] <- 2

OP[is.na(OP$Name_of_Associated_Covered_Drug_or_Biological1),"Name_of_Associated_Covered_Drug_or_Biological1"] <- ""
OP[OP$Name_of_Associated_Covered_Drug_or_Biological1 != "" & OP$DrugCount== 0,"DrugCount"] <- 1

#5 drugs
PaySum5 <- OP[OP$DrugCount == 5,c(6,26,27,31,52,57,63,67)]
PaySum4 <- OP[OP$DrugCount == 5,c(6,26,27,31,51,56,63,67)]
PaySum3 <- OP[OP$DrugCount == 5,c(6,26,27,31,50,55,63,67)]
PaySum2 <- OP[OP$DrugCount == 5,c(6,26,27,31,49,54,63,67)]
PaySum1 <- OP[OP$DrugCount == 5,c(6,26,27,31,48,53,63,67)]

names(PaySum1)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum1)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"
  
names(PaySum2)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum2)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum3)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum3)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum4)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum4)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum5)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum5)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"


PaySum1$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 5
PaySum2$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 5
PaySum3$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 5
PaySum4$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 5
PaySum5$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 5

PaySum <- merge(PaySum1, PaySum2, all = TRUE)
PaySum <- merge(PaySum, PaySum3, all=TRUE)
PaySum <- merge(PaySum, PaySum4, all=TRUE)
PaySum <- merge(PaySum, PaySum5, all=TRUE)

rm(PaySum5)

# 4 drugs
PaySum4 <- OP[OP$DrugCount == 4,c(6,26,27,31,51,56,63,67)]
PaySum3 <- OP[OP$DrugCount == 4,c(6,26,27,31,50,55,63,67)]
PaySum2 <- OP[OP$DrugCount == 4,c(6,26,27,31,49,54,63,67)]
PaySum1 <- OP[OP$DrugCount == 4,c(6,26,27,31,48,53,63,67)]

names(PaySum1)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum1)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum2)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum2)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum3)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum3)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum4)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum4)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

PaySum1$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 4
PaySum2$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 4
PaySum3$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 4
PaySum4$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 4

PaySum <- merge(PaySum, PaySum1, all = TRUE)
PaySum <- merge(PaySum, PaySum2, all=TRUE)
PaySum <- merge(PaySum, PaySum3, all=TRUE)
PaySum <- merge(PaySum, PaySum4, all=TRUE)

rm(PaySum4)

# 3 Drugs
PaySum3 <- OP[OP$DrugCount == 3,c(6,26,27,31,50,55,63,67)]
PaySum2 <- OP[OP$DrugCount == 3,c(6,26,27,31,49,54,63,67)]
PaySum1 <- OP[OP$DrugCount == 3,c(6,26,27,31,48,53,63,67)]

names(PaySum1)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum1)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum2)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum2)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum3)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum3)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

PaySum1$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 3
PaySum2$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 3
PaySum3$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 3

PaySum <- merge(PaySum, PaySum1, all = TRUE)
PaySum <- merge(PaySum, PaySum2, all = TRUE)
PaySum <- merge(PaySum, PaySum3, all = TRUE)

rm(PaySum3)

#2 Drugs
PaySum2 <- OP[OP$DrugCount == 2,c(6,26,27,31,49,54,63,67)]
PaySum1 <- OP[OP$DrugCount == 2,c(6,26,27,31,48,53,63,67)]

names(PaySum1)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum1)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

names(PaySum2)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum2)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

PaySum1$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 2
PaySum2$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars / 2

PaySum <- merge(PaySum, PaySum1, all = TRUE)
PaySum <- merge(PaySum, PaySum2, all=TRUE)

rm(PaySum2)

# 1 Drug
PaySum1 <- OP[OP$DrugCount == 1,c(6,26,27,31,48,53,63,67)]

names(PaySum1)[5] <- "Name_of_Associated_Covered_Drug_or_Biological"
names(PaySum1)[6] <- "NDC_of_Associated_Covered_Drug_or_Biological"

PaySum1$Total_Amount_of_Payment_USDollars <- PaySum1$Total_Amount_of_Payment_USDollars 

PaySum <- merge(PaySum, PaySum1, all = TRUE)

rm(PaySum1)
rm(OP)

write.csv(PaySum,"paymentSummary.csv", row.names = FALSE)

