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
  dplyr::select(starts_with("Provider.")) %>% 
  dplyr::select(NPI) %>%
  dplyr::filter(Entity.Type.Codes == "1") %>%
  dplyr::filter(Provider.Business.Practice.Location.Address.State.Name %nin% c("ZZ", "AS", "FM", "GU", "MH", "MP", "PW", "VI"))

readr::write_csv(NPPES, "/Volumes/Projects/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_2.csv")
