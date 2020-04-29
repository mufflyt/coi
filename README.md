# Do doctors prescribe more of a drug if they receive money from a pharmaceutical company tied to it?
Muffly, Archer, Guido, Ferber

*Hypotheses and Specific Aims:*

*Hypothesis:  We hypothesize that OBGYN physicians who receive pharmaceutical industry non-research payments are more likely to prescribe medications created by the company from which they received payments, compared to their peers who do not receive pharmaceutical industry non-research payments.*
 
*Aim 1:   To evaluate whether OBGYN physicians who receive pharmaceutical non-industry payments, including general payments and payments in the form of ownership or investments, are more likely than their peer to prescribe medications created by the company from which they received payments.*
 
*Aim 2:  To assess whether prescribing rates for certain medications differ depending on which type of industry payments OBGYN physicians received including: payments for travel and lodging, food and beverage, consulting, charitable contributions, serving as faculty or as a speaker, royalties or licenses, space rentals or facility fees, honoraria, gifts, and education.*
 
*Aim 3:  To identify if there is a measurable monetary threshold at which there is an association between pharmaceutical payments to OBGYN physicians and prescribing practices.*


Working Abstract
==========
OBJECTIVE:
To characterize industry payments to physician specialists who prescribe gynecologic drugs in the Medicare program.  Pharmacetical companies spend more than a billion dollars annually to maket their treatments, and a significant portion is targeted at doctors.  These interactions between doctors and pharmaceutical companies include sponsored meals, promotional speaking, consulting and travel expenses.  Other research has found correlations between industry interactions and prescribing for certain classes of drugs, including opioids, urology drugs, oncology treatments, inflammatory bowel disease treatments and heartburn medication. 

