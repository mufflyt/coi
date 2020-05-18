#
# set working directory, load libraries

# load qdapRegex
# add in these .. Tax codes ... 17400000X, 390200000X, 208D0000X


setwd("C:/Users/jguido/Dropbox (Personal)/Docs for Dollars/Guido")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("RSQLite", lib.loc="~/R/win-library/3.2")
#
# load GOB and Doximity Data Files
#
GOB <- read.csv("~/Dropbox (Personal)/Upwork/guido/DataFiles/GOBA_unique.csv", stringsAsFactors=FALSE)
GOB_temp<- GOB
GOB<-GOB[GOB$dup_used!="N",]
NPPES_OBGYN_DEMO <- read.csv("DataFiles/NPPES_OBGYN_DEMO.csv", stringsAsFactors=FALSE)
NPPES_OBGYN_DEMO <- NPPES_OBGYN_DEMO[!is.na(NPPES_OBGYN_DEMO$NPI),]
NOD<- NPPES_OBGYN_DEMO
# 
# Normalize capitalization and create smaller subset files for matching process
#
GOB_Match <- subset(GOB,select = c("ID","Full.Name", "First.Name.1", "First.Name.2","First.Name.3", "First.Name.4", "First.Name.5", "Last.Name.1", "Last.Name.2", "Last.Name.3","Full.Name.Suffix",   "City", "State","Provider.Last.Name..Legal.Name.","Provider.First.Name","Provider.Middle.Name","Provider.Name.Suffix.Text","Provider.Other.Last.Name","Provider.Other.First.Name","Provider.Other.Middle.Name","Provider.Other.Name.Suffix.Text"))
GOB_Match$NPI <- ""
GOB_Match$Type <- ""
GOB_Match$Full.Name <- toupper(GOB_Match$Full.Name)
GOB_Match$Last.Name.1 <- toupper(GOB_Match$Last.Name.1)
GOB_Match$Last.Name.2 <- toupper(GOB_Match$Last.Name.2)
GOB_Match$Last.Name.3 <- toupper(GOB_Match$Last.Name.3)
GOB_Match$First.Name.1 <- toupper(GOB_Match$First.Name.1)
GOB_Match$First.Name.2 <- toupper(GOB_Match$First.Name.2)
GOB_Match$First.Name.3 <- toupper(GOB_Match$First.Name.3)
GOB_Match$First.Name.4 <- toupper(GOB_Match$First.Name.4)
GOB_Match$First.Name.5 <- toupper(GOB_Match$First.Name.5)
GOB_Match$Full.Name.Suffix <- toupper(GOB_Match$Full.Name.Suffix)

GOB_Match$Provider.Last.Name..Legal.Name. <- toupper(GOB_Match$Provider.Last.Name..Legal.Name.)
GOB_Match$Provider.First.Name <- toupper(GOB_Match$Provider.First.Name)
GOB_Match$Provider.Middle.Name <- toupper(GOB_Match$Provider.Middle.Name)
GOB_Match$Provider.Name.Suffix.Text <- toupper(GOB_Match$Provider.Name.Suffix.Text)
GOB_Match$Provider.Other.Last.Name <- toupper(GOB_Match$Provider.Other.Last.Name)
GOB_Match$Provider.Other.First.Name <- toupper(GOB_Match$Provider.Other.First.Name)
GOB_Match$Provider.Other.Middle.Name <- toupper(GOB_Match$Provider.Other.Middle.Name)
GOB_Match$Provider.Other.Name.Suffix.Text <- toupper(GOB_Match$Provider.Other.Name.Suffix.Text)

