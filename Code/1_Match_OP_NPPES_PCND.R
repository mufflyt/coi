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
NPPES <- read.csv("/Volumes/Projects/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_2.csv", stringsAsFactors = FALSE)
#NPPES <- read.csv("D:/muffly/data/Originals/match_data/npidata_pfile_20050523-20190707_demo.csv", stringsAsFactors=FALSE)

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
readr::write_rds(NPPES, "/Volumes/Projects/Pharma_Influence/Data/output_of_1_Match_OP_NPPES_PCDN_NPPES_dataframe.rds")

# Load OP data ********************************************************************************************************************
# *********************************************************************************************************************************

OP <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01172020_2.csv", stringsAsFactors=FALSE)
#OP <- read.csv("D:/muffly/data/Originals/match_data/OP_PH_PRFL_SPLMTL_P06292018_demo.csv", stringsAsFactors=FALSE)

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

# *******************************************************************************************************************************************************************

OP_Matched <- OP[OP$NPI != "",]
OP_UnMatched <- OP[OP$NPI == "",]

#OP_Spec <- read.csv("D:/muffly/data/Originals/match_data/OP_PH_PRFL_SPLMTL_P06292018_tax.csv", stringsAsFactors=FALSE)

#OP_UnMatched <- sqldf('select OP_UnMatched.*, OP_Spec.Physician_Profile_Primary_Specialty from OP_UnMatched left outer join OP_Spec on OP_UnMatched.Physician_Profile_ID = OP_Spec.Physician_Profile_ID')
#unMatchedOBGYN <- read.csv("D:/muffly/data/Originals/match_data/unMatchedOBGYN.csv", stringsAsFactors=FALSE)
#unMatchedOBGYNx <- sqldf('select unMatchedOBGYN.*, NPPES.* from unMatchedOBGYN left outer join NPPES on unMatchedOBGYN.Physician_Profile_Last_Name = NPPES.[Provider.Last.Name..Legal.Name.]   and unMatchedOBGYN.Physician_Profile_Zipcode = NPPES.[Provider.Business.Practice.Location.Address.Postal.Code] and NPPES.[Physician_Profile_ID] = "" ')

#write.csv(OP_Matched,"D:/muffly/data/Originals/match_data/OP_Matched.csv",row.names = FALSE)

#
# *************************************************************************************************
# Clean up 
#PCND <- read.csv("D:/muffly/data/Originals/Physician_Compare/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)
PCND <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File2.csv", stringsAsFactors=FALSE)
  
  
PCND <- filter(PCND, PCND$State %nin% c("AP","AE", "AS", "FM", "GU", "MH","MP", "PR","PW","UM","VI", "ZZ"))
PCND <- filter(PCND, (PCND$Primary.specialty %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  | (PCND$Secondary.specialty.1 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$Secondary.specialty.2 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$Secondary.specialty.3 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$Secondary.specialty.4 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  ) 

PCND_Matched <- sqldf('select PCND.NPI from PCND group by PCND.NPI')
PCND_Matched <- sqldf('select PCND_Matched.NPI, OP_Matched.Physician_Profile_ID from PCND_Matched left outer join OP_Matched on PCND_Matched.NPI = OP_Matched.NPI')

PCND1 <- sqldf('select PCND.NPI,  PCND.Gender, PCND.[Medical.school.name] as "MedSchool",PCND.State, PCND.[Graduation.year] as "GraduationYear" from PCND group by PCND.NPI')
PCND1 <- sqldf('select PCND1.*, PCND_Matched.Physician_Profile_ID as "PPI" from PCND1 join PCND_Matched on PCND1.NPI = PCND_Matched.NPI')
PCND1 <- PCND1[,c(1,6,2:5)]

StudyGroup1 <- PCND[,c(1,2)]
StudyGroup1 <- StudyGroup[!is.na(StudyGroup$PPI),]

PCND2 <- sqldf('select PCND.*, StudyGroup1.PPI from PCND left outer join StudyGroup1 on PCND.NPI = StudyGroup1.NPI')
PCND2 <- PCND2[is.na(PCND2$PPI),]

rm(PCND)
rm(PCND_Matched)
rm(OP_Matched)
rm(OP_UnMatched)
#
# *************************************************************************************************
# Match remaining PCND

PCND <- PCND2

PCND$Zip.Code <- substr(PCND$Zip.Code,1,5)
PCND$Last.Name <- tolower(PCND$Last.Name)
PCND$First.Name <- tolower(PCND$First.Name)
PCND$Middle.Name <- tolower(PCND$Middle.Name)
PCND$Line.1.Street.Address <- tolower(PCND$Line.1.Street.Address)
PCND$City <- tolower(PCND$City)
PCND$State <- tolower(PCND$State)

PCND_CS <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name],[Line.1.Street.Address],City, State from PCND group by [NPI], [City],[State]')

PCND_ZIP <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name], [Line.1.Street.Address],[Zip.Code] from PCND group by [NPI], [Zip.Code]')

