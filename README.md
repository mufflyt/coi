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
Add this image.  
https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmarket-it.fr%2Fpharmacomplianceinfo%2Fwp-content%2Fuploads%2F2014%2F10%2FOpen-Payments-Sunshine-Act-CMS.gouv_.jpg&f=1&nofb=1

Drug and Payments Data pull and preparation
==========
* [Open Payments Downloads, 2013 to 2018 available](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads)
* [Medicare Part D prescribing data, 2013 to 2017](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber)
* [National Bureau of Economic Research, NDC crosswalk](https://data.nber.org/data/ndc-hcpcs-crosswalk-dme.html)
* [National Drug Code Directory, Download NDC Database File - Excel Version (Zip Format)](https://www.fda.gov/drugs/drug-approvals-and-databases/national-drug-code-directory)
* [NPPES, Full Replacement Monthly NPI File](https://download.cms.gov/nppes/NPI_Files.html)



Physician Demographics
==========
* [Physician Compare National Downloadable File](https://data.medicare.gov/Physician-Compare/Physician-Compare-National-Downloadable-File/mj5m-pzi6)
* [National Uniform Claim Committee, Taxonomy Codes](http://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57)
* https://www.youtube.com/watch?v=YQZ2UeOTO3I&feature=share


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

### `2_Load_Data.R`

**Description**: Files starts with `StudyGroupR3.csv` defined as `StudyGroup` and I don't know where this comes from.  Reads in data for all years by reading txt file from the internet: `PartD_Prescriber_PUF_NPI_DRUG_xx.txt`.  Merge all the years of Prescriber Drug information together.  Read in the open payments data that was processed before:  `OP_DTL_GNRL_PGYR2017_P0629xxx.csv`.  Corrects the column names across all years.  `PaySum5` aggregates dollar amounts.  

**Use**: `source("2_Load_Data.R")` 

**Input**: 
* `StudyGroupR3.csv` - Crosswalk of NPI number and matching PPI number from Open Payments.  I don't know where this came from.  
* `PartD_Prescriber_PUF_NPI_DRUG_13.txt -> PartD_Prescriber_PUF_NPI_DRUG_17.txt`
* `OP_DTL_GNRL_PGYR2013_P06292018.csv -> OP_DTL_GNRL_PGYR2017_P06292018.csv`

**Output**: `paymentSummary.csv`

### `API access for NPPES.R`

**Description**: Takes a csv file and searches the NPPES database. I have a list of names that I would like to search for their NPI number using the NPI API (https://npiregistry.cms.hhs.gov/registry/help-api).  NPI number is a unique identifier number.  There are about 45,000 names that I want to see if there is a match in the csv file to the API.  There is documentation of the API listed above and this is also helpful (https://npiregistry.cms.hhs.gov/api/demo?version=2.1).  My goal is to get the correct NPI and all data as possible from the API.  The example API call would be: https://npiregistry.cms.hhs.gov/api/?number=&enumeration_type=NPI-1&taxonomy_description=&first_name=kale&use_first_name_alias=&last_name=turner&organization_name=&address_purpose=&city=&state=&postal_code=&country_code=&limit=&skip=&version=2.1.  Ultimately I want to use the location data for geocoding and to create a map.   

**Use**: `source("API access for NPPES.R")` 

**Output**: Address output.  

### `Buld_Output.R`



### `GOBA_Compare.R`

**Description**: Takes a file called `GOBA_unique.csv` of NPI numbers and merges it withe demographic data from `Physician Compare`.

**Output**: Puts out a file called: "GOBA_Compare.csv".




### Get scripts into a new RStudio project:
`New Project - Version Control - Git -` https://github.com/mufflyt/coi.git as `Repository URL`
(Our use your preferred way of cloning/downloading from GitHub.)

### Contact:
Please contact me with any questions or concerns: tyler (dot) muffly (at) dhha (dot) org.  
