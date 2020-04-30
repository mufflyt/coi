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
#Dropbox Access
drop_auth()
token <- drop_auth()
saveRDS(token, file = "token.rds")
drop_acc() %>% data.frame()
drop_dir() %>% 
  filter(.tag == "folder") %>%
  arrange(name) %>%
  View()

drop_dir("Pharma_Influence/data/National Drug Code Directory/") %>% View()
drop_download("Pharma_Influence/data/National Drug Code Directory/package.txt", overwrite = TRUE, progress=TRUE)

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

# PartD_Prescriber_PUF_NPI_Drug_14 <- read_delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_DRUG_14/PartD_Prescriber_PUF_NPI_Drug_14.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
#   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
#   # Make all OBGYN the same factor with "Obstetrics & Gynecology"
#   mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
#   select(-description_flag, everything()) %>%
#   select(generic_name, everything()) %>%
#   mutate(npi = factor(npi)) %>%
#   mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
#   mutate (year = "2014") %>%
#   filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))
# 
# #2015 year  
# # download.file("https://www.dropbox.com/s/4xt8epb06xvnigo/PartD_Prescriber_PUF_NPI_Drug_15.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_15.txt", method = "auto", cacheOK = TRUE)
# 
# PartD_Prescriber_PUF_NPI_Drug_15 <- read_delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_Drug_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
#   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
#   # Make all OBGYN the same factor with "Obstetrics & Gynecology"
#   mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
#   select(-description_flag, everything()) %>%
#   select(generic_name, everything()) %>%
#   mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
#   mutate (year = "2015") %>%
#   filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))
# 
# #2016 year 
# download.file("https://www.dropbox.com/s/xzjxw5etettxjas/PartD_Prescriber_PUF_NPI_Drug_16.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_16.txt", method = "wget")
# 
# PartD_Prescriber_PUF_NPI_Drug_16 <- read_delim("~/Dropbox/Pharma_Influence/data/Medicare Part D data/PartD_Prescriber_PUF_NPI_DRUG_16/PartD_Prescriber_PUF_NPI_Drug_16.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
#   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
#   # Make all OBGYN the same factor with "Obstetrics & Gynecology"
#   mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
#   select(-description_flag, everything()) %>%
#   select(generic_name, everything()) %>%
#   mutate(npi = factor(npi)) %>%
#   mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
#   mutate (year = "2016") %>%
#   filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))
# 
# #2017 year
# download.file("https://www.dropbox.com/s/7ovqho9pp6g6kft/PartD_Prescriber_PUF_NPI_Drug_17.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_17.txt", method = "auto")
# 
# PartD_Prescriber_PUF_NPI_Drug_17 <- read_delim("PartD_Prescriber_PUF_NPI_Drug_17.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
#   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
#   # Make all OBGYN the same factor with "Obstetrics & Gynecology"
#   mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
#   select(-description_flag, everything()) %>%
#   select(generic_name, everything()) %>%
#   mutate(npi = factor(npi)) %>%
#   mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
#   mutate (year = "2017") %>% 
#   filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))
# 
# all_PUF_NPI_Drug <- dplyr::bind_rows(PartD_Prescriber_PUF_NPI_Drug_14, PartD_Prescriber_PUF_NPI_Drug_15, PartD_Prescriber_PUF_NPI_Drug_16, PartD_Prescriber_PUF_NPI_Drug_17) %>% as.data.frame()
# unique(all_PUF_NPI_Drug$year)  #check to make sure that all data sets are labeled by year

# all_PUF_NPI_Drug <- all_PUF_NPI_Drug %>%
#   filter(specialty_description == "Obstetrics & Gynecology") %>%
#   mutate(npi = factor(npi)) %>%
#   select(-specialty_description) %>%
#   mutate(year = factor(year)) %>%
#   filter(nppes_provider_state %nin% c("GU", "VI", "ZZ", "AP", "AE"))

#write_rds(all_PUF_NPI_Drug, "~/Dropbox/Pharma_Influence/data/all_PUF_NPI_Drug.rds") 
# #Delete drug files once they are all combined to the all_PUF_NPI_Drug
# remove(PartD_Prescriber_PUF_NPI_Drug_14, PartD_Prescriber_PUF_NPI_Drug_15, PartD_Prescriber_PUF_NPI_Drug_16, PartD_Prescriber_PUF_NPI_Drug_17)
# gc()

