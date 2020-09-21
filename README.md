# DEVELOPMENT BRANCH


# Do doctors prescribe more of a drug if they receive money from a pharmaceutical company tied to it?
# Association of Industry Payments to Obstetrician-Gynecologists and Prescription Behavior: an observational study using Open Payments and Medicare Part D Data
Muffly, Archer, Guido, Ferber, Schwarz

*Hypotheses and Specific Aims:*

*Hypothesis:  We hypothesize that OBGYN physicians who receive pharmaceutical industry non-research payments are more likely to prescribe medications created by the company from which they received payments, compared to their peers who do not receive pharmaceutical industry non-research payments.*
 
*Aim 1:   To evaluate whether OBGYN physicians who receive pharmaceutical non-industry payments, including general payments and payments in the form of ownership or investments, are more likely than their peer to prescribe medications created by the company from which they received payments.*
 
*Aim 2:  To assess whether prescribing rates for certain medications differ depending on which type of industry payments OBGYN physicians received including: payments for travel and lodging, food and beverage, consulting, charitable contributions, serving as faculty or as a speaker, royalties or licenses, space rentals or facility fees, honoraria, gifts, and education.*
 
*Aim 3:  To identify if there is a measurable monetary threshold at which there is an association between pharmaceutical payments to OBGYN physicians and prescribing practices.*

