# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")

#Start

Prescriber_13 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_13/PartD_Prescriber_PUF_NPI_DRUG_13.txt", stringsAsFactors=FALSE)
Prescriber_13 <- sqldf('select Prescriber_13.npi,Prescriber_13.nppes_provider_first_name,Prescriber_13.nppes_provider_last_org_name,Prescriber_13.nppes_provider_city,Prescriber_13.nppes_provider_state from Prescriber_13 group by Prescriber_13.npi ')

Prescriber_14 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_DRUG_14.txt", stringsAsFactors=FALSE)
Prescriber_14 <- sqldf('select Prescriber_14.npi,Prescriber_14.nppes_provider_first_name,Prescriber_14.nppes_provider_last_org_name,Prescriber_14.nppes_provider_city,Prescriber_14.nppes_provider_state from Prescriber_14 group by Prescriber_14.npi ')

Prescriber_15 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_DRUG_15.txt", stringsAsFactors=FALSE)
Prescriber_15 <- sqldf('select Prescriber_15.npi,Prescriber_15.nppes_provider_first_name,Prescriber_15.nppes_provider_last_org_name,Prescriber_15.nppes_provider_city,Prescriber_15.nppes_provider_state from Prescriber_15 group by Prescriber_15.npi ')

Prescriber_16 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_DRUG_16.txt", stringsAsFactors=FALSE)
Prescriber_16 <- sqldf('select Prescriber_16.npi,Prescriber_16.nppes_provider_first_name,Prescriber_16.nppes_provider_last_org_name,Prescriber_16.nppes_provider_city,Prescriber_16.nppes_provider_state from Prescriber_16 group by Prescriber_16.npi ')

Prescriber_17 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_17/PartD_Prescriber_PUF_NPI_DRUG_17.txt", stringsAsFactors=FALSE)
Prescriber_17 <- sqldf('select Prescriber_17.npi,Prescriber_17.nppes_provider_first_name,Prescriber_17.nppes_provider_last_org_name,Prescriber_17.nppes_provider_city,Prescriber_17.nppes_provider_state from Prescriber_17 group by Prescriber_17.npi ')


Prescriber <- merge(Prescriber_13, Prescriber_14,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_15,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_16,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_17,all = TRUE)

rm(Prescriber_13)
rm(Prescriber_14)
rm(Prescriber_15)
rm(Prescriber_16)
rm(Prescriber_17)


Prescriber_Name <- sqldf('select Prescriber.npi,Prescriber.nppes_provider_first_name,Prescriber.nppes_provider_last_org_name,Prescriber.nppes_provider_city,Prescriber.nppes_provider_state  from Prescriber group by Prescriber.npi ')

write.csv(Prescriber_Name, "D:/muffly/data/Prescriber_ALL_NPI_Names.csv",row.names = FALSE)
rm(Prescriber)
rm(Prescriber_Name)
