# 1. Input

# 1.1 NPPES - raw NPPES data file [2021 update]
#			  "~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_January_2021/npidata_pfile_20050523-20210110.csv"
# 1.2 OP - raw Open payments demographic file [2021 update]
#		   "~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01222021.csv"

# 2. Functions - none

# 3. Processing Summary

# 3.1 File prep
# - building single taxonomy summary field for NPPES file (combine 15 taxonomy columns into single)
# - drop non demographic fields from NPPES 
# - drop non demographic fields from OP 

# 3.2 match OP and NPPES file - (each time only keep unique matches) match on:
#	- first, middle, last, suffix, address, city, state
#	- first, last, suffix, address, city, state
#	- first, last, address, city, state
#	- first(NP alt first), last, address, city, state
#	- first, last( NP alt last), address, city, state
#	- first(OP alt first), last, address, city, state
#	- first, last(OP alt last), address, city, state
#	- first(OP alt first), last(OP alt last), address, city, state
#	- first, last, suffix, address(NP alt address), city(NP alt city), state (NP alt state)
#	- first, middle, last, suffix, city, state
#	- first, middle, last, city, state
#	- first, last, city, state
#	- first, middle, last, suffix, zip
#	- first, middle, last, zip
#	- first, last, zip
# 
# 5. Output
# 5.1 OP_Matched - OP file with matches 
#					"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_Matched.csv"
# 5.2 OP_Unmatched - OP file - only non matches
#					"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_UnMatched.csv"
# 5.3 OP_Unmatched_OBGYN - sames as 4.8, but filtered on OBGYNs
#					"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_UnMatched_OBGYN.csv"


# changes pending (needed)
## dump NPPES file with NPI numbers

#
# Revisions
#
# 01/23/2021 
# - initial .. based on 2_Match_OP_NPPES_PCND



# Installing
# install.packages("readr")
# install.packages("qdapRegex")
# install.packages("sqldf")
# install.packages("tidyverse")
# install.packages("Hmisc")
# Loading

library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("tidyverse")
library ("Hmisc")

# Load NPPES Data *****************************************************************************************************************
NPPES <- read.csv("~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_January_2021/npidata_pfile_20050523-20210110.csv",stringsAsFactors = FALSE)
NPPES <- NPPES[NPPES$Entity.Type.Code == 1,]
NPPES <- NPPES[,c(1,6,7,8,9,10,14,15,16,17,18,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,48,52,56,60,64,68,72,76,80,84,88,92,96,100,104)]            
NPPES$TAX <- NA
NPPES$TAX <- paste(NPPES$Healthcare.Provider.Taxonomy.Code_1,NPPES$Healthcare.Provider.Taxonomy.Code_2,NPPES$Healthcare.Provider.Taxonomy.Code_3,NPPES$Healthcare.Provider.Taxonomy.Code_4, NPPES$Healthcare.Provider.Taxonomy.Code_5, NPPES$Healthcare.Provider.Taxonomy.Code_6, NPPES$Healthcare.Provider.Taxonomy.Code_7, NPPES$Healthcare.Provider.Taxonomy.Code_8, NPPES$Healthcare.Provider.Taxonomy.Code_9, NPPES$Healthcare.Provider.Taxonomy.Code_10, NPPES$Healthcare.Provider.Taxonomy.Code_11, NPPES$Healthcare.Provider.Taxonomy.Code_12, NPPES$Healthcare.Provider.Taxonomy.Code_13, NPPES$Healthcare.Provider.Taxonomy.Code_14, NPPES$Healthcare.Provider.Taxonomy.Code_15)
NPPES <- NPPES[,c(1:26,42)]

NPPES$Provider.First.Name = tolower(NPPES$Provider.First.Name)
NPPES$Provider.Middle.Name = tolower(NPPES$Provider.Middle.Name)
NPPES$Provider.Middle.Name <- gsub("\\.","",NPPES$Provider.Middle.Name)
NPPES$Provider.Last.Name..Legal.Name. = tolower(NPPES$Provider.Last.Name..Legal.Name.)
NPPES$Provider.Name.Suffix.Text = tolower(NPPES$Provider.Name.Suffix.Text)

NPPES$Provider.Other.First.Name = tolower(NPPES$Provider.Other.First.Name)
NPPES$Provider.Other.Middle.Name = tolower(NPPES$Provider.Other.Middle.Name)
NPPES$Provider.Other.Middle.Name <- gsub("\\.","",NPPES$Provider.Other.Middle.Name)
NPPES$Provider.Other.Last.Name = tolower(NPPES$Provider.Other.Last.Name)
NPPES$Provider.Other.Name.Suffix.Text = tolower(NPPES$Provider.Other.Name.Suffix.Text)

