#Download the 2016 PUF NPI DRUG 16.txt  trying URL 'https://www.dropbox.com/s/xzjxw5etettxjas/PartD_Prescriber_PUF_NPI_Drug_16.txt?raw=1'Content type 'text/plain' length 3200631461 bytes (3052.4 MB)

#Maybe start with the docs who make money from drug companies and then find out if those companies make the drug that they prescribed.  

#Objective:  To study the association between obstetrician-gynecologists physicians’ receipt of industry-sponsored money, and rates of prescribing the promoted drug to Medicare beneficiaries.

# DESIGN, SETTING, AND PARTICIPANTS
# Cross-sectional analysis of industry payment data from the federal Open Payments Program for August 1, 2013 to December 31, 2017, and prescribing data for individual physicians from Medicare Part D, for a four and a half year period. Participants were OBGYN physicians who wrote Medicare prescriptions in any of 4 drug classes: anticholinergics, vaginal estrogen replacement, yeast treatment, and probably will add more. We identified physicians who received industry-sponsored money promoting the most-prescribed brand-name drug in each class ###(?????????????rosuvastatin, nebivolol, olmesartan, and desvenlafaxine, respectively). 

# EXPOSURES
# Receipt of an industry-sponsored meal promoting the drug of interest.
# 
# MAINOUTCOMESANDMEASURES Prescribing rates of promoted drugs compared with alternatives in the same class, after adjustment for physician prescribing volume, demographic characteristics, specialty, and practice setting.
# 
# RESULTS A total of x physicians received x payments associated with the
# x target drugs. x percent of payments were meals, with a mean value of less than $20. Rosuvastatin represented 8.8% (SD, 9.9%) of statin prescriptions; nebivolol represented 3.3% (7.4%) of cardioselective β-blocker prescriptions; olmesartan represented 1.6% (3.9%) of ACE inhibitor and ARB prescriptions; and desvenlafaxine represented 0.6% (2.6%) of SSRI and SNRI prescriptions. Physicians who received a single meal promoting the drug of interest had higher rates of prescribing rosuvastatin over other statins (odds ratio [OR], 1.18; 95% CI, 1.17-1.18), nebivolol over other β-blockers (OR, 1.70; 95% CI, 1.69-1.72), olmesartan over other ACE inhibitors and ARBs (OR, 1.52; 95% CI, 1.51-1.53), and desvenlafaxine over other SSRIs and SNRIs (OR, 2.18; 95% CI, 2.13-2.23). Receipt of additional meals and receipt of meals costing more than $20 were associated with higher relative prescribing rates.

# CONCLUSIONS AND RELEVANCE Receipt of industry-sponsored money/meals? was associated with an increased rate of prescribing the brand-name medication that was being promoted. The findings represent an association, not a cause-and-effect relationship.

# Set libPaths.
.libPaths("/Users/tylermuffly/.exploratory/R/3.6")

# Load required packages.
if(!require(pacman))install.packages("pacman")
pacman::p_load('janitor', 'lubridate', 'hms', 'tidyr', 'devtools', 'purrr', 'readr', 'ggplot2', 'dplyr', 'forcats', 'RcppRoll', 'lubridate', 'hms', 'tidyr', 'stringr', "bit64", "remotes", "tidylog","inspectdf", "DataExplorer", "arsenal", "RCurl", "RSQLite", "DBI", "sqldf", "qdapRegex", "dplyr", "dbplyr", "RPostgreSQL", "data.table", "Hmisc", "rdrop2")

##################################################################
# create postgresql data base with the following commands in bash terminal
# psql postgres
# CREATE DATABASE pharma_influence;

# Connect to or create data base to perform data manipulation on disk
drv <- DBI::dbDriver("PostgreSQL")
con <- dbConnect(drv, user="tylermuffly", password="",
                 host="127.0.0.1", port=5432, dbname="pharma_influence")
##################################################################

drop_auth()
token <- drop_auth()
saveRDS(token, file = "token.rds")
drop_acc() %>% data.frame()
drop_dir() %>% 
  filter(.tag == "folder") %>%
  arrange(name) %>%
  View()

drop_dir("Pharma_Influence/data/National Drug Code Directory/") %>% View()
drop_download("Pharma_Influence/data/National Drug Code Directory/package.xls", overwrite = TRUE, progress=TRUE)

##################################################################
# Set data file locations ----
setwd("~/Dropbox/Pharma_Influence")
data_folder <- paste0(getwd(),"~/R Projects/Data/")
results_folder <- paste0(getwd(),"~/R Projects/Results/")
##################################################################
# Load data ----

