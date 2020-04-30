# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
# Loading
library("sqldf", lib.loc="~/R/win-library/3.2")
library("qdapRegex", lib.loc="~/R/win-library/3.2")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("readr")

#Start

Prescriber_13 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_13/PartD_Prescriber_PUF_NPI_DRUG_13.txt", stringsAsFactors=FALSE)
Prescriber_13 <- sqldf('select Prescriber_13.npi,Prescriber_13.specialty_description from Prescriber_13 group by Prescriber_13.npi ')

Prescriber_14 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_DRUG_14.txt", stringsAsFactors=FALSE)
Prescriber_14 <- sqldf('select Prescriber_14.npi,Prescriber_14.specialty_description from Prescriber_14 group by Prescriber_14.npi ')

Prescriber_15 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_DRUG_15.txt", stringsAsFactors=FALSE)
Prescriber_15 <- sqldf('select Prescriber_15.npi,Prescriber_15.specialty_description from Prescriber_15 group by Prescriber_15.npi ')

Prescriber_16 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_DRUG_16.txt", stringsAsFactors=FALSE)
Prescriber_16 <- sqldf('select Prescriber_16.npi,Prescriber_16.specialty_description from Prescriber_16 group by Prescriber_16.npi ')

Prescriber_17 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_17/PartD_Prescriber_PUF_NPI_DRUG_17.txt", stringsAsFactors=FALSE)
Prescriber_17 <- sqldf('select Prescriber_17.npi,Prescriber_17.specialty_description from Prescriber_17 group by Prescriber_17.npi ')


Prescriber <- merge(Prescriber_13, Prescriber_14,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_15,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_16,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_17,all = TRUE)

rm(Prescriber_13)
rm(Prescriber_14)
rm(Prescriber_15)
rm(Prescriber_16)
rm(Prescriber_17)


Prescriber_Name <- sqldf('select Prescriber.npi,Prescriber.specialty_description  from Prescriber group by Prescriber.npi ')

write.csv(Prescriber_Name, "D:/muffly/data/Prescriber_ALL_NPI_Specialty.csv",row.names = FALSE)
