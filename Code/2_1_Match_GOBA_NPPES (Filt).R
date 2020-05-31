#
# 5/23/20 - reworked matching to use function.  added fuzzy match files (removed duplicate names from each first)
# 5/23/20 2059 - added 174400000X to taxonomy filter
library("sqldf")
library("RSQLite")
library("qdapRegex")

#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
# load data
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#
# Prescriber Data File (PRE)
#

PRE_Match <- read.csv("~/Dropbox/Pharma_Influence/Data/Medicare_Part_D/PartD_Prescriber_PUF_NPI_DRUG_Combined.csv", stringsAsFactors=FALSE)
names(PRE_Match) <- c("NPI","First_Name", "Last_Name","State")
PRE_Match$GOB_ID <- ""
PRE_Match$Type <- ""

#
# GOBA Data File
#

GOBA <- read.csv("~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv", stringsAsFactors=FALSE, strip.white = TRUE)
GOBA$ID <- GOBA$userid
GOB_Match <- GOBA  

# Normalize capitalization and create smaller subset files for matching process
GOB_Match$OP_Physician_Profile_ID <- ""
GOB_Match$Type <- ""
GOB_Match$NPI<- ""

states <- c("AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY","DC")

GOB_Match <- GOB_Match[GOB_Match$state %in% states,]

GOB_Match$Full.Name.Suffix <- (GOB_Match$Suffix)
GOB_Match$state <- (toupper(GOB_Match$state))
GOB_Match$city <- (toupper(GOB_Match$city))

GOB_Match$NamePart <- gsub("'","",GOB_Match$NamePart)
GOB_Match$NamePart <- gsub("-","",GOB_Match$NamePart)
GOB_Match$NamePart <- gsub("\\."," ",GOB_Match$NamePart)
GOB_Match$NamePart <- rm_white(GOB_Match$NamePart)
GOB_Match$NamePart <- gsub("(NMN)","",GOB_Match$NamePart)
GOB_Match$NamePart <- gsub("(Nmn)","",GOB_Match$NamePart)
GOB_Match$NamePart <- gsub("\\(","",GOB_Match$NamePart)
GOB_Match$NamePart <- gsub(")","",GOB_Match$NamePart)
GOB_Match$NamePart <- toupper(GOB_Match$NamePart)

GOB_Match$Middle <- gsub("'","",GOB_Match$Middle)
GOB_Match$Middle <- gsub("-","",GOB_Match$Middle)
GOB_Match$Middle <- gsub("\\."," ",GOB_Match$Middle)
GOB_Match$Middle <- gsub(")","",GOB_Match$Middle)
GOB_Match$Middle <- gsub("\\(","",GOB_Match$Middle)
GOB_Match$Middle <- gsub(" ","",GOB_Match$Middle)
GOB_Match$Middle <- rm_white(GOB_Match$Middle)

GOB_Match$First <- gsub("-","",GOB_Match$First)
GOB_Match$First <- gsub("'","",GOB_Match$First)
GOB_Match$First <- gsub("\\.","",GOB_Match$First)

GOB_Match$Last <- gsub("'","",GOB_Match$Last)
GOB_Match$Last <- gsub(")","",GOB_Match$Last)
GOB_Match$Last <- gsub("\\(","",GOB_Match$Last)

GOB_Match$Last_Left <- gsub(")","",GOB_Match$Last_Left)
GOB_Match$Last_Left <- gsub("\\(","",GOB_Match$Last_Left)
GOB_Match$Last_Left <- gsub("'","",GOB_Match$Last_Left)

GOB_Match$Last_Right <- gsub("'","",GOB_Match$Last_Right)

GOB_Match$Middle <- gsub("NMN","",GOB_Match$Middle)

GOB_Match$Full.Name <- toupper(GOB_Match$NamePart)
GOB_Match$Last.Name.1 <- (GOB_Match$Last)
GOB_Match$Last.Name.2 <- (GOB_Match$Last_Left)
GOB_Match$Last.Name.3 <- (GOB_Match$Last_Right)
GOB_Match$First.Name.1 <-(GOB_Match$First)
GOB_Match$First.Name.2 <- NA
GOB_Match$First.Name.3 <- NA
GOB_Match$First.Name.4 <- NA
GOB_Match$First.Name.5 <- NA

GOB_Match[GOB_Match$Last.Name.3 == "","Last.Name.3"] <- GOB_Match[GOB_Match$Last.Name.3 == "","Last.Name.2"]