NPPES$Provider.First.Line.Business.Practice.Location.Address = tolower(NPPES$Provider.First.Line.Business.Practice.Location.Address)
NPPES$Provider.Business.Practice.Location.Address.City.Name = tolower(NPPES$Provider.Business.Practice.Location.Address.City.Name)
NPPES$Provider.Business.Practice.Location.Address.State.Name = tolower(NPPES$Provider.Business.Practice.Location.Address.State.Name)

NPPES$Provider.First.Line.Business.Mailing.Address = tolower(NPPES$Provider.First.Line.Business.Mailing.Address)
NPPES$Provider.Business.Mailing.Address.City.Name = tolower(NPPES$Provider.Business.Mailing.Address.City.Name)
NPPES$Provider.Business.Mailing.Address.State.Name = tolower(NPPES$Provider.Business.Mailing.Address.State.Name)

NPPES$Provider.Business.Practice.Location.Address.Postal.Code <- substr(NPPES$Provider.Business.Practice.Location.Address.Postal.Code,1,5)
NPPES$Provider.Provider.Business.Mailing.Address.Postal.Code <- substr(NPPES$Provider.Business.Mailing.Address.Postal.Code,1,5)

NPPES$Physician_Profile_ID <- ""


# Load OP data ********************************************************************************************************************
# *********************************************************************************************************************************

OP <- read.csv("~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01222021.csv", stringsAsFactors=FALSE)
OP <- OP[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,17,18,19,20,21,22)]

OP$Physician_Profile_First_Name = tolower(OP$Physician_Profile_First_Name)
OP$Physician_Profile_Middle_Name = tolower(OP$Physician_Profile_Middle_Name)
OP$Physician_Profile_Middle_Name <- gsub("\\.","",OP$Physician_Profile_Middle_Name)
OP$Physician_Profile_Last_Name = tolower(OP$Physician_Profile_Last_Name)
OP$Physician_Profile_Suffix = tolower(OP$Physician_Profile_Suffix)

OP$Physician_Profile_Alternate_First_Name = tolower(OP$Physician_Profile_Alternate_First_Name)
OP$Physician_Profile_Alternate_Middle_Name = tolower(OP$Physician_Profile_Alternate_Middle_Name)
OP$Physician_Profile_Alternate_Middle_Name <- gsub("\\.","",OP$Physician_Profile_Alternate_Middle_Name)
OP$Physician_Profile_Alternate_Last_Name = tolower(OP$Physician_Profile_Alternate_Last_Name)
OP$Physician_Profile_Alternate_Suffix = tolower(OP$Physician_Profile_Alternate_Suffix)

OP$Physician_Profile_Address_Line_1 = tolower(OP$Physician_Profile_Address_Line_1)
OP$Physician_Profile_City = tolower(OP$Physician_Profile_City)
OP$Physician_Profile_State = tolower(OP$Physician_Profile_State)

OP$Physician_Profile_Zipcode <- substr(OP$Physician_Profile_Zipcode,1,5)

OP$NPI <- ""

OP$TAX <- NA
OP$TAX <- paste(OP$Physician_Profile_OPS_Taxonomy_1,OP$Physician_Profile_OPS_Taxonomy_2,OP$Physician_Profile_OPS_Taxonomy_3,OP$Physician_Profile_OPS_Taxonomy_4, OP$Physician_Profile_OPS_Taxonomy_5)

# save prepped files

write.csv(NPPES,"~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_January_2021/npidata_pfile_20050523-20210110_prepped.csv",row.names = FALSE)
write.csv(OP,"~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01222021__prepped.csv",row.names = FALSE)

# Matching ************************************************************************************************************************1
# First, middle, last, suffix, address, city, state *******************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]  and OP.Physician_Profile_Middle_Name = NPPES.[Provider.Middle.Name] and OP.Physician_Profile_Suffix = NPPES.[Provider.Name.Suffix.Text] and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]  #remove duplicate PPI
OPM <- OPM[!duplicated(OPM$NPI),]  #Remove duplicate NPI

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************2
# First, last, suffix, address, city, state ***************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]  and OP.Physician_Profile_Suffix = NPPES.[Provider.Name.Suffix.Text] and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')


OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************3
# First, last, address, city, state ***********************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]   and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************4
# OP First NP AltFirst, last, address, city, state ********************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.Other.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]   and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]


