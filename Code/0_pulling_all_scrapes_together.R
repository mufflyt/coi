# Setup to Create GOBA file----
# Set libPaths.
rm(list = setdiff(ls(), lsf.str()))
.libPaths("/Users/tylermuffly/.exploratory/R/3.6")
here::set_here()

# Load required packages.....
library(geosphere)
library(gmapsdistance)
library(zipcode)
library(R.utils)
library(janitor)
library(lubridate)
library(hms)
library(tidyr)
library(stringr)
library(readr)
library(forcats)
library(RcppRoll)
library(dplyr)
library(tibble)
library(bit64)
library(exploratory)
library(RDSTK)

# Read in all data of GOBA scrapes ----
# We start with a list of FPMRS physicians and the year that they were boarded called all_bound_together.csv.  The data is filtered for providers who are retired, not in the United States, and has a unique random id.  

#####Alternative that is cleaner
###Scrapes from COVID-19 time in March 2020
###  https://www.r-bloggers.com/merge-all-files-in-a-directory-using-r-into-a-single-dataframe/
setwd("~/Dropbox/workforce/scraper/Scraper_results_2019/")
file_list <- list.files()
file_list

for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.csv(file, header=TRUE, sep=",")
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <- read.csv(file, header=TRUE, sep=",")
    dataset<- dplyr::bind_rows(dataset, temp_dataset) %>%
      distinct(userid, .keep_all = TRUE) %>%
      filter(!is.na(userid) & !is.na(name)) %>%
      filter(!is.na(city)) %>%
      mutate(userid = coalesce(userid, ID)) %>%
      mutate(certStatus = recode(certStatus, `Not Certified` = "Not Currently Certified", `Not Currently Certified` = "Not Currently Certified")) %>%
      mutate_at(vars(userid, ID), funs(parse_number))
    
    rm(temp_dataset)
  }
  
}
dim(dataset)
View(dataset)
readr::write_csv(dataset, "~/Dropbox/Pharma_Influence/Data/GOBA/goba_scraper_merged.csv")
GOBA_rough <- read_csv("~/Dropbox/Pharma_Influence/Data/GOBA/goba_scraper_merged.csv")
rm(dataset)

setwd("~/Dropbox/Pharma_Influence/")

dim(GOBA)
############
GOBA <- GOBA_rough %>% #aka dataset
  dplyr::distinct(userid, .keep_all = TRUE) %>%
  dplyr::select(-starts_with("ID.new")) %>%
  dplyr::arrange(desc(userid)) %>%
  dplyr::filter(sub1certStatus %nin% c("Retired")) %>%
  dplyr::filter(sub2certStatus %nin% c("Retired")) %>%
  dplyr::filter(certStatus %nin% c("Retired")) %>%
  dplyr::filter(state %nin% c("ON", "AB")) %>%
  dplyr::mutate(Year_Boarded = lubridate::year(orig_sub)) %>%
  separate(name, into = c("full_name", "degree"), sep = "\\s*\\,\\s*", convert = TRUE) %>%
  mutate(degree = str_remove_all(degree, "[[:punct:]]+")) %>%
  mutate(degree = recode(degree, Jr = "NA", MB = "NA", II = "NA", III = "NA", IV = "NA", Md = "MD", Dr = "NA", Sr = "NA", PhD = "NA", Lambers = "NA", MS = "NA", `MD MSPH` = "NA", `MD PhD` = "MD", `MD COL` = "MD", `M D` = "MD", Demott = "NA", JD = "NA", Mrs = "NA", MPH = "NA")) %>%
  mutate(full_name = humaniformat::format_period(full_name)) %>%
  mutate(degree = na_if(degree, "NA")) %>%
  mutate(first_name = humaniformat::first_name(full_name)) %>%
  mutate(last_name = humaniformat::last_name(full_name)) %>%
  mutate(middle_name = humaniformat::middle_name(full_name)) %>%
  mutate(middle_name = str_remove_all(middle_name, "[[:punct:]]+")) %>%
  mutate_at(vars(first_name, last_name, middle_name), funs(str_to_title)) %>%
  distinct(userid, .keep_all = TRUE) %>%
  reorder_cols(userid, full_name, city, state, startDate, certStatus, mocStatus, sub1, sub1startDate, sub1certStatus, sub1mocStatus, sub2, sub2startDate, sub2certStatus, sub2mocStatus, clinicallyActive, orig_sub, x_sub_orig, orig_bas, ID, DateTime, Year_Boarded, first_name, last_name, middle_name, degree) %>%
  filter(state %nin% c("-", "--", ".", "..", "0", "21", "310 42 HAVERDAL", "AB", "ABU DHABI", "AE", "AG", "AL-KHOBAR", "ALEXANDRIA", "AMMAN", "ANTWERP", "AP", "APO NEW YORK", "APO SAN FRANCISCO", "BA", "BANGKOK", "BARDI PARMA", "BC", "BE", "BR", "BUDAPEST", "C0", "CENTRAL", "CN", "DAMASCUS", "DHAHRAN", "DI", "DUNEDIN", "ECUADOR", "F", "FR", "GIVAT SHMUEL", "GM", "GR", "GU", "GUAYNABO", "HONG KONG", "IO", "IS", "JEDDAH", "JERUSALEM", "KE", "KENT", "KFAR-SABA UU356", "KP", "UK", "LAHORE", "LS", "MP", "MERCIER", "MU", "N/", "NASSAU", "NEW DELHI", "NL", "NR", "NS", "NZ", "ON", "OT", "P", "PARANAQUE", "PQ", "TEGUCIGALPA", "QA", "QB", "QC", "QL", "QU", "UMM AL QUWAIN", "RANANNA", "RE", "RM", "SAHUVAL", "SAN JUAN", "SINAJONA", "SK", "SO", "US", "TAEGU", "TAMILNADU", "TAMUNING", "TEHRAN 19177", "TR", "UR", "VANCOUVER BC", "VI", "WALES", "WARWICK", "ZI"))  %>%
  mutate(middle_name = impute_na(middle_name, type = "value", val = ""), city = str_to_title(city)) %>%
  unite(GOBA.full.name.1, first_name, middle_name, last_name, sep = " ", remove = FALSE, na.rm = FALSE) %>%
  unite(GOBA.full.name.state, first_name, middle_name, last_name, state, sep = " ", remove = FALSE, na.rm = FALSE) %>%
  mutate(GOBA.full.name.state = str_clean(GOBA.full.name.state)) %>%
  readr::write_csv("~/Dropbox/Pharma_Influence/Data/GOBA.csv")

dim(GOBA)
colnames(GOBA)
head(GOBA, 200)
dplyr::glimpse(GOBA)