# Directory:  Dropbox/Pharma_Influence/Data/Medicare Part D data/ PartD_Prescriber_PUF_DRUG_15
# File: PartD_Prescriber_PUF_NPI_Drug_15.txt
# Each row is one drug prescribed by one provider.  So there are many rows with one provider who prescribed multiple drugs.  
# Data dictionary: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/Prescriber_Methods.pdf 

#Part D Prescriber Public Use File (herein referred to as the “Part D Prescriber PUF”), with information on prescription drug events incurred by Medicare beneficiaries with a Part D prescription drug plan
# Steps to read in drug_prescribers_x_year

#Download file from https://www.cms.gov/research-statistics-data-and-systems/statistics-trends-and-reports/medicare-provider-charge-data/part-d-prescriber.html and extract the .txt file

#2014 year
# download.file("https://www.dropbox.com/s/pakz20fn1u8m5v2/PartD_Prescriber_PUF_NPI_Drug_14.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_14.txt", method = "auto")

PartD_Prescriber_PUF_NPI_Drug_14 <- read_delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_Drug_14.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  # Make all OBGYN the same factor with "Obstetrics & Gynecology"
  mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
  select(-description_flag, everything()) %>%
  select(generic_name, everything()) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  mutate (year = "2014") %>%
  filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))

#2015 year  
# download.file("https://www.dropbox.com/s/4xt8epb06xvnigo/PartD_Prescriber_PUF_NPI_Drug_15.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_15.txt", method = "auto", cacheOK = TRUE)

PartD_Prescriber_PUF_NPI_Drug_15 <- read_delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_Drug_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  # Make all OBGYN the same factor with "Obstetrics & Gynecology"
  mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
  select(-description_flag, everything()) %>%
  select(generic_name, everything()) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  mutate (year = "2015") %>%
  filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))

#2016 year 
download.file("https://www.dropbox.com/s/xzjxw5etettxjas/PartD_Prescriber_PUF_NPI_Drug_16.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_16.txt", method = "wget")

PartD_Prescriber_PUF_NPI_Drug_16 <- read_delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_Drug_16.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  # Make all OBGYN the same factor with "Obstetrics & Gynecology"
  mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
  select(-description_flag, everything()) %>%
  select(generic_name, everything()) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  mutate (year = "2016") %>%
  filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))

#2017 year
download.file("https://www.dropbox.com/s/7ovqho9pp6g6kft/PartD_Prescriber_PUF_NPI_Drug_17.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_17.txt", method = "auto")

PartD_Prescriber_PUF_NPI_Drug_17 <- read_delim("PartD_Prescriber_PUF_NPI_Drug_17.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  # Make all OBGYN the same factor with "Obstetrics & Gynecology"
  mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
  select(-description_flag, everything()) %>%
  select(generic_name, everything()) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  mutate (year = "2017") %>% 
  filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))

all_PUF_NPI_Drug <- dplyr::bind_rows(PartD_Prescriber_PUF_NPI_Drug_14, PartD_Prescriber_PUF_NPI_Drug_15, PartD_Prescriber_PUF_NPI_Drug_16, PartD_Prescriber_PUF_NPI_Drug_17) %>% as.data.frame()
unique(all_PUF_NPI_Drug$year)  #check to make sure that all data sets are labeled by year

all_PUF_NPI_Drug <- all_PUF_NPI_Drug %>%
  filter(specialty_description == "Obstetrics & Gynecology") %>%
  mutate(npi = factor(npi)) %>%
  select(-specialty_description) %>%
  mutate(year = factor(year)) %>%
  filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))

write_rds(all_PUF_NPI_Drug, "~/Dropbox/Pharma_Influence/data/all_PUF_NPI_Drug.rds") 
colnames(all_PUF_NPI_Drug)

#Delete drug files once they are all combined to the all_PUF_NPI_Drug
remove(PartD_Prescriber_PUF_NPI_Drug_14, PartD_Prescriber_PUF_NPI_Drug_15, PartD_Prescriber_PUF_NPI_Drug_16, PartD_Prescriber_PUF_NPI_Drug_17)
gc()

drug_count <- all_PUF_NPI_Drug %>% 
  #as.factor(drug_name) %>%
  arrange(desc(drug_name)) %>%
  group_by(drug_name) %>%
  dplyr::summarize(count=n()) %>%
  arrange(desc(count)) %>%
  #str_to_title(drug_name) %>%
  as.data.table() 
drug_count %>% View()

drug_count[[1,1]]
drug_count[[1,2]]