GOB_Match$Full.Name.1 <- paste(GOB_Match$First.Name.1, GOB_Match$First.Name.2, GOB_Match$Provider.Last.Name..Legal.Name., sep=" ")
GOB_Match$Full.Name.2 <- paste(GOB_Match$First.Name.1, GOB_Match$First.Name.2, GOB_Match$Provider.Last.Name..Legal.Name., GOB_Match$Provider.Name.Suffix.Text,sep=" ")
GOB_Match$Full.Name.3 <- paste(GOB_Match$First.Name.1, substr(GOB_Match$First.Name.2,1,1), GOB_Match$Provider.Last.Name..Legal.Name., sep=" ")
GOB_Match$Full.Name.4 <- paste(GOB_Match$First.Name.1, substr(GOB_Match$First.Name.2,1,1), GOB_Match$Provider.Last.Name..Legal.Name., GOB_Match$Full.Name.Suffix,sep=" ")

#GOB_Match$Full.Name.1 <- paste(GOB_Match$First.Name.1, GOB_Match$Provider.Last.Name..Legal.Name., sep=" ")
#GOB_Match$Full.Name.2 <- paste(GOB_Match$First.Name.1, GOB_Match$Provider.Last.Name..Legal.Name., GOB_Match$Provider.Name.Suffix.Text,sep=" ")
#GOB_Match$Full.Name.3 <- paste(GOB_Match$First.Name.1, GOB_Match$Last.Name.1, sep=" ")
#GOB_Match$Full.Name.4 <- paste(GOB_Match$First.Name.1, GOB_Match$Last.Name.1, GOB_Match$Full.Name.Suffix,sep=" ")

GOB_Match$Full.Name.1 <- gsub("\\.","",GOB_Match$Full.Name.1)
GOB_Match$Full.Name.1 <- gsub("-","",GOB_Match$Full.Name.1)

GOB_Match$Full.Name.2 <- gsub("\\.","",GOB_Match$Full.Name.2)
GOB_Match$Full.Name.2 <- gsub("-","",GOB_Match$Full.Name.2)

GOB_Match$Full.Name.3 <- gsub("\\.","",GOB_Match$Full.Name.3)
GOB_Match$Full.Name.3 <- gsub("-","",GOB_Match$Full.Name.3)

GOB_Match$Full.Name.4 <- gsub("\\.","",GOB_Match$Full.Name.4)
GOB_Match$Full.Name.4 <- gsub("-","",GOB_Match$Full.Name.4)

GOB_Match$Full.Name <- gsub("\\.","",GOB_Match$Full.Name)
GOB_Match$Full.Name <- gsub("-","",GOB_Match$Full.Name)
#
GOB_Match$Full.Name <- rm_white(GOB_Match$Full.Name)
GOB_Match$Full.Name.1 <- rm_white(GOB_Match$Full.Name.1)
GOB_Match$Full.Name.2 <- rm_white(GOB_Match$Full.Name.2)
GOB_Match$Full.Name.3 <- rm_white(GOB_Match$Full.Name.3)
GOB_Match$Full.Name.4 <- rm_white(GOB_Match$Full.Name.4)

