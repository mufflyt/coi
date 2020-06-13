#
# set working directory, load libraries
#
setwd("C:/Users/jguido/Dropbox")
install.packages("sqldf")
install.packages("qdapRegex")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("qdapRegex", lib.loc="~/R/win-library/3.2")
#
# load GOB and Doximity Data Files
#
OP <- read.csv("~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01172020.csv", stringsAsFactors=FALSE)
GOBA <- read.csv("~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv", stringsAsFactors=FALSE)#
GOBA$ID <- GOBA$userid
GOB_Match <- GOBA  

# Normalize capitalization and create smaller subset files for matching process
GOB_Match$OP_Physician_Profile_ID <- ""
GOB_Match$Type <- ""
GOB_Match$NPI.Code<- ""
GOB_Match$Full.Name <- toupper(GOB_Match$NamePart)
GOB_Match$Last.Name.1 <- toupper(GOB_Match$Last)
GOB_Match$Last.Name.2 <- toupper(GOB_Match$Last_Left)
GOB_Match$Last.Name.3 <- toupper(GOB_Match$Last_Right)
GOB_Match$First.Name.1 <- toupper(GOB_Match$First)
GOB_Match$First.Name.2 <- NA
GOB_Match$First.Name.3 <- NA
GOB_Match$First.Name.4 <- NA
GOB_Match$First.Name.5 <- NA
GOB_Match$Full.Name.Suffix <- NA
#
GOB_Match[is.na(GOB_Match$Middle),"Middle"]=""

GOB_Match$Full.Name.1 <- toupper(paste(GOB_Match$First, GOB_Match$Middle,GOB_Match$Last, sep=" "))
GOB_Match$Full.Name.2 <- toupper(paste(GOB_Match$First, GOB_Match$Middle,GOB_Match$Last_Left, sep=" "))
GOB_Match$Full.Name.3 <- toupper(paste(GOB_Match$First, substr(GOB_Match$Middle,1,1), GOB_Match$Last,sep=" "))
GOB_Match$Full.Name.4 <- toupper(paste(GOB_Match$First, substr(GOB_Match$Middle,1,1), GOB_Match$Last_Left,sep=" "))

#
OP_Match <- subset(OP,select = c("Physician_Profile_ID","Physician_Profile_First_Name", "Physician_Profile_Alternate_First_Name", "Physician_Profile_Last_Name", "Physician_Profile_Alternate_Last_Name", "Physician_Profile_Middle_Name", "Physician_Profile_Alternate_Middle_Name","Physician_Profile_Suffix", "Physician_Profile_Alternate_Suffix" , "Physician_Profile_City", "Physician_Profile_State","Physician_Profile_Primary_Specialty" ,"Physician_Profile_OPS_Taxonomy_1", "Physician_Profile_OPS_Taxonomy_2", "Physician_Profile_OPS_Taxonomy_3","Physician_Profile_OPS_Taxonomy_4","Physician_Profile_OPS_Taxonomy_5"))
OP_Match$GOB_ID <- ""
OP_Match$Type <- ""
OP_Match$Physician_Profile_Last_Name <- toupper(OP_Match$Physician_Profile_Last_Name)
OP_Match$Physician_Profile_Alternate_Last_Name <- toupper(OP_Match$Physician_Profile_Alternate_Last_Name)
OP_Match$Physician_Profile_First_Name  <- toupper(OP_Match$Physician_Profile_First_Name)
OP_Match$Physician_Profile_Alternate_First_Name  <- toupper(OP_Match$Physician_Profile_Alternate_First_Name)
OP_Match$Physician_Profile_Middle_Name  <- toupper(OP_Match$Physician_Profile_Middle_Name)
OP_Match$Physician_Profile_Alternate_Middle_Name  <- toupper(OP_Match$Physician_Profile_Alternate_Middle_Name)
OP_Match$Physician_Profile_Suffix  <- toupper(OP_Match$Physician_Profile_Suffix)
OP_Match$Physician_Profile_Alternate_Suffix  <- toupper(OP_Match$Physician_Profile_Alternate_Suffix)
#
# create full name field based on first, middle, last and suffix
# two versions based on middle and alternate middle, then two versions - with and without suffix
# total of four full names
# full.name,1 = first, middle, last
# full.name.3 = first, middle2, last
#
OP_Match$Full.Name.1 <- paste(OP_Match$Physician_Profile_First_Name, OP_Match$Physician_Profile_Middle_Name, OP_Match$Physician_Profile_Last_Name, sep=" ")
OP_Match$Full.Name.3 <- paste(OP_Match$Physician_Profile_First_Name, substr(OP_Match$Physician_Profile_Middle_Name,1,1), OP_Match$Physician_Profile_Last_Name, sep=" ")