PCND_CS_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_CS group by NPI ')
PCND_CS_dup_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count > 1,]
PCND_CS_uni_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count == 1,]

PCND_CS_dup<- semi_join(PCND_CS,PCND_CS_dup_cnt, by = "NPI" )
PCND_CS_uni<- semi_join(PCND_CS,PCND_CS_uni_cnt, by = "NPI" )

PCND_ZIP_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_ZIP group by NPI ')

# load payment data

OP_Summary <- OP
OP_Summary <- sqldf('select OP_Summary.*, StudyGroup1.NPI as "mNPI" from OP_Summary left outer join StudyGroup1 on OP_Summary.Physician_Profile_ID = StudyGroup1.PPI')
OP_Summary <- OP_Summary[is.na(OP_Summary$mNPI),]
OP_Summary$mNPI <- NULL
OP_Summary$NPI <- NULL

OP_Summary$Physician_Profile_Last_Name <- tolower(OP_Summary$Physician_Profile_Last_Name)
OP_Summary$Physician_Profile_First_Name <- tolower(OP_Summary$Physician_Profile_First_Name)
OP_Summary$Physician_Profile_Alternate_Last_Name <- tolower(OP_Summary$Physician_Profile_Alternate_Last_Name)
OP_Summary$Physician_Profile_Alternate_First_Name <- tolower(OP_Summary$Physician_Profile_Alternate_First_Name)
OP_Summary$Physician_Profile_Middle_Name <- tolower(OP_Summary$Physician_Profile_Middle_Name)
OP_Summary$Physician_Profile_Address_Line_1 <- tolower(OP_Summary$Physician_Profile_Address_Line_1)
OP_Summary$Physician_Profile_City <- tolower(OP_Summary$Physician_Profile_City)
OP_Summary$Physician_Profile_State <- tolower(OP_Summary$Physician_Profile_State)
OP_Summary$Physician_Profile_Zipcode <- substr(OP_Summary$Physician_Profile_Zipcode,1,5)

OP_Summary <- OP_Summary[OP_Summary$Physician_Profile_Last_Name != "",]
OP_Summary <- OP_Summary[OP_Summary$Physician_Profile_First_Name != "",]
OP_Summary <- OP_Summary[OP_Summary$Physician_Profile_City != "",]
OP_Summary <- OP_Summary[OP_Summary$Physician_Profile_State != "",]
OP_Summary <- OP_Summary[OP_Summary$Physician_Profile_Zipcode != "",]

OP_Summary <- OP_Summary[!is.na(OP_Summary$Physician_Profile_Last_Name),]
OP_Summary <- OP_Summary[!is.na(OP_Summary$Physician_Profile_First_Name),]
OP_Summary <- OP_Summary[!is.na(OP_Summary$Physician_Profile_City),]
OP_Summary <- OP_Summary[!is.na(OP_Summary$Physician_Profile_State),]
OP_Summary <- OP_Summary[!is.na(OP_Summary$Physician_Profile_Zipcode),]

