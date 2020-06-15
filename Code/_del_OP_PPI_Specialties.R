library("sqldf", lib.loc="~/R/win-library/3.2")
library("qdapRegex", lib.loc="~/R/win-library/3.2")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("readr")

#Start

OP_13 <- read.csv("D:/muffly/data/Originals/PGYR13_P062918/OP_DTL_GNRL_PGYR2013_P06292018.csv",stringsAsFactors = FALSE)
OP_13 <- sqldf('select OP_13.Physician_Profile_ID, OP_13.Physician_Specialty  from OP_13 group by OP_13.Physician_Profile_ID' )

OP_14 <- read.csv("D:/muffly/data/Originals/PGYR14_P062918/OP_DTL_GNRL_PGYR2014_P06292018.csv",stringsAsFactors = FALSE)
OP_14<- sqldf('select OP_14.Physician_Profile_ID, OP_14.Physician_Specialty  from OP_14 group by OP_14.Physician_Profile_ID ' )

OP_15 <- read.csv("D:/muffly/data/Originals/PGYR15_P062918/OP_DTL_GNRL_PGYR2015_P06292018.csv",stringsAsFactors = FALSE)
OP_15<- sqldf('select OP_15.Physician_Profile_ID, OP_15.Physician_Specialty  from OP_15 group by OP_15.Physician_Profile_ID' )

OP_16 <- read.csv("D:/muffly/data/Originals/PGYR16_P062918/OP_DTL_GNRL_PGYR2016_P06292018.csv",stringsAsFactors = FALSE)
OP_16<- sqldf('select OP_16.Physician_Profile_ID, OP_16.Physician_Specialty  from OP_16 group by OP_16.Physician_Profile_ID' )

OP_17 <- read.csv("D:/muffly/data/Originals/PGYR17_P062918/OP_DTL_GNRL_PGYR2017_P06292018.csv",stringsAsFactors = FALSE)
OP_17<- sqldf('select OP_17.Physician_Profile_ID, OP_17.Physician_Specialty  from OP_17 group by OP_17.Physician_Profile_ID' )

OPx <- merge(OP_13, OP_14, all = TRUE)
OPx <- merge(OPx, OP_15, all = TRUE)
OPx <- merge(OPx, OP_16, all = TRUE)
OPx <- merge(OPx, OP_17, all = TRUE)

rm(OP_13)
rm(OP_14)
rm(OP_15)
rm(OP_16)
rm(OP_17)

OPx_Name <- sqldf('select OPx.Physician_Profile_ID, OPx.Physician_Specialty from OPx group by OPx.Physician_Profile_ID')
OPx_SP <- OPx_Name[!is.na(OPx_Name$Physician_Profile_ID),]
write.csv(OPx_SP,"OP_AllSpecialty.csv", row.names = FALSE)