all_PUF_NPI_Drug <- readr::read_rds("~/Dropbox/Pharma_Influence/data/all_PUF_NPI_Drug.rds")
colnames(all_PUF_NPI_Drug)

drug_count <- all_PUF_NPI_Drug %>% 
  #as.factor(drug_name) %>%
  arrange(desc(drug_name)) %>%
  group_by(drug_name) %>%
  dplyr::summarize(count=n()) %>%
  arrange(desc(count)) %>%
  #str_to_title(drug_name) %>%
  as.data.table() 
drug_count %>% View()

drug_count[[1,1]]  #Name of the top drug
drug_count[[1,2]]   #Number of the top drugs

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






#############################################################################
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
download.file("https://www.dropbox.com/s/nsh62v24zl13l77/product.xls?raw=1", destfile = "product.txt", method="auto")

product <- read_delim("product.txt", 
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
download.file("https://www.dropbox.com/s/5gbrm7tpjup5lfd/package.txt?dl=0?raw=1", destfile = "package.xls", method="auto")

package <- read_delim("package.txt", 
                      "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  distinct(PRODUCTNDC, .keep_all = TRUE) %>%
  distinct(NDCPACKAGECODE, .keep_all = TRUE) %>%
  mutate(PRODUCTNDC = factor(PRODUCTNDC)) %>%
  separate(NDCPACKAGECODE, into = c("NDCPACKAGECODE_1", "NDCPACKAGECODE_2", "last2"), sep = "\\s*\\-\\s*", remove = FALSE, convert = FALSE) %>%
  mutate(NDCPACKAGECODE_1 = str_pad(NDCPACKAGECODE_1, width= 5, pad="0", side="left")) %>%
  unite(NDCPACKAGECODE_1_NDCPACKAGECODE_2_last2, NDCPACKAGECODE_1, NDCPACKAGECODE_2, last2, sep = "-", remove = FALSE) %>%
  rename(`5,4,2versionofNDCpackagecode` = NDCPACKAGECODE_1_NDCPACKAGECODE_2_last2) %>%
  mutate(`5,4,2versionofNDCpackagecode` = factor(`5,4,2versionofNDCpackagecode`))

#NDC package files
download.file(url = "https://www.dropbox.com/s/281b7xf8xiyq3m9/nda2segments.csv?raw=1", destfile = "nda2segments.csv", method = "auto", cacheOK = TRUE)

#Also could bring in NDA segments instead of doing it ourselves
nda2segments <- read_csv("data/National Drug Code Directory/nda2segments.csv")


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

#2017
OP_DTL_GNRL_PGYR2017_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2017_P06292018.csv") 
colnames(OP_DTL_GNRL_PGYR2017_P06292018)
OP_DTL_GNRL_PGYR2017_P06292018$Associated_Drug_or_Biological_NDC_1

OP2017 <- OP_DTL_GNRL_PGYR2017_P06292018 %>%
  filter(Physician_Specialty %in% c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Critical Care Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Female Pelvic Medicine and Reconstructive Surgery", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology")) %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country %nin% "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type %nin% c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  
  rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
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
rm(OP_DTL_GNRL_PGYR2017_P06292018)
gc()

#2016
OP_DTL_GNRL_PGYR2016_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2016_P06292018.csv") 

OP2016 <- OP_DTL_GNRL_PGYR2016_P06292018 %>%
  filter(Physician_Specialty %in% c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Critical Care Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Female Pelvic Medicine and Reconstructive Surgery", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology")) %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country %nin% "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type %nin% c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  
  #rename(NDC_1_Package_Code = Associated_Drug_or_Biological_NDC_1) %>%
  # Limit COI to only drugs
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Related_Product_Indicator, -Covered_or_Noncovered_Indicator_1, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Product_Category_or_Therapeutic_Area_1, Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(Associated_Drug_or_Biological_NDC_1, everything()) %>%
  drop_na(Associated_Drug_or_Biological_NDC_1) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(Associated_Drug_or_Biological_NDC_1, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2016")
rm(OP_DTL_GNRL_PGYR2016_P06292018)
gc()

#2015
OP_DTL_GNRL_PGYR2015_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2015_P06292018.csv") 

OP2015 <- OP_DTL_GNRL_PGYR2015_P06292018 %>%
  filter(Physician_Specialty %in% c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Critical Care Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Female Pelvic Medicine and Reconstructive Surgery", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology")) %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name, -Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Primary_Business_Street_Address_Line2, -Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  filter(Physician_Primary_Type %nin% c("Chiropractor", "Doctor of Dentistry", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  #select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  rename(NDC_1_Package_Code = Name_of_Associated_Covered_Drug_or_Biological1) %>%
  # Limit COI to only drugs
  #filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Covered_or_Noncovered_Indicator_2, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Product_Category_or_Therapeutic_Area_2, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2, -Associated_Drug_or_Biological_NDC_2, -Covered_or_Noncovered_Indicator_3, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Product_Category_or_Therapeutic_Area_3, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3, -Associated_Drug_or_Biological_NDC_3, -Covered_or_Noncovered_Indicator_4, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Product_Category_or_Therapeutic_Area_4, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4, -Associated_Drug_or_Biological_NDC_4, -Covered_or_Noncovered_Indicator_5, -Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Product_Category_or_Therapeutic_Area_5, -Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_5, -Associated_Drug_or_Biological_NDC_5, -Program_Year) %>%
  # select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_1_Package_Code, everything()) %>%
  drop_na(NDC_1_Package_Code) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_1_Package_Code, into = c("5", "4", "2 NDC"), sep = "\\s*\\-\\s*", remove = FALSE, convert = TRUE) %>%
  mutate_at(vars(`4`, `5`, `2 NDC`), funs(as.character)) %>%
  mutate(`5` = str_pad(`5`, pad="0", side="left", width=5), `4` = str_pad(`4`, pad="0", side="left", width=4), `2 NDC` = str_pad(`2 NDC`, pad="0", side="left", width=2)) %>%
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) %>%
  mutate (year = "2015")
