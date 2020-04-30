OP_Name <- OP_Name[OP_Name$NPI =="",]

Prescriber_13 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_13/PartD_Prescriber_PUF_NPI_13.txt", stringsAsFactors=FALSE)
#Prescriber_13 <- Prescriber_13[Prescriber_13$specialty_description == "Obstetrics/Gynecology",]

Prescriber_14 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_14/PartD_Prescriber_PUF_NPI_14.txt", stringsAsFactors=FALSE)
#Prescriber_14 <- Prescriber_14[Prescriber_14$specialty_description == "Obstetrics/Gynecology",]

Prescriber_15 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_15/PartD_Prescriber_PUF_NPI_15.txt", stringsAsFactors=FALSE)
#Prescriber_15 <- Prescriber_15[Prescriber_15$specialty_description == "Obstetrics/Gynecology",]

Prescriber_16 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_16/PartD_Prescriber_PUF_NPI_16.txt", stringsAsFactors=FALSE)
#Prescriber_16 <- Prescriber_16[Prescriber_16$specialty_description == "Obstetrics/Gynecology",]

Prescriber_17 <- read.delim("D:/muffly/data/Originals/PartD_Prescriber_PUF_NPI_17/PartD_Prescriber_PUF_NPI_17.txt", stringsAsFactors=FALSE)
#Prescriber_17 <- Prescriber_17[Prescriber_17$specialty_description == "Obstetrics & Gynecology",]

Prescriber <- merge(Prescriber_13, Prescriber_14,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_15,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_16,all = TRUE)
Prescriber <- merge(Prescriber, Prescriber_17,all = TRUE)

rm(Prescriber_13)
rm(Prescriber_14)
rm(Prescriber_15)
rm(Prescriber_16)
rm(Prescriber_17)

Prescriber_Name <- sqldf('select Prescriber.npi, Prescriber.nppes_provider_last_org_name, Prescriber.nppes_provider_first_name, Prescriber.nppes_provider_mi, nppes_provider_street1, nppes_provider_city,nppes_provider_state, nppes_provider_zip5, Prescriber.specialty_description from Prescriber group by Prescriber.npi ')

Prescriber_Name$Physician_Profile_ID <- ""
Prescriber_Name$MType <- ""

names(Prescriber_Name) <- c("NPI", "LName", "FName", "MI", "Address", "City", "State", "Zip","Specialty", "PPI", "MType")

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

#write.csv(unmatch_Dup,"unmatch_dups_unfil.csv",row.names = FALSE)
#write.csv(OP_Name_Matched, "OP_Name_Matched_unfil.csv",row.names = FALSE)
#write.csv(OP_Name_UnMatched, "OP_Name_UnMatched_unfil.csv",row.names = FALSE)

#write.csv(Prescriber_Name_Matched, "Prescriber_Name_Matched_unfil.csv",row.names = FALSE)
#write.csv(Prescriber_Name_UnMatched, "Prescriber_Name_UnMatched_unfil.csv",row.names = FALSE)