names(OP_Summary)[1] = "PPI"

# start match

# match - first, last, city, state

MP1 <- sqldf('select PCND_CS.NPI, OP_Summary.PPI from PCND_CS left outer join OP_Summary on PCND_CS.[Last.Name] = OP_Summary.Physician_Profile_Last_Name and PCND_CS.[First.Name] = OP_Summary.Physician_Profile_First_Name and PCND_CS.[City] = OP_Summary.Physician_Profile_City  and PCND_CS.[State] = OP_Summary.Physician_Profile_State ')
MP1 <- MP1[!is.na(MP1$PPI),]


MP2 <- sqldf('select PCND_ZIP.NPI, OP_Summary.PPI from PCND_ZIP left outer join OP_Summary on PCND_ZIP.[Last.Name] = OP_Summary.Physician_Profile_Last_Name and PCND_ZIP.[First.Name] = OP_Summary.Physician_Profile_First_Name and PCND_ZIP.[Zip.Code] = OP_Summary.Physician_Profile_Zipcode  ')
MP2 <- MP2[!is.na(MP2$PPI),]

MP <- merge(MP1, MP2, all = TRUE)

# process dups

rm(MP1)
rm(MP2)

MP_dupNPI <-  sqldf('select NPI, count(NPI) as "num" from MP group by NPI')
MP_dupNPI <- MP_dupNPI[MP_dupNPI$num >1,]

MP_dupPPI <-  sqldf('select PPI, count(PPI) as num from MP group by PPI')
MP_dupPPI <- MP_dupPPI[MP_dupPPI$num >1,]

MPd1 <- sqldf('select MP.* from MP join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MPd2 <- sqldf('select MP.* from MP join MP_dupPPI on MP.PPI = MP_dupPPI.PPI')
MPd <- merge(MPd1,MPd2, all = TRUE)
rm(MPd1)
rm(MPd2)

# remove dups from MP
MP <- sqldf('select MP.*, MP_dupNPI.NPI as "dup" from MP left outer join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

MP <- sqldf('select MP.*, MP_dupPPI.PPI as "dup" from MP left outer join MP_dupPPI on MP.NPI = MP_dupPPI.PPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

rm(MP_dupNPI)
rm(MP_dupPPI)

#check for matches using address

MPd <- sqldf('select PCND_CS.*,MPd.PPI as "jPPI" from PCND_CS join MPd on PCND_CS.NPI = MPd.NPI')
MPd <- sqldf('select MPd.*,OP_Summary.* from OP_Summary join MPd on OP_Summary.PPI = MPd.jPPI')
MPd$jPPI <- NULL

dupM1 <- MPd[MPd$Physician_Profile_Address_Line_1 == MPd$Line.1.Street.Address,]
dupM1 <- dupM1[!duplicated(dupM1$NPI),]
dupM1 <- dupM1[!duplicated(dupM1$PPI),]

# remove matches from dup list
MPd <- sqldf('select MPd.*,dupM1.NPI as "uNPI" from MPd left outer join dupM1 on MPd.NPI = dupM1.NPI')
MPd <- MPd[is.na(MPd$uNPI),]

MPd <- sqldf('select MPd.*,dupM1.PPI as "uPPI" from MPd left outer join dupM1 on MPd.PPI = dupM1.PPI')
MPd <- MPd[is.na(MPd$uPPI),]

MPd$uNPI<- NULL
MPd$uPPI <- NULL

# check if there are unique ones left
dupM2 <- MPd[!duplicated(MPd$NPI),]
dupM2 <- dupM2[!duplicated(dupM2$NPI),]

dupM <- merge(dupM1,dupM2, all = TRUE)

rm(dupM1)
rm(dupM2)

dupM <- dupM[!duplicated(dupM$NPI),]
dupM <- dupM[!duplicated(dupM$PPI),]
dupM <- dupM[,c(1,8)]

MP <- merge(MP,dupM, all = TRUE)
rm(dupM)
rm(MPd)

MP <- MP[!duplicated(MP$NPI),]
MP <- MP[!duplicated(MP$PPI),]

PCND$PPI <- ""
OP_Summary$NPI <- ""
#
# ************************************************************************************************
# ***** Round 2 ALT Last **************************************************************************
# ************************************************************************************************
#
# update PCND master with matches, generate new working PCND files
#
OP_Summary <- sqldf('select OP_Summary.*, MP.NPI as "mNPI" from OP_Summary left outer join MP on OP_Summary.PPI = MP.PPI')
OP_Summary[!is.na(OP_Summary$mNPI),"NPI"] <- OP_Summary[!is.na(OP_Summary$mNPI),"mNPI"]
OP_Summary$mNPI <- NULL

PCND <- sqldf('select PCND.*, MP.PPI as "mPPI" from PCND left outer join MP on PCND.NPI = MP.NPI')
PCND[!is.na(PCND$mPPI),"PPI"] <- PCND[!is.na(PCND$mPPI),"mPPI"]
PCND$mPPI <- NULL
PCNDx <- PCND[PCND$PPI =="",]

PCND_CS <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name],[Line.1.Street.Address],City, State from PCNDx group by [NPI], [City],[State]')

PCND_CS_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_CS group by NPI ')
PCND_CS_dup_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count > 1,]
PCND_CS_uni_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count == 1,]

