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
# install.packages("readxl")

# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("Hmisc")
library('reshape')
library('reshape2')
library("tidyverse")
library("readxl")

#Prep to PCND to get it managable and save as a new CSV for use
#https://data.medicare.gov/Physician-Compare/Physician-Compare-National-Downloadable-File/mj5m-pzi6
#The API is nice because you do not have to store a huge file or take the time to download it.  
PCND <- read.socrata(
    "https://data.medicare.gov/resource/mj5m-pzi6.json",
    app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
    email     = "tyler.muffly@dhha.org",
    password  = "Balance1"
  ) %>%
  distinct(npi, .keep_all = TRUE) %>%
  tidyr::drop_na(npi) %>%
  dplyr::select(npi, lst_nm, frst_nm, mid_nm, cred, gndr, med_sch, grd_yr, pri_spec, sec_spec_1, sec_spec_2, sec_spec_3, sec_spec_4, adr_ln_1, cty, st, zip) %>%
  dplyr::rename(State = st, City = cty, Zip.Code = zip, First.Name = frst_nm, Last.Name = lst_nm, Middle.Name = mid_nm, Primary.specialty = pri_spec, Secondary.specialty.1 = sec_spec_1, Secondary.specialty.2 = sec_spec_2, Secondary.specialty.3 = sec_spec_3, Secondary.specialty.4 = sec_spec_4, Line.1.Street.Address = adr_ln_1, Gender = gndr, Medical.School.Name = med_sch, Graduation.year = grd_yr) %>%
  dplyr::filter(State %nin% c("AP","AE", "AS", "FM", "GU", "MH","MP", "PR","PW","UM","VI", "ZZ")) %>%
  dplyr::filter(Primary.specialty %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))  | (Secondary.specialty.1 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (Secondary.specialty.2 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (Secondary.specialty.3 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) | (Secondary.specialty.4 %in% c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY")) %>%
  substr(Zip.Code,1,5) %>%
  arrange (Last.Name) %>%
  tolower(c(Last.Name, First.Name, Middle.Name, Line.1.Street.Address, City, State)) %>%
  readr::write_csv("/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File2.csv")


#Prep downloaded file NPPES to get it managable and save as new csv for use
NPPES <- read.csv("/Volumes/Projects/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412.csv", stringsAsFactors = FALSE) %>%
dplyr::filter(Entity.Type.Code == "1") %>%  #Remove all hospitals and nursing homes
dplyr::filter(Provider.Business.Practice.Location.Address.State.Name %nin% c("ZZ", "AS", "FM", "GU", "MH", "MP", "PW", "VI")) %>% #Take out the places are not in the United States
  dplyr::select(c("NPI", starts_with("Provider"))) %>% #Then select out the columns that you want
  dplyr::select(c(-contains("License.Number"), -"Provider.Enumeration.Date", -contains(".Second.Line."), -ends_with(".Number")))

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

#Rural zip Codes Imported
rural_zip_codes <- readxl::read_xlsx("/Volumes/Projects/Pharma_Influence/Data/Rurality/nonmetrocountiesandcts2016.xlsx") %>%
  dplyr::select(-CT, -`RUCA 2010`, -Memo) %>%
  dplyr::rename(State = ST, Zip_Code = `CTY FIPS`) %>%
  distinct(Zip_Code, .keep_all = TRUE) %>%
  mutate(Rural_Zip_codes = "Rural Zip codes")

#Open Payments
#https://openpaymentsdata-origin.cms.gov/dataset/Open-Payments-for-Developers/ap6w-xznw
taxonomy_codes <- c("207V00000X", #Blank, general obgyn
                    "207VB0002X", #Obesity Medicine
                    "207VC0200X", #Critical Care Medicine
                    "207VE0102X", #Reproductive Endocrinology
                    "207VF0040X", #Female Pelvic Medicine and Reconstructive Surgery
                    "207VG0400X", # Gynecology
                    "207VH0002X", #Hospice and Palliative Medicine
                    "207VM0101X", #Maternal & Fetal Medicine
                    "207VX0000X", #Obstetrics
                    "207VX0201X") #Gynecologic Oncology

#https://dev.socrata.com/foundry/openpaymentsdata.cms.gov/tr8n-5p4d
#Takes about 10 minutes
Physician_Profile_Data <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/tr8n-5p4d.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
) %>%
  dplyr::select(physician_profile_id, physician_profile_first_name, physician_profile_middle_name, physician_profile_last_name, physician_profile_alternate_first_name, physician_profile_alternate_middle_name, physician_profile_alternate_last_name, physician_profile_address_line_1, physician_profile_city, physician_profile_state, physician_profile_zipcode, physician_profile_country_name, physician_profile_primary_specialty, physician_profile_ops_taxonomy_1, physician_profile_ops_taxonomy_2, physician_profile_ops_taxonomy_3, physician_profile_ops_taxonomy_4, physician_profile_ops_taxonomy_5) %>%
  filter(physician_profile_country_name=="UNITED STATES") %>%
  filter(physician_profile_ops_taxonomy_1 %in% taxonomy_codes
         | physician_profile_ops_taxonomy_2 %in% taxonomy_codes
         | physician_profile_ops_taxonomy_3 %in% taxonomy_codes
         | physician_profile_ops_taxonomy_4 %in% taxonomy_codes
         | physician_profile_ops_taxonomy_5 %in% taxonomy_codes)


#General Payment Data – Detailed Dataset 2013 Reporting Year
OP2013 <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/9gtv-e3na.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
) %>%
  dplyr::select(-starts_with("teaching"), -ends_with("_of_travel"), -change_type, -recipient_primary_business_street_address_line2, -recipient_province, -starts_with"physician_license_")

#General Payment Data – Detailed Dataset 2014 Reporting Year
OP2014 <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/csst-wbe8.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
)

#General Payment Data – Detailed Dataset 2015 Reporting Year
OP2015 <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/rqr8-e3gy.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
)

#General Payment Data – Detailed Dataset 2016 Reporting Year
OP2016 <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/daqx-kcwf.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
)

#General Payment Data – Detailed Dataset 2017 Reporting Year
OP2017 <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/trby-32sz.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
)

#General Payment Data – Detailed Dataset 2018 Reporting Year
OP2018 <- read.socrata(
  "https://openpaymentsdata.cms.gov/resource/9gtv-e3na.json",
  app_token = "vZUBqP0g0i4Lr3vXOqNxCjzyL",
  email     = "tyler.muffly@dhha.org",
  password  = "Balance1"
)