#
GOB_Match[is.na(GOB_Match$Middle),"Middle"]=""

GOB_Match$Full.Name.1 <- (paste(GOB_Match$First, GOB_Match$Middle,GOB_Match$Last, sep=" "))
GOB_Match$Full.Name.2 <- (paste(GOB_Match$First, GOB_Match$Middle,GOB_Match$Last, GOB_Match$Full.Name.Suffix, sep=" "))
GOB_Match$Full.Name.3 <- (paste(GOB_Match$First, substr(GOB_Match$Middle,1,1), GOB_Match$Last,sep=" "))
GOB_Match$Full.Name.4 <- (paste(GOB_Match$First, substr(GOB_Match$Middle,1,1), GOB_Match$Last, GOB_Match$Full.Name.Suffix, sep=" "))

GOB_Match$Full.Name.1 <- rm_white(GOB_Match$Full.Name.1)
GOB_Match$Full.Name.2 <- rm_white(GOB_Match$Full.Name.2)
GOB_Match$Full.Name.3 <- rm_white(GOB_Match$Full.Name.3)
GOB_Match$Full.Name.4 <- rm_white(GOB_Match$Full.Name.4)
#

#
rm(GOBA)
#
write.csv(GOB_Match,"~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_2.csv", row.names = FALSE, na="")

#
# NPPES Data File
#

NPPES <- read.csv("~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412.csv", stringsAsFactors=FALSE)
NOD <- NPPES[,c(1,48,52,56,60,64,68,72,76,80,84,88,92,96,100,104,7,15,6,14,8,16,10,18,24,23, 25,2)
             ]
rm(NPPES)
#
NOD$TAX <- NA
NOD$TAX <- paste(NOD$Healthcare.Provider.Taxonomy.Code_1,NOD$Healthcare.Provider.Taxonomy.Code_2,NOD$Healthcare.Provider.Taxonomy.Code_3,NOD$Healthcare.Provider.Taxonomy.Code_4, NOD$Healthcare.Provider.Taxonomy.Code_5, NOD$Healthcare.Provider.Taxonomy.Code_6, NOD$Healthcare.Provider.Taxonomy.Code_7, NOD$Healthcare.Provider.Taxonomy.Code_8, NOD$Healthcare.Provider.Taxonomy.Code_9, NOD$Healthcare.Provider.Taxonomy.Code_10, NOD$Healthcare.Provider.Taxonomy.Code_11, NOD$Healthcare.Provider.Taxonomy.Code_12, NOD$Healthcare.Provider.Taxonomy.Code_13, NOD$Healthcare.Provider.Taxonomy.Code_14, NOD$Healthcare.Provider.Taxonomy.Code_15)
#
colnames(NOD)[17]<- "First_Name"
colnames(NOD)[18] <- "First_Name_2"
colnames(NOD)[19] <- "Last_Name"
colnames(NOD)[20] <- "Last_Name_2"
colnames(NOD)[21] <- "Middle_Name"
colnames(NOD)[22] <- "Middle_Name_2"
colnames(NOD)[23] <- "Suffix"
colnames(NOD)[24] <- "Suffix_2"
colnames(NOD)[25] <- "State"
colnames(NOD)[26] <- "City"
colnames(NOD)[27] <- "Zipcode"
colnames(NOD)[28] <- "TypeCode"
#
# remove type 2
#
NOD<- NOD[,c(1,17,18,19,20,21,22,23,24,25,26,27,28,29)]
#
NOD <- NOD[NOD$TypeCode !=2,]
#
NOD <- NOD[!is.na(NOD$TypeCode),]
#
# Normalize capitalization and create smaller subset files for matching process
#
NOD_Match <- NOD

NOD_Match <- NOD_Match[NOD_Match$State %in% states,]

NOD_Match$All_Name <- paste(NOD_Match$First_Name,NOD_Match$First_Name_2, NOD_Match$Middle_Name, NOD_Match$Middle_Name_2, NOD_Match$Last_Name, NOD_Match$Last_Name_2, NOD_Match$Suffix, NOD_Match$Suffix_2, sep = " | ")

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
# clean up names some more
NOD_Match[grepl(" JR",NOD_Match$Last_Name),"Suffix"] <- "JR"
NOD_Match[grepl(" JR.",NOD_Match$Last_Name),"Suffix"] <- "JR"
NOD_Match[grepl(", JR",NOD_Match$Last_Name),"Suffix"] <- "JR"
NOD_Match[grepl(", JR.",NOD_Match$Last_Name),"Suffix"] <- "JR"