GOB<- GOB_temp
#
colnames(NOD)[22]<- "First_Name"
colnames(NOD)[30] <- "First_Name_2"
colnames(NOD)[21] <- "Last_Name"
colnames(NOD)[29] <- "Last_Name_2"
colnames(NOD)[23] <- "Middle_Name"
colnames(NOD)[31] <- "Middle_Name_2"
colnames(NOD)[25] <- "Suffix"
colnames(NOD)[33] <- "Suffix_2"
colnames(NOD)[39] <- "State"
#
NOD_Match <- subset(NOD,select = c("NPI","First_Name", "First_Name_2", "Last_Name", "Last_Name_2", "Middle_Name", "Middle_Name_2","Suffix", "Suffix_2" , "State"))
NOD_Match$GOB_ID <- ""
NOD_Match$Type <- ""
NOD_Match$Last_Name <- toupper(NOD_Match$Last_Name)
NOD_Match$Last_Name_2 <- toupper(NOD_Match$Last_Name_2)
NOD_Match$First_Name  <- toupper(NOD_Match$First_Name)
NOD_Match$First_Name_2  <- toupper(NOD_Match$First_Name_2)
NOD_Match$Middle_Name  <- toupper(NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2  <- toupper(NOD_Match$Middle_Name_2)
NOD_Match$Suffix  <- toupper(NOD_Match$Suffix)
NOD_Match$Suffix_2  <- toupper(NOD_Match$Suffix_2)
#
# create full name field based on first, middle, last and suffix
# two versions based on middle and alternate middle, then two versions - with and without suffix
# total of four full names
# full.name,1 = first, middle, last
# full.name.2 = first, middle, last, suffix
# full.name.3 = first, middle2, last
# full.name.4 = first, middle2, last, suffix
#
NOD_Match$Full.Name.1 <- paste(NOD_Match$First_Name, NOD_Match$Middle_Name, NOD_Match$Last_Name, sep=" ")
NOD_Match$Full.Name.2 <- paste(NOD_Match$First_Name, NOD_Match$Middle_Name, NOD_Match$Last_Name, NOD_Match$Suffix,sep=" ")
NOD_Match$Full.Name.3 <- paste(NOD_Match$First_Name, substr(NOD_Match$Middle_Name,1,1), NOD_Match$Last_Name, sep=" ")
NOD_Match$Full.Name.4 <- paste(NOD_Match$First_Name, substr(NOD_Match$Middle_Name,1,1), NOD_Match$Last_Name,NOD_Match$Suffix, sep=" ")

#NOD_Match$Full.Name.1 <- paste(NOD_Match$First_Name, NOD_Match$Middle_Name_2, NOD_Match$Last_Name, sep=" ")
#NOD_Match$Full.Name.2 <- paste(NOD_Match$First_Name, NOD_Match$Middle_Name_2, NOD_Match$Last_Name, NOD_Match$Suffix,sep=" ")
#NOD_Match$Full.Name.3 <- paste(NOD_Match$First_Name, substr(NOD_Match$Middle_Name_2,1,1), NOD_Match$Last_Name, sep=" ")
#NOD_Match$Full.Name.4 <- paste(NOD_Match$First_Name, substr(NOD_Match$Middle_Name_2,1,1), NOD_Match$Last_Name,NOD_Match$Suffix, sep=" ")

#
# replace '."
#
NOD_Match$Full.Name.1 <- gsub("\\.","",NOD_Match$Full.Name.1)
NOD_Match$Full.Name.2 <- gsub("\\.","",NOD_Match$Full.Name.2)
NOD_Match$Full.Name.3 <- gsub("\\.","",NOD_Match$Full.Name.3)
NOD_Match$Full.Name.4 <- gsub("\\.","",NOD_Match$Full.Name.4)
#
# replace "-"
#
NOD_Match$Full.Name.1 <- gsub("-","",NOD_Match$Full.Name.1)
NOD_Match$Full.Name.2 <- gsub("-","",NOD_Match$Full.Name.2)
NOD_Match$Full.Name.3 <- gsub("-","",NOD_Match$Full.Name.3)
NOD_Match$Full.Name.4 <- gsub("-","",NOD_Match$Full.Name.4)


NOD_Match$Full.Name.1 <- rm_white(NOD_Match$Full.Name.1)
NOD_Match$Full.Name.2 <-  rm_white(NOD_Match$Full.Name.2)
NOD_Match$Full.Name.3 <-  rm_white(NOD_Match$Full.Name.3)
NOD_Match$Full.Name.4 <-  rm_white(NOD_Match$Full.Name.4)

#
# add a field that flags physicians with OBGYN specialty and with blank specialty
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN1"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
##dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN1<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN1 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname2 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.2] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN2"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
##dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN2<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN2 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL

#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.3] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN3"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN3<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN3 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname4 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.4] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN4"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN4<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN4 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN1"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN1<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN1 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname2 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.2] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN2"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN2<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN2 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.3] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN3"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN3<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN3 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname4 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.4] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN4"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN4<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN4 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL













#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname3 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.3] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN3__O_FN1"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN3__O_FN1<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN3__O_FN1 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname3 / fullname2 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.3] = NOD_Match.[Full.Name.2] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN3__O_FN2"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN3__O_FN2<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN3__O_FN2 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname3 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.3] = NOD_Match.[Full.Name.3] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN3__O_FN3"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN3__O_FN3<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN3__O_FN3 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname3 / fullname4 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.3] = NOD_Match.[Full.Name.4] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN3__O_FN4"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN3__O_FN4<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN3__O_FN4 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL








#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname4 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.4] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN4__O_FN1"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN4__O_FN1<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN4__O_FN1 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname4 / fullname2 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.4] = NOD_Match.[Full.Name.2] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN4__O_FN2"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN4__O_FN2<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN4__O_FN2 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname4 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.4] = NOD_Match.[Full.Name.3] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN4__O_FN3"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN4__O_FN3<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN4__O_FN3 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname4 / fullname4 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.4] = NOD_Match.[Full.Name.4] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN4__O_FN4"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN4__O_FN4<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN4__O_FN4 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN1"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN1<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN1 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname2 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name] = NOD_Match.[Full.Name.2] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN2"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN2<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN2 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN3"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN3<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN3 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname4 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.1] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN4"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN4<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN4 <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
# -------------------------------------------------------------------------------------------------------
# + State  ------------------------------------------------------------------------------------------------
#
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname1 + state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.1] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN1S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN1S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN1S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname2 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.2] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN2S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN2S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN2S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname3 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.3] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN3S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN3S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN3S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname4 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.4] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN1__O_FN4S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN1__O_FN4S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN1__O_FN4S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname1 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.1] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FNS"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN1S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN1 <- matches
matches$dup_nameS <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname2 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.2] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN2S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN2S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN2S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname3 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.3] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN3S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN3S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN3S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname4 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.2] = NOD_Match.[Full.Name.4] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN2__O_FN4S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN2__O_FN4S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN2__O_FN4S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname1 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name] = NOD_Match.[Full.Name.1] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN1S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN1S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN1S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname2 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name] = NOD_Match.[Full.Name.2] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN2S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN2S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN2S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname3 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.1] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN3S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN3S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN3S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname4 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Full.Name.1] = NOD_Match.[Full.Name.1] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "G_FN__O_FN4S"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_G_FN__O_FN4S<- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_G_FN__O_FN4S <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#
#----------------------------------------------------------------------------------------------------------
#
# match on first, last and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.1] = NOD_Match.[Last_Name] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, LName, State"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameLnameState <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameLnameState <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA_last1, OP Alt Last  and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.1] = NOD_Match.[Last_Name_2] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, GOBA_LName, OP_ALTLNAME,State"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameGOBLnameOPAltLnameState <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameGOBLnameOPAltLnameState <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#     
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA_last2, OP Last1  and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.2] = NOD_Match.[Last_Name] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, GOBA_LName_2, OP_LNAME,State"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameGOBLname2OPLnameState <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameGOBLname2OPLnameState <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA_last2, OP ALTLast  and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.2] != "" and NOD_Match.[Last_Name_2] != "" and GOB_Match.[Last.Name.2] = NOD_Match.[Last_Name_2] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),2])
names(dup_OP) = c("Full.Name")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)

