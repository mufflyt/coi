#Wor, on merge between docs and drugs and companies and drugs

#Add more of a data dictionary for each variable
#add in dummy tables
#

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
pacman::p_load('janitor', 'lubridate', 'hms', 'tidyr', 'devtools', 'purrr', 'readr', 'ggplot2', 'dplyr', 'forcats', 'RcppRoll', 'lubridate', 'hms', 'tidyr', 'stringr', "bit64", "remotes", "tidylog","inspectdf", "DataExplorer", "arsenal", "RCurl")

##################################################################
# Set data file locations ----
setwd("~/Dropbox/Pharma_Influence")
data_folder <- paste0(getwd(),"/Data/")
results_folder <- paste0(getwd(),"/Results/")

##################################################################
# Load data ----

#Create a function or a loop to read in each year of the PUF_NPI_DRUG and Prescriber_PUF_NPI???

# Directory:  Dropbox/Pharma_Influence/Data/Medicare Part D data/ PartD_Prescriber_PUF_DRUG_15
# File: PartD_Prescriber_PUF_NPI_Drug_15.txt
# These are tab delimated files and need to be brought in with read_delim.  
# Data dictionary: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/Prescriber_Methods.pdf 

#Part D Prescriber Public Use File (herein referred to as the “Part D Prescriber PUF”), with information on prescription drug events incurred by Medicare beneficiaries with a Part D prescription drug plan
# Steps to read in drug_prescribers_x_year

#Download file from https://www.cms.gov/research-statistics-data-and-systems/statistics-trends-and-reports/medicare-provider-charge-data/part-d-prescriber.html and extract the .txt file

#2016 year 
PartD_Prescriber_PUF_NPI_Drug_16 <- download.file("http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/PartD_Prescriber_PUF_NPI_DRUG_16.zip", destfile = "PartD_Prescriber_PUF_NPI_Drug_16.zip", method = "auto")

#2014 year
PartD_Prescriber_PUF_NPI_Drug_14 <- download.file("http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/PartD_Prescriber_PUF_NPI_DRUG_14.zip", destfile = "PartD_Prescriber_PUF_NPI_Drug_14.zip", method = "auto")

#2013 year
PartD_Prescriber_PUF_NPI_Drug_13 <- download.file("http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/PartD_Prescriber_PUF_NPI_DRUG_14.zip", destfile = "PartD_Prescriber_PUF_NPI_Drug_14.zip", method = "auto")