* [Marketing to Doctors: Last Week Tonight with John Oliver (HBO)](https://www.youtube.com/watch?v=YQZ2UeOTO3I&feature=share)
* [Propublica Doctors Prescribe more of a durg if they receive money from the pharma manufacturer](https://www.propublica.org/article/doctors-prescribe-more-of-a-drug-if-they-receive-money-from-a-pharma-company-tied-to-it
)
* [Propublica Methodology](https://projects.propublica.org/graphics/d4dpartd-methodology)

* [Excellent paper 1](https://github.com/mufflyt/coi/blob/dev_01/Association%20of%20Industry%20Payments%20to%20Physicians%20With%20the%20Prescribing%20of%20Brand-name%20Statins%20in%20Massachusetts.pdf)

* 

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

* [See crosswalk between states and ACOG districts](https://github.com/mufflyt/coi/blob/dev_01/Reference_Data/Crosswalk_ACOG_Districts.csv),  A way to look at large areas of the US that are geographically close.  

* [NPPES, NPPES Data Dissemination](https://download.cms.gov/nppes/NPI_Files.html) #downloaded April 30, 2020.  The issue is that without an API we can't pick and choose data.  The file is HUGE at 7 GB so it is hard to have R load it all in RAM with read.csv and filter it on one core without getting errors.  I'm trying to find a package successfully to load the data but may need to edit it in Excel beforehand prn.  
* [Federal Office of Rural Health Policy (FORHP) Data Files for rural vs. urban by zip code](https://www.hrsa.gov/sites/default/files/hrsa/ruralhealth/aboutus/definition/nonmetrocountiesandcts2016.xlsx), In the interest of making information on the FORHP Rural Areas more easily usable for Researchers and other Government Agencies, FORHP has created a crosswalk of ZIP Codes identifying the set of Non-Metro Counties and rural Census Tracts (CTs) that comprise rural areas as defined by FORHP. This Excel file contains Non-Metro Counties (Micropolitan and non-core based counties.  

Our goal is to create a Venn diagram of who has payments and who we matched up with or how many OBGYNs we were able to identify:
```r
install.packages("stringdist")
library(stringdist)
library(dplyr)

applicants <- read.csv
residents <- read.csv

set1 <-  applicants 
set2 <- residents

####Start the Venn Diagram here.  
# Venn diagram with dist<=1
library(VennDiagram)

require(gridExtra)
grid.newpage()

venn.plot <- draw.pairwise.venn(dim(set1)[1], dim(set1)[1], dim(matchNames[matchNames$dist<=1,])[1],
c("Applicants", "Residents"),
fill = c("red", "blue"),
cat.pos = c(0, 0),
cat.dist = rep(0.025, 2),
scaled = FALSE, );

grid.arrange(gTree(children=venn.plot), top="Applicants and Residents")
```
Thanks to Sneha Gupta for her help with this code.

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

# Project Tools
* R 3.6.2
* Rstudio 1.2.5042
* exploratory.io
* delimit for PC. http://www.delimitware.com.  Opens huge ass files but does not work for Mac.  
* XTabularor works for Mac.  https://www.bartastechnologies.com/products/xtabulator/.  I had to use this because R choked with it's one core and requiring everything in active memory.  
* Git Large File Storage (https://git-lfs.github.com).  Install with ```r brew install git-lfs```.  See more below.  
* COM Add ins: Fuzzy Look Up Add-In for Excel 1.3.0.0.  This was easier to use than R for fuzzy matching.  https://www.microsoft.com/en-us/download/details.aspx?id=15011.  The Fuzzy Lookup Add-In for Excel was developed by Microsoft Research and performs fuzzy matching of textual data in Microsoft Excel. It can be used to identify fuzzy duplicate rows within a single table or to fuzzy join similar rows between two different tables. The matching is robust to a wide variety of errors including spelling mistakes, abbreviations, synonyms and added/missing data. For instance, it might detect that the rows “Mr. Andrew Hill”, “Hill, Andrew R.” and “Andy Hill” all refer to the same underlying entity, returning a similarity score along with each match. Does NOT work with Mac.  

## Installation and use
### Install packages so that can use exploratory functions.  Use R 3.6.2 version because R 4.0.0 had difficulties with these packages.  
```r
# Installing
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("paulhendricks/anonymizer")
library(anonymizer)

devtools::install_github("tidyverse/glue")
library(glue)

install.packages("backports")
library(backports)

devtools::install_github("exploratory-io/exploratory_func")
library(exploratory)

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

# File Storage on Dropbox
Given the limitation of LFS on github we will storage files that are quite large on Dropbox as with prior projects.  The directory is ```~/Dropbox/Pharma_Influence/```.  NB this requires sharing of privileges from Dropbox.  Without relative paths  the script is very fragile, hard-wired to exactly one time and place. We should also consider relative file paths using the here:here package so it can run on Tyler and on Joe's machines.  

```r 
library(here) #Loads the here package
here:here()   #Sets the top level of the current project
here::dr_here()
readr::read_csv(here("data", "mtcars.csv"))  #reads out of the data folder
ggplot2::ggsave(here("figs", "mpg_hp.png")) #save png to a figs folder
## [1] "/Users/mufflyt/folders/to/directory/figs/mpg_hp.png"
```


### --->```~/Dropbox/Pharma_Influence/Data ```
*Data sub-directories are:*
* --->```~/Dropbox/Pharma_Influence/Data/GOBA ```
* --->```~/Dropbox/Pharma_Influence/Data/Medicare_Part_D ```
* --->```~/Dropbox/Pharma_Influence/Data/National Bureau of Economic Research ```
* --->```~/Dropbox/Pharma_Influence/Data/National Drug Code Directory ```
* --->```~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020 ```
* --->```~/Dropbox/Pharma_Influence/Data/Open_Payments ```
* --->```~/Dropbox/Pharma_Influence/Data/Physician_Compare ```
* --->```~/Dropbox/Pharma_Influence/Data/Rurality ```

### --->  ```~/Dropbox/Pharma_Influence/```
* ```~/Dropbox/Pharma_Influence/Articles for Pharma_Influence```
* ```~/Dropbox/Pharma_Influence/coi ```
* ```~/Dropbox/Pharma_Influence/Guido_Working_file```

## Matching Overview
* NPPES - NPI given so able to match with other databases with the key of NPI number
* PCND - NPI given so able to match with NPPES above
* OP - NO NPI so we need to match based on name, address, state, alternate names, suffix, etc.  
* GOBA - NO NPI so we need to match based on name, city, state.  

## Scripts: purpose for searching for NPPES
### Path:  `/Pharma_Influence/Guido_Working_file`

Due to the absence of a common variable, a two-step process linked Open Payment with Provider Utilization and Payment Data Public Use File. First, the Open Payments Database was linked to National Provider Identification database based on the physicians first and last name, city and state. Then Medicare Provider Utilization and Payment Data Public Use File was linked using the common variable NPI.  Prescriber groups that did not have prescriptive authority or were not eligible for payments from the pharmaceutical industry (e.g., nurse practitioners, physician assistants, and pharmacists) also were excluded. The final analytic file included physician name, gender, address, city, state, zip code, physician specialty, drug name, total drug cost, total days’ supply for the drug, total amount of payments received and amount of payment received by individual manufacturers.  This work was done by the amazing Joe Guido.  

Each file stands independently.  It installs the programs needed, writes the output to disk, and cleans up all the data in the Viewer at the end.  Very clean.  
```r
#cleanup and write output
GOBA_all_a_dataframes_1 <- df
rm(df)
rm(GOBA_all_a_dataframes)
rm(Regions)

write.csv(GOBA_all_a_dataframes_1,"~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv",row.names = FALSE, na="")

rm(list=ls()) 
gc()
```

### Matching Physician Names to Open Payments Data Process
### `1_1_pulling_all_scrapes_togetherR1.R`
**Description**: Pulls data from disparate sources to create the one true list.  It merges all the data together that has a unique id number `userid`.  

**Use**: `source("1_1_pulling_all_scrapes_togetherR1.R")` 

**Input**: All data is linked to the location on-line with Dropbox.  Remember that is is named with the format: `Physician_x to y with Sys.time.csv`.  

**Output**: 
```r readr::write_csv(all_bound_together, "~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes.csv")```.  We start with a list of OBGYN physicians and the year that they were boarded called all_bound_together.csv.  The data is filtered for providers who are retired, not in the United States.

### `1_2_GOBA_Prep.R`
**Description**: These are some bespoke functions to get the first, middle, and last names off.  
* trap_suffix - function to strip off everything after the first comma .  looks for common name suffix (Jr, SR, I, II, III, IV) and splits into a seperate component based on a space delimeter. leaves the balance untouched (Doe III) -> DOE, III

* trap_title -  splits into two parts, based on comma delimeter.  first part is assumed to be full name second part is assumed to be the title string ( John K Doe, MD PHD -> "John K Doe", "MD PHD")
```r
df[,c("NamePart","Title")] <-  df$name %>% trap_title
```

* trap_compound - function to strip left and right part of hyphenated last name.  breaks compound name (defined as two character strings joined by a '-' into a left and right component ( doe-james -> doe, james)
```r
df[,c("Last_Left","Last_Right")] <- df$Last %>% trap_compound
```
* fml - fml is First, Middle, Last name.  function to parse name into first, middle and last.  If more than 3 segments, joins second through next to last with '-'.  converts input stream into 3 parts (first, middle, last) based on space delimiter.  if there are more than 3 parts, 3rd and higher part are allocated to last name field.  from [slightly modified, changed collapse character to space]  https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/.  
```r
df[,c("First","Middle","Last")] <- df$NamePart %>% fml
```
We could re-use this for other name matching problems.  

**Processing Summary:**
* - parses single name string into components:'First, Middle, Last, Last_Right, Last_Left, Title' by applying functions `trap_title`, `fml`, and `trap_compound`.
* - cleans up data by removing leading and trailing spaces, periods
* - converts to upper case
* - splits off suffix from Last name field, places in 'suffix' field
* - adds 'region' field based on input file defining states into ACOG Districts

based on code at https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/

**Use**: `source("1_2_GOBA_Prep.R")` 

**Input**: `GOBA_all_a_dataframes.csv`.  This is a list of OBGYN names from a web search.  

**Output**: `~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv`.

### `1_3_Match_GOBA_NPPES (Filt).R` 
**Description**:  This is some real baller code that Joe Guido created 10000%.  Amazing.  

Merges the GOBA data with the NPPES data.  

GOBA Data prep:
* - removed if not in 50 states + DC
* - removed punctuation / non alpha charactors: (),.' and spaces
* - created matching variables: Full.Name.1 (first, middle, last); Full.Name.2 (First, middle initial, last);
		Full.Name.3 (first, middle, last, suffix); Full.Name.4 (first, middle initial, last, suffix)
* - removed any '-' character (doe-james -> doejames)

NPPES Data prep:
* - moved suffix (Jr, SR, I, II, III, IV) embedded in last name to suffix field 
* - removed punctuation / non alpha charactors: (),.' and spaces
* - removed any '-' character (doe-james -> doejames)
* - removed 'NMN' string (appears to represent no middle name)
* - created matching variables: Full.Name.1 (first, middle, last); Full.Name.2 (First, middle initial, last);
		Full.Name.3 (first, middle, last, suffix); Full.Name.4 (first, middle initial, last, suffix)
*- filtered on taxonomy corresponding to OBGYN ( '%207V%', '%174000000X', '%390200000X%','%208D00000X%', '174400000X'

##### Names to match on
* create full name field based on first, middle, last and suffix
* two versions based on middle and alternate middle, then two versions - with and without suffix
* total of four full names
* full.name,1 = first, middle, last
* full.name.2 = first, middle, last_2, 
* full.name.3 = first, middle initial, last
* full.name.4 = first, middle initial, last_2

##### Function to do the actual matching
```r
#fullname
match1 <- function(Gmatch,Nmatch,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch, ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )

  dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
  names(dup_names) = c("Full.Name")
  dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
  names(dup_OP) = c("PID")
  dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
  dup_names <- merge(dup_names, dup_OP  , all=TRUE)
  rm(dup_OP)
  dup_names <- data.frame(dup_names[!duplicated(dup_names),])
  names(dup_names) = c("Full.Name")
  #mark dups
  matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
  rm(dup_names)
  #annotate and store

  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL
  
  if (nrow(matches) > 0) {
     
  
  matches$Type <- MatchType
  matches <- subset(matches, is.na(matches$dup_name))
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
  } else {
    
    print( paste(MatchType," ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
    
  }
    
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

# fullname state
match2 <- function(Gmatch,Nmatch,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch, ' and GOB_Match.[State] = NOD_Match.[State] and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )
  
  dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
  names(dup_names) = c("Full.Name")
  dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
  names(dup_OP) = c("PID")
  dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
  dup_names <- merge(dup_names, dup_OP  , all=TRUE)
  rm(dup_OP)
  dup_names <- data.frame(dup_names[!duplicated(dup_names),])
  names(dup_names) = c("Full.Name")
  #mark dups
  matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
  rm(dup_names)
  #annotate and store
  
  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL  
  
  if (nrow(matches) > 0) {
  
    matches$Type <- MatchType   
  
    matches <- subset(matches, is.na(matches$dup_name))
    
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
  } else {
    print( paste(MatchType," ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  }
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

# first last
match3 <- function(Gmatch,Nmatch, Gmatch1,Nmatch1,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch,' and GOB_Match.',Gmatch1, ' = NOD_Match.',Nmatch1 , ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )
  
  dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
  names(dup_names) = c("Full.Name")
  dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
  names(dup_OP) = c("PID")
  dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
  dup_names <- merge(dup_names, dup_OP  , all=TRUE)
  rm(dup_OP)
  dup_names <- data.frame(dup_names[!duplicated(dup_names),])
  names(dup_names) = c("Full.Name")
  #mark dups
  matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
  rm(dup_names)
  #annotate and store
  
  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL

  if (nrow(matches) > 0) {
    
    matches$Type <- MatchType 
    
    matches <- subset(matches, is.na(matches$dup_name))
  
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
  } else {
    
    print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
    
  }
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}

# first, last, state
match4 <- function(Gmatch,Nmatch, Gmatch1,Nmatch1,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch,' and GOB_Match.',Gmatch1, ' = NOD_Match.',Nmatch1 , ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" and GOB_Match.[State] = NOD_Match.[State]',sep="")
  matches <- sqldf(matchString )
  
  dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
  names(dup_names) = c("Full.Name")
  dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
  names(dup_OP) = c("PID")
  dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
  dup_names <- merge(dup_names, dup_OP  , all=TRUE)
  rm(dup_OP)
  dup_names <- data.frame(dup_names[!duplicated(dup_names),])
  names(dup_names) = c("Full.Name")
  #mark dups
  matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
  rm(dup_names)
  #annotate and store
  
  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL
  
  if (nrow(matches) > 0) {
  
    matches$Type <- MatchType   
  matches <- subset(matches, is.na(matches$dup_name))
  
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
} else {
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  
}
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}
```



# 1.1 PRE_Match: Prescriber Data File is known as PRE.  Prescriber Demographics (raw, unprocessed) 
`~/Dropbox/Pharma_Influence/Data/Medicare_Part_D/PartD_Prescriber_PUF_NPI_DRUG_Combined.csv`
* 1.2 GOB_Match: GOBA data, cleaned [ ] `~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv`
* 1.3 NOD_Match: NPPES data file (raw, unprocessed) `~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv`, NOD stands for Nppes Obgyn Demographics.  ??

# 2. Functions
* 2.1 match1 - takes one input fields from each of two files, performs match, removed duplicates, updates datasets
* 2.2 match2 - same as match1, but also requires state to be the same
* 2.3 match3 - takes two input fields from each of two files, performs match, removed duplicates, updates datasets
* 2.4 match4 - same as match3 but also requires state to be the same.

# 3. Processing Summary
* 3.1 Data Prep
* 3.1.1 GOBA (GOB_Match)
+ - removed if not in 50 states + DC
+ - removed punctuation / non alpha charactors: (),.' and spaces
+ - created matching variables: Full.Name.1 (first, middle, last); Full.Name.2 (First, middle initial, last); Full.Name.3 (first, middle, last, suffix); Full.Name.4 (first, middle initial, last, suffix)
+ - removed any '-' character (doe-james -> doejames)

* 3.1.2 NPPES (NOD_Match)
+ - moved suffix (Jr, SR, I, II, III, IV) embedded in last name to suffix field
+ - removed punctuation / non alpha charactors: (),.' and spaces
+ - removed any '-' character (doe-james -> doejames)
+ - removed 'NMN' string (appears to represent no middle name)
+ - created matching variables: 
+ Full.Name.1 (first, middle, last); `GOB_Match$Full.Name.1 <- (paste(GOB_Match$First, GOB_Match$Middle,GOB_Match$Last, sep=" "))`
+ Full.Name.2 (First, middle initial, last);`GOB_Match$Full.Name.2 <- (paste(GOB_Match$First, GOB_Match$Middle,GOB_Match$Last, GOB_Match$Full.Name.Suffix, sep=" "))`
+ Full.Name.3 (first, middle, last, suffix); `GOB_Match$Full.Name.3 <- (paste(GOB_Match$First, substr(GOB_Match$Middle,1,1), GOB_Match$Last,sep=" "))`
+ Full.Name.4 (first, middle initial, last, suffix)`GOB_Match$Full.Name.4 <- (paste(GOB_Match$First, substr(GOB_Match$Middle,1,1), GOB_Match$Last, GOB_Match$Full.Name.Suffix, sep=" "))`
+ - filtered on taxonomy corresponding to OBGYN ( '%207V%', '%174000000X', '%390200000X%','%208D00000X%', '174400000X'

* 3.2 Matching
* 3.2.1 - GOBA and NPPES matched based on variations of fullname (middle initial / full middle name; with and without suffix)

* match1 is a function where the input is created in a variable called matchString.  matchString is made up of multiple column names from GOBA, and NOD.  Then there is an inner join.  
```r
#fullname. 
match1 <- function(Gmatch,Nmatch,MatchType,GOB_Match,NOD_Match){
  
  matchString <- paste('select GOB_Match.[ID] , GOB_Match.[Full.Name], NOD_Match.[NPI] from GOB_Match INNER JOIN NOD_Match on GOB_Match.',Gmatch,' = NOD_Match.',Nmatch, ' and NOD_Match.[GOB_ID] = "" and GOB_Match.[NPI] = "" ',sep="")
  matches <- sqldf(matchString )
 ```
 
* Joe: I am not sure what "PID" stands for here.  
 ```r
  dup_names <- data.frame(matches[duplicated(matches$Full.Name),2])
  names(dup_names) = c("Full.Name")
  dup_OP    <- data.frame(matches[duplicated(matches$NPI),3])
  names(dup_OP) = c("PID")
  dup_OP <- sqldf("select matches.[Full.Name] from matches inner join dup_OP on matches.[NPI] = dup_OP.[PID]")
  dup_names <- merge(dup_names, dup_OP  , all=TRUE)
  rm(dup_OP)
  dup_names <- data.frame(dup_names[!duplicated(dup_names),])
  names(dup_names) = c("Full.Name")
  #mark dups
  matches <- fn$sqldf('select matches.*, dup_names.[Full.Name] as dup_name  from matches LEFT OUTER JOIN dup_names on dup_names.[Full.Name] = matches.[Full.Name] ')
  rm(dup_names)
  #annotate and store

  dup_set <- subset(matches, !is.na(matches$dup_name))
  dup_set$dup_name <- NULL
```

* If there are multiple matches then do a LEFT OUTER JOIN.  
```r
  if (nrow(matches) > 0) {
  
  matches$Type <- MatchType
  matches <- subset(matches, is.na(matches$dup_name))
  GOB_Match <- sqldf('select GOB_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from GOB_Match LEFT OUTER JOIN matches on GOB_Match.[ID] = matches.[ID]')
  GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
  GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_Type"]
  GOB_Match$m_ID<- NULL
  GOB_Match$m_Type <- NULL
  GOB_Match$m_NPI <- NULL
  
  NOD_Match <- sqldf('select NOD_Match.*, matches.[ID] as m_ID, matches.[NPI] as m_NPI, matches.[Type] as m_Type from NOD_Match LEFT OUTER JOIN matches on NOD_Match.[NPI] = matches.[NPI]')
  NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
  NOD_Match[!is.na(NOD_Match$m_Type),"Type"] <-  NOD_Match[!is.na(NOD_Match$m_Type),"m_Type"]
  NOD_Match$m_ID<- NULL
  NOD_Match$m_NPI <- NULL
  NOD_Match$m_Type <- NULL
  
  print( paste(MatchType, " ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
  ```
 * If there is a perfect match then print the result in real-time.  
  ```r
  } else {
    
    print( paste(MatchType," ***** ",nrow(matches)," match rows","***** ",nrow(dup_set)," duplicate rows"))
    
  }
    
  return(list(GOB_Match,NOD_Match,nrow(matches)))
}
```

* 3.2.2 - remaining GOBA items (unmatched) matched on prescription data: (compares first, last, and state on each side; for GOBA uses 3 variations of last name)

* 3.3 Setup for Fuzzy Matches
* 3.3.1 output files corresponding to unmatched GOBA and NPPES data are generated.
* 3.3.2 output files are fed into excel and fuzzy match done using microsoft fuzzy match tool.

# 4. Intermediate Files
* 4.1 Cleaned and Normalized GOBA data: ~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_2.csv
* 4.2 Cleaned and Normalized NPPES: 
+ Read in: `NPPES <- read.csv(file = "~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412.csv",  colClasses = c(rep("character", 104), rep("NULL", 196)), header = TRUE)`

* create full name field based on first, middle, last and suffix
+ two versions based on middle and alternate middle, then two versions - with and without suffix for a total of four full names
+ full.name,1 = first, middle, last
+ full.name.2 = first, middle, last_2, 
+ full.name.3 = first, middle initial, last
+ full.name.4 = first, middle initian, last_2
`~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_1.csv`

* 4.3 Cleaned and Normalized NPPES, Filtered on OBGYN Taxonomy Codes: `~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_2.csv`

# 5. Output
* 5.1 GOBA_Match_NPPES_Matched:  "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_Matched.csv"
* 5.2 GOBA_Match_NPPES_UnMatched: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_UnMatched.csv"
* 5.3 GOB_Match: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL.csv"
* 5.4 NOD_Match:  "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Match_ALL.csv"
* 5.5 GOB_Fuzzy:  "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Fuzzy.csv"
* 5.6 NOD_Fuzzy: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Fuzzy.csv"

### `1_4_Match_GOBA_NPPES (UnFilt).R` 
**Description**: 
* 1.1 GOB_Match: GOBA data with matching NPI nums from 1_3:      "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL.csv"
* 1.2 Fuzzy_Match: output from processing of GOBA_Fuzzy and NOD_Fuzzy from 1_3 using excel workbook (microsoft fuzzy match tool): "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/Fuzzy_R1.csv"
* 1.3 RejectMI - list of rejected matches from 1.3 (first, last + state matches where MI is inconsistent):  "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/Reject_MI.csv"    
* 1.4 NOD_Match - from 1_3, normalized NPPES data, without filter on OBGYN taxonomy (large dataset): "~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_1.csv"

# 2. Functions
* 2.1 match2 - takes one input fields from each of two files, plus state, performs match, removed duplicates, updates datasets
* 2.2 match4 - takes two input fields from each of two files, plus state, performs match, removed duplicates, updates datasets

# Processing Summary
* - Remove NAs,
* - up dates GOBA file with manual matches from Fuzzy_Match, 
* - removes rejectMI matches from GOBA match file (rejected by middle initial, rejectMI)
* - Saves new list of matches to `GOBA_Match_NPPES`
* - load NOD file without Taxonomy filter
* - matching of NPPES and GOBA on full.name fields repeated, using much larger NPPES data set (and requiring state to match)
* - matching of NPPES and GOBA on first / last name fields repeated, using much larger NNPES data set (and recquiring matching city and state)
* - fuzzy match input files generated (in case another fuzzy round is warrented)

# Intermediate Files
* none

# Output 
* 5.1 GOBA_Match_NPPES_Matched: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_Matched_1.csv"
* 5.2 GOBA_Match_NPPES_UnMatched: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_UnMatched_1.csv"
* 5.3 GOB_Match: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL_1.csv"
* 5.4 NOD_Match:  "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Match_ALL_1.csv"
* 5.5 GOB_Fuzzy:  "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Fuzzy_1.csv"
* 5.6 NOD_Fuzzy: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Fuzzy_1.csv"

Runs matching in a while loop.  
https://www.google.com/webhp?tab=iw
![While loop for R](path-to-image-here)

### `2_Match_OP_NPPES_PCND.R`
# 1. Input
* 1.1 NPPES - raw NPPES data file: "~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412.csv"
* 1.2 OP - raw Open payments demographic file: "~/Dropbox/Pharma_Influence/Data/Open_Payments/OP_PH_PRFL_SPLMTL_P01172020.csv"
* 1.3 PCND - raw physician compare file: "~/Dropbox/Pharma_Influence/Data/Physician_Compare/Physician_Compare_National_Downloadable_File.csv"
* 1.4 GOBA - goba match file from 1_4: "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL_1.csv"

# 2. Functions - none
# 3. Processing Summary
* 3.1 File prep
* - building single taxonomy summary field for NPPES file (combine 15 taxonomy columns into single)
* - drop non demographic fields from NPPES 
* - drop non demographic fields from OP 

# 3.2 match OP and NPPES file - (each time only keep unique matches) match on:
+	- first, middle, last, suffix, address, city, state
+	- first, last, suffix, address, city, state
+	- first, last, address, city, state
+	- first(NP alt first), last, address, city, state
+	- first, last( NP alt last), address, city, state
+	- first(OP alt first), last, address, city, state
+	- first, last(OP alt last), address, city, state
+	- first(OP alt first), last(OP alt last), address, city, state
+	- first, last, suffix, address(NP alt address), city(NP alt city), state (NP alt state)
+	- first, middle, last, suffix, city, state
+	- first, middle, last, city, state
+	- first, last, city, state
+	- first, middle, last, suffix, zip
+	- first, middle, last, zip
+	- first, last, zip

# 3.3 take unmatched OP file and match against PCND.  complication with PCND is it has dups .. so have to cycle through each city/state entry
* - first, last, city, state
* - first (alt first), last, city, state
* - first, last (alt last), city, state

# 3.4 check load PPI data into GOBA based on NPI/PPI cross references developed on OP matching

# 4. Intermediate Files
* 4.1 studygroup1 - PPI/NPI matches from OP/NPPES compare
* 4.2 studygroup2 - PPI/NPI matches based on PCND
* 4.3 studygroup3 - PPI/NPI matches based on GOBA
* 4.4 StudyGroup_GOBA - NPI/PPI cross reference based on GOBA,						"~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_GOBA.csv"
* 4.5 StudyGroup_PCND - NPI/PPI cross reference based on PCND file
						~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_PCND.csv
* 4.6 PCND_unmatched - PCND OBGYNs with no matches
* 4.7 OP_Matched - OP file with matches 
					"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_Matched.csv"
* 4.8 OP_Unmatched - OP file - only non matches
					"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_UnMatched.csv"
* 4.9 OP_Unmatched_OBGYN - sames as 4.8, but filtered on OBGYNs
					"~/Dropbox/Pharma_Influence/Guido_Working_file/OP_UnMatched_OBGYN.csv"
 

* 5. Output
* 5.1 StudyGroup -  final cross reference of NPI/PPI data for OBGYNs based on OP, PCND, NPPES, and GOBA: ~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup.csv

* dump NPPES file with NPI numbers

# Revisions
06/07/2020 
* - dropbox file paths for input data, new field names in PCND
* - added code to amend cross reference list (NPI to PPI) to include GOBA names
* this file generates NPI to PPI cross reference.  NPI list is from PCND OBGYN's and GOBA OBGYNs


I have to learn SQL code/sqldf and how to do this for sure! Takes many hours to run given the single core nature of R.  

This is a great video on sqldf: https://youtu.be/s2oTUsAJfjI

`# filter on Taxonomy
NOD_Match <- sqldf("select NOD_Match.* from NOD_Match where NOD_Match.[TAX] like '%207V%' or NOD_Match.[TAX] like '%174000000X%' or NOD_Match.[TAX] like '%390200000X%' or NOD_Match.[TAX] like '%208D00000X%' or NOD_Match.[TAX] like '174400000X' ")`

DPLYR CODE
all_data %>% summarise(n_distinct(Medical_School))

is the same as....

SQLDF CODE
sqldf("SELECT COUNT(DISTINCT Medical_School) from all_data")

[![Reference about the types of database left outer joins we will do here](https://i.stack.imgur.com/S3WMq.jpg)](https://i.stack.imgur.com/S3WMq.jpg) 



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

```r
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
```

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
# Fuzzy Matching
This is challenging using R but ```r stringdist``` may be a package worth exploring in the future.  
```r
library(dplyr)
applicants <- read.csv(url(""))%>% pull(x)
residents <- read.csv(url("")) %>% pull(x)
set1 <-  applicants 
set2 <- residents
library(stringdist)

fuzzymatch<-function(dat1,dat2,string1,string2,meth,id1,id2){
  #initialize Variables:
  matchfile <-NULL #iterate appends
  x<-nrow(dat1) #count number of rows in input, for max number of runs
  
  #Check to see if function has ID values. Allows for empty values for ID variables, simple list match
  if(missing(id1)){id1=NULL}
  if(missing(id2)){id2=NULL}
     
  #### lowercase text only
  dat1[,string1]<-as.character(tolower(dat1[,string1]))#force character, if values are factors
  dat2[,string2]<-as.character(tolower(dat2[,string2]))
  
    #Loop through dat1 dataset iteratively. This is a work around to allow for large datasets to be matched
    #Can run as long as dat2 dataset fits in memory. Avoids full Cartesian join.
    for(i in 1:x) {
      d<-merge(dat1[i,c(string1,id1), drop=FALSE],dat2[,c(string2,id2), drop=FALSE])#drop=FALSE to preserve 1var dataframe
      
      #Calculate String Distatnce based method specified "meth"
      d$dist <- stringdist(d[,string1],d[,string2], method=meth)
      
      #dedupes A_names selects on the smallest distatnce.
      d<- d[order(d[,string1], d$dist, decreasing = FALSE),]
      d<- d[!duplicated(d[,string1]),]
      
      #append demos on matched file
      matchfile <- rbind(matchfile,d)
     # print(paste(round(i/x*100,2),"% complete",sep=''))
      
    }
  return(matchfile)
}
fuzzymatch
set1<-data.frame(set1)
set2<-data.frame(set2)
matchNames<-fuzzymatch(set1,set2,"set1","set2",meth="osa")

head(matchNames)
```

# Venn Diagram


## Docker
I am kicking around the idea of having a Docker file associated with this project.  It would help run the code in a reproducible manner without affecting local settings that can be quite important to some people.  

Good intro to docker: https://www.youtube.com/watch?v=I4k0LkTOKvU
 
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

LG high def screen


People with first initials is an issue.  

Look at goba_fuzzy in Dropbox.  

Power Query

Latest GOBA issues.xls - There are 71 people with the exact same first, middle, last, suffix names and the same city, state.  



85% matched from GOBA to PPI number.  
# Add demographics with NPPES and PhysicianCompare.  


Having issues with github so I downloaded the repository to my Documents folder.  

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