# Matching ************************************************************************************************************************5
# First, OP last NP AltLast , address, city, state ********************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Other.Last.Name] and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************6
# OP Alt First NP First, last,address, city, state ********************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_Alternate_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.] and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************7
# First, OP Altlast NP last,address, city, state ********************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Alternate_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.] and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************8
# OP altFirst NP First, OP Altlast NP last,address, city, state *******************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_Alternate_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Alternate_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.] and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Practice.Location.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]


# Matching ************************************************************************************************************************9
# First, last, NP Altaddress, NP Altcity, NP Altstate *****************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]   and OP.Physician_Profile_Address_Line_1 = NPPES.[Provider.First.Line.Business.Mailing.Address] and OP.Physician_Profile_City = NPPES.[Provider.Business.Mailing.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Mailing.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]
OP_UnMatched <- OP[OP$NPI == "",]

# Matching ************************************************************************************************************************10
# First, middle, last, suffix, city, state ****************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]  and OP.Physician_Profile_Middle_Name = NPPES.[Provider.Middle.Name] and OP.Physician_Profile_Suffix = NPPES.[Provider.Name.Suffix.Text]  and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************11
# First, middle, last, city, state ************************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]  and OP.Physician_Profile_Middle_Name = NPPES.[Provider.Middle.Name]  and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************12
# First, last, city, state ********************************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]   and OP.Physician_Profile_City = NPPES.[Provider.Business.Practice.Location.Address.City.Name] and OP.Physician_Profile_State = NPPES.[Provider.Business.Practice.Location.Address.State.Name] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************13
# First, middle, last, suffix, zip  ****************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]  and OP.Physician_Profile_Middle_Name = NPPES.[Provider.Middle.Name] and OP.Physician_Profile_Suffix = NPPES.[Provider.Name.Suffix.Text]  and OP.Physician_Profile_Zipcode = NPPES.[Provider.Business.Practice.Location.Address.Postal.Code] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************14
# First, middle, last, zip  ************************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]  and OP.Physician_Profile_Middle_Name = NPPES.[Provider.Middle.Name]  and OP.Physician_Profile_Zipcode = NPPES.[Provider.Business.Practice.Location.Address.Postal.Code] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# Matching ************************************************************************************************************************15
# First, last, zip ********************************************************************************************************
# *********************************************************************************************************************************

OPM <- sqldf('select OP.Physician_Profile_ID, NPPES.NPI from OP left outer join NPPES on OP.Physician_Profile_First_Name = NPPES.[Provider.First.Name] and OP.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]   and OP.Physician_Profile_Zipcode = NPPES.[Provider.Business.Practice.Location.Address.Postal.Code] and NPPES.[Physician_Profile_ID] = "" ')

OPM <- OPM[!duplicated(OPM$Physician_Profile_ID),]
OPM <- OPM[!duplicated(OPM$NPI),]

#update OP
OP <- sqldf('select OP.*, OPM.NPI as "uNPI" from OP left outer join OPM on OP.Physician_Profile_ID = OPM.Physician_Profile_ID')

OP[OP$NPI =="","NPI"] <- OP[OP$NPI =="","uNPI"]
OP$uNPI <- NULL
OP[is.na(OP$NPI),"NPI"] <- ""

#update NPPES
NPPES <- sqldf('select NPPES.*, OPM.Physician_Profile_ID as "uPPI" from NPPES left outer join OPM on NPPES.NPI = OPM.NPI')

NPPES[NPPES$Physician_Profile_ID =="","Physician_Profile_ID"] <- NPPES[NPPES$Physician_Profile_ID =="","uPPI"]
NPPES$uPPI <- NULL
NPPES[is.na(NPPES$Physician_Profile_ID),"Physician_Profile_ID"] <- ""

rm(OPM)
OP_Matched <- OP[OP$NPI != "",]

# *******************************************************************************************************************************************************************

# Dump intermediate results

NPPES_Matches <- NPPES[,c(1,29)]
write.csv(NPPES_Matches,"~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_January_2021/npidata_pfile_20050523-20210110_matched.csv",row.names = FALSE)
rm(NPPES_Matches)

OP_Matches <- OP[,c(1,21)]
write.csv(OP_Matches,"~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01222021_matched.csv",row.names = FALSE)
rm(OP_Matches)



# *************************************************************************************************************************************************************************
# update OP with matched 


OP_UnMatched <- OP[OP$NPI == "",]
OP_Matched <- OP[OP$NPI != "",]


write.csv(OP_Matched,"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_Matched.csv", row.names = FALSE)
write.csv(OP_UnMatched,"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_UnMatched.csv", row.names = FALSE)

rm(list=ls()) 
gc()

