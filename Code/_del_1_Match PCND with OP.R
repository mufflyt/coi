# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("tidyverse")
install.packages("Hmisc")
# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("tidyverse")
library ("Hmisc")


#PCND <- read.csv("D:/muffly/data/Originals/Physician_Compare/Physician_Compare_National_Downloadable_File.csv", stringsAsFactors=FALSE)

PCND <- readr::read_csv("/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File2.csv") 

PCND_CS <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name],[Line.1.Street.Address],City, State from PCND group by [NPI], [City],[State]')  #PCND by city and state, so that is what PCND_CS stands for 

PCND_ZIP <- sqldf('select NPI, [Last.Name], [First.Name],[Middle.Name], [Line.1.Street.Address],[Zip.Code] from PCND group by [NPI], [Zip.Code]')

PCND_CS_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_CS group by NPI ')
PCND_CS_dup_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count > 1,]
PCND_CS_uni_cnt <- PCND_CS_cnt[PCND_CS_cnt$Count == 1,]

PCND_CS_dup<- semi_join(PCND_CS,PCND_CS_dup_cnt, by = "NPI" )
PCND_CS_uni<- semi_join(PCND_CS,PCND_CS_uni_cnt, by = "NPI" )

PCND_ZIP_cnt <- sqldf('select NPI, Count(NPI) as "Count" from PCND_ZIP group by NPI ')

# load payment data

#OP_Summary <- read.csv("D:/muffly/data/Originals/PHPRFL_P062819/OP_PH_PRFL_SPLMTL_P06282019.csv", stringsAsFactors=FALSE)
OP_Summary <- read.csv("/Volumes/Projects/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01172020_2.csv", stringsAsFactors=FALSE)

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


PCND <- sqldf('select PCND.NPI, PCND.Gender, PCND.[Medical.school.name] as "MedSchool",PCND.State, PCND.[Graduation.year] as "GraduationYear" from PCND group by PCND.NPI')

PCND <- sqldf('select PCND.NPI, MP.PPI, PCND.Gender, PCND.MedSchool,PCND.State, PCND.GraduationYear from PCND left outer join MP on PCND.NPI = MP.NPI')

write.csv(MP, "studygroupR2.csv", row.names = FALSE)
write.csv(PCND, "PCND.csv", row.names = FALSE)
write_rds(MP,"StudyGroupR2.rds")

rm(PCND_CS)
rm(PCND_CS_cnt)
rm(PCND_CS_dup)
rm(PCND_CS_dup_cnt)
rm(PCND_CS_uni)
rm(PCND_CS_uni_cnt)
rm(PCND_ZIP)
rm(PCND_ZIP_cnt)