drug_count_top_20 <- drug_count %>% 
  top_n(20) 
  #transform(count = reorder(count, -count))
drug_count_top_20

ggplot(data = drug_count_top_20) +
  aes(x = drug_name, weight = count) +
  geom_bar(fill = '#6dcd59') +
  labs(title = 'Count of Number of OBGYNs who Prescribed the top 20 drugs',
    x = 'Drug names',
    y = 'Count of Prescriptions') +
  coord_flip() +
  geom_text(aes(label = count, y = count), size = 3, position = position_stack(vjust = 0.5))

#Write to a postgresql database????????????????????????
# RPostgreSQL::dbWriteTable(conn=con, name = "all_PUF_NPI_Drug", value= all_PUF_NPI_Drug, row.names=FALSE, overwrite = TRUE)


cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(all_PUF_NPI_Drug, show_plot = TRUE)
print(str(all_PUF_NPI_Drug))
plot_intro(all_PUF_NPI_Drug)
DataExplorer::plot_missing(all_PUF_NPI_Drug)
DataExplorer::plot_bar(all_PUF_NPI_Drug)
DataExplorer::plot_histogram(all_PUF_NPI_Drug)
inspectdf::inspect_cat(all_PUF_NPI_Drug, show_plot = TRUE)
inspectdf::inspect_imb(all_PUF_NPI_Drug, show_plot = TRUE)
table1_all_PUF_NPI_Drug <- arsenal::tableby( ~., data=all_PUF_NPI_Drug, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_all_PUF_NPI_Drug, text=T, title='Table 1:  PartD_Prescriber_PUF_NPI_Drug_15, Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)























# Steps to read in npi_prescribers_x_year

# aggregated information at the prescriber-level (i.e. one summary record per NPI) that includes enhanced prescriber demographic information beyond what is provided in the Part D Prescriber PUF detail data.  The “Part D Prescriber Summary Table” contains overall drug utilization (claims, 30-day standardized fill counts and day’s supply), drug costs, and beneficiary counts organized by NPI. Drug utilization, drug costs, and beneficiary counts are also included for each of the following sub group classifications:
# • Beneficiariesage65andolder;
# • Brand drugs, generic drugs, and other drugs;
# • Medicare Advantage Prescription Drug (MAPD) and stand-alone Prescription Drug Plans (PDP);
# • Low-income subsidy (LIS) and no low-income subsidy (nonLIS); and
# • Opioids, long-acting opioids, antibiotics, and antipsychotics in the elderly.

#################  NOT DRUG #################################

#2014 year
download.file("https://www.dropbox.com/s/pakz20fn1u8m5v2/PartD_Prescriber_PUF_NPI_14.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_15.txt", method = "auto")

# PartD_Prescriber_PUF_NPI_14 <- read_delim("PartD_Prescriber_PUF_NPI_14.txt", "\t", escape_double = FALSE, trim_ws = TRUE)  %>%
#   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
#   mutate(npi = factor(npi)) %>%
#   mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
#   arrange(npi) %>%
#   filter(nppes_entity_code != "O") %>%
#   filter(nppes_provider_country =="US") %>%
#   filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))%>%
#   mutate (year = "2014")

#2015 year
download.file("https://www.dropbox.com/s/4xt8epb06xvnigo/PartD_Prescriber_PUF_NPI_15.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_15.txt", method = "auto")

PartD_Prescriber_PUF_NPI_15 <- read_delim("PartD_Prescriber_PUF_NPI_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE)  %>%
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  arrange(npi) %>%
  #filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))%>%
  mutate (year = "2015")
write_rds(PartD_Prescriber_PUF_NPI_15, "PartD_Prescriber_PUF_NPI_15.rds")

#2016 year
# download.file("https://www.dropbox.com/s/xzjxw5etettxjas/PartD_Prescriber_PUF_NPI_16.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_16.txt", method = "auto")
# 
# PartD_Prescriber_PUF_NPI_16 <- read_delim("PartD_Prescriber_PUF_NPI_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE)  %>%
#   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
#   mutate(npi = factor(npi)) %>%
#   mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
#   arrange(npi) %>%
#   filter(nppes_entity_code != "O") %>%
#   filter(nppes_provider_country =="US") %>%
#   filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))%>%
#   mutate (year = "2016")
# 
# #2017 year
# download.file("https://www.dropbox.com/s/7ovqho9pp6g6kft/PartD_Prescriber_PUF_NPI_17.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_17.txt", method = "auto")
# 
PartD_Prescriber_PUF_NPI_17 <- read_delim("/Volumes/MUFFLYPROJ/Data/PartD_Prescriber_PUF_NPI_17.txt", "\t", escape_double = FALSE, trim_ws = TRUE)  %>%
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  arrange(npi) %>%
  filter(nppes_entity_code != "O") %>%
  filter(nppes_provider_country =="US") %>%
  filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))%>%
  mutate (year = "2017")