#
# replace '."
#
OP_Match$Full.Name.1 <- gsub("\\.","",OP_Match$Full.Name.1)
OP_Match$Full.Name.3 <- gsub("\\.","",OP_Match$Full.Name.3)
#
# replace "-"
#
OP_Match$Full.Name.1 <- gsub("-"," ",OP_Match$Full.Name.1)
OP_Match$Full.Name.3 <- gsub("-"," ",OP_Match$Full.Name.3)
#
#
#
OP_Match$Full.Name.1   <- rm_white(OP_Match$Full.Name.1)
OP_Match$Full.Name.3   <- rm_white(OP_Match$Full.Name.3)
#
# add a field that flags physicians with OBGYN specialty and with blank specialty
#
OP_Match$ISOBGYN[grepl("Gyn",OP_Match$Physician_Profile_Primary_Specialty)]<- "OBGYN"
OP_Match$ISOBGYN[OP_Match$Physician_Profile_Primary_Specialty==""]<- "BLANK"
OP_Match_All <- OP_Match
#
# subset on OBGYNs only 
# Rev 01/07/17
# add in these .. Tax codes ... 174000000X, 390200000X, 208D00000X
#
OP_Match <- sqldf("select OP_Match.* from OP_Match where OP_Match.[ISOBGYN]='OBGYN' or OP_Match.[Physician_Profile_OPS_Taxonomy_1] like '207V%' or OP_Match.[Physician_Profile_OPS_Taxonomy_2] like '207V%' or OP_Match.[Physician_Profile_OPS_Taxonomy_3] like '207V%' or OP_Match.[Physician_Profile_OPS_Taxonomy_4] like '207V%' or OP_Match.[Physician_Profile_OPS_Taxonomy_5] like '207V%' or OP_Match.[Physician_Profile_OPS_Taxonomy_1] like '174000000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_2] like '174000000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_3] like '174000000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_4] like '174000000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_5] like '174000000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_1] like '390200000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_2] like '390200000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_3] like '390200000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_4] like '390200000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_5] like '390200000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_1] like '208D00000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_2] like '208D00000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_3] like '208D00000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_4] like '208D00000X' or OP_Match.[Physician_Profile_OPS_Taxonomy_5] like '208D00000X'  ")
#
#
################################# S T A R T M A T C H I N G
#
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.1] = OP_Match.[Full.Name.1] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.1] = OP_Match.[Full.Name.3] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.2] = OP_Match.[Full.Name.1] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.2] = OP_Match.[Full.Name.3] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname3 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.3] = OP_Match.[Full.Name.1] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname3 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.3] = OP_Match.[Full.Name.3] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname4 / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.4] = OP_Match.[Full.Name.1] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname4 / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.4] = OP_Match.[Full.Name.3] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname1 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name] = OP_Match.[Full.Name.1] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname3 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.1] = OP_Match.[Full.Name.1] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname1 + state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.1] = OP_Match.[Full.Name.1] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname1 / fullname3 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.1] = OP_Match.[Full.Name.3] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname1 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.2] = OP_Match.[Full.Name.1] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname2 / fullname3 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.2] = OP_Match.[Full.Name.3] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname1 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name] = OP_Match.[Full.Name.1] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on fullname / fullname3 State
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Full.Name.1] = OP_Match.[Full.Name.1] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#
#----------------------------------------------------------------------------------------------------------
#
# match on first, last and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.1] = OP_Match.[Physician_Profile_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA_last1, OP Alt Last  and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.1] = OP_Match.[Physician_Profile_Alternate_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#     
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA_last2, OP Last1  and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.2] = OP_Match.[Physician_Profile_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA_last2, OP ALTLast  and state
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.2] != "" and OP_Match.[Physician_Profile_Alternate_Last_Name] != "" and GOB_Match.[Last.Name.2] = OP_Match.[Physician_Profile_Alternate_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and GOB_Match.[State] = OP_Match.[Physician_Profile_State] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),2])
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
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, last, middle
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.1] = OP_Match.[Physician_Profile_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and GOB_Match.[First.Name.2] = OP_Match.[Physician_Profile_Middle_Name] and OP_Match.[Physician_Profile_Middle_Name] != ""  and GOB_Match.[First.Name.2] != "" and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, last, GOBA middle OP Alt Middle
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.1] = OP_Match.[Physician_Profile_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and GOB_Match.[First.Name.2] = OP_Match.[Physician_Profile_Alternate_Middle_Name] and OP_Match.[Physician_Profile_Alternate_Middle_Name] != ""  and GOB_Match.[First.Name.2] != "" and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#---------------------------------------------------------------------------------------------------------------------------------
#
# match on first, last 
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.1] = OP_Match.[Physician_Profile_Last_Name] and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA last OP Alt LAST
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.1] = OP_Match.[Physician_Profile_Alternate_Last_Name] and OP_Match.[Physician_Profile_Alternate_Last_Name] !=""  and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#---------------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA last2 OP LAST
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.2] = OP_Match.[Physician_Profile_Last_Name] and GOB_Match.[Last.Name.2]!=""  and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL
#
#------------------------------------------------------------------------------------------------------------------------
#
# match on first, GOBA last2 OP ALTLAST
#
matches <- sqldf('select GOB_Match.[ID] , GOB_Match.[Full.Name], OP_Match.[Physician_Profile_ID] from GOB_Match INNER JOIN OP_Match on GOB_Match.[Last.Name.2] = OP_Match.[Physician_Profile_Alternate_Last_Name] and GOB_Match.[Last.Name.2]!="" and OP_Match.[Physician_Profile_Alternate_Last_Name] != ""  and GOB_Match.[First.Name.1] = OP_Match.[Physician_Profile_First_Name] and OP_Match.[GOB_ID] = "" and GOB_Match.[OP_Physician_Profile_ID] = "" ' )
#                 
#find dups
#
# new- start
#
dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
names(dup_names) = c("Full.Name")
dup_OP    <- data.frame(matches[duplicated(matches$Physician_Profile_ID),3])
names(dup_OP) = c("PID")
dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[Physician_Profile_ID] = dup_OP.[PID]")
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
dups <- sqldf("select GOB_Match.*, dup_set.[Physician_Profile_ID]  from GOB_Match inner join dup_set on GOB_Match.[ID] = dup_set.[ID]")
rm(dup_set)
dups <- sqldf("select dups.*, OP_Match.* from dups inner join OP_Match on dups.[Physician_Profile_ID] = OP_Match.[Physician_Profile_ID]")
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
GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"OP_Physician_Profile_ID"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Physician_Profile_ID"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
GOB_Match$m_ID<- NULL
GOB_Match$m_Type <- NULL
GOB_Match$m_Physician_Profile_ID <- NULL
#
#update OP_Match
#
OP_Match <- sqldf('select OP_Match.*, matches.[ID] as m_ID, matches.[Physician_Profile_ID] as m_Physician_Profile_ID, matches.[Type] as m_Type from OP_Match LEFT OUTER JOIN matches on OP_Match.[Physician_Profile_ID] = matches.[Physician_Profile_ID]')
OP_Match[!is.na(OP_Match$m_ID),"GOB_ID"] <-  OP_Match[!is.na(OP_Match$m_ID),"m_ID"]
OP_Match[!is.na(OP_Match$m_Type),"Type"] <-  OP_Match[!is.na(OP_Match$m_Type),"m_Type"]
OP_Match$m_ID<- NULL
OP_Match$m_Physician_Profile_ID <- NULL
OP_Match$m_Type <- NULL