PCND_CS_dup<- semi_join(PCND_CS,PCND_CS_dup_cnt, by = "NPI" )
PCND_CS_uni<- semi_join(PCND_CS,PCND_CS_uni_cnt, by = "NPI" )

# start match

# match - first, last, city, state / alt last

MP1 <- sqldf('select PCND_CS.NPI, OP_Summary.PPI from PCND_CS left outer join OP_Summary on PCND_CS.[Last.Name] = OP_Summary.Physician_Profile_Alternate_Last_Name and PCND_CS.[First.Name] = OP_Summary.Physician_Profile_First_Name and PCND_CS.[City] = OP_Summary.Physician_Profile_City  and PCND_CS.[State] = OP_Summary.Physician_Profile_State where OP_Summary.NPI = ""')
MP1 <- MP1[!is.na(MP1$PPI),]

MP <- MP1

# process dups

rm(MP1)

MP_dupNPI <-  sqldf('select NPI, count(NPI) as "num" from MP group by NPI')
MP_dupNPI <- MP_dupNPI[MP_dupNPI$num >1,]

MP_dupPPI <-  sqldf('select PPI, count(PPI) as num from MP group by PPI')
MP_dupPPI <- MP_dupPPI[MP_dupPPI$num >1,]

MPd1 <- sqldf('select MP.* from MP join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MPd2 <- sqldf('select MP.* from MP join MP_dupPPI on MP.PPI = MP_dupPPI.PPI')
MPd <- merge(MPd1,MPd2, all = TRUE)
rm(MPd1)
rm(MPd2)

# remove dups from MP
MP <- sqldf('select MP.*, MP_dupNPI.NPI as "dup" from MP left outer join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

MP <- sqldf('select MP.*, MP_dupPPI.PPI as "dup" from MP left outer join MP_dupPPI on MP.NPI = MP_dupPPI.PPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

rm(MP_dupNPI)
rm(MP_dupPPI)

#check for matches using address

MPd <- sqldf('select PCND_CS.*,MPd.PPI as "jPPI" from PCND_CS join MPd on PCND_CS.NPI = MPd.NPI')
MPd <- sqldf('select MPd.*,OP_Summary.* from OP_Summary join MPd on OP_Summary.PPI = MPd.jPPI')
MPd$jPPI <- NULL

dupM1 <- MPd[MPd$Physician_Profile_Address_Line_1 == MPd$Line.1.Street.Address,]
dupM1 <- dupM1[!duplicated(dupM1$NPI),]
dupM1 <- dupM1[!duplicated(dupM1$PPI),]

# remove matches from dup list
MPd <- sqldf('select MPd.*,dupM1.NPI as "uNPI" from MPd left outer join dupM1 on MPd.NPI = dupM1.NPI')
MPd <- MPd[is.na(MPd$uNPI),]

MPd <- sqldf('select MPd.*,dupM1.PPI as "uPPI" from MPd left outer join dupM1 on MPd.PPI = dupM1.PPI')
MPd <- MPd[is.na(MPd$uPPI),]

MPd$uNPI<- NULL
MPd$uPPI <- NULL

# check if there are unique ones left
dupM2 <- MPd[!duplicated(MPd$NPI),]
dupM2 <- dupM2[!duplicated(dupM2$NPI),]

dupM <- merge(dupM1,dupM2, all = TRUE)

rm(dupM1)
rm(dupM2)

dupM <- dupM[!duplicated(dupM$NPI),]
dupM <- dupM[!duplicated(dupM$PPI),]
dupM <- dupM[,c(1,8)]

MP <- merge(MP,dupM, all = TRUE)
rm(dupM)
rm(MPd)

#
# ************************************************************************************************
# ***** Round 3 ALT First ************************************************************************
# ************************************************************************************************
#
# update PCND master with matches, generate new working PCND files
#
OP_Summary <- sqldf('select OP_Summary.*, MP.NPI as "mNPI" from OP_Summary left outer join MP on OP_Summary.PPI = MP.PPI')
OP_Summary[!is.na(OP_Summary$mNPI),"NPI"] <- OP_Summary[!is.na(OP_Summary$mNPI),"mNPI"]
OP_Summary$mNPI <- NULL

PCND <- sqldf('select PCND.*, MP.PPI as "mPPI" from PCND left outer join MP on PCND.NPI = MP.NPI')
PCND[!is.na(PCND$mPPI),"PPI"] <- PCND[!is.na(PCND$mPPI),"mPPI"]
PCND$mPPI <- NULL
PCNDx <- PCND[PCND$PPI =="",]

PCND_CS <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name],[Line.1.Street.Address],City, State from PCNDx group by [NPI], [City],[State]')

PCND_CS_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_CS group by NPI ')
PCND_CS_dup_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count > 1,]
PCND_CS_uni_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count == 1,]

