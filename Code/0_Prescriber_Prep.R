# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
# Loading
library("sqldf")
library("qdapRegex")
library("readr")

#Start

Prescriber_13 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_13/PartD_Prescriber_PUF_NPI_DRUG_13.txt", stringsAsFactors=FALSE)
Prescriber_13_1 <- sqldf('select Prescriber_13.npi,Prescriber_13.nppes_provider_first_name,Prescriber_13.nppes_provider_last_org_name,Prescriber_13.nppes_provider_city,Prescriber_13.nppes_provider_state, Prescriber_13.specialty_description from Prescriber_13 group by Prescriber_13.npi ')
Prescriber_13_2 <- Prescriber_13_1[Prescriber_13_1$specialty_description %in% c("Obstetrics/Gynecology","Gynecological/Oncology","Obstetrics & Gynecology","Gynecological Oncology"),]

Prescriber_14 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_DRUG_14.txt", stringsAsFactors=FALSE)
Prescriber_14_1 <- sqldf('select Prescriber_14.npi,Prescriber_14.nppes_provider_first_name,Prescriber_14.nppes_provider_last_org_name,Prescriber_14.nppes_provider_city,Prescriber_14.nppes_provider_state,Prescriber_14.specialty_description from Prescriber_14 group by Prescriber_14.npi ')
Prescriber_14_2 <- Prescriber_14_1[Prescriber_14_1$specialty_description %in% c("Obstetrics/Gynecology","Gynecological/Oncology","Obstetrics & Gynecology","Gynecological Oncology"),]

Prescriber_15 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_DRUG_15.txt", stringsAsFactors=FALSE)
Prescriber_15_1 <- sqldf('select Prescriber_15.npi,Prescriber_15.nppes_provider_first_name,Prescriber_15.nppes_provider_last_org_name,Prescriber_15.nppes_provider_city,Prescriber_15.nppes_provider_state,Prescriber_15.specialty_description  from Prescriber_15 group by Prescriber_15.npi ')
Prescriber_15_2 <- Prescriber_15_1[Prescriber_15_1$specialty_description %in% c("Obstetrics/Gynecology","Gynecological/Oncology","Obstetrics & Gynecology","Gynecological Oncology"),]

Prescriber_16 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_DRUG_16.txt", stringsAsFactors=FALSE)
Prescriber_16_1 <- sqldf('select Prescriber_16.npi,Prescriber_16.nppes_provider_first_name,Prescriber_16.nppes_provider_last_org_name,Prescriber_16.nppes_provider_city,Prescriber_16.nppes_provider_state, Prescriber_16.specialty_description from Prescriber_16 group by Prescriber_16.npi ')
Prescriber_16_2 <- Prescriber_16_1[Prescriber_16_1$specialty_description %in% c("Obstetrics/Gynecology","Gynecological/Oncology","Obstetrics & Gynecology","Gynecological Oncology"),]

Prescriber_17 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_DRUG_17/PartD_Prescriber_PUF_NPI_DRUG_17.txt", stringsAsFactors=FALSE)
Prescriber_17_1 <- sqldf('select Prescriber_17.npi,Prescriber_17.nppes_provider_first_name,Prescriber_17.nppes_provider_last_org_name,Prescriber_17.nppes_provider_city,Prescriber_17.nppes_provider_state, Prescriber_17.specialty_description from Prescriber_17 group by Prescriber_17.npi ')
Prescriber_17_2 <- Prescriber_17_1[Prescriber_17_1$specialty_description %in% c("Obstetrics/Gynecology","Gynecological/Oncology","Obstetrics & Gynecology","Gynecological Oncology"),]

Prescriber <- merge(Prescriber_13_2, Prescriber_14_2,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_15_2,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_16_2,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_17_2,all = TRUE)

Prescriber_Name_State <- sqldf('select Prescriber.npi,Prescriber.nppes_provider_first_name,Prescriber.nppes_provider_last_org_name,Prescriber.nppes_provider_state from Prescriber group by Prescriber.npi ')
write.csv(Prescriber_Name, "D:/muffly/data/Prescriber_Name_State.csv",row.names = FALSE)

Prescriber_Name <- sqldf('select Prescriber.npi,Prescriber.nppes_provider_first_name,Prescriber.nppes_provider_last_org_name from Prescriber group by Prescriber.npi ')
write.csv(Prescriber_Name, "D:/muffly/data/Prescriber_Name.csv",row.names = FALSE)