#---------------------------------------------------------------------------------------------------------------------------------

# compile and write final outputs
GOBA_Match_OP <- subset(GOB_Match,select = c("ID","OP_Physician_Profile_ID", "Type"))
GOBA_Match_OP_Matched <- GOBA_Match_OP[GOBA_Match_OP$OP_Physician_Profile_ID!= "",]
GOBA_Match_OP_UnMatched <- GOBA_Match_OP[GOBA_Match_OP$OP_Physician_Profile_ID == "",]
#
#
#
################################# E N D
#
#
#
# merge matches back into GOBA and OP
#
# switch gob back to full file
#

GOB <- sqldf('select GOBA_Match_OP_Matched.[OP_Physician_Profile_ID] as "OP_Physician_Profile_ID" ,GOBA_Match_OP_Matched.[Type] as "OP_Match_Type", GOB.* from GOB left outer join GOBA_Match_OP_Matched on GOB.[ID]                  = GOBA_Match_OP_Matched.[ID]  ')

#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
#
# write output, cleanup workspace
#
write.csv(GOBA_Match_OP_Matched, "~/Dropbox/Pharma_Influence/GOBA_Match_OP_Matched.csv", row.names = FALSE, na="")
write.csv(GOBA_Match_OP_UnMatched, "~/Dropbox/Pharma_Influence/GOBA_Match_OP_UnMatched.csv", row.names = FALSE, na="")
write.csv(GOB_Match, "~/Dropbox/Pharma_Influence/GOBA_Match_All.csv", row.names = FALSE, na="")