PCND_CS_dup<- semi_join(PCND_CS,PCND_CS_dup_cnt, by = "NPI" )
PCND_CS_uni<- semi_join(PCND_CS,PCND_CS_uni_cnt, by = "NPI" )

# start match

# match - first, last, city, state / alt first

MP1 <- sqldf('select PCND_CS.NPI, OP_Summary.PPI from PCND_CS left outer join OP_Summary on PCND_CS.[Last.Name] = OP_Summary.Physician_Profile_Last_Name and PCND_CS.[First.Name] = OP_Summary.Physician_Profile_Alternate_First_Name and PCND_CS.[City] = OP_Summary.Physician_Profile_City  and PCND_CS.[State] = OP_Summary.Physician_Profile_State where OP_Summary.NPI = ""')
MP1 <- MP1[!is.na(MP1$PPI),]

MP <- MP1

# process dups

rm(MP1)

MP_dupNPI <-  sqldf('select NPI, count(NPI) as "num" from MP group by NPI')
MP_dupNPI <- MP_dupNPI[MP_dupNPI$num >1,]

MP_dupPPI <-  sqldf('select PPI, count(PPI) as num from MP group by PPI')
MP_dupPPI <- MP_dupPPI[MP_dupPPI$num >1,]

MPd1 <- sqldf('select MP.* from MP join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MPd2 <- sqldf('select MP.* from MP join MP_dupPPI on MP.PPI = MP_dupPPI.PPI')
MPd <- merge(MPd1,MPd2, all = TRUE)
rm(MPd1)
rm(MPd2)

# remove dups from MP
MP <- sqldf('select MP.*, MP_dupNPI.NPI as "dup" from MP left outer join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

MP <- sqldf('select MP.*, MP_dupPPI.PPI as "dup" from MP left outer join MP_dupPPI on MP.NPI = MP_dupPPI.PPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

rm(MP_dupNPI)
rm(MP_dupPPI)

#check for matches using address

MPd <- sqldf('select PCND_CS.*,MPd.PPI as "jPPI" from PCND_CS join MPd on PCND_CS.NPI = MPd.NPI')
MPd <- sqldf('select MPd.*,OP_Summary.* from OP_Summary join MPd on OP_Summary.PPI = MPd.jPPI')
MPd$jPPI <- NULL

dupM1 <- MPd[MPd$Physician_Profile_Address_Line_1 == MPd$Line.1.Street.Address,]
dupM1 <- dupM1[!duplicated(dupM1$NPI),]
dupM1 <- dupM1[!duplicated(dupM1$PPI),]

# remove matches from dup list
MPd <- sqldf('select MPd.*,dupM1.NPI as "uNPI" from MPd left outer join dupM1 on MPd.NPI = dupM1.NPI')
MPd <- MPd[is.na(MPd$uNPI),]

MPd <- sqldf('select MPd.*,dupM1.PPI as "uPPI" from MPd left outer join dupM1 on MPd.PPI = dupM1.PPI')
MPd <- MPd[is.na(MPd$uPPI),]

MPd$uNPI<- NULL
MPd$uPPI <- NULL

# check if there are unique ones left
dupM2 <- MPd[!duplicated(MPd$NPI),]
dupM2 <- dupM2[!duplicated(dupM2$NPI),]

dupM <- merge(dupM1,dupM2, all = TRUE)

rm(dupM1)
rm(dupM2)

dupM <- dupM[!duplicated(dupM$NPI),]
dupM <- dupM[!duplicated(dupM$PPI),]
dupM <- dupM[,c(1,8)]

MP <- merge(MP,dupM, all = TRUE)
rm(dupM)
rm(MPd)

#
# ************************************************************************************************
# ***** Round 4 ALT First ALT Last ***************************************************************
# ************************************************************************************************
#
# update PCND master with matches, generate new working PCND files
#
OP_Summary <- sqldf('select OP_Summary.*, MP.NPI as "mNPI" from OP_Summary left outer join MP on OP_Summary.PPI = MP.PPI')
OP_Summary[!is.na(OP_Summary$mNPI),"NPI"] <- OP_Summary[!is.na(OP_Summary$mNPI),"mNPI"]
OP_Summary$mNPI <- NULL

PCND <- sqldf('select PCND.*, MP.PPI as "mPPI" from PCND left outer join MP on PCND.NPI = MP.NPI')
PCND[!is.na(PCND$mPPI),"PPI"] <- PCND[!is.na(PCND$mPPI),"mPPI"]
PCND$mPPI <- NULL
PCNDx <- PCND[PCND$PPI =="",]

PCND_CS <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name],[Line.1.Street.Address],City, State from PCNDx group by [NPI], [City],[State]')

PCND_CS_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_CS group by NPI ')
PCND_CS_dup_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count > 1,]
PCND_CS_uni_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count == 1,]

