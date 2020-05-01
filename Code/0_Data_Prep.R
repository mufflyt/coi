## Setup file

# Loading
#rm(list = setdiff(ls(), lsf.str())). #cleans all environment except functions

# Installing
# install.packages("readr")
# install.packages("qdapRegex")
# install.packages("sqldf")
# install.packages("Hmisc")
# install.packages('reshape')
# install.packages('reshape2')
# install.packages("tidyverse")

# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("Hmisc")
library('reshape')
library('reshape2')
library("tidyverse")

#Prep to PCND to get it managable and save as a new CSV for use
PCND <- readr::read_csv("/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv") %>% 
  dplyr::select(NPI, lst_nm, frst_nm, mid_nm, gndr, Med_sch, Grd_yr, pri_spec, sec_spec_1, sec_spec_2, sec_spec_3, sec_spec_4, adr_ln_1, cty, st, zip) %>%
  rename(State = st, City = cty, Zip.Code = zip, First.Name = frst_nm, Last.Name = lst_nm, Middle.Name = mid_nm, Primary.specialty = pri_spec, Secondary.speciality.1 = sec_spec_1, Secondary.speciality.2 = sec_spec_2, Secondary.speciality.3 = sec_spec_3, Secondary.speciality.4 = sec_spec_4, Line.1.Street.Address = adr_ln_1, Gender = gndr, Medical.School.Name = Med_sch, Graduation.year = Grd_yr)
readr::write_csv(PCND, "/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File2.csv")

#Prep NPPES to get it managable and save as new csv for use
NPPES <- read.csv("/Volumes/Projects/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412.csv", stringsAsFactors = FALSE) %>%
dplyr::filter(Entity.Type.Code == "1") %>%  #Remove all hospitals and nursing homes
dplyr::filter(Provider.Business.Practice.Location.Address.State.Name %nin% c("ZZ", "AS", "FM", "GU", "MH", "MP", "PW", "VI")) %>% #Take out the places are not in the United States
  dplyr::select(c("NPI", starts_with("Provider")) %>% #Then select out the columns that you want
  dplyr::select(c(-contains("License.Number", -"Provider.Enumeration.Date", -contains(".Second.Line."), -ends_with(".Number"))))

readr::write_csv(NPPES, "/Volumes/Projects/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_2.csv")



#Prep GOBA_unique.csv for use with demographics
GOBA_unique <- read.csv("/Volumes/Projects/Pharma_Influence/Data/GOBA_unique.csv", stringsAsFactors = FALSE) %>%
  dplyr::select(NPI_Match, GOBA_ID, GOBA_Full.Name, GOBA_State, GOBA_Cert, OP_Physician_Profile_ID) %>%
  rename(NPI = NPI_Match) %>%
  distinct(NPI, .keep_all = TRUE) %>%
  distinct(GOBA_ID, .keep_all = TRUE) %>%
  drop_na(NPI) %>%
  mutate(GOBA_Cert = recode(GOBA_Cert, `Family Planning` = "Obstetrics and Gynecology", `Hospice and Palliative Care` = "Gynecologic Oncology", `Critical Care` = "Gynecologic Oncology")) %>%
  filter(GOBA_State %nin% c("-", "--", ".", "..", "0", "21", "310 42 HAVERDAL", "AB", "ABU DHABI", "AE", "AG", "AL-KHOBAR", "ALEXANDRIA", "AMMAN", "ANTWERP", "AP", "APO NEW YORK", "APO SAN FRANCISCO", "BA", "BANGKOK", "BARDI PARMA", "BC", "BE", "BR", "BUDAPEST", "C0", "CENTRAL", "CN", "DAMASCUS", "DHAHRAN", "DI", "DUNEDIN", "ECUADOR", "F", "FR", "GIVAT SHMUEL", "GM", "GR", "GU", "GUAYNABO", "HONG KONG", "IO", "IS", "JEDDAH", "JERUSALEM", "KE", "KENT", "KFAR-SABA UU356", "KP", "UK", "LAHORE", "LS", "MP", "MERCIER", "MU", "N/", "NASSAU", "NEW DELHI", "NL", "NR", "NS", "NZ", "ON", "OT", "P", "PARANAQUE", "PQ", "TEGUCIGALPA", "QA", "QB", "QC", "QL", "QU", "UMM AL QUWAIN", "RANANNA", "RE", "RM", "SAHUVAL", "SAN JUAN", "SINAJONA", "SK", "SO", "US", "TAEGU", "TAMILNADU", "TAMUNING", "TEHRAN 19177", "TR", "UR", "VANCOUVER BC", "VI", "WALES", "WARWICK", "ZI")) %>%
  mutate(ACOG_Region = GOBA_State, ACOG_Region = recode_factor(ACOG_Region, CO = "District VIII", AL = "District VII", AR = "District VII", AZ = "District VIII", CA = "District IX", FL = "District XII", GA = "District IV", HI = "District VIII", IA = "District VI", ID = "District VIII", IL = "District VI", IN = "District V", KS = "District VII", LA = "District VII", MA = "District I", MD = "District IV", ME = "District I", MI = "District V", MN = "District VI", MO = "District VII", NC = "District IV", NH = "District I", NJ = "District III", NM = "District VIII", NY = "District II", OH = "District V", OR = "District VIII", PA = "District III", RI = "District I", SD = "District IV", TN = "District VII", TX = "District XI", VA = "District IV", WA = "District VIII", WI = "District VI", CT = "District I", DC = "District IV", KY = "District V", MS = "District VII", NE = "District VI", NV = "District VIII", SC = "District IV", WV = "District IV", UT = "District VIII", AK = "District VIII", DE = "District III", OK = "District VII"))  %>%
  mutate(ACOG_Region = fct_other(ACOG_Region, keep = c("District I", "District II", "District III", "District IV", "District V", "District VI", "District VII", "District VIII", "District IX", "District XI", "District XII"))) %>%
  rename(`American Congress of Obstetricians and Gynecologists District` = ACOG_Region) %>%
  mutate(`American Congress of Obstetricians and Gynecologists District` = recode(`American Congress of Obstetricians and Gynecologists District`, `District I` = "District I (Atlantic Provinces, Connecticut, Maine, Massachusetts, Rhode Island, Vermont)", `District II` = "District II (New York)", `District III` = "District III (Delaware, New Jersey, Pennsylvania)", `District IV` = "District IV (District of Columbia, Georgia, Maryland, North Carolina, South Carolina, Virginia, West Virginia)", `District V` = "District V (Indiana, Kentucky, Ohio, Michigan)", `District VI` = "District VI (Illinois, Iowa, Minnesota, Nebraska, North Dakota, South Dakota, Wisconsin)", `District VII` = "District VII (Alabama, Arkansas, Kansas, Louisiana, Mississippi, Missouri, Oklahoma, Tennessee)", `District VIII` = "District VIII (Alaska, Arizona, Colorado, Hawaii, Idaho, Montana, Nevada, New Mexico, Oregon, Utah, Washington, Wyoming)", `District IX` = "District IX (California)", `District XI` = "District XI (Texas)", `District XII` = "District XII (Florida)"))

write_csv(GOBA_unique, "/Volumes/Projects/Pharma_Influence/Data/GOBA_unique_2.csv")