#Download 2015 file from Dropbox:  
download.file("https://www.dropbox.com/s/4xt8epb06xvnigo/PartD_Prescriber_PUF_NPI_Drug_15.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_Drug_15.txt", method = "auto", cacheOK = TRUE)
PartD_Prescriber_PUF_NPI_Drug_15 <- read_delim("~/Downloads/PartD_Prescriber_PUF_NPI_DRUG_15/PartD_Prescriber_PUF_NPI_Drug_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>% #tab deliminated file
    filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  # Make all OBGYN the same factor with "Obstetrics & Gynecology"
  mutate(npi = factor(npi), specialty_description = recode(specialty_description, `Gynecological Oncology` = "Obstetrics & Gynecology", `Obstetrics/Gynecology` = "Obstetrics & Gynecology")) %>%
  select(-description_flag, everything()) %>%
  select(generic_name, everything()) %>%
    mutate(npi = factor(npi)) %>%
    mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
    arrange(npi)

cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(PartD_Prescriber_PUF_NPI_Drug_15, show_plot = TRUE)
print(str(PartD_Prescriber_PUF_NPI_Drug_15))
plot_intro(PartD_Prescriber_PUF_NPI_Drug_15)
DataExplorer::plot_missing(PartD_Prescriber_PUF_NPI_Drug_15)
DataExplorer::plot_bar(PartD_Prescriber_PUF_NPI_Drug_15)
DataExplorer::plot_histogram(PartD_Prescriber_PUF_NPI_Drug_15)
inspectdf::inspect_cat(PartD_Prescriber_PUF_NPI_Drug_15, show_plot = TRUE)
inspectdf::inspect_imb(PartD_Prescriber_PUF_NPI_Drug_15, show_plot = TRUE)
table1_PartD_Prescriber_PUF_NPI_Drug_15 <- arsenal::tableby( ~., data=PartD_Prescriber_PUF_NPI_Drug_15, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_all_data, text=T, title='Table 1:  PartD_Prescriber_PUF_NPI_Drug_15, Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)

# Steps to read in npi_prescribers_x_year

# aggregated information at the prescriber-level (i.e. one summary record per NPI) that includes enhanced prescriber demographic information beyond what is provided in the Part D Prescriber PUF detail data.  The “Part D Prescriber Summary Table” contains overall drug utilization (claims, 30-day standardized fill counts and day’s supply), drug costs, and beneficiary counts organized by NPI. Drug utilization, drug costs, and beneficiary counts are also included for each of the following sub group classifications:
# • Beneficiariesage65andolder;
# • Brand drugs, generic drugs, and other drugs;
# • Medicare Advantage Prescription Drug (MAPD) and stand-alone Prescription Drug Plans (PDP);
# • Low-income subsidy (LIS) and no low-income subsidy (nonLIS); and
# • Opioids, long-acting opioids, antibiotics, and antipsychotics in the elderly.

download.file("https://www.dropbox.com/s/4xt8epb06xvnigo/PartD_Prescriber_PUF_NPI_Drug_15.txt?raw=1", destfile = "PartD_Prescriber_PUF_NPI_15.txt", method = "auto")

PartD_Prescriber_PUF_NPI_15 <- read_delim("~/Downloads/PartD_Prescriber_PUF_NPI_15/PartD_Prescriber_PUF_NPI_15.txt", "\t", escape_double = FALSE, trim_ws = TRUE) %>%
   filter(specialty_description %in% c("Obstetrics & Gynecology", "Obstetrics/Gynecology", "Gynecological Oncology")) %>%
  mutate(npi = factor(npi)) %>%
  mutate(specialty_description = fct_drop(specialty_description), npi = fct_drop(npi)) %>%
  arrange(npi) %>%
  filter(nppes_entity_code != "O") %>%
  filter(nppes_provider_country =="US") %>%
  filter(nppes_provider_state != c("ZZ", "AA", "AE", "AP", "AS", "GU", "MP", "VI"))

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

physician_compare <- read_csv("~/Downloads/Physician_Compare_National_Downloadable_File.csv") %>%
  mutate(NPI = factor(NPI), `PAC ID` = factor(`PAC ID`), `Professional Enrollment ID` = factor(`Professional Enrollment ID`)) %>%
  filter(Credential %in% c("MD", "DO") & `Primary specialty` %in% c("OBSTETRICS/GYNECOLOGY", "GYNECOLOGICAL ONCOLOGY")) %>%
  select(-`Line 2 Street Address`, -`Phone Number`, -`Secondary specialty 1`, -`Secondary specialty 2`, -`Secondary specialty 3`, -`Secondary specialty 4`, -`All secondary specialties`) %>%
  mutate(`Graduation year` = factor(`Graduation year`)) %>%
  select(-`PAC ID`, -`Professional Enrollment ID`, everything()) %>%
  distinct(NPI, .keep_all = TRUE)
  #clean.zipcodes(`Zip Code`)  #not working for some reason

cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(physician_compare, show_plot = TRUE)
print(str(physician_compare))
plot_intro(physician_compare)
DataExplorer::plot_missing(physician_compare)
DataExplorer::plot_bar(physician_compare)
DataExplorer::plot_histogram(physician_compare)
inspectdf::inspect_cat(physician_compare, show_plot = TRUE)
#inspectdf::inspect_imb(z, show_plot = TRUE)
table1_physician_compare <- arsenal::tableby( ~., data=physician_compare, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_physician_compare, text=T, title='Table 1:  Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)


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

product <- read_delim("~/Downloads/National Drug Code Directory/product.xls", 
                      "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  select(-DOSAGEFORMNAME, -ROUTENAME, -APPLICATIONNUMBER) %>%
  distinct(NONPROPRIETARYNAME, .keep_all = TRUE) %>%
  select(-PROPRIETARYNAME, everything()) %>%
  distinct(PRODUCTNDC, .keep_all = TRUE) %>%
  select(-SUBSTANCENAME) %>%
  mutate(PRODUCTNDC = factor(PRODUCTNDC), PRODUCTNDC = fct_drop(PRODUCTNDC))

cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(aa, show_plot = TRUE)
print(str(product))
plot_intro(product)
DataExplorer::plot_missing(product)
DataExplorer::plot_bar(product)
DataExplorer::plot_histogram(product)
inspectdf::inspect_cat(product, show_plot = TRUE)
inspectdf::inspect_imb(product, show_plot = TRUE)
table1_product <- arsenal::tableby( ~., data=product, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_product, text=T, title='Table 1:  Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)

#NDC package files
download.file("https://www.dropbox.com/s/5gbrm7tpjup5lfd/package.xls?dl=0?raw=1", destfile = "package.xls", method="auto")

package <- read_delim("~/Downloads/National Drug Code Directory/package.xls", 
                                 "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  distinct(PRODUCTNDC, .keep_all = TRUE) %>%
  distinct(NDCPACKAGECODE, .keep_all = TRUE) %>%
  mutate(PRODUCTNDC = factor(PRODUCTNDC)) %>%
  separate(NDCPACKAGECODE, into = c("NDCPACKAGECODE_1", "NDCPACKAGECODE_2", "last2"), sep = "\\s*\\-\\s*", remove = FALSE, convert = FALSE) %>%
  mutate(NDCPACKAGECODE_1 = str_pad(NDCPACKAGECODE_1, width= 5, pad="0", side="left")) %>%
  unite(NDCPACKAGECODE_1_NDCPACKAGECODE_2_last2, NDCPACKAGECODE_1, NDCPACKAGECODE_2, last2, sep = "-", remove = FALSE) %>%
  rename(`5,4,2versionofNDCpackagecode` = NDCPACKAGECODE_1_NDCPACKAGECODE_2_last2) %>%
  mutate(`5,4,2versionofNDCpackagecode` = factor(`5,4,2versionofNDCpackagecode`))

cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(package, show_plot = TRUE)
print(str(package))
plot_intro(package)
DataExplorer::plot_missing(package)
DataExplorer::plot_bar(package)
DataExplorer::plot_histogram(package)
inspectdf::inspect_cat(package, show_plot = TRUE)
inspectdf::inspect_imb(package, show_plot = TRUE)
table1_package <- arsenal::tableby( ~., data=package, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_package, text=T, title='Table 1:  Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)

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
PGYR17_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR17_P011819.ZIP", destfile = "PGYR17_P011819.ZIP", method = "auto", cacheOK = TRUE)

#Open Payments 2016 data
PGYR16_P011819 <- PGYR17_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR16_P011819.ZIP", destfile = "PGYR17_P011819.ZIP", method = "auto", cacheOK = TRUE)

#Open Payments 2015 data
PGYR15_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR15_P011819.ZIP", destfile = "PGYR15_P011819.ZIP", method = "auto", cacheOK = TRUE)

#Open Payments 2014 data
PGYR14_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR14_P011819.ZIP", destfile = "PGYR15_P011819.ZIP", method = "auto", cacheOK = TRUE)

#Open Payments 2013 data
PGYR13_P011819 <- download.file(url = "http://download.cms.gov/openpayments/PGYR13_P011819.ZIP", destfile = "PGYR13_P011819.ZIP", method = "auto", cacheOK = TRUE)

open_payments_2017 <- read_csv("~/Downloads/OP_DTL_GNRL_PGYR2015_P01182019.csv") %>%
#Start merging data together.  Do we need a sql back-end?
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
  unite(`5_4_2_NDC`, `5`, `4`, `2 NDC`, sep = "-", remove = FALSE) 


cat("\n","----- Initial Structure of data frame -----","\n")
# examine the structure of the initial data frame
inspectdf::inspect_types(open_payments_2019, show_plot = TRUE)
print(str(open_payments_2019))
plot_intro(open_payments_2019)
DataExplorer::plot_missing(open_payments_2019)
DataExplorer::plot_bar(open_payments_2019)
DataExplorer::plot_histogram(open_payments_2019)
inspectdf::inspect_cat(open_payments_2019, show_plot = TRUE)
inspectdf::inspect_imb(open_payments_2019, show_plot = TRUE)
table1_open_payments_2019 <- arsenal::tableby( ~., data=open_payments_2019, control = tableby.control(test = TRUE, total = F, digits = 1L, digits.p = 2L, digits.count = 0L, numeric.simplify = F, numeric.stats = c("median", "q1q3"), cat.stats = c("Nmiss","countpct"), stats.labels = list(Nmiss = "N Missing", Nmiss2 ="N Missing", meansd = "Mean (SD)", medianrange = "Median (Range)", median ="Median", medianq1q3 = "Median (Q1, Q3)", q1q3 = "Q1, Q3", iqr = "IQR",range = "Range", countpct = "Count (Pct)", Nevents = "Events", medSurv ="Median Survival", medTime = "Median Follow-Up")))

summary(table1_open_payments_2019, text=T, title='Table 1:  Characteristics of Physicians Prescribing Medication to Medicare PArt D patients in 2015', pfootnote=TRUE)


##################################
### Join all the data together ###

#Merge the NPI file data with the NDC data about the drugs by merging on the generic name.  
# Lost a lot of data here.  THIS COULD BE A PROBLEM AND COULD ?USE FUZZY MATCHING?
dim(PartD_Prescriber_PUF_NPI_Drug_15)

join <- PartD_Prescriber_PUF_NPI_Drug_15 %>%
inner_join(product, by = c("generic_name" = "NONPROPRIETARYNAME"))
dim(join)

physician_data <- open_payments_2019 #%>%
#we need to get these physicians matched to their NPI numbers before joining the OP data with the demographics data please

left_join(OP_GNRL_2016_P06292018, by = c("PRODUCTNDC" = "5_4_2_NDC"))