#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
#annotate and store
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, GOBA_LName_2, OP_LNAME,State"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameGOBLname2OPAltLnameState <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameGOBLname2OPAltLnameState <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, last, middle
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.1] = NOD_Match.[Last_Name] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and GOB_Match.[First.Name.2] = NOD_Match.[Middle_Name] and NOD_Match.[Middle_Name] != ""  and GOB_Match.[First.Name.2] != "" and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, LName, MiddleName"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameLnameMname <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameLnameMname <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, last, GOBA middle OP Alt Middle
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.1] = NOD_Match.[Last_Name] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and GOB_Match.[First.Name.2] = NOD_Match.[Middle_Name_2] and NOD_Match.[Middle_Name_2] != ""  and GOB_Match.[First.Name.2] != "" and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, LName, GOB MiddleName OP AltMiddleName"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameLnameGOBAMnameOPAltMname <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameLnameGOBAMnameOPAltMname <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#---------------------------------------------------------------------------------------------------------------------------------
#
# match on first, last 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.1] = NOD_Match.[Last_Name] and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, LName"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameLname <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameLname <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA last OP Alt LAST
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.1] = NOD_Match.[Last_Name_2] and NOD_Match.[Last_Name_2] !=""  and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, GOB LName OP AltLName"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_fnameGOBlnameOPAltLname <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_fnameGOBlnameOPAltLnam <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#---------------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA last2 OP LAST
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.2] = NOD_Match.[Last_Name] and GOB_Match.[Last.Name.2]!=""  and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, GOB LName2 OP LName"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_FnameGOBLname2OPLname <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_FnameGOBLname2OPLname <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA last2 OP ALTLAST
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.[Last.Name.2] = NOD_Match.[Last_Name_2] and GOB_Match.[Last.Name.2]!="" and NOD_Match.[Last_Name_2] != ""  and GOB_Match.[First.Name.1] = NOD_Match.[First_Name] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
dup_names <- merge(dup_names, dup_OP  , all=TRUE)
rm(dup_OP)
dup_names <- data.frame(dup_names[!duplicated(dup_names),])
names(dup_names) = c("Full.Name")
#mark dups
matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
rm(dup_names)
#annotate and store
#
# new - end
#
matches$Type <- "FName, GOB LName2 OP ALT LName"
#
# new - start
#
dup_set <- subset(matches, !is.na(matches$dup_name))
dups <- sqldf("select GOB_Match.*, dup_set.[NPI]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
#dups <- sqldf("select dups.*, NOD_Match.* from dups inner join NOD_Match on dups.[NPI] = NOD_Match.[NPI]")
# set next  <- dups
# rm(dups)
## new - end
#
dups_fnameGOBlname2OPALTLname <- dups
rm(dups)
matches <- subset(matches, is.na(matches$dup_name))
match_fnameGOBlname2OPALTLname <- matches
matches$dup_name <- NULL
#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_NPI <- NULL
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
NOD_Match$m_Type <- NULL





































































































































































































































#
#---------------------------------------------------------------------------------------------------------------------------------
# compile and write final outputs
GOBA_Match_NPPES <- subset(GOB_Match,select = c("ID","NPI", "Type"))
GOBA_Match_NPPES_Matched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI!= "",]
GOBA_Match_NPPES_UnMatched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI == "",]
#
# merge matches back into GOBA and OP
#
GOB <- sqldf("select GOBA_Match_NPPES_Matched.[NPI] as 'NPI_rnd2' ,GOBA_Match_NPPES_Matched.[Type] as 'RND2_NPI_Match_Type', GOB.* from GOB LEFT OUTER JOIN GOBA_Match_NPPES_Matched on GOB.[ID] = GOBA_Match_NPPES_Matched.[ID]")

#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
#
# write output, cleanup workspace
#
write.csv(GOBA_Match_NPPES_Matched, "~/Dropbox (Personal)/Upwork/guido/DataFiles/GOBA_Match_NPPES_Matched_RND2.csv", row.names = FALSE,na="")
write.csv(GOBA_Match_NPPES_UnMatched, "~/Dropbox (Personal)/Upwork/guido/DataFiles/GOBA_Match_NPPES_UnMatched_RND2.csv", row.names = FALSE, na="")
write.csv(GOB, "~/Dropbox (Personal)/Upwork/guido/DataFiles/GOBA_unique.csv", row.names = FALSE, na="")
write.csv(GOB_Match, "~/Dropbox (Personal)/Upwork/guido/DataFiles/GOB_Match.csv", row.names = FALSE, na="")
write.csv(NOD_Match, "~/Dropbox (Personal)/Upwork/guido/DataFiles/NOD_Match.csv", row.names = FALSE, na="")
rm(list=ls()) 
