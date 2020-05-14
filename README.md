# Do doctors prescribe more of a drug if they receive money from a pharmaceutical company tied to it?
# Association of Industry Payments to Obstetrician-Gynecologists and Prescription Behavior: an observational study using Open Payments and Medicare Part D Data
Muffly, Archer, Guido, Ferber

*Hypotheses and Specific Aims:*

*Hypothesis:  We hypothesize that OBGYN physicians who receive pharmaceutical industry non-research payments are more likely to prescribe medications created by the company from which they received payments, compared to their peers who do not receive pharmaceutical industry non-research payments.*
 
*Aim 1:   To evaluate whether OBGYN physicians who receive pharmaceutical non-industry payments, including general payments and payments in the form of ownership or investments, are more likely than their peer to prescribe medications created by the company from which they received payments.*
 
*Aim 2:  To assess whether prescribing rates for certain medications differ depending on which type of industry payments OBGYN physicians received including: payments for travel and lodging, food and beverage, consulting, charitable contributions, serving as faculty or as a speaker, royalties or licenses, space rentals or facility fees, honoraria, gifts, and education.*
 
*Aim 3:  To identify if there is a measurable monetary threshold at which there is an association between pharmaceutical payments to OBGYN physicians and prescribing practices.*

* [Marketing to Doctors: Last Week Tonight with John Oliver (HBO)](https://www.youtube.com/watch?v=YQZ2UeOTO3I&feature=share)
* [Propublica Doctors Prescribe more of a durg if they receive money from the pharma manufacturer](https://www.propublica.org/article/doctors-prescribe-more-of-a-drug-if-they-receive-money-from-a-pharma-company-tied-to-it
)
* [Propublica Methodology](https://projects.propublica.org/graphics/d4dpartd-methodology)


Drug and Payments Data pull and preparation: This retrospective, cross-sectional study linked two large, publicly available datasets for 2013 to 2018: the Open Payment Database General Payments and the Medicare Part D Prescriber Public Use Files.  
==========
* [Open Payments Database General Payments (The Sunshine Act) Downloads, 2013 to 2018 available](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads), The Physician Payment Sunshine Act was passed as part of the Affordable Care Act and collects information about payments made to physicians by drug and device companies. It contains all transactions over $10 for things like travel, research, meals, gifts, and speaking fees. Each case contains the dollar value and nature of the payment, identifying information about the payment recipient and industry sponsor, as well as the medications or devices associated with each payment. This is NOT money for grants and research.  #downloaded April 30, 2020

* [Medicare Part D Prescriber Public Use Files, 2013 to 2018](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber), The Centers for Medicare & Medicaid Services (CMS) Provider Utilization and Payment Data (Part D Prescriber) Public Use File (Part D PUF) is available and contains information on prescriptions prescribed to Medicare beneficiaries enrolled in Medicare’s prescription drug program.  For each prescriber and drug, it identifies the brand and generic name, the total days’ supply prescribed by that provider (which includes the original and refill prescriptions) as well as the drug cost dispensed at a provider’s direction for each calendar year. It contains information on the physician’s National Provider Identifier (NPI), full name, and specialty. To protect patient privacy, records derived from 10 or fewer claims are excluded. We identified all prescriptions made for the most commonly prescribed OBGYN medications from 2013 to 2018. 

Each row is one prescriber.  The dataset identifies providers by their National Provider Identifier (NPI) and the specific prescriptions that were dispensed at their direction, listed by brand name (if applicable) and generic name.  For each prescriber and drug, the dataset includes the total number of prescriptions that were dispensed, which include original prescriptions and any refills, and the total drug cost.  The total drug cost includes the ingredient cost of the medication, dispensing fees, sales tax, and any applicable administration fees and is based on the amount paid by the Part D plan, Medicare beneficiary, government subsidies, and any other third-party payers.Each row is one drug prescribed by one provider.  So there are many rows with one provider who prescribed multiple drugs. #downloaded April 30, 2020

* [National Bureau of Economic Research, NDC crosswalk](https://data.nber.org/data/ndc-hcpcs-crosswalk-dme.html)
* [National Drug Code Directory, Download NDC Database File - Excel Version (Zip Format)](https://www.fda.gov/drugs/drug-approvals-and-databases/national-drug-code-directory)
[![National Drug Code Directory](https://www.drugs.com/img/misc/ndc.png)](https://www.drugs.com/img/misc/ndc.png)


Physician Demographics
==========
* [Open Payments Database, Physician Supplement File for all Program Years](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads),  A supplementary file that displays all of the physicians indicated as recipients of payments in records reported in Open Payments. Each record includes the physicians demographic information, specialties, and license information, as well as a unique identification number (Physician Profile ID) that can be used to search for a specific physician in the general, research, and physician ownership files.  #downloaded April 30, 2020 
* [Physician Compare National Downloadable File](https://data.medicare.gov/Physician-Compare/Physician-Compare-National-Downloadable-File/mj5m-pzi6) #downloaded April 30, 2020
* [National Uniform Claim Committee, Taxonomy Codes](http://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57)
```r 
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
```

[![ACOG district map](https://acogpresident.files.wordpress.com/2013/03/districtmapupdated.jpg?w=608)](https://acogpresident.files.wordpress.com/2013/03/districtmapupdated.jpg?w=608) 
* [NPPES, NPPES Data Dissemination](https://download.cms.gov/nppes/NPI_Files.html) #downloaded April 30, 2020
* [Federal Office of Rural Health Policy (FORHP) Data Files for rural vs. urban by zip code](https://www.hrsa.gov/sites/default/files/hrsa/ruralhealth/aboutus/definition/nonmetrocountiesandcts2016.xlsx), In the interest of making information on the FORHP Rural Areas more easily usable for Researchers and other Government Agencies, FORHP has created a crosswalk of ZIP Codes identifying the set of Non-Metro Counties and rural Census Tracts (CTs) that comprise rural areas as defined by FORHP. This Excel file contains Non-Metro Counties (Micropolitan and non-core based counties.  


Drug Classes that Muffly created
==========
* Payment_Class.csv
* Prescription_Class.csv
* ClassList - Two authors (TM and BB) developed a candidate list of drug classes based on use for common conditions, high cost, and presence of similarly effective, less expensive therapies.  These co-authors applied *a priori* criteria based on their clinical experience and the approved drugs database by the U.S. Food and Drug Administration to determine a list of drugs commonly prescribed by obstetrician-gynecologists.  

[![Matching name and NPI](https://github.com/mufflyt/coi/blob/master/op%20plus%20MPUPS.png?raw=true)](https://github.com/mufflyt/coi/blob/master/op%20plus%20MPUPS.png?raw=true)

[![Flow chart](https://github.com/mufflyt/coi/blob/master/Flow%20chart.png?raw=true)](https://github.com/mufflyt/coi/blob/master/Flow%20chart.png?raw=true)

Table 1: Proposed types of medications for comparison.  											
											
Drug class,	Medication										
* Bisphosphonates: 	Fosamax,	Actonel,	Boniva,	Atelvia,	Prolia						
* Anticholinergics for overactive bladder:	Ditropan,	Ditropan XL,	Oxytrol,	Gelnique,	Detrol,	Detrol LA,	Sanctura,	Sanctura XR,	Vesicare,	Enablex,	Toviaz
* Oral Combined Estrogen and Progestin Products for Hormone Replacement:	Activella,	Combipatch,	Femhrt,	Premphase,	Prempro,	Menest,	Climara Pro				
* Transdermal estrogen: 	Alora,	Climara,	Vivelle,	Vivelle-Dot,	Menostar						
* Gel estrogens: 	Divigel,	Estrogel,	Elestrin								
* Vaginal Estrogen Hormone Therapy: 	Premarin,	Estrace,	Vagifem,	Estring,	Yuvafem,	Osphena,	Intrarosa				
* Antiviral: 	Valtrex,	Zovirax									
* Anti infective: 	Flagyl,	Tindamax									

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
install.packages('humaniformat')
install.packages("RSocrata")
install.packages("exploratory")
install.packages("janitor")

# Loading
library("sqldf")
library("qdapRegex")
library("sqldf")
library("readr")
library("Hmisc")
library('reshape')
library('reshape2')
library("tidyverse")
library("humaniformat")
library("RSocrata")
library("exploratory")
library("janitor")
```

## Matching Overview
* NPPES - NPI given so able to match with other databases with the key of NPI number
* PCND - NPI given
* OP - NO NPI so we need to match based on name, address, state, alternate names, suffix, etc.  
* GOBA - NO NPI

## Scripts: purpose for searching for NPPES
### Path:  `/Pharma_Influence/Guido_Working_file`

Due to the absence of a common variable, a two-step process linked Open Payment with Provider Utilization and Payment Data Public Use File. First, the Open Payments Database was linked to National Provider Identification database based on the physicians first and last name, city and state. Then Medicare Provider Utilization and Payment Data Public Use File was linked using the common variable NPI.  Prescriber groups that did not have prescriptive authority or were not eligible for payments from the pharmaceutical industry (e.g., nurse practitioners, physician assistants, and pharmacists) also were excluded. The final analytic file included physician name, gender, address, city, state, zip code, physician specialty, drug name, total drug cost, total days’ supply for the drug, total amount of payments received and amount of payment received by individual manufacturers.  

### Matching Physician Names to Open Payments Data Process
### `00_Pulling all scrapes together.R`
**Description**: Pulls data from disparate sources to create the one true list of GOBA.  It merges all the data together that has a unique id number `userid`.  Then the data is run through the NPPES API system (not RSocrata, bummer) to find a matching NPI number because there is no matching key between the two.  I need to figure how to do multiple rounds like in the original work that Joe did.  

**Use**: `source("00_Pulling all scrapes together.R")` 

**Input**: Get data off all machines first.  Remember that is is named `Physician_x to y with Sys.time.csv`.  

**Output**: 
`readr::write_csv("~/Dropbox/Pharma_Influence/Data/GOBA.csv")`


### `0_Data_Prep.R`

**Description**: First thing to run when starting.  THIS SHOULD RUN OVERNIGHT.  It installs and loads the libraries.  This takes hours....  After that it does some significant data cleaning and writes a file to the same folder with the name underscore 2.  On May 3, 2020 I had the nutz idea of trying to get the most recent data using APIs instead of downloading the individual files.  APIs are capable of providing data that is refreshed much more often than you can achieve with pulling, cleaning, and loading files.  This will allow for less storage of data.  The API also pulls from the "source" so we are always getting the straight data.  That being said it takes forever to get the data from the APIs so I switched back to files saved to an external drive.  

API with Documentation:
* Physician Compare with a helpful `RSocrata` code snippet - https://dev.socrata.com/foundry/data.medicare.gov/mj5m-pzi6
* Open Payments Overview of all available data - https://openpaymentsdata-origin.cms.gov/dataset/Open-Payments-for-Developers/ap6w-xznw
* Open Payments Physician Profile Data also uses `RSocrata` package - https://dev.socrata.com/foundry/openpaymentsdata.cms.gov/tr8n-5p4d

Do several rounds of matching OP Physician Demographics `OP_Summary` name to NPPES database `NPPES`.  These are the name variations tried:
* two versions based on middle and alternate middle, then two versions - with and without suffix

[![Name Matching challenges to accurate and consistent matching](https://www.rosette.com/wp-content/uploads/2017/12/NameMatchingMethods-Graphic1-v1.svg)](https://www.rosette.com/wp-content/uploads/2017/12/NameMatchingMethods-Graphic1-v1.svg) 

OP Physician Demographics :
* OP.full.name.1 = first, middle, last
* OP.full.name.2 = first, middle, last, suffix
* OP.full.name.3 = first2, middle2, last2 (all alternative/maiden/married name options)
* OP.full.name.4 = first2, middle2, last2, suffix2 (all alternative options)
* OP.full.name.state

NPPES:  
* nppes.full.name.1
* nppes.full.name.2
* nppes.full.name.3 (use alternative/maiden/married name options)
* nppes.full.name.state

Rounds to match OP Physician Demographics to NPPES:  (originally from `2_3_0_GOB_NPPES_Match.R`)
* Round 1: match on OP.full.name.1 / nppes.full.name.1 
* Round 2: match on OP.full.name.1 / nppes.full.name.2 
* Round 3: match on OP.full.name.1 / nppes.full.name.3 
* Round 5: match on OP.full.name.2 / nppes.full.name.1
* Round 6: match on OP.full.name.2 / nppes.full.name.2
* Round 7: match on OP.full.name.2 / nppes.full.name.3
* Round 9: match on OP.full.name.3 / nppes.full.name.1 
* Round 10: match on OP.full.name.3 / nppes.full.name.2 
* Round 11: match on OP.full.name.3 / nppes.full.name.3 
* Round 13: match on OP.full.name.4 / nppes.full.name.1 
* Round 14: match on OP.full.name.4 / nppes.full.name.2 
* Round 15: match on OP.full.name.4 / nppes.full.name.3 
* Round 17: match on OP.full.name.1 / nppes.full.name.1 
* Round 18: match on OP.full.name.1 / nppes.full.name.2 
* Round 19: match on OP.full.name.1 / nppes.full.name.3 
* Round 21: match on OP.full.name.1 / nppes.full.name.1 + state #did not do the state
* Round 22: match on OP.full.name.1 / nppes.full.name.2 + State
* Round 23: match on OP.full.name.1 / nppes.full.name.2 + State
* Round 25: match on OP.full.name.2 / nppes.full.name.1 State
* Round 26: match on OP.full.name.2 / nppes.full.name.2 State
*. There are more....

GOBA: (no suffixes or 
* GOBA.full.name.1
* GOBA.full.name.state

**Use**: `source("0_Data_Prep.R")` 

**Input**: None.  This takes raw data from the APIS and originally external hard drives `/Volumes/Pharma_Influence/Data` loads it and selects only the columns needed.  This is especially important with the NPPES file.  It is HUGE!  I cleaned the GOBA_unique.csv file making it unique NPI and GOBA_ID numbers.  I also added the ACOG districts.  

**Output**: 
readr::write_csv(PCND, "/Volumes/Projects/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File2.csv"
"/Volumes/Projects/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_2.csv"


### `1_Match PCND with OP.R`
**Description**: The goal of this file and the `1_Match_OP_NPPES_PCND.R` are to create a crosswalk between NPI and PPI numbers. This has nothing to do with payments and only uses the Physician summary data from open payments. 

Steps to get ready for matching the full names:
* keep only unique NPI numbers
* Change first, middle, last names, and alternative names to title text
* Change NA to "" so no names are created as Tyler NA
* Impute NA to "" for middle names so don't get Tyler NA Muffly
* str_clean all name fields
* Remove all punctuation from state name
* Filter to include only states + DC + PR: 
* keep only unique NPI numbers again
* Split names into: first, middle, last, suffix
* Unite to create: full.name.1 that is first, middle, last
* Unite to create: full.name. that is first, middle, last, suffix (II, III, Jr.). There were no suffixes or alternative names for PCND
* Unite to create: full.name. that is other first, other middle, other last name
* Unite to create: full.name.2 that is first, middle, last, state name
* Unite to create: full.name.3 that is first line address, state name, last name (I suspect that PCND and NPPES use same address)

These files are numbered in ordered of how they are to be used "1_", then "2_", then "3_".Take the Physician_Compare_National_Downloadable_File.csv (abbreviated as PCND) and filters out APO/territories and selects the specialty of interest as `c("GYNECOLOGICAL ONCOLOGY", "OBSTETRICS/GYNECOLOGY"))` for primary and secondary specialties using the baller move of '|'.  The SQL codes removes duplicate NPI numbers.  Open Payment data is loaded from `OP_PH_PRFL_SPLMTL_P06282019.csv`.  All data is changed to lower case and `!=" "`.  Then the merge process starts based on 
* first, last, city, state creates matching payments (MP).  
* check for matches using address
Counts are taken throughout the project.  Of note, `Physician_Profile_ID` is a unique identificaiton number for Open Payments doctors.  

**Use**:   `source("1_Match PCND with OP.R")` 

**Output**: 
* `studygroupR2.csv` - Matching payments data is all matched based on the above criteria and written out.  
* `PCND.csv` - Physician compare data left joined with the `MP` so this has the demographics of the doctors who had matching payments.  
* `StudyGroupR2.rds` - 'MP' dataframe is saved so this is a list of the physicians matched with payments.  


### `1_Match_OP_NPPES_PCND.R`

**Description**: Loads NPPES data (mainly demographics) and Open Payments data.  Joe used a great combination of Open Payments  names and NPPES names.  He even included the alternative last names.  Wow!  Baller!  Then he mixed the NPPES addressed with names.  I have to learn SQL code/sqldf and how to do this for sure! Takes many hours to run given the single core nature of R.  

This is a great video on sqldf: https://youtu.be/s2oTUsAJfjI

DPLYR CODE
all_data %>% summarise(n_distinct(Medical_School))

is the same as....

SQLDF CODE
sqldf("SELECT COUNT(DISTINCT Medical_School) from all_data")

[![Reference about the types of database left outer joins we will do here](https://i.stack.imgur.com/S3WMq.jpg)](https://i.stack.imgur.com/S3WMq.jpg) 

Matching via multiple rounds:
* Round 1: First, middle, last, suffix, address, city, state
* Round 2: First, last, suffix, address, city, state
* Round 3: First, last, address, city, state
* Round 4: OP First NP AltFirst, last, address, city, state
* Round 5: First, OP last NP AltLast , address, city, state
* Round 6: OP Alt First NP First, last,address, city, state
* Round 7: First, OP Altlast NP last,address, city, state
* Round 8: OP altFirst NP First, OP Altlast NP last,address, city, state
* Round 9: First, last, NP Altaddress, NP Altcity, NP Altstate
* Round 10: First, middle, last, suffix, city, state
* Round 11: First, middle, last, city, state
* Round 12: First, last, city, state
* Round 13: First, middle, last, suffix, zip 
* Round 14: First, middle, last, zip
* Round 15: First, last, zip 

Following this Hurculean effort Joe then matched the remaining with Physician Compare Download File (PCND).  Payment data was loaded and matching of the demographics from above (NPPES) was done with the PCND file.  

Matching via multiple rounds:
* Round 1: first, last, city, state
* Round 2: ALT Last
* Round 3: ALT First
* Round 4: ALT First ALT Last
Update OP with matched based on PCND, add specialty, filter on OBGYN (i.e., build list of unmatched OBGYN in OP)

**Output**: `write.csv(OP_UnMatched,"OP_UnMatched.csv", row.names = FALSE)`
`write.csv(OP_UnMatched_OBGYN,"OP_UnMatched_OBGYN.csv", row.names = FALSE)`


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
* `write.csv(class_xyz,"class_xyz.csv",row.names = FALSE,na="")` - The prescriptions and payments by NPI and by drug.  
** `NPI number` is who wrote or did not write for a drug.  Including both allowed us to see a baseline for who wrote prescrptions and who did not.  
** `Year` of payment is present so we can make sure that the prescription behavior follows the payment
** `Pay_metrogel` is payments for the drug metrogel to this one provider for the `Year` specified.  The Pay_ prefix describes payments to the prescriber from that drug company who makes the prescription drug of choice.  
** `Pre_metrogel` is the number of prescriptions for each year by each individual NPI number.  The Pre_ prefix means prescriptions written for that drug.  

### Adding Physician Demographics
Covariables included gender, American Board of Obstetrics and Gynecology-approved (ABOG) subspecialty (general OBGYNs, female pelvic medicine and reconstructive surgeons, gynecologic oncologists, maternal-fetal medicine specialists, and reproductive endocrinology and infertility specialists), ACOG region, overall physician volume of prescribing and prescribing volume in the same therapeutic class.  The overall prescribing volume of a physician was calculated as the total days’ supply of all drugs of any category prescribed by that physician.  A log of overall prescribing volume of a physician and the therapeutic class prescribing volume were used for improved model specifications.  Secondary analyses tested the association of payment from the manufacturer of the selected drug with the primary outcome. 

### GOBA
**Description**: Pulls GOBA data from multiple time frames into one csv file that can be used.  Raw data are stored at `Dropbox, workforce, scraper, Scraper_results_2019` and are linked by URL to the code.  

**Use**: `source("pulling_all_scrapes_together.R")` 

**Output**:  
**Output**:  


### `GOBA_Compare.R`

**Description**: Takes a file called `GOBA_unique.csv` of NPI numbers and merges it withe demographic data from `Physician Compare`.  Most importantly, `GOBA_unique.csv` can be matched to get subspecialties `GOBA_Cert`from the NPI.  
**Output**: Puts out a file called: "GOBA_Compare.csv". 

### `API access for NPPES.R`

**Description**: Takes a csv file of `first_name` and `last_name` and searches the NPPES database for an NPI number. Instead of having complicated 12 round joins with PCND I wanted to try this NPPES API to see if the majority of the work could be done here. 

I have a list of names that I would like to search for their NPI number using the NPI API (https://npiregistry.cms.hhs.gov/registry/help-api).  NPI number is a unique identifier number.  There are about 45,000 names that I want to see if there is a match in the csv file to the API.  There is documentation of the API listed above and this is also helpful (https://npiregistry.cms.hhs.gov/api/demo?version=2.1).  My goal is to get the correct NPI and all data as possible from the API.  The example API call would be: https://npiregistry.cms.hhs.gov/api/?number=&enumeration_type=NPI-1&taxonomy_description=&first_name=kale&use_first_name_alias=&last_name=turner&organization_name=&address_purpose=&city=&state=&postal_code=&country_code=&limit=&skip=&version=2.1.  Ultimately I want to use the retrieved location data for geocoding and to create a map.   

**Use**: `source("API access for NPPES.R")` 

**Output**: `~/Dropbox/Pharma_Influence/Data/NPPES_API_Output.csv`

[![API, how does it work](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Ff8%2F02%2Fcc%2Ff802cc6d8fbc9e3f4a9223eb1d965275.jpg&f=1&nofb=1)](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Ff8%2F02%2Fcc%2Ff802cc6d8fbc9e3f4a9223eb1d965275.jpg&f=1&nofb=1)


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
**Description**: Merges all years of the open payments data and selects the PPI (`Physician_Profile_ID`) and Physician Specialty from all years of open payments.  

**Use**: `source("OP_PPI_Specialties.R")` 

**Input**: `OP_DTL_GNRL_PGYR2013_P062920xx.csv`?Not sure?

**Output**: `write.csv(OPx_SP,"OP_AllSpecialty.csv", row.names = FALSE)`. `write.csv(OPx_SP,"OP_AllSpecialty.csv", row.names = FALSE)` generates file to determine the specialty of every physician who received an open payment: `Physician_Profile_ID`, and `Physician_Specialty`.  

### Aggregating Statistics
### `OutputForStats.R`
**Description**: Removes physicians not practicing in the United States.  Remove physicians who do not accept Medicaid.  Physician Compare docs are all the physicians who accept Medicare.  Load the drug class data.  
```r
filter(StudyGroup, Physician_Profile_State %nin% c("GU", "VI", "ZZ", "AP", "AE")
```

**Use**: `source(".R")` 

**Input**: `Prescriber.csv`, `paymentSummary.csv`, `StudyGroupR1.csv`, `OP_PH_PRFL_SPLMTL_P06292018.csv`, `Physician_Compare_National_Downloadable_File.csv`, 

**Output**: `StudyGroup.rds`, `PaySum.rds`, `Prescriber.rds`.  


### `Table 2 R1.R`

**Description**: Creates Table 2.  

**Use**: `source("Table 2 R1.R")` 

**Input**: Brings in all data needed from within the file.  Self-contained.  

**Output**: ```r write.csv(T2, "T2.csv"), write.csv(OP,"AllPaymentData.csv") ```



### Start the Modeling!
A Poisson model will be used instead of a zero inflation model. Outcome of the model will be cumulative pay. The deliverable will be a graph of each drug with number of scripts on the Y-axis and dollars from the drug company on the X-axis.  IF the line goes up and to the right then we see a positive relationship between drugs and dollars from the drug company.   

### `Model all classes 2020.01.30.R`

**Description**: Runs a multi-response Poisson model model to determine the relationship between payments and prescribing.  Each class takes about 3 hours to run on my laptop and there are 8 classes.  `Cpay` stands for cumulative payments.  
SUMMARY-----------------------------------------
anti_inf:   cpay not sig, drug plots not great
antichol:   cpay sig, some plots not great, most fine
antiviral:  no cpay, see warning message, no payments in data
hormone:    cpay sig but negative, a couple not great, most fine
oral:       cpay sig but negative, plots perfect
transderm:  no cpay, probably same warning message
vaginal:    cpay sig, couple not great, most good

* [MCMCglmm](https://cran.r-project.org/web/packages/MCMCglmm/vignettes/Overview.pdf)


**Use**: `source("Model all classes 2020.01.30.R")` 

**Input**: `class_Anti_infective.csv` for each class 

**Output**: `anti_inf.5000.50000.10.poisson.rds` is the output from the model.  

> summary(result_anti_inf)

 Iterations = 5001:49991
 Thinning interval  = 10
 Sample size  = 4500 

 DIC: 109276.9 

 G-structure:  ~NPI2

     post.mean l-95% CI u-95% CI eff.samp
NPI2     9.239    8.599    9.838     1175

 R-structure:  ~units

      post.mean l-95% CI u-95% CI eff.samp
units     20.78    20.09    21.42    405.5

 Location effects: Pre ~ drug + Cpay 

                  post.mean  l-95% CI  u-95% CI eff.samp  pMCMC    
(Intercept)       -25.98190 -30.09269 -21.79644    1.582 <2e-04 ***
drugmetronidazole  25.32763  21.11161  29.45196    1.620 <2e-04 ***
drugtinidazole      9.86899   5.97936  14.55711    1.792 <2e-04 ***
Cpay                0.01275  -0.01127   0.04089  867.046  0.339    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

[![Random Trace Plot of Anti-Infectives](https://github.com/mufflyt/coi/blob/master/random%20effects%20trace%20plot%20of%20anti_inf_VCV.png?raw=true)](https://github.com/mufflyt/coi/blob/master/random%20effects%20trace%20plot%20of%20anti_inf_VCV.png?raw=true)

[![Random Trace Plot of Anti-Infectives](https://github.com/mufflyt/coi/blob/master/fixed%20effects%20trace%20plot%20anti-infective.png?raw=true)](https://github.com/mufflyt/coi/blob/master/fixed%20effects%20trace%20plot%20anti-infective.png?raw=true)

Tinidazole (dat_anti_inf,2) as a treatment for Bacterial vaginosis.  Y-axis is dollars to the physician form the manufacturer of tinidazole and X-axis is number of prescriptions.  Tinidazole does start increasing to meaningful numbers ($1,500, 30 rx).  
[![Prescriptions vs. Contributions to MD](https://github.com/mufflyt/coi/blob/master/tinidazole.png?raw=true)](https://github.com/mufflyt/coi/blob/master/tinidazole.png?raw=true)

### Matching Physician Names to Open Payments Data Process
Adjust the analysis based on:
* Gender
* Age at the time of prescribing
* ACOG district (map above)
* OBGYN generalist or subspecialist
* International Medical Graduate vs. U.S. Senior Medical Graduate
* Rurality of practice location
* Years since graduating from medical school
* Median income of households in the zip code of the physician's office (maybe from ACS, see Rui's project)
* Total amount of dollars that the physician received in Open Payments?
* A particular type of Open Payment (food, consulting, travel, etc.)?


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

### Get scripts into a new RStudio project:
`New Project - Version Control - Git -` https://github.com/mufflyt/coi.git as `Repository URL`
(Our use your preferred way of cloning/downloading from GitHub.)

### Contact:
Please contact me with any questions or concerns: tyler (dot) muffly (at) dhha (dot) org.  

### Target drug classes and Drug Manufacturers
```r
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
 ```
 
## Working Abstract
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



## Dummy Results Section
Results
From xxx,xxxx individual prescribers who prescribed drugs to Medicare Part D beneficiaries in 2013 to 2017, xxx,xxx wrote for OBGYN medications.  X% (n=?,???) of whom received at least one payment from the pharmaceutical industry (Table 1 and Table 2).  A total of ??,??? OBGYN physicians prescribing OBGYN medications were identified, including x number (??%) general OBGYNs, x number (?%) female pelvic medicine and reconstructive surgeons, x number (?%) gynecologic oncologists, x number (?%) maternal-fetal medicine specialists, and x number (?%) reproductive endocrinology and infertility specialists. Each physician wrote a mean (SD) of x(y) days of OBYN prescriptions. Mean (SD) days of prescriptions were x (SD), x (SD), x (SD), x (SD), and x (SD) for general OBGYNs, female pelvic medicine and reconstructive surgeons, gynecologic oncologists, maternal-fetal medicine specialists, and reproductive endocrinology and infertility specialists respectively.  
A total of xx,xxx providers receiving payments for OBGYN medications  were identified, and x (y%) of these compensated providers did not have any OBGYN prescriptions recorded. The overlap between compensation, and OBGYN prescriptions is shown in Figure 2. Overall, x,xxx of y (z%) compensated OBGYN medication prescribers prescribed OBGYN medications , compared to x,xxx of xx,xxx (y%) non-compensated OBGYN prescribers (P<.001, table 3).  This remained true following stratification by specialty, with general OBGYNs having the largest increase at 14-fold likelihood (Table 4). Compensated OBGYN medication prescribers received a median payment value of $xx ($yy-$yyy) and z(zz-zz) payments vs $xx ($yy-$yy) and z (zz-zz) for compensated non-prescribers (P<??.001 and <??.001, respectively).The mean (SD) rate of OBGYN medications prescriptions was 0.2%(2.5%) in non-compensated physicians and x.x% (x.x%) in compensated physicians (P<.001).There was a significant correlation between the percentage of OBGYN medications  prescriptions and both the number (r=0.??,P<?.001) and dollar value (r= 0.?,P<?0.001) of payments (Figures). When stratified by specialty, there was a significant correlation between the percentage of OBGYN medications  prescriptions and number of payments for general OBGYNS (r= 0.??,P<??.001), female pelvic medicine and reconstructive surgeons (r= 0.??,P<??.001), gynecologic oncologists (r= 0.??,P<??.001), maternal-fetal medicine specialists(r= 0.??,P<??.001), and reproductive endocrinologist and infertility specialists (r= 0.??,P<??.001).  There was also a significant correlation between the percentage of OBGYN medications  prescriptions and total dollar value of payments for general OBGYNS (r= 0.??,P<??.001), female pelvic medicine and reconstructive surgeons (r= 0.??,P<??.001), gynecologic oncologists (r= 0.??,P<??.001), maternal-fetal medicine specialists(r= 0.??,P<??.001), and reproductive endocrinologist and infertility specialists (r= 0.??,P<??.001).  
Table x shows the multivariable analysis for the odds of prescribing each drug by physicians who received any payment versus those who did not.  Any industry payment was associated with increased odds of prescribing of all the drugs??.  


Tyler to dos:
Create relative paths using here:here for all scripts
Rebuild GOBA unique with the more recent data 