#write_rds(OP2015, "~/Dropbox/Pharma_Influence/data/Open Payments/OP2015.rds")
rm(OP_DTL_GNRL_PGYR2015_P06292018)

#2014
OP_DTL_GNRL_PGYR2014_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2014_P06292018.csv") 

OP2014 <- OP_DTL_GNRL_PGYR2014_P06292018 %>%
  filter(Physician_Specialty %in% c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Critical Care Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Female Pelvic Medicine and Reconstructive Surgery", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology")) %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type %nin% c("Chiropractor", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  #rename(NDC_1_Package_Code = Name_of_Associated_Covered_Drug_or_Biological1) %>%
  # Limit COI to only drugs
  #filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_of_Associated_Covered_Drug_or_Biological1, everything()) %>%
  drop_na(NDC_of_Associated_Covered_Drug_or_Biological1) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_of_Associated_Covered_Drug_or_Biological1, into = c("NDC_of_Associated_Covered_Drug_or_Biological1_1", "NDC_of_Associated_Covered_Drug_or_Biological1_2"), sep = c(4), remove = FALSE, convert = TRUE) %>%
  mutate(NDC_of_Associated_Covered_Drug_or_Biological1_1 = str_pad(NDC_of_Associated_Covered_Drug_or_Biological1_1, pad="0", side="left", width=5)) %>%
  separate(NDC_of_Associated_Covered_Drug_or_Biological1_2, into = c("NDC_of_Associated_Covered_Drug_or_Biological1_2_1", "NDC_of_Associated_Covered_Drug_or_Biological1_2_2"), sep = c(4), remove = TRUE, convert = TRUE) %>%
  rename(First5 = NDC_of_Associated_Covered_Drug_or_Biological1_1, Second4 = NDC_of_Associated_Covered_Drug_or_Biological1_2_1, Last2 = NDC_of_Associated_Covered_Drug_or_Biological1_2_2) %>%
  unite('5_4_2_NDC', First5, Second4, Last2, sep = "-", remove = FALSE) %>%
  select(-NDC_of_Associated_Covered_Drug_or_Biological1, -First5, -Second4, -Last2) %>%
  mutate (year = "2014") %>% as_tibble() 
View(OP2014)

rm(OP_DTL_GNRL_PGYR2014_P06292018)
gc()

#2013
OP_DTL_GNRL_PGYR2013_P06292018 <- read_csv("~/Dropbox/Pharma_Influence/data/Open Payments/OP_DTL_GNRL_PGYR2013_P06292018.csv") 
colnames(OP_DTL_GNRL_PGYR2013_P06292018)