PCND_CS_dup<- semi_join(PCND_CS,PCND_CS_dup_cnt, by = "NPI" )
PCND_CS_uni<- semi_join(PCND_CS,PCND_CS_uni_cnt, by = "NPI" )

# start match

# match - first, last, city, state / alt first alt last

MP1 <- sqldf('select PCND_CS.NPI, OP_Summary.PPI from PCND_CS left outer join OP_Summary on PCND_CS.[Last.Name] = OP_Summary.Physician_Profile_Alternate_Last_Name and PCND_CS.[First.Name] = OP_Summary.Physician_Profile_Alternate_First_Name and PCND_CS.[City] = OP_Summary.Physician_Profile_City  and PCND_CS.[State] = OP_Summary.Physician_Profile_State where OP_Summary.NPI = ""')
MP1 <- MP1[!is.na(MP1$PPI),]

MP <- MP1

# process dups

rm(MP1)

MP_dupNPI <-  sqldf('select NPI, count(NPI) as "num" from MP group by NPI')
MP_dupNPI <- MP_dupNPI[MP_dupNPI$num >1,]

MP_dupPPI <-  sqldf('select PPI, count(PPI) as num from MP group by PPI')
MP_dupPPI <- MP_dupPPI[MP_dupPPI$num >1,]

MPd1 <- sqldf('select MP.* from MP join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MPd2 <- sqldf('select MP.* from MP join MP_dupPPI on MP.PPI = MP_dupPPI.PPI')
MPd <- merge(MPd1,MPd2, all = TRUE)
rm(MPd1)
rm(MPd2)

# remove dups from MP
MP <- sqldf('select MP.*, MP_dupNPI.NPI as "dup" from MP left outer join MP_dupNPI on MP.NPI = MP_dupNPI.NPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

MP <- sqldf('select MP.*, MP_dupPPI.PPI as "dup" from MP left outer join MP_dupPPI on MP.NPI = MP_dupPPI.PPI')
MP <- MP[is.na(MP$dup),]
MP$dup <- NULL

rm(MP_dupNPI)
rm(MP_dupPPI)

#check for matches using address

MPd <- sqldf('select PCND_CS.*,MPd.PPI as "jPPI" from PCND_CS join MPd on PCND_CS.NPI = MPd.NPI')
MPd <- sqldf('select MPd.*,OP_Summary.* from OP_Summary join MPd on OP_Summary.PPI = MPd.jPPI')
MPd$jPPI <- NULL

dupM1 <- MPd[MPd$Physician_Profile_Address_Line_1 == MPd$Line.1.Street.Address,]
dupM1 <- dupM1[!duplicated(dupM1$NPI),]
dupM1 <- dupM1[!duplicated(dupM1$PPI),]

# remove matches from dup list
MPd <- sqldf('select MPd.*,dupM1.NPI as "uNPI" from MPd left outer join dupM1 on MPd.NPI = dupM1.NPI')
MPd <- MPd[is.na(MPd$uNPI),]

MPd <- sqldf('select MPd.*,dupM1.PPI as "uPPI" from MPd left outer join dupM1 on MPd.PPI = dupM1.PPI')
MPd <- MPd[is.na(MPd$uPPI),]

MPd$uNPI<- NULL
MPd$uPPI <- NULL

# check if there are unique ones left
dupM2 <- MPd[!duplicated(MPd$NPI),]
dupM2 <- dupM2[!duplicated(dupM2$NPI),]

dupM <- merge(dupM1,dupM2, all = TRUE)

rm(dupM1)
rm(dupM2)

dupM <- dupM[!duplicated(dupM$NPI),]
dupM <- dupM[!duplicated(dupM$PPI),]
dupM <- dupM[,c(1,8)]

MP <- merge(MP,dupM, all = TRUE)
rm(dupM)
rm(MPd)
#
# update PCND master with matches, generate new working PCND files (last)
#
OP_Summary <- sqldf('select OP_Summary.*, MP.NPI as "mNPI" from OP_Summary left outer join MP on OP_Summary.PPI = MP.PPI')
OP_Summary[!is.na(OP_Summary$mNPI),"NPI"] <- OP_Summary[!is.na(OP_Summary$mNPI),"mNPI"]
OP_Summary$mNPI <- NULL

PCND <- sqldf('select PCND.*, MP.PPI as "mPPI" from PCND left outer join MP on PCND.NPI = MP.NPI')
PCND[!is.na(PCND$mPPI),"PPI"] <- PCND[!is.na(PCND$mPPI),"mPPI"]
PCND$mPPI <- NULL
#
# *************************************************************************************************
# Clean up 

# Generate Round 2 match list
PCND <- sqldf('select PCND.NPI, PCND.PPI , PCND.Gender, PCND.[Medical.school.name] as "MedSchool",PCND.State, PCND.[Graduation.year] as "GraduationYear" from PCND group by PCND.NPI')

StudyGroup2 <- PCND[,c(1,2)]
StudyGroup2 <- StudyGroup2[StudyGroup2$PPI != "",]
StudyGroup <- merge(StudyGroup1, StudyGroup2, all = TRUE)

rm(PCND)
rm(PCND2)

#update PCND with Round 1 and Round 2 lists
PCND <- sqldf('select PCND1.*, StudyGroup2.PPI as "R2PPI" from PCND1 left outer join StudyGroup2 on PCND1.NPI = StudyGroup2.NPI')
PCND[is.na(PCND$PPI),"PPI"] <- PCND[is.na(PCND$PPI),"R2PPI"]
PCND$R2PPI <- NULL
rm(PCND1)

write.csv(PCND,"PCND.csv", row.names = FALSE)
write_rds(PCND,"PCND.rds")
write.csv(StudyGroup, "studygroupR2.csv", row.names = FALSE)
write_rds(StudyGroup,"StudyGroupR2.rds")
PCND_UnMatched <- PCND[is.na(PCND$PPI),]

PCND <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File2.csv", stringsAsFactors=FALSE)
PCND <- filter(PCND, PCND$State %nin% c("AP","AE", "AS", "FM", "GU", "MH","MP", "PR","PW","UM","VI", "ZZ"))
PCND <- filter(PCND, (PCND$Primary.specialty %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  | (PCND$Secondary.specialty.1 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$Secondary.specialty.2 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$Secondary.specialty.3 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (PCND$Secondary.specialty.4 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  ) 

PCND_UnMatchedx <- sqldf('select PCND.* from PCND_UnMatched left outer join PCND on PCND.NPI = PCND_UnMatched.NPI')
PCND_UnMatchedx <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name],[Line.1.Street.Address],City, State, [Zip.Code] from PCND_UnMatchedx group by [NPI]')

write.csv(PCND_UnMatchedx,"PCND_UnMatched.csv", row.names = FALSE)

# rm(PCND)
# rm(PCND_CS)
# rm(PCND_CS_cnt)
# rm(PCND_CS_dup)
# rm(PCND_CS_dup_cnt)
# rm(PCND_CS_uni)
# rm(PCND_CS_uni_cnt)
# rm(PCND_ZIP)
# rm(PCND_ZIP_cnt)
# rm(PCNDx)
# rm(MP)
# rm(OP_Summary)

# *************************************************************************************************************************************************************************
# update OP with matched based on PCND, add specialty, filter on OBGYN (i.e., build list of unmatched OBGYN in OP)


OP<- sqldf('select OP.*, StudyGroup.NPI from OP left outer join StudyGroup on OP.Physician_Profile_ID = StudyGroup.PPI')

OP[OP$NPPES_NPI =="","NPPES_NPI"] <- OP[OP$NPPES_NPI =="","PCND_NPI"]
OP$PCND_NPI <- NULL
names(OP)[15] <- "NPI"
OP_UnMatched <- OP[is.na(OP$NPI),]
OP_Matched <- OP[!is.na(OP$NPI),]

#OP_Spec <- read.csv("D:/muffly/data/Originals/match_data/OP_PH_PRFL_SPLMTL_P06292018_tax.csv", stringsAsFactors=FALSE)
OP_Spec <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P06292018_tax.csv", stringsAsFactors=FALSE)

  
  
OP_UnMatched <- sqldf('select OP_UnMatched.*, OP_Spec.Physician_Profile_Primary_Specialty from OP_UnMatched left outer join OP_Spec on OP_Unmatched.Physician_Profile_ID = OP_Spec.Physician_Profile_ID')
OP_UnMatched_OBGYN <- filter(OP_UnMatched, OP_UnMatched$Physician_Profile_Primary_Specialty %in% c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology","Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine","Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology"))

write.csv(OP_UnMatched,"OP_UnMatched.csv", row.names = FALSE)
write.csv(OP_UnMatched_OBGYN,"OP_UnMatched_OBGYN.csv", row.names = FALSE)

beepr::beep(sound = 5)
beepr::beep(sound = 5)
beepr::beep(sound = 5)