NOD_Match$Last_Name <- gsub(", JR.","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub(", JR","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub(" JR.","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub(" JR","",NOD_Match$Last_Name)

NOD_Match[grepl(" III",NOD_Match$Last_Name),"Suffix"] <- "III"
NOD_Match[grepl(", III",NOD_Match$Last_Name),"Suffix"] <- "III"
NOD_Match[grepl(",III",NOD_Match$Last_Name),"Suffix"] <- "III"

NOD_Match$Last_Name <- gsub(", III","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub(" III","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub("III","",NOD_Match$Last_Name)

NOD_Match[grepl(" II",NOD_Match$Last_Name),"Suffix"] <- "II"
NOD_Match[grepl(", II",NOD_Match$Last_Name),"Suffix"] <- "II"

NOD_Match$Last_Name <- gsub(", II","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub(" II","",NOD_Match$Last_Name)

NOD_Match[grepl(", SR",NOD_Match$Last_Name),"Suffix"] <- "SR"
NOD_Match$Last_Name <- gsub(", SR","",NOD_Match$Last_Name)

NOD_Match[grepl(", SR\\.",NOD_Match$Last_Name),"Suffix"] <- "SR"
NOD_Match$Last_Name <- gsub(", SR\\.","",NOD_Match$Last_Name)

NOD_Match[grepl(" JR",NOD_Match$Last_Name_2),"Suffix"] <- "JR"
NOD_Match[grepl(" JR.",NOD_Match$Last_Name_2),"Suffix"] <- "JR"
NOD_Match[grepl(", JR",NOD_Match$Last_Name_2),"Suffix"] <- "JR"
NOD_Match[grepl(", JR.",NOD_Match$Last_Name_2),"Suffix"] <- "JR"

NOD_Match$Last_Name_2 <- gsub(", JR.","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(", JR","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(" JR.","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(" JR","",NOD_Match$Last_Name_2)

NOD_Match[grepl(" III",NOD_Match$Last_Name_2),"Suffix"] <- "III"
NOD_Match[grepl(", III",NOD_Match$Last_Name_2),"Suffix"] <- "III"

NOD_Match$Last_Name_2 <- gsub(", III","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(" III","",NOD_Match$Last_Name_2)

NOD_Match[grepl(" II",NOD_Match$Last_Name_2),"Suffix"] <- "II"
NOD_Match[grepl(", II",NOD_Match$Last_Name_2),"Suffix"] <- "II"

NOD_Match$Last_Name_2 <- gsub(", II","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(" II","",NOD_Match$Last_Name_2)

NOD_Match[grepl(", SR",NOD_Match$Last_Name_2),"Suffix"] <- "SR"
NOD_Match$Last_Name_2 <- gsub(", SR","",NOD_Match$Last_Name_2)

NOD_Match[grepl(", SR\\.",NOD_Match$Last_Name_2),"Suffix"] <- "SR"
NOD_Match$Last_Name_2 <- gsub(", SR\\.","",NOD_Match$Last_Name_2)

NOD_Match$Last_Name <- gsub(" ","",NOD_Match$Last_Name)
NOD_Match$Last_Name_2 <- gsub(" ","",NOD_Match$Last_Name_2)

NOD_Match$Last_Name <- gsub("-","",NOD_Match$Last_Name)
NOD_Match$Last_Name_2 <- gsub("-","",NOD_Match$Last_Name_2)
#
# TODO - maybe add code to split compound first name into alternates?
#
NOD_Match$First_Name <- gsub("'","",NOD_Match$First_Name)
NOD_Match$First_Name <- gsub("-","",NOD_Match$First_Name)
NOD_Match$First_Name <- gsub("\\.","",NOD_Match$First_Name)
NOD_Match$First_Name <- gsub(" ","",NOD_Match$First_Name)

NOD_Match$First_Name_2 <- gsub("'","",NOD_Match$First_Name_2)
NOD_Match$First_Name_2 <- gsub("-","",NOD_Match$First_Name_2)
NOD_Match$First_Name_2 <- gsub("\\.","",NOD_Match$First_Name_2)
NOD_Match$First_Name_2 <- gsub(" ","",NOD_Match$First_Name_2)

NOD_Match$Last_Name <- gsub("'","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub("-","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub("\\.","",NOD_Match$Last_Name)
NOD_Match$Last_Name <- gsub(" ","",NOD_Match$Last_Name)

NOD_Match$Last_Name_2 <- gsub("'","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub("-","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub("\\.","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(" ","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub("(MAIDEN)","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub("\\(ALSO,","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub("\\(","",NOD_Match$Last_Name_2)
NOD_Match$Last_Name_2 <- gsub(")","",NOD_Match$Last_Name_2)

NOD_Match$Middle_Name <- gsub("NMN","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub("NMN","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub("'","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub("'","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub("-","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub("-","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub(" ","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub(" ","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub("\\.","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub("\\.","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub("\\(","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub("\\(","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub(")","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub(")","",NOD_Match$Middle_Name_2)
NOD_Match$Middle_Name <- gsub(",","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub(",","",NOD_Match$Middle_Name_2)
#
# TODO ... replace with regular expression for any numeric character
#
NOD_Match$Middle_Name <- gsub("0","",NOD_Match$Middle_Name)
NOD_Match$Middle_Name_2 <- gsub("0","",NOD_Match$Middle_Name_2)
#
NOD_Match$Suffix <- gsub("\\.","",NOD_Match$Suffix)
NOD_Match$Suffix_2 <- gsub("\\.","",NOD_Match$Suffix_2)
#
# create full name field based on first, middle, last and suffix
# two versions based on middle and alternate middle, then two versions - with and without suffix
# total of four full names
# full.name,1 = first, middle, last
# full.name.2 = first, middle, last_2, 
# full.name.3 = first, middle initial, last
# full.name.4 = first, middle initian, last_2
#

NOD_Match$Full.Name.1 <- paste(NOD_Match$First_Name, NOD_Match$Middle_Name, NOD_Match$Last_Name, sep=" ")
NOD_Match$Full.Name.2 <- paste(NOD_Match$First_Name, NOD_Match$Middle_Name, NOD_Match$Last_Name, NOD_Match$Suffix,sep=" ")
NOD_Match$Full.Name.3 <- paste(NOD_Match$First_Name, substr(NOD_Match$Middle_Name,1,1), NOD_Match$Last_Name, sep=" ")
NOD_Match$Full.Name.4 <- paste(NOD_Match$First_Name, substr(NOD_Match$Middle_Name,1,1), NOD_Match$Last_Name, NOD_Match$Suffix, sep=" ")
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
#
# remove whitespace
#
NOD_Match$Full.Name.1 <- rm_white(NOD_Match$Full.Name.1)
NOD_Match$Full.Name.2 <-  rm_white(NOD_Match$Full.Name.2)
NOD_Match$Full.Name.3 <-  rm_white(NOD_Match$Full.Name.3)
NOD_Match$Full.Name.4 <-  rm_white(NOD_Match$Full.Name.4)
#
# populate first and last tname 2 if empty with last or first name
#
NOD_Match[is.na(NOD_Match$First_Name_2),"First_Name_2"] <- ""
NOD_Match[NOD_Match$First_Name_2 == "","First_Name_2"] <-NOD_Match[NOD_Match$First_Name_2 == "","First_Name"]

NOD_Match[is.na(NOD_Match$Last_Name_2),"Last_Name_2"] <- ""
NOD_Match[NOD_Match$Last_Name_2 == "","Last_Name_2"] <-NOD_Match[NOD_Match$Last_Name_2 == "","Last_Name"]

#
# dump copy for working file prior to filter
#

write.csv(NOD_Match,"~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_1.csv",row.names = FALSE, na="")
#
# filter on Taxonomy
#
NOD_Match <- sqldf("select NOD_Match.* from NOD_Match where NOD_Match.[TAX] like '%207V%' or NOD_Match.[TAX] like '%174000000X%' or NOD_Match.[TAX] like '%390200000X%' or NOD_Match.[TAX] like '%208D00000X%' or NOD_Match.[TAX] like '174400000X' ")
#
# dump copy of working file after filter
#
write.csv(NOD_Match,"~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_2.csv",row.names = FALSE, na="") #filtered dataset
#
rm(NOD)
rm(NPPES)

#-------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------
# load functions for matching
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------

#fullname
match1 <- function(Gmatch,Nmatch,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch, ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )

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

  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL
  
  if (nrow(matches) > 0) {
     
  
  matches$Type <- MatchType
  matches <- subset(matches, is.na(matches$dup_name))
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
  } else {
    
    print( paste(MatchType," ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
    
  }
    
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

# fullname state
match2 <- function(Gmatch,Nmatch,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch, ' and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )
  
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
  
  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL  
  
  if (nrow(matches) > 0) {
  
    matches$Type <- MatchType   
  
    matches <- subset(matches, is.na(matches$dup_name))
    
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
  } else {
    print( paste(MatchType," ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  }
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

# first last
match3 <- function(Gmatch,Nmatch, Gmatch1,Nmatch1,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch,' and GOB_Match.',Gmatch1, ' = NOD_Match.',Nmatch1 , ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )
  
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
  
  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL

  if (nrow(matches) > 0) {
    
    matches$Type <- MatchType 
    
    matches <- subset(matches, is.na(matches$dup_name))
  
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
  } else {
    
    print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
    
  }
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

# first, last, state
match4 <- function(Gmatch,Nmatch, Gmatch1,Nmatch1,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch,' and GOB_Match.',Gmatch1, ' = NOD_Match.',Nmatch1 , ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" and GOB_Match.[State] = NOD_Match.[State]',sep="")
  matches <- sqldf(matchString )
  
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
  
  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL
  
  if (nrow(matches) > 0) {
  
    matches$Type <- MatchType   
  matches <- subset(matches, is.na(matches$dup_name))
  
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
} else {
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
}
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
# Start Matching
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
matchcount <- 0
priormatchcount <- 1
loops <- 1

while (priormatchcount != matchcount) {
  priormatchcount <- matchcount
  #######################
  #######################
  print (paste(loops," loops.  Start time this loop: ",Sys.time()) )
  
  #######################
  #######################
#
# FullName
#

returnvals <- match1("[Full.Name.1]","[Full.Name.1]","G_FN1_N_FN1",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]

returnvals <- match1("[Full.Name.1]","[Full.Name.2]","G_FN1_N_FN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]

returnvals <- match1("[Full.Name.1]","[Full.Name.3]","G_FN1_N_FN3",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]

returnvals <- match1("[Full.Name.1]","[Full.Name.4]","G_FN1_N_FN4",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.2]","[Full.Name.1]","G_FN2_N_FN1",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.2]","[Full.Name.2]","G_FN2_N_FN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.2]","[Full.Name.3]","G_FN2_N_FN3",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.2]","[Full.Name.4]","G_FN2_N_FN4",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.3]","[Full.Name.1]","G_FN3_N_FN1",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.3]","[Full.Name.2]","G_FN3_N_FN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.3]","[Full.Name.3]","G_FN3_N_FN3",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.3]","[Full.Name.4]","G_FN3_N_FN4",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.4]","[Full.Name.1]","G_FN4_N_FN1",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.4]","[Full.Name.2]","G_FN4_N_FN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.4]","[Full.Name.3]","G_FN4_N_FN3",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match1("[Full.Name.4]","[Full.Name.4]","G_FN4_N_FN4",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


#
# full name and state
#

returnvals <- match2("[Full.Name.1]","[Full.Name.1]","G_FN1_N_FN1 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.2]","G_FN1_N_FN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.3]","G_FN1_N_FN3 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.4]","G_FN1_N_FN4 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.1]","G_FN2_N_FN1 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.2]","G_FN2_N_FN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.3]","G_FN2_N_FN3 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.4]","G_FN2_N_FN4 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.1]","G_FN3_N_FN1 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.2]","G_FN3_N_FN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.3]","G_FN3_N_FN3 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.4]","G_FN3_N_FN4 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.1]","G_FN4_N_FN1 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.2]","G_FN4_N_FN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.3]","G_FN4_N_FN3 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.4]","G_FN4_N_FN4 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


#
# first name last name
#

returnvals <- match3("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiNLaN",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiNLaN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiNLaN",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiNLaN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN1LaN",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiNLaN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiN2LaN",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiN2LaN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiN2LaN",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiN2LaN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN2LaN",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match3("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiN2LaN2",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


#
# first name last name and state
#

returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiNLaN S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiNLaN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiNLaN S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiNLaN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN1LaN S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiNLaN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiN2LaN S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiN2LaN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiN2LaN S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiN2LaN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN2LaN S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiN2LaN2 S",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


#
# Include City in Matching----------------------------------------------------------------------------------------------------------
# 

GOB_Match$oldState <- GOB_Match$state
GOB_Match$state <- paste(GOB_Match$city,GOB_Match$state, sep = " ")
matchcount <- matchcount + returnvals[[3]]


NOD_Match$oldState <- NOD_Match$State
NOD_Match$State <- paste(NOD_Match$City,NOD_Match$State, sep = " ")
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.1]","G_FN1_N_FN1 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.2]","G_FN1_N_FN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.3]","G_FN1_N_FN3 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.4]","G_FN1_N_FN4 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.1]","G_FN2_N_FN1 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.2]","G_FN2_N_FN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.3]","G_FN2_N_FN3 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.4]","G_FN2_N_FN4 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.1]","G_FN3_N_FN1 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.2]","G_FN3_N_FN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.3]","G_FN3_N_FN3 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.4]","G_FN3_N_FN4 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.1]","G_FN4_N_FN1 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.2]","G_FN4_N_FN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.3]","G_FN4_N_FN3 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.4]","G_FN4_N_FN4 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiNLaN CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiNLaN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiNLaN CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiNLaN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN1LaN CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiNLaN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiN2LaN CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiN2LaN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiN2LaN CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiN2LaN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN2LaN CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiN2LaN2 CS",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


GOB_Match$state <- GOB_Match$oldState 
NOD_Match$State <- NOD_Match$oldState 

#
# Match on Prescription Data ----------------------------------------------------------------------------------------------------------------------------
# 

returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_P_FiNLaN",GOB_Match,PRE_Match)
GOB_Match <- returnvals[[1]]
PRE_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_P_FiNLaN",GOB_Match,PRE_Match)
GOB_Match <- returnvals[[1]]
PRE_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_P_FiNLaN",GOB_Match,PRE_Match)
GOB_Match <- returnvals[[1]]
PRE_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]

loops <- loops + 1

}

#
# End of Matching--------------------------------------------------------------------------------------------------------------------------------
# 

# compile and write final outputs

GOBA_Match_NPPES <- subset(GOB_Match,select = c("ID","NPI", "Type"))
GOBA_Match_NPPES_Matched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI!= "",]
GOBA_Match_NPPES_UnMatched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI == "",]

#
# write output, cleanup workspace
#

write.csv(GOBA_Match_NPPES_Matched, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_Matched.csv",row.names = FALSE)
write.csv(GOBA_Match_NPPES_UnMatched,"~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_UnMatched.csv",row.names = FALSE)
write.csv(GOB_Match, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL.csv",row.names = FALSE)
write.csv(NOD_Match, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Match_ALL.csv",row.names = FALSE)

NOD_Fuzzy <- NOD_Match[NOD_Match$GOB_ID == "",c("NPI", "Full.Name.2")]
NOD_Fuzzy_dup_names <- data.frame(NOD_Fuzzy[duplicated(NOD_Fuzzy$Full.Name.2),2])
names(NOD_Fuzzy_dup_names) = c("Full.Name.2")
NOD_Fuzzy <- fn$sqldf('select NOD_Fuzzy.*, NOD_Fuzzy_dup_names.[Full.Name.2] as dup_name  from NOD_Fuzzy LEFT OUTER JOIN NOD_Fuzzy_dup_names on NOD_Fuzzy_dup_names.[Full.Name.2] = NOD_Fuzzy.[Full.Name.2] ')
NOD_Fuzzy <- NOD_Fuzzy[is.na(NOD_Fuzzy$dup_name),]
NOD_Fuzzy$dup_name <- NULL
names(NOD_Fuzzy)[2] <- "FullName"

GOB_Fuzzy <- GOB_Match[GOB_Match$NPI == "",c("userid","NamePart")]
GOB_Fuzzy_dup_names <- data.frame(GOB_Fuzzy[duplicated(GOB_Fuzzy$NamePart),2])
names(GOB_Fuzzy_dup_names) = c("NamePart")
GOB_Fuzzy <- fn$sqldf('select GOB_Fuzzy.*, GOB_Fuzzy_dup_names.[NamePart] as dup_name  from GOB_Fuzzy LEFT OUTER JOIN GOB_Fuzzy_dup_names on GOB_Fuzzy_dup_names.[NamePart] = GOB_Fuzzy.[NamePart] ')
GOB_Fuzzy <- GOB_Fuzzy[is.na(GOB_Fuzzy$dup_name),]
GOB_Fuzzy$dup_name <- NULL
names(GOB_Fuzzy)[2] <- "FullName"
names(GOB_Fuzzy)[1] <- "GOB_ID"


write.csv(GOB_Fuzzy, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Fuzzy.csv",row.names = FALSE, na="")
write.csv(NOD_Fuzzy, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Fuzzy.csv",row.names = FALSE, na="")

rm(list=ls()) 

