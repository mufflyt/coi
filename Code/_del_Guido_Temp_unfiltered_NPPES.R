
#load results from first found GOBA Match, Load unfiltered NOB, transfer matching data so GOBA match can be repeated with huge dataset .. (gotta catch'em all)

GOBA_Match_NPPES_Matched <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_Matched.csv",stringsAsFactors = FALSE)
NOD_Match_Unfil <- read.csv("~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/NPPES_DEMO.csv", stringsAsFactors=FALSE)
#
# update NOD_Match_Unfil with matches so that process can restart with unfiltered dataset
#
NOD_Match_Unfil <- sqldf('select NOD_Match_Unfil.*, GOBA_Match_NPPES_Matched.[ID] as m_ID, GOBA_Match_NPPES_Matched.[NPI] as m_NPI, GOBA_Match_NPPES_Matched.[Type] as m_Type from NOD_Match_Unfil LEFT OUTER JOIN GOBA_Match_NPPES_Matched on NOD_Match_Unfil.[NPI] = GOBA_Match_NPPES_Matched.[NPI]')
NOD_Match_Unfil[!is.na(NOD_Match_Unfil$m_ID),"GOB_ID"] <-  NOD_Match_Unfil[!is.na(NOD_Match_Unfil$m_ID),"m_ID"]
NOD_Match_Unfil[!is.na(NOD_Match_Unfil$m_Type),"Type"] <-  NOD_Match_Unfil[!is.na(NOD_Match_Unfil$m_Type),"m_Type"]
NOD_Match_Unfil$m_ID<- NULL
NOD_Match_Unfil$m_NPI <- NULL
NOD_Match_Unfil$m_Type <- NULL
NOD_Match <- NOD_Match_Unfil
#