# 
# all_PartD_Prescriber_PUF_NPI <- bind_rows(PartD_Prescriber_PUF_NPI_14, PartD_Prescriber_PUF_NPI_15, PartD_Prescriber_PUF_NPI_16, PartD_Prescriber_PUF_NPI_17)
# 
# write_rds(all_PartD_Prescriber_PUF_NPI, "all_PartD_Prescriber_PUF_NPI.rds")

#Write to a postgresql database
RPostgreSQL::dbWriteTable(conn=con, name = "all_PartD_Prescriber_PUF_NPI", value= all_PartD_Prescriber_PUF_NPI, row.names=FALSE, overwrite = TRUE)

#Get table
PartD_Prescriber_PUF_NPI_15_db <- tbl(con, "PartD_Prescriber_PUF_NPI_15")

cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(PartD_Prescriber_PUF_NPI_15, show_plot = TRUE)
print(str(PartD_Prescriber_PUF_NPI_15))
plot_intro(PartD_Prescriber_PUF_NPI_15)
DataExplorer::plot_missing(PartD_Prescriber_PUF_NPI_15)
DataExplorer::plot_bar(PartD_Prescriber_PUF_NPI_15)
DataExplorer::plot_histogram(PartD_Prescriber_PUF_NPI_15)
inspectdf::inspect_cat(PartD_Prescriber_PUF_NPI_15, show_plot = TRUE)
inspectdf::inspect_imb(PartD_Prescriber_PUF_NPI_15, show_plot = TRUE)
table1_PartD_Prescriber_PUF_NPI_15 <- arsenal::tableby( ~., data=PartD_Prescriber_PUF_NPI_15, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_PartD_Prescriber_PUF_NPI_15, text=T, title='Table 1:  Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)


# Steps to produce physician_compare fore more physician demographics
download.file("https://www.dropbox.com/s/zzag6xbnak60ytq/Physician_Compare_National_Downloadable_File.csv?raw=1", destfile = "Physician_Compare_National_Downloadable_File.csv", method="auto")

physician_compare <- read_csv("~/Dropbox/Pharma_Influence/data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv") %>%
  mutate(NPI = factor(NPI), `PAC ID` = factor(`PAC ID`), `Professional Enrollment ID` = factor(`Professional Enrollment ID`)) %>%
  filter(Credential %in% c("MD", "DO") & `Primary specialty` %in% c("OBSTETRICS/GYNECOLOGY", "GYNECOLOGICAL ONCOLOGY")) %>%
  select(-`Line 2 Street Address`, -`Phone Number`, -`Secondary specialty 1`, -`Secondary specialty 2`, -`Secondary specialty 3`, -`Secondary specialty 4`, -`All secondary specialties`) %>%
  mutate(`Graduation year` = factor(`Graduation year`)) %>%
  select(-`PAC ID`, -`Professional Enrollment ID`, everything()) %>%
  distinct(NPI, .keep_all = TRUE)
#clean.zipcodes(`Zip Code`)  #not working for some reason



# Steps to produce National Drug Code Directory
# Directory: Dropbox/Pharma_Influence/Data/National Drug Code Directory
# File : Product.csv 
# ProductNDC – Factor of a unique drug name
# Nonproprietaryname – Generic name of the drug structure
# Proprietaryname – Brand name of the drug
# Labelername – Drug maker
# 
# File:  Package.xls
# ProductNDC – Link to the product.csv file
# NDCPackageCode - https://www.nber.org/data/ndc-to-labelercode-productcode-packagesize-crosswalk.html This describes the package code. I think we should split up the package code into the 5,4,2 version (first 5 digits then middle 4 then last 2 digits) and then pad the numbers as needed.  I think that we could do a 5,4,2 NDC join with with the open payments data field “PRODUCTNDC”.  
# https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf
download.file("https://www.dropbox.com/s/nsh62v24zl13l77/product.xls?raw=1", destfile = "product.xls", method="auto")

product <- read_delim("product.xls", 
                      "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  select(-DOSAGEFORMNAME, -ROUTENAME, -APPLICATIONNUMBER) %>%
  distinct(NONPROPRIETARYNAME, .keep_all = TRUE) %>%
  select(-PROPRIETARYNAME, everything()) %>%
  distinct(PRODUCTNDC, .keep_all = TRUE) %>%
  select(-SUBSTANCENAME) %>%
  mutate(PRODUCTNDC = factor(PRODUCTNDC), PRODUCTNDC = fct_drop(PRODUCTNDC))



#Write to a postgresql database
RPostgreSQL::dbWriteTable(conn=con, name = "product", value= product, row.names=FALSE, overwrite = TRUE)

#NDC package files
download.file("https://www.dropbox.com/s/5gbrm7tpjup5lfd/package.xls?dl=0?raw=1", destfile = "package.xls", method="auto")

package <- read_delim("package.xls", 
                      "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  distinct(PRODUCTNDC, .keep_all = TRUE) %>%
  distinct(NDCPACKAGECODE, .keep_all = TRUE) %>%
  mutate(PRODUCTNDC = factor(PRODUCTNDC)) %>%
  separate(NDCPACKAGECODE, into = c("NDCPACKAGECODE_1", "NDCPACKAGECODE_2", "last2"), sep = "\\s*\\-\\s*", remove = FALSE, convert = FALSE) %>%
  mutate(NDCPACKAGECODE_1 = str_pad(NDCPACKAGECODE_1, width= 5, pad="0", side="left")) %>%
  unite(NDCPACKAGECODE_1_NDCPACKAGECODE_2_last2, NDCPACKAGECODE_1, NDCPACKAGECODE_2, last2, sep = "-", remove = FALSE) %>%
  rename(`5,4,2versionofNDCpackagecode` = NDCPACKAGECODE_1_NDCPACKAGECODE_2_last2) %>%
  mutate(`5,4,2versionofNDCpackagecode` = factor(`5,4,2versionofNDCpackagecode`))
#Write to a postgresql database
RPostgreSQL::dbWriteTable(conn=con, name = "package", value= package, row.names=FALSE, overwrite = TRUE)

#NDC package files
download.file(url = "https://www.dropbox.com/s/281b7xf8xiyq3m9/nda2segments.csv?raw=1", destfile = "nda2segments.csv", method = "auto", cacheOK = TRUE)

#Also could bring in NDA segments instead of doing it ourselves
nda2segments <- read_csv("~/Downloads/National Drug Code Directory/nda2segments.csv")




# Directory:  Dropbox/Pharma_Influence/Data/Open Payments/PGYR17_P011819
# File:  OP_DTL_RSRCH_PGYR2017_P01182019.csv
# OP_PGYR2017_README_P01182019.txt – Description of data.  This the same doctor payments data we used before but the year 2017 was not available yet.  
# I would like to filter out non-USA territories in Recipient_Coutnry please.  
# Physician_Primary_Type should not include: c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")

#Bring in open payments data for each year


#Open Payments 2017 data from web but needs zip  #Make sure that we have the DTL_GNRL data  and NOT the DTL_RSRCH file
# PGYR17_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR17_P011819.ZIP", destfile = "PGYR17_P011819.ZIP", method = "auto", cacheOK = TRUE)
# 
# #Open Payments 2016 data
# PGYR16_P011819 <- PGYR17_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR16_P011819.ZIP", destfile = "PGYR17_P011819.ZIP", method = "auto", cacheOK = TRUE)
# 
# #Open Payments 2015 data
# PGYR15_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR15_P011819.ZIP", destfile = "PGYR15_P011819.ZIP", method = "auto", cacheOK = TRUE)
# 
# #Open Payments 2014 data
# PGYR14_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR14_P011819.ZIP", destfile = "PGYR15_P011819.ZIP", method = "auto", cacheOK = TRUE)
# 
# #Open Payments 2013 data
# PGYR13_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR13_P011819.ZIP", destfile = "PGYR13_P011819.ZIP", method = "auto", cacheOK = TRUE)

dbc <- cache_filesystem("~/Dropbox/Pharma_Influence/.rcache")
mrunif <- memoise(runif, cache = dbc)
mrunif(20) # Results stored in Dropbox .rcache folder which will be synced between computers.

#2017
OP_DTL_GNRL_PGYR2017_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2017_P06292018.csv") 

OP_DTL_GNRL_PGYR2017_P06292018 %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country %nin% "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type %nin%c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Related_Product_Indicator, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_1_Package_Code, everything()) %>%
  drop_na(NDC_1_Package_Code) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_1_Package_Code, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2017")

brand_drug_count <- OP_DTL_GNRL_PGYR2017_P06292018 %>% 
  #as.factor(drug_name) %>%
  arrange(desc(drug_name)) %>%
  group_by(drug_name) %>%
  dplyr::summarize(count=n()) %>%
  arrange(desc(count)) %>%
  #str_to_title(drug_name) %>%
  as.data.table() 
drug_count %>% View()


#2016
OP_DTL_GNRL_PGYR2016_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2016_P06292018.csv") %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type != c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Related_Product_Indicator, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_1_Package_Code, everything()) %>%
  drop_na(NDC_1_Package_Code) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_1_Package_Code, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2016")


#2015
OP_DTL_GNRL_PGYR2015_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2015_P06292018.csv") %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type %nin% c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  #rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  #filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Related_Product_Indicator, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_1_Package_Code, everything()) %>%
  drop_na(NDC_1_Package_Code) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_1_Package_Code, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2015")


#2014
OP_DTL_GNRL_PGYR2014_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2014_P06292018.csv") %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type != c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_1_Package_Code, everything()) %>%
  drop_na(NDC_1_Package_Code) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_1_Package_Code, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2014")



#2013
OP_DTL_GNRL_PGYR2013_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2013_P06292018.csv") %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type != c("Chiropractor", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Related_Product_Indicator, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_1_Package_Code, everything()) %>%
  drop_na(NDC_1_Package_Code) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_1_Package_Code, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2013")

all_open_payments <- dplyr::bind_rows(OP_DTL_GNRL_PGYR2013_P06292018, OP_DTL_GNRL_PGYR2014_P06292018, OP_DTL_GNRL_PGYR2015_P06292018, OP_DTL_GNRL_PGYR2016_P06292018, OP_DTL_GNRL_PGYR2017_P06292018) 
unique(open_payments$year)  #check to make sure that all data sets are labeled by year

write_rds(all_open_payments, "~/Dropbox/Pharma_Influence/data/all_open_payments.rds") 
colnames(all_open_payments)


cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(all_open_payments, show_plot = TRUE)
print(str(all_open_payments))
plot_intro(all_open_payments)
DataExplorer::plot_missing(all_open_payments)
DataExplorer::plot_bar(all_open_payments)
DataExplorer::plot_histogram(all_open_payments)
inspectdf::inspect_cat(all_open_payments, show_plot = TRUE)
inspectdf::inspect_imb(all_open_payments, show_plot = TRUE)
table1_open_payments_2019 <- arsenal::tableby( ~., data=all_open_payments, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(all_open_payments, text=T, title='Table 1:  Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)


##################################
#Add in the Drug Classes, https://www.pbm.va.gov/PBM/clinicalguidance/drugclassreviews/HormoneTherapyCombinedEstrogenProgestinAbbreviatedDrugClassReview.pdf

Bisphosphonates = c("Fosamax", "Risedronate", "Boniva", "Atelvia", "Prolia") #Need to specify po Boniva as it comes in IV as well.  #####

Anticholinergics_for_overactive_bladder <- (c("Ditropan", "Ditropan XL", "Oxytrol", "Gelnique", "Detrol", "Detrol LA", "Sanctura", "Sanctura XR", "Vesicare", "Enablex", "Toviaz"))

Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy <- (c("Activella", "Combipatch", "Femhrt", "Premphase", "Prempro", "Menest"))

Transdermal_estrogen = (c("Alora", "Climara", "Climara Pro", "Vivelle", "Vivelle-Dot", "Menostar"))
Gel_estrogens = (c("Divigel", "Estrogel", "Elestrin"))

Hormone_therapy_single_ingredient_therapy <- (c("Alora", "Climara", "Esclim", "Estraderm", "Vivelle", "Vivelle-Dot", "Premarin", "Provera", "Medroxyprogesterone acetate"))

LHRH_Agonists <- (c("Goserelin", "Leuprolide"))

COCPs <- (c("Alesse", "Loestrin", "Levlite", "Mircette", "Demulen", "Desogen", "Levlen", "Nordette", "Ortho-Cept", "Ortho-Cyclen", "Ortho Tri-Cyclen", "Brevicon", "Demulen", "Modicon", "Ovcon"))   #https://www.aafp.org/afp/1999/1101/p2073.html

COCP_modern <- (c("Yaz", "Yasmin", "Loestrin", "Aviane", "Lessina", "Lutera", "Ortho Tri-cyclen Lo", "Trinessa", "Tri-Previfem", "Tri-Sprintec", "Enpresse", "Trivora", "Mononessa", "Previfem", "Sprintec", "Balziva", "NECON 1/35–28", "NECON 10/11–28","NECON 7/7/7",
"NECON 0.5/35–28", "Nortrel", "Aranelle", "Leena", "Cryselle", "Low-Ogestrel", "Nuvaring", "Altavera", "Levora", "Portia", "Jolessa", "Quasense", "Kelnor 1-35", "Zovia 1-35e", "Caziant", "Velivet", "Azurette", "Kariva", "Tri-Legest Fe", "Microgestin", "Microgestin Fe", "Apri", "Reclipsen", "Ogestrel", "Ocella", "Zarah", "Gianvi", "Ortho Evra", "Yuvafem", "Lo Loestrin Fe", "BREVICON-28"))  #https://www.kff.org/womens-health-policy/fact-sheet/oral-contraceptive-pills/

Progestin_only_pills <- (c("Micronor", "Norgestrel"))

Extended_use_pills <- (c("Seasonale", "Seasonique", "Lybre"))  #https://www.nhpri.org/Portals/0/Uploads/Documents/NOTE_2_TABS_Contraceptive_Comparison_Chart_01_2012_2.pdf

Vaginal_Estrogen_Hormone_Therapy <- (c("Premarin", "Estrace", "Vagifem", "Estring", "Yuvafem", "Osphena", "Intrarosa"))  #Need to make sure premarin is vaginal  #Reference: https://www.empr.com/home/clinical-charts/oral-and-transdermal-estrogen-dose-equivalents/



IUD = (c("Mirena", "Paragard", "Liletta", "Kyleena"))
Antiviral = (c("Valtex", "Zovirax"))
Anti-infective = (c("Flagyl", "Tindamax"))
Hypoactive_sexual_desire = (c("Addyi"))


#Data checked from: https://www.empr.com.  Would be great if we could scrape it.  
target_drug_manufacturer <- c(
      'Fosamax'   = 'Merck', #Bisphosphonates
      'Actonel'   = 'Allergan', #Bisphosphonates
      "Boniva" = "Genentech, Inc.", #Bisphosphonates
      "Atelvia" = "Allergan", #Bisphosphonates
      "Prolia" = "Amgen, Inc.", #Note that Prolia is IV and others are PO
      
      
      "Ditropan" = "Pfizer", #Anticholinergics_for_overactive_bladder
      "Ditropan XL" = "Pfizer", #Anticholinergics_for_overactive_bladder  
      "Vesicare" = "Astellas",  #Anticholinergics_for_overactive_bladder
      "Enablex" = "Novartis", #Anticholinergics_for_overactive_bladder
      "Toviaz"= "Pfizer", #Anticholinergics_for_overactive_bladder
      "Myrbetriq" = "Astellas", #Anticholinergics_for_overactive_bladder ##????
      "Ditropan" = "", #Anticholinergics_for_overactive_bladder
      "Oxytrol" = "Merck", #Anticholinergics_for_overactive_bladder
      "Gelnique" = "Allergan", #Anticholinergics_for_overactive_bladder
      "Detrol" = "Pfizer", #Anticholinergics_for_overactive_bladder
      "Detrol LA" = "Pfizer", #Anticholinergics_for_overactive_bladder
      "Sanctura" = "Allergan",#Anticholinergics_for_overactive_bladder
      "Sanctura XR" = "Allergan", #Anticholinergics_for_overactive_bladder
      
      'Premarin'   = 'Pfizer', #Vaginal_Estrogen_Hormone_Therapy
      'Estrace'    = 'Allergan',#Vaginal_Estrogen_Hormone_Therapy
      'Vagifem'  = 'Novo Nordisk',#Vaginal_Estrogen_Hormone_Therapy
      'Yuvafem'   = 'Amneal',#Vaginal_Estrogen_Hormone_Therapy
      "Osphena" = "Duchesnay USA, Inc.",
      "Intrarosa" = "AMAG Pharmaceuticals",

      
      'Yaz'    = 'Bayer', #COCP_modern
      'Yasmin'   = 'Bayer', #COCP_modern
      'Loestrin' = 'Allergan', #COCP_modern
      'Lo Loestrin Fe' = 'Allergan', #COCP_modern
      'Aviane'   = 'Teva Pharmaceuticals', #COCP_modern
      'Lessina' = 'Teva Pharmaceuticals', #COCP_modern
      'Lutera' = 'Mayne Pharma US', #COCP_modern
      'Ortho Tri-cyclen Lo' = 'Janssen Pharmaceuticals, Inc.', #COCP_modern
      "Trinessa" = 'Teva Pharmaceuticals',  #COCP_modern
      "Tri-Previfem" = 'Teva Pharmaceuticals', #COCP_modern
      "Tri-Sprintec" = "Teva Pharmaceuticals", #COCP_modern
      "Enpresse" = "Teva Pharmaceuticals", #COCP_modern
      "Trivora" = "Mayne Pharma US", #COCP_modern
      "Mononessa" = "Teva Pharmaceuticals", #COCP_modern
      "Previfem" = "Teva Pharmaceuticals", #COCP_modern
      "Tri-Previfem" = "Teva Pharmaceuticals",       #COCP_modern
      "Sprintec" = "Teva Pharmaceuticals", #COCP_modern
      "Balziva" = "Teva Pharmaceuticals", #COCP_modern
      "NECON 1/35–28" = "Actavis", #COCP_modern
      "NECON 10/11–28" = "Actavis", #COCP_modern
      "NECON 7/7/7"= "Actavis", #COCP_modern
      "NECON 0.5/35–28"= "Actavis", #COCP_modern
      "Nortrel" =  "Teva Pharmaceuticals", #COCP_modern
      "Aranelle" = "Teva Pharmaceuticals", #COCP_modern
      "Leena" = "Mayne Pharma US", #COCP_modern
      "Cryselle" = "Teva Pharmaceuticals", #COCP_modern
      "BREVICON-28" = "Allergan",
      "Nuvaring" = "Merck",
      
      "Activella" = "Novo Nordisk", #Oral_Combined_Estrogen_and_Progestin_
      "Combipatch" = "Noven Therapeutics", #Oral_Combined_Estrogen_and_Progestin_
      "Femhrt" = "Allergan",#Oral_Combined_Estrogen_and_Progestin_
      "Premphase" = "Pfizer",#Oral_Combined_Estrogen_and_Progestin_
      "Prempro" = "Pfizer",#Oral_Combined_Estrogen_and_Progestin_
      "Menest" = "Pfizer",
      
      "Mirena" = "Bayer Healthcare Pharmaceuticals Inc.", #IUD, these are devices FYI
      "Paragard" = "The Cooper Companies", #IUD
      "Liletta" = "Allergan", #IUD
      "Kyleena" = "Bayer", #IUD
      
      "Valtrex" =  "GlaxoSmithKline", #Herpes treatment
      "Zovirax" = "Mylan Inc.", #Herpes treatment

      "Flagyl" = "Pfizer",  #Bacterial vaginosis treatment
       "Tindamax" = "Mission Pharmacal Company", #Bacterial vaginosis treatment
      
      "Addyi" = "Sprout Pharmaceuticals", #Hypoactive sexual desire
      
      "Alora" = "Allergan", #Transdermal_estrogen
      "Climara" = "Bayer", #Transdermal_estrogen
      "Climara Pro" = "Bayer",   #Transdermal_estrogen
      "Vivelle" = "Novartis", #Transdermal_estrogen
      "Vivelle-Dot" = "Novartis", #Transdermal_estrogen
      "Menostar" = "Bayer", #Transdermal_estrogen
      
      "Divigel" = "Vertical Pharmaceuticals",  #Gel_estrogens
      "Estrogel" = "Ascend Therapeutics",  #Gel_estrogens
      "Elestrin" = "Mylan Inc." #Gel_estrogens
      ) 

"Enablex" = "Novartis", #Anticholinergics_for_overactive_bladder
"Toviaz"= "Pfizer", #Anticholinergics_for_overactive_bladder
"Myrbetriq" = "Astellas", #Anticholinergics_for_overactive_bladder ##????
"Ditropan" = "", #Anticholinergics_for_overactive_bladder
"Oxytrol" = "Merck", #Anticholinergics_for_overactive_bladder
"Gelnique" = "Allergan", #Anticholinergics_for_overactive_bladder
"Detrol" = "Pfizer", #Anticholinergics_for_overactive_bladder
"Detrol LA" = "Pfizer", #Anticholinergics_for_overactive_bladder
"Sanctura" = "Allergan",#Anticholinergics_for_overactive_bladder
"Sanctura XR" = "Allergan", #Anticholinergics_for_overactive_bladder

partd_target = c(
  'Fosamax'   = 'Alendronate',
  'Actonel'     = 'Risedronate',
  'Boniva'   = 'Ibandronate',
  'Atelvia'    = 'Risedronate',
  'Prolia'  = 'Denosumab',
  
  'Ditropan'   = 'Oxybutynin chloride',
  'Ditropan XL'    = 'Oxybutynin chloride', #Need to make sure this is the extended release
  'Vesicare'   = 'Solifenacin succinate',
  'Enablex' = 'Darifenacin',
  'estrace'   = 'ESTRACE',
  'oxycontin' = 'OXYCONTIN'
),