OP2013 <- OP_DTL_GNRL_PGYR2013_P06292018 %>%
  filter(Physician_Specialty %in% c("Allopathic & Osteopathic Physicians|Obstetrics & Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Critical Care Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Female Pelvic Medicine and Reconstructive Surgery", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecologic Oncology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Gynecology", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Hospice and Palliative Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Maternal & Fetal Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obesity Medicine", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Obstetrics", "Allopathic & Osteopathic Physicians|Obstetrics & Gynecology|Reproductive Endocrinology")) %>%
  select(-Change_Type, -Covered_Recipient_Type, -Teaching_Hospital_CCN, -Teaching_Hospital_ID, -Teaching_Hospital_Name) %>%
  mutate(Physician_Profile_ID = factor(Physician_Profile_ID)) %>%
  filter(Recipient_Country != "United States Minor Outlying Islands") %>%
  select(-Recipient_Country, everything()) %>%
  select(-Recipient_Province, -Recipient_Postal_Code, -Delay_in_Publication_Indicator, -Dispute_Status_for_Publication, -Recipient_Country, -Recipient_Primary_Business_Street_Address_Line2) %>%
  filter(Physician_Primary_Type %nin% c("Chiropractor", "Doctor of Optometry", "Doctor of Podiatric Medicine")) %>%
  select(-Physician_License_State_code2, -Physician_License_State_code3, -Physician_License_State_code4, -Physician_License_State_code5) %>%
  mutate(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID = factor(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID)) %>%
  select(-Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country) %>%
  # THIS MAY BE THE PROBLEM OF THE NDC PACKAGE AND DRUGS NOT MATCHING UP, https://www.idmedicaid.com/Reference/NDC%20Format%20for%20Billing%20PAD.pdf, may need all numbers to be in a 5-4-2 pattern
  #rename(NDC_1_Package_Code = Name_of_Associated_Covered_Drug_or_Biological1) %>%
  # Limit COI to only drugs
  #filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Drug") %>%
  select(-Physician_Middle_Name, -Physician_Name_Suffix, -Recipient_Primary_Business_Street_Address_Line1, -Recipient_City, -Recipient_Zip_Code, -Physician_Primary_Type, -Physician_Specialty, -Physician_License_State_code1, -Date_of_Payment, -Record_ID, -Program_Year) %>%
  select(-Physician_First_Name, -Physician_Last_Name, -Recipient_State, -Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID, everything()) %>%
  select(-Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) %>%
  select(NDC_of_Associated_Covered_Drug_or_Biological1, everything()) %>%
  drop_na(NDC_of_Associated_Covered_Drug_or_Biological1) %>%
  filter(Total_Amount_of_Payment_USDollars >= 1) %>%
  separate(NDC_of_Associated_Covered_Drug_or_Biological1, into = c("NDC_of_Associated_Covered_Drug_or_Biological1_1", "NDC_of_Associated_Covered_Drug_or_Biological1_2"), sep = c(4), remove = FALSE, convert = TRUE) %>%
  mutate(NDC_of_Associated_Covered_Drug_or_Biological1_1 = str_pad(NDC_of_Associated_Covered_Drug_or_Biological1_1, pad="0", side="left", width=5)) %>%
  separate(NDC_of_Associated_Covered_Drug_or_Biological1_2, into = c("NDC_of_Associated_Covered_Drug_or_Biological1_2_1", "NDC_of_Associated_Covered_Drug_or_Biological1_2_2"), sep = c(4), remove = TRUE, convert = TRUE) %>%
  rename(First5 = NDC_of_Associated_Covered_Drug_or_Biological1_1, Second4 = NDC_of_Associated_Covered_Drug_or_Biological1_2_1, Last2 = NDC_of_Associated_Covered_Drug_or_Biological1_2_2) %>%
  unite('5_4_2_NDC', First5, Second4, Last2, sep = "-", remove = FALSE) %>%
  select(-NDC_of_Associated_Covered_Drug_or_Biological1, -First5, -Second4, -Last2) %>%
  mutate (year = "2013") %>% as_tibble() 
View(OP2013)

rm(OP_DTL_GNRL_PGYR2013_P06292018)
gc()

all_open_payments <- dplyr::bind_rows(OP2013, OP2014, OP2015, OP2016, OP2017) %>%   
filter(Recipient_State %nin% c("MP", "GU", "AE", "https://mirror.las.iastate.edu/CRAN/", "AE")) %>% #Keep Puerto Rico and DC in the sample
  select(-Name_of_Associated_Covered_Drug_or_Biological4, -Name_of_Associated_Covered_Drug_or_Biological5, -NDC_of_Associated_Covered_Drug_or_Biological4, -NDC_of_Associated_Covered_Drug_or_Biological5, -Name_of_Associated_Covered_Device_or_Medical_Supply5)  #Removed all columns that have no data
  readr::write_rds(all_open_payments, path="~/Dropbox/Pharma_Influence/all_open_payments.rds")
  
unique(all_open_payments$year)  #check to make sure that all data sets are labeled by year
unique(all_open_payments$Recipient_State)
describe(all_open_payments)

#write_rds(all_open_payments, "~/Dropbox/Pharma_Influence/data/all_open_payments.rds") 
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

class_Bisphosphonates = c("Fosamax", "Risedronate", "Boniva", "Atelvia", "Prolia") #Need to specify po Boniva as it comes in IV as well.  #####

class_Anticholinergics_for_overactive_bladder <- (c("Ditropan", "Ditropan XL", "Oxytrol", "Gelnique", "Detrol", "Detrol LA", "Sanctura", "Sanctura XR", "Vesicare", "Enablex", "Toviaz"))

class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy <- (c("Activella", "Combipatch", "Femhrt", "Premphase", "Prempro", "Menest", "Climara Pro"))

class_Transdermal_estrogen = (c("Alora", "Climara", "Vivelle", "Vivelle-Dot", "Menostar"))
class_Gel_estrogens = (c("Divigel", "Estrogel", "Elestrin"))

class_Hormone_therapy_single_ingredient_therapy <- (c("Alora", "Climara", "Esclim", "Estraderm", "Vivelle", "Vivelle-Dot", "Premarin", "Provera", "Medroxyprogesterone acetate"))

class_Vaginal_Estrogen_Hormone_Therapy <- (c("Premarin", "Estrace", "Vagifem", "Estring", "Yuvafem", "Osphena", "Intrarosa"))  #Need to make sure premarin is vaginal  #Reference: https://www.empr.com/home/clinical-charts/oral-and-transdermal-estrogen-dose-equivalents/

class_IUD_device = (c("Mirena", "Paragard T 380A", "Liletta", "Kyleena"))
class_Antiviral = (c("Valtex", "Zovirax"))
class_Anti_infective = (c("Flagyl", "Tindamax"))
class_Hypoactive_sexual_desire = (c("Addyi"))

#Data checked from: https://www.empr.com.  Would be great if we could scrape it.  
#https://www.accessdata.fda.gov/scripts/cder/ndc/index.cfm
target_drug_manufacturer <- c(
      'Fosamax'   = 'Merck Sharp & Dohme Corp.', #Bisphosphonates
      'Actonel'   = 'Allergan, Inc.', #Bisphosphonates
      "Boniva" = "Genentech, Inc.", #Bisphosphonates
      "Atelvia" = "Allergan, Inc.", #Bisphosphonates
      "Prolia" = "Amgen Inc", #Note that Prolia is IV and others are PO
      
      "Ditropan" = "Pfizer", #Anticholinergics_for_overactive_bladder
      "Ditropan XL" = "Pfizer", #Anticholinergics_for_overactive_bladder  #make sure XR
      "VESIcare" = "Astellas Pharma US, Inc.",  #Anticholinergics_for_overactive_bladder
      "Enablex" = "Allergan, Inc.", #Anticholinergics_for_overactive_bladder
      "Toviaz"= (c("Pfizer Laboratories Div Pfizer Inc", "U.S. Pharmaceuticals", "Cardinal Health")),#Anticholinergics_for_overactive_bladder
      "Myrbetriq" = (c("Astellas Pharma US, Inc.", "Cardinal Health")),#Anticholinergics_for_overactive_bladder ##????
      "Oxytrol" = "Merck Sharp & Dohme Corp.", #Anticholinergics_for_overactive_bladder #Make sure this is patch
      "Gelnique" = "Allergan, Inc.", #Anticholinergics_for_overactive_bladder #needs to be gel
      "Detrol" = "Pfizer", #Anticholinergics_for_overactive_bladder
      "Detrol LA" = "Pfizer", #Anticholinergics_for_overactive_bladder #make sure XR
      "Sanctura" = "Allergan, Inc.",#Anticholinergics_for_overactive_bladder
      "Sanctura XR" = "Allergan, Inc.", #Anticholinergics_for_overactive_bladder #make sure XR
      
      'Premarin'   = 'Pfizer', #Vaginal_Estrogen_Hormone_Therapy
      'Estrace'    = 'Allergan, Inc.',#Vaginal_Estrogen_Hormone_Therapy
      'Vagifem'  = 'Novo Nordisk',#Vaginal_Estrogen_Hormone_Therapy
      'Yuvafem'   = 'Amneal',#Vaginal_Estrogen_Hormone_Therapy
      "Osphena" = (c("Duchesnay USA, Inc.", "Shionogi Inc.")),
      "Intrarosa" = "AMAG Pharmaceuticals",
      
      "Activella" = "Novo Nordisk", #Oral_Combined_Estrogen_and_Progestin_
      "Combipatch" = "Noven Therapeutics", #Oral_Combined_Estrogen_and_Progestin_
      "Femhrt" = "Allergan, Inc.",#Oral_Combined_Estrogen_and_Progestin_
      "Premphase" = "Pfizer",#Oral_Combined_Estrogen_and_Progestin_
      "Prempro" = "Pfizer",#Oral_Combined_Estrogen_and_Progestin_
      "Menest" = "Pfizer",
      "Climara Pro" = "Bayer HealthCare Pharmaceuticals Inc.",   #Transdermal_estrogen
      
      "Mirena" = "Bayer Healthcare Pharmaceuticals Inc.", #IUD, these are devices FYI
      "Paragard T 380A" = (c("CooperSurgical, Inc.", "Teva Women's Health, Inc.")), #IUD
      "Liletta" = (c("Allergan, Inc.", "Actavis Pharma, Inc.")),#IUD
      "Kyleena" = "Bayer HealthCare Pharmaceuticals Inc.", #IUD
      
      "Valtrex" =  "GlaxoSmithKline", #Herpes treatment
      "Zovirax" = "Prestium Pharma, Inc.", #Herpes treatment

      "Flagyl" = "Pfizer",  #Bacterial vaginosis treatment
       "Tindamax" = "Mission Pharmacal Company", #Bacterial vaginosis treatment
      
      "Addyi" = "Sprout Pharmaceuticals", #Hypoactive sexual desire
      
      "Alora" = (c("Allergan, Inc.", "Actavis Pharma, Inc.")), #Transdermal_estrogen
      "Climara" = "Bayer HealthCare Pharmaceuticals Inc.", #Transdermal_estrogen
      "Vivelle" = "Novartis", #Transdermal_estrogen
      "Vivelle-Dot" = "Novartis", #Transdermal_estrogen
      "Menostar" = "Bayer HealthCare Pharmaceuticals Inc.", #Transdermal_estrogen
      
      "Divigel" = "Vertical Pharmaceuticals, LLC",  #Gel_estrogens
      "Estrogel" = "Ascend Therapeutics",  #Gel_estrogens
      "Elestrin" = "Mylan Inc." #Gel_estrogens
      ) 

target_partd = c(
  'Fosamax'   = 'Alendronate',
  'Actonel'     = 'Risedronate',
  'Boniva'   = 'Ibandronate',
  'Atelvia'    = 'Risedronate',
  'Prolia'  = 'Denosumab',
  
  'Ditropan'   = 'Oxybutynin chloride',
  'Ditropan XL'    = 'Oxybutynin chloride', #Need to make sure this is the extended release
  'VESIcare'   = 'Solifenacin succinate',
  'Enablex' = 'Darifenacin',
  'Toviaz'   = 'Fesoterodine fumarate',
  'Myrbetriq' = 'Mirabegron',
  'Oxytrol' = 'Oxybutynin', #Patch needed
  'Gelnique' = "Oxybutynin chloride 10%", #needs to be a gel
  'Detrol' = 'Tolterodine tartrate',
  'Detrol LA' = 'Tolterodine tartrate', #needs to be extended release
  "Sanctura" = "Trospium chloride",#Anticholinergics_for_overactive_bladder
  "Sanctura XR" = "Trospium chloride", #Anticholinergics_for_overactive_bladder
  
   'Premarin'   = 'Conjugated estrogens', #make sure it is the vaginal cream
   'Estrace'    = 'Estradiol',#cream needed
   'Vagifem'  = 'Estradiol',#vaginal insert needed
   'Yuvafem'   = 'Estradiol ',#vaginal insert needed
   "Osphena" = "Ospemifene",
   "Intrarosa" = "Prasterone",
  
  "Activella" = "Estradiol", #Oral_Combined_Estrogen_and_Progestin_
  "Combipatch" = "Estradiol 0.05mg + norethindrone acetate", #Patch
  "Femhrt" = "Norethindrone acetate 0.5mg, ethinyl estradiol 2.5mcg",#Oral_Combined_Estrogen_and_Progestin_
  "Premphase" = "conjugated estrogens and medroxyprogesterone acetate",#Oral_Combined_Estrogen_and_Progestin_
  "Prempro" = "CONJUGATED ESTROGENS and MEDROXYPROGESTERONE ACETATE",#Oral_Combined_Estrogen_and_Progestin_
  "Menest" = "esterified estrogens",
  "Climara Pro" = "Estradiol and Levonorgestrel",   #Transdermal_estrogen+Progesterone
  
  "Mirena" = "Levonorgestrel", #IUD, these are devices FYI
  "Paragard T 380A" = "Copper", #IUD
  "Liletta" = "Levonorgestrel", #IUD
  "Kyleena" = "Levonorgestrel", #IUD
  
  "Valtrex" =  "valacyclovir hydrochloride", #Herpes treatment
  "Zovirax" = "ACYCLOVIR", #Herpes treatment
  
  "Flagyl" = "Metronidazole",  #Bacterial vaginosis treatment
  "Tindamax" = "tinidazole", #Bacterial vaginosis treatment
  
  "Addyi" = "flibanserin", #Hypoactive sexual desire
  
  "Alora" = "Estradiol Transdermal System", #Transdermal_estrogen
  "Climara" = "estradiol", #Transdermal_estrogen
  "Vivelle" = "estradiol", #Transdermal_estrogen
  "Vivelle-Dot" = "estradiol", #Transdermal_estrogen
  "Menostar" = "estradiol", #Transdermal_estrogen
  
  "Divigel" = "estradiol",  #Gel_estrogens
  "Estrogel" = "estradiol",  #Gel_estrogens
  "Elestrin" = "estradiol" #Gel_estrogens
) 

target_ndc_package_code = c(
  'Fosamax'   = (c('0006-0031-44', "0006-0270-21", "0006-0270-44", "0006-0710-44")),
  'Actonel'     = (c("0430-0470-15", "0430-0471-15", "0430-0472-03", "0430-0472-07", "0430-0478-01", "0430-0478-02")),
  'Boniva'   = (c("0004-0186-83", "0004-0191-09")),
  'Atelvia'    = '0430-0979-03',
  'Prolia'  = '55513-710-01',
  
  'Ditropan'   = (c("0603-4975-02", "0603-4975-04", "0603-4975-16", "0603-4975-20",
                    "0603-4975-21", "0603-4975-22", "0603-4975-28", "0603-4975-32")),
  'Ditropan XL'    = (c('50458-805-01', "50458-810-01")), #Need to make sure this is the extended release
  'VESIcare'   = (c('51248-150-01', "51248-151-03", "51248-150-03", "51248-150-52", "51248-151-52", "51248-151-01")),
  'Enablex' = (c("0430-0170-00", "0430-0170-15", "0430-0170-23", "0430-0170-96", "0430-0171-00", "0430-0171-15", "0430-0171-23", "0430-0171-96")),
  'Toviaz'   = (c("0069-0242-30", "0069-0244-30")),
  'Myrbetriq' = (c("0469-2601-30", "0469-2601-71", "0469-2601-90", "0469-2602-30", "0469-2602-71", "0469-2602-90")),
  'Oxytrol' = (c("0023-6153-08", "0023-9637-04")), #Patch needed
  'Gelnique' = (c("0023-5812-30", "0023-5861-11")), #needs to be a gel
  'Detrol' = (c("0009-4541-02", "0009-4544-02", "0009-4544-03")),
  'Detrol LA' = (c("0009-5190-01", "0009-5190-02", "0009-5190-03", "0009-5190-04", "0009-5191-01", "0009-5191-02", "0009-5191-03", "0009-5191-04", "0009-5191-99")), #needs to be extended release
  "Sanctura" = (c("60505-3454-5", "60505-3454-8", "60505-3454-6")),#Anticholinergics_for_overactive_bladder
  "Sanctura XR" = (c("0591-3636-05", "0591-3636-30", "0591-3636-60")), #Anticholinergics_for_overactive_bladder
  
  'Premarin'   = (c("0046-0872-04", "0046-0872-21")), 
  'Estrace'    = (c("0430-3754-14")),
  'Vagifem'  = (c("0169-5176-03", "0169-5176-04", "0169-5176-99")),
  'Yuvafem'   = (c("69238-1524-8", "69238-1524-7")),
  "Osphena" = (c("59630-580-55", "59630-580-90", "59630-580-18")),
  "Intrarosa" = (c("64011-601-28", "64011-601-14")),
  
  "Activella" = (c("60846-202-01", "60846-201-01", "60846-231-01", "60846-232-01")), #Oral_Combined_Estrogen_and_Progestin_
  "Combipatch" = (c("68968-0514-8", "68968-0525-8")), #Patch
  "Femhrt" = ("0430-0145-14"),#Oral_Combined_Estrogen_and_Progestin_
  "Premphase" = ("0046-2575-12"),#Oral_Combined_Estrogen_and_Progestin_
  "Prempro" = (c("0046-1105-11", "0046-1106-11", "0046-1107-11", "0046-1108-11")),#Oral_Combined_Estrogen_and_Progestin_
  "Menest" = (c("61570-074-01", "61570-073-01", "61570-072-01", "61570-075-50")),
  "Mirena" = (c("50419-423-08", "50419-423-01")), #IUD, these are devices FYI
  "Paragard T 380A" = (c("59365-5128-1", "51285-204-01")), #IUD
  "Liletta" = (c("52544-035-54", "0023-5858-01")), #IUD
  "Kyleena" = (c("50419-424-71", "50419-424-01", "50419-424-08")), #IUD
  
  "Valtrex" =  (c("0173-0933-08", "0173-0933-10", "0173-0933-56", "0173-0565-04", "0173-0565-10")), #Herpes treatment
  "Zovirax" = (c("40076-949-55", "40076-945-55")), #Herpes treatment
  
  "Flagyl" = (c("0025-1821-31", "0025-1821-50", "0025-1831-31", "0025-1831-50")),  #Bacterial vaginosis treatment
  "Tindamax" = (c("0178-8250-40", "0178-8500-20", "0178-8500-60")), #Bacterial vaginosis treatment
  
  "Addyi" = "58604-214-30", #Hypoactive sexual desire
  
  "Alora" = (c("0023-5885-12", "0023-5886-15", "0023-5887-17", "0023-5888-11", "52544-472-08", "52544-473-08", "52544-884-08", "52544-471-08")), #Transdermal_estrogen
  "Climara" = (c("50419-453-04", "50419-456-04", "50419-459-04", "50419-452-04", "50419-451-04", "50419-454-04")), #Transdermal_estrogen
  "Climara Pro" = (c("50419-491-73", "50419-491-04")),   #Transdermal_estrogen
  "Vivelle-Dot" = (c("0078-0343-45", "0078-0344-45", "0078-0345-42", "0078-0345-45", "0078-0346-42", "0078-0346-45", "0078-0365-42", "0078-0365-45")), #Transdermal_estrogen
  "Menostar" = "50419-455-04", #Transdermal_estrogen
  
  "Divigel" = (c("68025-066-30", "68025-067-07", "68025-065-07", "68025-067-30", "68025-083-07", "68025-065-30", "68025-083-30", "68025-066-07")),  #Gel_estrogens
  "Estrogel" = "A17139-617-40",  #Gel_estrogens
  "Elestrin" = (c("0037-4801-70", "0037-4802-35")))
  













##################################
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

PartD_Prescriber_PUF_NPI_14 <- read_delim("PartD_Prescriber_PUF_NPI_14.txt", "\t", escape_double = FALSE, trim_ws = TRUE)  %>%
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  arrange(npi) %>%
  filter(nppes_entity_code != "O") %>%
  filter(nppes_provider_country =="US") %>%
  filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))%>%
  mutate (year = "2014")

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
download.file("https://www.dropbox.com/s/xzjxw5etettxjas/PartD_Prescriber_PUF_NPI_16.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_16.txt", method = "auto")

PartD_Prescriber_PUF_NPI_16 <- read_delim("PartD_Prescriber_PUF_NPI_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE)  %>%
  filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  arrange(npi) %>%
  filter(nppes_entity_code != "O") %>%
  filter(nppes_provider_country =="US") %>%
  filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))%>%
  mutate (year = "2016")
# 
# #2017 year
download.file("https://www.dropbox.com/s/7ovqho9pp6g6kft/PartD_Prescriber_PUF_NPI_17.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_17.txt", method = "auto")

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
all_PartD_Prescriber_PUF_NPI <- bind_rows(PartD_Prescriber_PUF_NPI_14, PartD_Prescriber_PUF_NPI_15, PartD_Prescriber_PUF_NPI_16, PartD_Prescriber_PUF_NPI_17)
# 
# write_rds(all_PartD_Prescriber_PUF_NPI, "all_PartD_Prescriber_PUF_NPI.rds")

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


