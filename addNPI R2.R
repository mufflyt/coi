# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("tidyverse")
library("dplyr")
library("inspectdf")
library("Hmisc")
library("DataExplorer")
library("GGally")

#Start
#Start
OBGYN_List <- (c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Critical Care Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Female Pelvic Medicine and Reconstructive Surgery", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology")) %>% 
  as.data.frame()
"Physician_Specialty" -> names(OBGYN_List)
colnames(OBGYN_List)


OP_13 <- read.csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2013_P06292018.csv",stringsAsFactors = FALSE)
OP_13 <- sqldf('select OP_13.* from OP_13 join OBGYN_List on OP_13.Physician_Specialty = OBGYN_List.Physician_Specialty' )
OP_13 <- OP_13[OP_13$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

OP_14 <- read.csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2014_P06292018.csv",stringsAsFactors = FALSE)
OP_14<- sqldf('select OP_14.* from OP_14 join OBGYN_List on OP_14.Physician_Specialty = OBGYN_List.Physician_Specialty' )
OP_14 <- OP_14[OP_14$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

OP_15 <- read.csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2015_P06292018.csv",stringsAsFactors = FALSE)
OP_15<- sqldf('select OP_15.* from OP_15 join OBGYN_List on OP_15.Physician_Specialty = OBGYN_List.Physician_Specialty' )
OP_15 <- OP_15[OP_15$Name_of_Associated_Covered_Drug_or_Biological1 !="",]

OP_16 <- read.csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2016_P06292018.csv",stringsAsFactors = FALSE)
OP_16<- sqldf('select OP_16.* from OP_16 join OBGYN_List on OP_16.Physician_Specialty = OBGYN_List.Physician_Specialty' )
OP_16 <- OP_16[OP_16$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Drug" | OP_16$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Biological" ,]

OP_17 <- read.csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2017_P06292018.csv",stringsAsFactors = FALSE)
OP_17<- sqldf('select OP_17.* from OP_17 join OBGYN_List on OP_17.Physician_Specialty = OBGYN_List.Physician_Specialty' )
OP_17 <- OP_17[OP_17$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Drug" | OP_17$Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 =="Biological",]

cols_15 <- colnames(OP_15) %>% as.data.frame()
cols_16 <- colnames(OP_16) %>% as.data.frame()
outer <- dplyr::anti_join(cols_15, cols_16)
outer
outer2 <- dplyr::anti_join(cols_16, cols_15)
outer2

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

Prescriber_13 <- read.delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_13/PartD_Prescriber_PUF_NPI_13.txt", stringsAsFactors=FALSE)
Prescriber_13 <- Prescriber_13[Prescriber_13$specialty_description == "Obstetrics/Gynecology",]

Prescriber_14 <- read.delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_14/PartD_Prescriber_PUF_NPI_14.txt", stringsAsFactors=FALSE)
Prescriber_14 <- Prescriber_14[Prescriber_14$specialty_description == "Obstetrics/Gynecology",]

Prescriber_15 <- read.delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_15/PartD_Prescriber_PUF_NPI_15.txt", stringsAsFactors=FALSE)
Prescriber_15 <- Prescriber_15[Prescriber_15$specialty_description == "Obstetrics/Gynecology",]

Prescriber_16 <- read.delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_16/PartD_Prescriber_PUF_NPI_16.txt", stringsAsFactors=FALSE)
Prescriber_16 <- Prescriber_16[Prescriber_16$specialty_description == "Obstetrics/Gynecology",]

Prescriber_17 <- read.delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_17/PartD_Prescriber_PUF_NPI_17.txt", stringsAsFactors=FALSE)
Prescriber_17 <- Prescriber_17[Prescriber_17$specialty_description == "Obstetrics & Gynecology",]

Prescriber <- merge(Prescriber_13, Prescriber_14,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_15,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_16,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_17,all = TRUE)

rm(Prescriber_13)
rm(Prescriber_14)
rm(Prescriber_15)
rm(Prescriber_16)
rm(Prescriber_17)


Prescriber_Name <- sqldf('select Prescriber.npi, Prescriber.nppes_provider_last_org_name, Prescriber.nppes_provider_first_name, Prescriber.nppes_provider_mi, nppes_provider_street1, nppes_provider_city,nppes_provider_state, nppes_provider_zip5 from Prescriber group by Prescriber.npi ')

OP_Name <- sqldf('select OP.Physician_Profile_ID, OP.Physician_Last_Name, OP.Physician_First_Name, OP.Physician_Middle_Name,  Recipient_Primary_Business_Street_Address_Line1,Recipient_City, Recipient_State, Recipient_Zip_Code from OP group by OP.Physician_Profile_ID')

OP_Name <- OP_Name[!is.na(OP_Name$Physician_Profile_ID),]

write.csv(OP_Name, "~/Dropbox/Pharma_Influence/data/OP_Name.csv",row.names = FALSE)
write.csv(Prescriber_Name, "~/Dropbox/Pharma_Influence/data/Prescriber_Name.csv",row.names = FALSE)
write.csv(OP,"~/Dropbox/Pharma_Influence/data/OP.csv",row.names = FALSE)
write.csv(Prescriber, "~/Dropbox/Pharma_Influence/data/Prescriber.csv",row.names = FALSE)

#*********************************************************************************************
# start temp

# OP_Name <- read.csv("D:/muffly/data/OP_Name.csv", stringsAsFactors=FALSE)
# Prescriber_Name <- read.csv("D:/muffly/data/Prescriber_Name.csv", stringsAsFactors=FALSE)

# end temp
#*********************************************************************************************

OP_Name$NPI <- ""
OP_Name$MType <- ""


Prescriber_Name$Physician_Profile_ID <- ""
Prescriber_Name$MType <- ""

names(OP_Name) <- c("PPI", "LName", "FName", "MName", "Address", "City", "State", "Zip", "NPI", "MType")
names(Prescriber_Name) <- c("NPI", "LName", "FName", "MI", "Address", "City", "State", "Zip", "PPI", "MType")
OP_Name$MI <- substr(OP_Name$MName,1,1)

OP_Name$MatchNMIZip <- tolower(paste(OP_Name$FName,OP_Name$LName,OP_Name$Zip,sep=" "))
OP_Name$MatchNMI <- tolower(paste(OP_Name$FName,OP_Name$LName,sep=" "))
OP_Name$MatchMI <- tolower(paste(OP_Name$FName,OP_Name$MI, OP_Name$LName,sep=" "))

Prescriber_Name$MatchNMIZip <- tolower(paste(Prescriber_Name$FName, Prescriber_Name$LName,Prescriber_Name$Zip, sep=" "))
Prescriber_Name$MatchNMI <- tolower(paste(Prescriber_Name$FName, Prescriber_Name$LName, sep=" "))
Prescriber_Name$MatchMI <- tolower(paste(Prescriber_Name$FName, Prescriber_Name$MI,Prescriber_Name$LName, sep=" "))

matches <- sqldf('select OP_Name.*, Prescriber_Name.NPI as "MNPI" from OP_Name left outer join Prescriber_Name on OP_Name.MatchMI = Prescriber_Name.MatchMI')

dc_OP <- sqldf ('select matches.PPI, count(matches.PPI) as "CNT" from matches group by matches.PPI ')
dup_OP <- dc_OP[dc_OP$CNT >= 2,]                             
dup_OP_Record <- sqldf('select matches.* from matches join dup_OP  on dup_OP.PPI = matches.PPI')

u_OP  <- dc_OP[dc_OP$CNT == 1,]                             
u_OP_Record <- sqldf('select matches.* from matches join u_OP on matches.PPI = u_OP.PPI')
OP_NoMatch <- u_OP_Record[is.na(u_OP_Record$MNPI),]
OP_Match <- u_OP_Record[!is.na(u_OP_Record$MNPI),]

dc_P <- sqldf ('select OP_Match.MNPI, count(OP_Match.NPI) as "CNT" from OP_Match group by OP_Match.MNPI ')
dup_P <- dc_P[dc_P$CNT >=2,]
dup_P_Record<- sqldf('select matches.* from matches join dup_P on matches.MNPI = dup_P.MNPI')

u_P <- dc_P[dc_P$CNT ==1,]
u_P_Record <- sqldf('select matches.* from matches join u_P on matches.MNPI = u_P.MNPI')

OP_Name <- sqldf('select OP_Name.*, u_P_Record.MNPI from OP_Name left outer join u_P_Record on OP_Name.PPI = u_P_Record.PPI')
OP_Name[!is.na(OP_Name$MNPI),"NPI"] <- OP_Name[!is.na(OP_Name$MNPI),"MNPI"]
OP_Name[!is.na(OP_Name$MNPI),"MType"] <- "matchMI"
OP_Name$MNPI <- NULL

Prescriber_Name <- sqldf('select Prescriber_Name.*, u_P_Record.PPI as "MPPI" from Prescriber_Name left outer join u_P_Record on Prescriber_Name.NPI = u_P_Record.MNPI')
Prescriber_Name[!is.na(Prescriber_Name$MPPI),"PPI"] <- Prescriber_Name[!is.na(Prescriber_Name$MPPI),"MPPI"]
Prescriber_Name[!is.na(Prescriber_Name$MPPI), "MType"] <- "matchMI" 
Prescriber_Name$MPPI <- NULL

match_MI <- u_P_Record
dup_OP_Record$Source <- "OPDup"
dup_P_Record$Source <- "PDup"
dup_MI <- merge(dup_OP_Record, dup_P_Record, all = TRUE)
nomatch_MI <- OP_NoMatch
nomatch_MI$MNPI <- NULL

rm(dc_OP)
rm(dc_P)
rm(dup_OP)
rm(dup_OP_Record)
rm(dup_P)
rm(dup_P_Record)
rm(matches)
rm(OP_Match)
rm(OP_NoMatch)
rm(u_OP)
rm(u_OP_Record)
rm(u_P)
rm(u_P_Record)

#*********************************************************************************
# round2, no middle initial
#
matches <- sqldf('select nomatch_MI.*, Prescriber_Name.NPI as "MNPI" from nomatch_MI left outer join Prescriber_Name on nomatch_MI.MatchNMI = Prescriber_Name.MatchNMI where Prescriber_Name.PPI = ""')

#*********************************************************************************

dc_OP <- sqldf ('select matches.PPI, count(matches.PPI) as "CNT" from matches group by matches.PPI ')
dup_OP <- dc_OP[dc_OP$CNT >= 2,]                             
dup_OP_Record <- sqldf('select matches.* from matches join dup_OP  on dup_OP.PPI = matches.PPI')

u_OP  <- dc_OP[dc_OP$CNT == 1,]                             
u_OP_Record <- sqldf('select matches.* from matches join u_OP on matches.PPI = u_OP.PPI')
OP_NoMatch <- u_OP_Record[is.na(u_OP_Record$MNPI),]
OP_Match <- u_OP_Record[!is.na(u_OP_Record$MNPI),]

dc_P <- sqldf ('select OP_Match.MNPI, count(OP_Match.NPI) as "CNT" from OP_Match group by OP_Match.MNPI ')
dup_P <- dc_P[dc_P$CNT >=2,]
dup_P_Record<- sqldf('select matches.* from matches join dup_P on matches.MNPI = dup_P.MNPI')

u_P <- dc_P[dc_P$CNT ==1,]
u_P_Record <- sqldf('select matches.* from matches join u_P on matches.MNPI = u_P.MNPI')

OP_Name <- sqldf('select OP_Name.*, u_P_Record.MNPI from OP_Name left outer join u_P_Record on OP_Name.PPI = u_P_Record.PPI')
OP_Name[!is.na(OP_Name$MNPI),"NPI"] <- OP_Name[!is.na(OP_Name$MNPI),"MNPI"]
OP_Name[!is.na(OP_Name$MNPI),"MType"] <- "matchNMI"
OP_Name$MNPI <- NULL

Prescriber_Name <- sqldf('select Prescriber_Name.*, u_P_Record.PPI as "MPPI" from Prescriber_Name left outer join u_P_Record on Prescriber_Name.NPI = u_P_Record.MNPI and Prescriber_Name.PPI =""')
Prescriber_Name[!is.na(Prescriber_Name$MPPI),"PPI"] <- Prescriber_Name[!is.na(Prescriber_Name$MPPI),"MPPI"]
Prescriber_Name[!is.na(Prescriber_Name$MPPI), "MType"] <- "matchNMI" 
Prescriber_Name$MPPI <- NULL

match_NMI <- u_P_Record
dup_OP_Record$Source <- "OPDup"
dup_P_Record$Source <- "PDup"
dup_NMI <- merge(dup_OP_Record, dup_P_Record, all = TRUE)
nomatch_NMI <- OP_NoMatch
nomatch_NMI$MNPI <- NULL

rm(dc_OP)
rm(dc_P)
rm(dup_OP)
rm(dup_OP_Record)
rm(dup_P)
rm(dup_P_Record)
rm(matches)
rm(OP_Match)
rm(OP_NoMatch)
rm(u_OP)
rm(u_OP_Record)
rm(u_P)
rm(u_P_Record)

# **************************************************************************************************************
# clean and output
# **************************************************************************************************************

OP_Matched <- sqldf('select OP_Name.PPI from OP_Name where OP_Name.NPI !=""')
OP_Matched <- sqldf('select OP_Matched.PPI, count(OP_Matched.PPI) from OP_Matched group by OP_Matched.PPI ')
OP_Matched$`count(OP_Matched.PPI)`<- NULL

P_Matched <- sqldf('select Prescriber_Name.NPI from Prescriber_Name where Prescriber_Name.PPI !=""')
P_Matched <- sqldf('select P_Matched.NPI, count(P_Matched.NPI) from P_Matched group by P_Matched.NPI ')
P_Matched$`count(P_Matched.NPI)`<- NULL

dups <- merge(dup_MI,dup_NMI, all = TRUE)
rm(dup_MI)
rm(dup_NMI)

dups<- sqldf('select dups.*, OP_Matched.PPI as "OPPI" from dups left outer join OP_Matched on dups.PPI = OP_Matched.PPI')
dups <- dups[is.na(dups$OPPI),]
dups$OPPI <- NULL

dups<- sqldf('select dups.*, P_Matched.NPI as "PNPI" from dups left outer join P_Matched on dups.NPI = P_Matched.NPI')
dups <- dups[is.na(dups$PNPI),]
dups$PNPI <- NULL

OP_Name_Matched <- OP_Name[OP_Name$NPI != "",]
OP_Name_UnMatched  <-OP_Name[OP_Name$NPI == "",]

Prescriber_Name_Matched <- Prescriber_Name[Prescriber_Name$PPI != "",]
Prescriber_Name_UnMatched <- Prescriber_Name[Prescriber_Name$PPI == "",]

rm(match_MI)
rm(match_NMI)

dupsx <- sqldf('select dups.*, Prescriber_Name.Lname as "PLName", Prescriber_Name.FName as "PFName", Prescriber_Name.MI as "PMI",Prescriber_Name.MatchNMIZip as "PMZip"  from dups left outer join Prescriber_Name on dups.MNPI = Prescriber_Name.NPI ')

match_Dup <- sqldf('select dupsx.* from dupsx where dupsx.MatchNMIZip = dupsx.PMZip')
match_Dup$dup <- ""

match_Dup_OP <- sqldf('select match_Dup.PPI, count(match_Dup.PPI) as "CNT" from match_Dup group by match_Dup.PPI')
match_Dup_OP <- match_Dup_OP[match_Dup_OP$CNT >1,]
match_Dup <- sqldf('select match_Dup.*, match_Dup_OP.PPI as dupPPI from match_Dup left outer join match_Dup_OP on match_Dup.PPI = match_Dup_OP.PPI')

match_Dup[!is.na(match_Dup$dupPPI),"dup"] <- "DUP"
rm(match_Dup_OP)

match_Dup_P <- sqldf('select match_Dup.MNPI, count(match_Dup.MNPI) as "CNT" from match_Dup group by match_Dup.MNPI')
match_Dup_P <- match_Dup_P[match_Dup_P$CNT >1,]

match_Dup <- sqldf('select match_Dup.*, match_Dup_P.MNPI as dupMNPI from match_Dup left outer join match_Dup_P on match_Dup.MNPI = match_Dup_P.MNPI')

match_Dup[!is.na(match_Dup$dupMNPI),"dup"] <- "DUP"
rm(match_Dup_P)

unmatch_Dup <- sqldf('select dupsx.* from dupsx where dupsx.MatchNMIZip != dupsx.PMZip')
unmatch_Dup$dup <- ""

match_Dup$dupMNPI <- NULL
match_Dup$dupPPI <- NULL

match_Dup_rej <- match_Dup[match_Dup$dup !="",]
match_Dup_acc <- match_Dup[match_Dup$dup =="",]

unmatch_Dup <- merge(unmatch_Dup,match_Dup_rej, all = TRUE )
match_Dup <- match_Dup_acc
rm(match_Dup_acc)
rm(match_Dup_rej)
rm(dups)
rm(dupsx)
rm(nomatch_MI)
rm(nomatch_NMI)
rm(OP_Matched)

OP_Name <- sqldf('select OP_Name.*, match_Dup.MNPI as "dMNPI" from OP_Name left outer join match_Dup on OP_Name.PPI = match_Dup.PPI')
OP_Name[!is.na(OP_Name$dMNPI),"NPI"] <- OP_Name[!is.na(OP_Name$dMNPI),"dMNPI"]
OP_Name[!is.na(OP_Name$dMNPI),"MType"] <- "MDup"
OP_Name$dMNPI <- NULL


Prescriber_Name <- sqldf('select Prescriber_Name.*, match_Dup.PPI as "dPPI" from Prescriber_Name left outer join match_Dup on Prescriber_Name.NPI = match_Dup.MNPI')
Prescriber_Name[!is.na(Prescriber_Name$dPPI),"PPI"] <- Prescriber_Name[!is.na(Prescriber_Name$dPPI),"dPPI"]
Prescriber_Name[!is.na(Prescriber_Name$dPPI),"MType"] <- "MDup"
Prescriber_Name$dPPI <- NULL

# redo final tallys (after processing dups)

OP_Name_Matched <- OP_Name[OP_Name$NPI != "",]
OP_Name_UnMatched  <-OP_Name[OP_Name$NPI == "",]

Prescriber_Name_Matched <- Prescriber_Name[Prescriber_Name$PPI != "",]
Prescriber_Name_UnMatched <- Prescriber_Name[Prescriber_Name$PPI == "",]

#OP_Name <- sqldf('select OP_Name.*, match_Dup.MNPI from OP_Name left outer join match_Dup on OP_Name')

write.csv(unmatch_Dup,"~/Dropbox/Pharma_Influence/data/unmatch_dups.csv",row.names = FALSE)
write.csv(OP_Name_Matched, "~/Dropbox/Pharma_Influence/data/OP_Name_Matched.csv",row.names = FALSE)
write.csv(OP_Name_UnMatched, "~/Dropbox/Pharma_Influence/data/OP_Name_UnMatched.csv",row.names = FALSE) #See Julie Lemoine as an example.  

write.csv(Prescriber_Name_Matched, "~/Dropbox/Pharma_Influence/data/Prescriber_Name_Matched.csv",row.names = FALSE)  #Unmatched because they had no open payments???

write.csv(Prescriber_Name_UnMatched, "~/Dropbox/Pharma_Influence/data/Prescriber_Name_UnMatched.csv",row.names = FALSE)  #People who are unmatched in the prescriber_name_unmatched.csv file means they prescribed money but did not have any conflicts of interest in Open Payments?  

#Value is the amount of money that matched to data or did not match?
value <- sqldf('select OP.Physician_Profile_ID, sum(OP.Total_Amount_of_Payment_USDollars) as Total from OP group by OP.Physician_Profile_ID')


write.csv(value, "~/Dropbox/Pharma_Influence/data/value.csv")

