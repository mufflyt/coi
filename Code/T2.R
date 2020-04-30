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



OP_13 <- read.csv("D:/muffly/data/Originals/PGYR13_P062918/OP_DTL_GNRL_PGYR2013_P06292018.csv",stringsAsFactors = FALSE)
OP_13 <- sqldf('select OP_13.* from OP_13 join StudyGroup on OP_13.Physician_Profile_ID = StudyGroup.PPI' )
OP_13 <- OP_13[OP_13$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

OP_14 <- read.csv("D:/muffly/data/Originals/PGYR14_P062918/OP_DTL_GNRL_PGYR2014_P06292018.csv",stringsAsFactors = FALSE)
OP_14 <- sqldf('select OP_14.* from OP_14 join StudyGroup on OP_14.Physician_Profile_ID = StudyGroup.PPI' )
OP_14 <- OP_14[OP_14$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

OP_15 <- read.csv("D:/muffly/data/Originals/PGYR15_P062918/OP_DTL_GNRL_PGYR2015_P06292018.csv",stringsAsFactors = FALSE)
OP_15 <- sqldf('select OP_15.* from OP_15 join StudyGroup on OP_15.Physician_Profile_ID = StudyGroup.PPI' )
OP_15 <- OP_15[OP_15$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

OP_16 <- read.csv("D:/muffly/data/Originals/PGYR16_P062918/OP_DTL_GNRL_PGYR2016_P06292018.csv",stringsAsFactors = FALSE)
OP_16 <- sqldf('select OP_16.* from OP_16 join StudyGroup on OP_16.Physician_Profile_ID = StudyGroup.PPI' )
OP_16 <- OP_16[OP_16$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Drug" | OP_16$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Biological" ,]

OP_17 <- read.csv("D:/muffly/data/Originals/PGYR17_P062918/OP_DTL_GNRL_PGYR2017_P06292018.csv",stringsAsFactors = FALSE)
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
