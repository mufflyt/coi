# Loading
library("sqldf", lib.loc="~/R/win-library/3.2")
library("qdapRegex", lib.loc="~/R/win-library/3.2")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("readr")


GOBA_unique <- read.csv("/Volumes/Pharma_Influence/Data/GOBA_unique_2.csv", stringsAsFactors=FALSE)

GOBA <- GOBA_unique#[,c(4,13,15,18)]  #this might be an issue
GOBA_Compare <- sqldf('select GOBA.*, StudyGroup.PPI from GOBA left outer join StudyGroup on GOBA.NPI = StudyGroup.NPI')
GOBA_Comparex <- sqldf('select GOBA_Compare.*, OP_Info.Physician_Profile_Primary_Specialty from GOBA_Compare left outer join OP_Info on GOBA_Compare.OP_Physician_Profile_ID = OP_Info.Physician_Profile_ID')
GOBAx <- GOBA[!is.na(GOBA$NPI_Match),]

GOBAx <- sqldf('select GOBAx.*, Prescriber_Name.npi from GOBAx left outer join Prescriber_Name on GOBAx.NPI = Prescriber_Name.npi')

write.csv(GOBA_Comparex,"GOBA_Compare.csv", row.names = FALSE)