DESIGN, SETTING, AND PARTICIPANTS:
This study was a cross-sectional analysis of Centers for Medicare & Medicaid Services 2015, 2016, 2017 Part D prescribing data linked to 2015, 2016, 2017 Open Payments data.  We utliized a Markov Chain Monte Carlo for a generalized linear mix model.  MCMCglmm::MCMCglmm(Pre~drug + Cpay, random = ~NPI2, family = "poisson", burnin=5000, nitt=50000000, thin = 10)
The Pre~drug + Cpay is a formula to predict the number of prescriptions based on the drug class and cumulative financial payments from drug companies to that physician.  (https://projects.propublica.org/graphics/d4dpartd-methodology)

Our analysis uses data from the 2015 to 2017 calendar years. The prescription drug landscape has changed somewhat between 2017 and the performance of this analysis in 2020. Some drugs listed above have gone off patent, and competitors and generics have come to market.

All together, these x drugs accounted for about y% of all prescriptions under Part D.

(https://projects.propublica.org/graphics/d4dpartd-methodology) We chose to use a measure of total dollar value of the interactions. Typically the value of industry interactions for a particular doctor and drug were quite small, and the most common type of interaction was sponsored meals. Prior medical and psychology literature has established that even small gifts influence behavior, and therefore we were most interested in capturing whether any interaction occurred, regardless of the value. Additionally, there were outliers whose interactions were worth thousands or tens of thousands of dollars. A binary measure of industry interaction avoided outlier issues.


(https://projects.propublica.org/graphics/d4dpartd-methodology) Only providers with 11 or more claims for the drug were included in this model specification. Providers with fewer than 11 claims but who had industry interactions were excluded. This was necessary because we had no good comparison for such providers. Doctors with no industry interactions and who had fewer than 11 claims for a drug were not identifiable in our data.


(https://projects.propublica.org/graphics/d4dpartd-methodology) This model controlled for practice volume using doctors’ total Part D prescribing for all drugs other than the drug of interest. To avoid using a covariate that also measured the outcome variable, which was claims for the drug of interest, the covariate was defined as total Part D prescribing for all drugs minus prescribing for the drug of interest.



CONCLUSIONS AND RELEVANCE:
Pending!



Drug and Payments Data pull and preparation: This retrospective, cross-sectional study linked two large, publicly available datasets for 2013 to 2017: the Open Payment Database General Payments and the Medicare Part D Prescriber Public Use Files.  
==========
* [Open Payments Database General Payments (The Sunshine Act) Downloads, 2013 to 2018 available](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads), The Physician Payment Sunshine Act was passed as part of the Affordable Care Act and collects information about payments made to physicians by drug and device companies. It contains all transactions over $10 for things like travel, research, meals, gifts, and speaking fees. Each case contains the dollar value and nature of the payment, identifying information about the payment recipient and industry sponsor, as well as the medications or devices associated with each payment.

* [Medicare Part D Prescriber Public Use Files, 2013 to 2017](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber), The Centers for Medicare & Medicaid Services (CMS) Provider Utilization and Payment Data (Part D Prescriber) Public Use File (Part D PUF) is available and contains information on prescriptions prescribed to Medicare beneficiaries enrolled in Medicare’s prescription drug program.  For each prescriber and drug, it identifies the brand and generic name, the total days’ supply prescribed by that provider (which includes the original and refill prescriptions) as well as the drug cost dispensed at a provider’s direction for each calendar year. It contains information on the physician’s National Provider Identifier (NPI), full name, and specialty. To protect patient privacy, records derived from 10 or fewer claims are excluded. We identified all prescriptions made for the most commonly prescribed OBGYN medications from 2013 to 2017.  

Each row is one prescriber.  The dataset identifies providers by their National Provider Identifier (NPI) and the specific prescriptions that were dispensed at their direction, listed by brand name (if applicable) and generic name.  For each prescriber and drug, the dataset includes the total number of prescriptions that were dispensed, which include original prescriptions and any refills, and the total drug cost.  The total drug cost includes the ingredient cost of the medication, dispensing fees, sales tax, and any applicable administration fees and is based on the amount paid by the Part D plan, Medicare beneficiary, government subsidies, and any other third-party payers.Each row is one drug prescribed by one provider.  So there are many rows with one provider who prescribed multiple drugs.

* [National Bureau of Economic Research, NDC crosswalk](https://data.nber.org/data/ndc-hcpcs-crosswalk-dme.html)
* [National Drug Code Directory, Download NDC Database File - Excel Version (Zip Format)](https://www.fda.gov/drugs/drug-approvals-and-databases/national-drug-code-directory)
[![National Drug Code Directory](https://www.drugs.com/img/misc/ndc.png)](https://www.drugs.com/img/misc/ndc.png)


Physician Demographics
==========
* [Physician Compare National Downloadable File](https://data.medicare.gov/Physician-Compare/Physician-Compare-National-Downloadable-File/mj5m-pzi6)
* [National Uniform Claim Committee, Taxonomy Codes](http://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57)
* [Marketing to Doctors: Last Week Tonight with John Oliver (HBO)](https://www.youtube.com/watch?v=YQZ2UeOTO3I&feature=share)
[![ACOG district map](https://acogpresident.files.wordpress.com/2013/03/districtmapupdated.jpg?w=608)](https://acogpresident.files.wordpress.com/2013/03/districtmapupdated.jpg?w=608) 


Drug Classes that Muffly created
==========
* Payment_Class.csv
* Prescription_Class.csv
* ClassList - Two authors (TM and BB) developed a candidate list of drug classes based on use for common conditions, high cost, and presence of similarly effective, less expensive therapies.  These co-authors applied a priori criteria based on their clinical experience and the approved drugs database by the U.S. Food and Drug Administration to determine a list of drugs commonly prescribed by obstetrician-gynecologists.  

[![Matching name and NPI](https://github.com/mufflyt/coi/blob/master/op%20plus%20MPUPS.png?raw=true)](https://github.com/mufflyt/coi/blob/master/op%20plus%20MPUPS.png?raw=true)

[![Flow chart](https://github.com/mufflyt/coi/blob/master/Flow%20chart.png?raw=true)](https://github.com/mufflyt/coi/blob/master/Flow%20chart.png?raw=true)

#OP_PPI_Specialties.R

## Installation and use
### Install packages 
```r
rm(list = setdiff(ls(), lsf.str())). #cleans all environment except functions

# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("Hmisc")
install.packages('reshape')
install.packages('reshape2')
install.packages("tidyverse")

# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("Hmisc")
library("tidyverse")
library('reshape')
library('reshape2')
```

## Scripts: purpose for searching for NPPES
### Path:  `/Pharma_Influence/Guido_Working_file`

### Matching MPUPS Physician Names to Open Payments Data Process
Due to the absence of a common variable, a two-step process linked Open Payment with Provider Utilization and Payment Data Public Use File. First, the Open Payments Database was linked to National Provider Identification database based on the physicians first and last name, city and state. Then Medicare Provider Utilization and Payment Data Public Use File was linked using the common variable NPI.  Prescriber groups that did not have prescriptive authority or were not eligible for payments from the pharmaceutical industry (e.g., nurse practitioners, physician assistants, and pharmacists) also were excluded. The final analytic file included physician name, gender, address, city, state, zip code, physician specialty, drug name, total drug cost, total days’ supply for the drug, total amount of payments received and amount of payment received by individual manufacturers.  

### `1_Match PCND with OP.R`
**Description**: These files are numbered in ordered of how they are to be used "1_", then "2_", then "3_".Take the Physician_Compare_National_Downloadable_File.csv (abbreviated as PCND) and filters out APO/territories and selects the specialty of interest as `c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))` for primary and secondary specialties using the baller move of '|'.  The SQL codes removes duplicate NPI numbers.  Open Payment data is loaded from `OP_PH_PRFL_SPLMTL_P06282019.csv`.  All data is changed to lower case and `!=" "`.  Then the merge process starts based on 
* first, last, city, state creates matching payments (MP).  
* check for matches using address
Counts are taken throughout the project.  Of note, `Physician_Profile_ID` is a unique identificaiton number for Open Payments doctors.  

**Use**:   `source("1_Match PCND with OP.R")` 

**Output**: 
* `studygroupR2.csv` - Matching payments data is all matched based on the above criteria and written out.  
* `PCND.csv` - Physician compare data left joined with the `MP` so this has the demographics of the doctors who had matching payments.  
* `StudyGroupR2.rds` - 'MP' dataframe is saved so this is a list of the physicians matched with payments.  

### Matching Physician Names to Open Payments Data Process
### `Unfiltered_Match.R`

**Description**: There are going to be a few rounds of physician name matching to Open Payments data.  
Round 1:
* `Prescriber_Name$MatchNMIZip` is a match based on first name, last name and zip code.
* `Prescriber_Name$MatchNMI` is first name and last name.  
* `Prescriber_Name$MatchMI` is the first name, middle initial, and last name.  

Round 2:
* no middle initial

**Use**: `source(".R")` 

**Input**: The file builds everything it needs from scratch without requiring inputs.  

**Output**: 
* Prescriber_Name_Matched_unfil.csv
* Prescriber_Name_UnMatched_unfil.csv




### `2_Load_Data.R`

**Description**: Files starts with `StudyGroupR3.csv` defined as `StudyGroup` and I don't know where this comes from.  Reads in data for all years by reading txt file from the internet: `PartD_Prescriber_PUF_NPI_DRUG_xx.txt`.  Merge all the years of Prescriber Drug information together.  Read in the open payments data that was processed before:  `OP_DTL_GNRL_PGYR2017_P0629xxx.csv`.  Corrects the column names across all years.  `PaySum5` aggregates dollar amounts.  

**Use**: `source("2_Load_Data.R")` 

**Input**: 
* `StudyGroupR3.csv` - Crosswalk of NPI number and matching PPI number from Open Payments.  I don't know where this came from.  
* `PartD_Prescriber_PUF_NPI_DRUG_13.txt -> PartD_Prescriber_PUF_NPI_DRUG_17.txt`
* `OP_DTL_GNRL_PGYR2013_P06292018.csv -> OP_DTL_GNRL_PGYR2017_P06292018.csv`

**Output**: `paymentSummary.csv` has the `Physician_Profile_ID` listed then the drug of interest (e.g. `NDC_of_Associated_Covered_Drug_or_Biological`) that doctor prescribed and how much they received in payments from that pharmaceutical company.  Very useful!


### `3_Buld_Output R1.R`

**Description**: Normalize column names, change drug names to lower case.  

**Use**: `source("3_Buld_Output R1.R")` 

**Input**: (in case this is run independently)
* StudyGroupR3.csv [updated to R3 10/6/19], `StudyGroup`
* prescriber.csv, `Prescriber`
* PaySum.csv, `PaySum` 
* Payment_Class.csv loaded in to the github repository
* Prescription_Class.csv  loaded in to the github repository

**Output**:
* `write_rds(PaySum, "PaySum_wClass.rds"  )`
* `write_rds(Prescriber, "Prescriber_wClass.rds")`
* `write.csv(class_xyz,"class_xyz.csv",row.names = FALSE,na="")`

### Adding Physician Demographics
Covariables included gender, American Board of Obstetrics and Gynecology-approved (ABOG) subspecialty (general OBGYNs, female pelvic medicine and reconstructive surgeons, gynecologic oncologists, maternal-fetal medicine specialists, and reproductive endocrinology and infertility specialists), ACOG region, overall physician volume of prescribing and prescribing volume in the same therapeutic class.  The overall prescribing volume of a physician was calculated as the total days’ supply of all drugs of any category prescribed by that physician.  A log of overall prescribing volume of a physician and the therapeutic class prescribing volume were used for improved model specifications.  Secondary analyses tested the association of payment from the manufacturer of the selected drug with the primary outcome. 

### `API access for NPPES.R`

**Description**: Takes a csv file and searches the NPPES database. I have a list of names that I would like to search for their NPI number using the NPI API (https://npiregistry.cms.hhs.gov/registry/help-api).  NPI number is a unique identifier number.  There are about 45,000 names that I want to see if there is a match in the csv file to the API.  There is documentation of the API listed above and this is also helpful (https://npiregistry.cms.hhs.gov/api/demo?version=2.1).  My goal is to get the correct NPI and all data as possible from the API.  The example API call would be: https://npiregistry.cms.hhs.gov/api/?number=&enumeration_type=NPI-1&taxonomy_description=&first_name=kale&use_first_name_alias=&last_name=turner&organization_name=&address_purpose=&city=&state=&postal_code=&country_code=&limit=&skip=&version=2.1.  Ultimately I want to use the location data for geocoding and to create a map.   

**Use**: `source("API access for NPPES.R")` 

**Output**: Address output.  


### `GOBA_Compare.R`
**Description**: Takes a file called `GOBA_unique.csv` of NPI numbers and merges it withe demographic data from `Physician Compare`.  `GOBA_unique.csv` can be matched to get subspecialties out of NPI.  
**Output**: Puts out a file called: "GOBA_Compare.csv". 

### Code fragment that we can use to create a map
I had this from a separate project that I had done. I geocoded the street address, city, state of each FPMRS into lat and long using the Google geocoding API.  Zip codes were challenging to use and the street address, city, state information was accurate without zip codes.  Any non-matches were omitted.  These data were written to a file called locations.csv.  Many thanks to Jesse Adler for the great code.  I need to put google key.  

[![Geocoding, how does it work](https://geospatialmedia.s3.amazonaws.com/wp-content/uploads/2018/05/geocoding-graph.jpg)](https://geospatialmedia.s3.amazonaws.com/wp-content/uploads/2018/05/geocoding-graph.jpg)

```r
# Google geocoding of FPMRS physician locations ----
#Google map API, https://console.cloud.google.com/google/maps-apis/overview?pli=1

#Allows us to map the FPMRS to street address, city, state
library(ggmap)
gc(verbose = FALSE)
ggmap::register_google(key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
ggmap::ggmap_show_api_key()
ggmap::has_google_key()
colnames(full_list)

View(full_list$place_city_state)
dim(full_list)
sum(is.na(full_list$place_city_state))

locations_df <- ggmap::mutate_geocode(data = full_list, location = place_city_state, output="more", source="google")
locations <- tibble::as_tibble(locations_df) %>%
   tidyr::separate(place_city_state, into = c("city", "state"), sep = "\\s*\\,\\s*", convert = TRUE) %>%
   dplyr::mutate(state = statecode(state, output_type = "name"))
 colnames(locations)
 write_csv(locations, "locations.csv")
locations <- readr::read_csv("/Users/tylermuffly/Dropbox/workforce/Rui_Project/locations.csv")

head(locations)
dim(locations)  
View(locations)
```

### `OP_PPI_Specialties.R`
**Description**: Brings together Open Payments data 

**Use**: `source("OP_PPI_Specialties.R")` 

**Input**: `OP_DTL_GNRL_PGYR2013_P062920xx.csv`?Not sure?

**Output**: write.csv(OPx_SP,"OP_AllSpecialty.csv", row.names = FALSE)



### Get scripts into a new RStudio project:
`New Project - Version Control - Git -` https://github.com/mufflyt/coi.git as `Repository URL`
(Our use your preferred way of cloning/downloading from GitHub.)

### Contact:
Please contact me with any questions or concerns: tyler (dot) muffly (at) dhha (dot) org.  


TEMPLATE
### Matching Physician Names to Open Payments Data Process
### `.R`

**Description**: 

**Use**: `source(".R")` 

**Input**: 


**Output**: 

### STROBE study
The study was written using the STROBE checklist:
https://www.strobe-statement.org/index.php?id=available-checklists
