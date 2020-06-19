# Input
# ~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes.csv
# ~/Dropbox/Pharma_Influence/Data/Regions.csv


# Functions
# trap_suffix - looks for common name suffix (Jr, SR, I, II, III, IV) and splits into a seperate component
#               based on a space delimeter. leaves the balance untouched ( Doe III) -> DOE, III
# trap_title -  splits into two parts, based on comma delimeter.  first part is assumed to be full name
#               second part is assumed to be the title string ( John K Doe, MD PHD -> "John K Doe", "MD PHD")
# trap_compound - breaks compound name (defined as two character strings joined by a '-' into a left and 
#                 right component ( doe-james -> doe, james)
# fml - converts input stream into 3 parts (first, middle, last) based on space delimiter. 
#       if there are more than 3 parts, 3rd and higher part are allocated to last name field

# Processing Summary
# - parses single name string into components:'First, Middle, Last, Last_Right, Last_Left, Title' by applying
#   functions trap_title, fml, and trap_compound.
# - cleans up data by removing leading and trailing spaces, periods
# - converts to upper case
# - splits off suffix from Last name field, places in 'suffix' field
# - adds 'region' field based on input file defining states into regions

# Intermediate Files
# none

# Output
# ~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv

# changes pending (needed)
# 


# Load required packages.
library(geosphere)
library(gmapsdistance)
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
library("qdapRegex")
# input GOBA_all_a_dataframes.csv - from pulling all scrapes file
# output GOBA_all_a_dataframes_1.csv - splits name into components (first, middle, last and title, if compound last splits that as well), cleans up names (whitespace, extra periods, hypens from last name).  adds region codes


# function to strip off everything after the first comma 
# based on code at https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/

trap_suffix <- function(mangled_names) {
  mangled_names %>% sapply(function(name) {
    split <- str_split(name, " ") %>% unlist
    original_length <- length(split)
    Titles <- c("Jr","Sr","I","II", "III","IV")
    if (split[1] %in% Titles){
      case_when(
        length(split) == 1 ~ c(split[1],NA),
        length(split) >  1 ~ c(split[1],
                               paste(split[2:(length(split))], 
                                     collapse = " ")) 
      )
    } else {
      
      case_when(
        length(split) == 1 ~ c(NA,split[1]),
        length(split) >  1 ~ c(NA,
                               paste(split[1:(length(split))], 
                                     collapse = " ")) 
      )      
    }
    

  }) %>% t %>% return
}

trap_title <- function(mangled_names) {
  mangled_names %>% sapply(function(name) {
    split <- str_split(name, ",") %>% unlist
    original_length <- length(split)
      case_when(
      length(split) == 1 ~ c(split[1],NA),
      length(split) >  1 ~ c(split[1],
                             paste(split[2:(length(split))], 
                                         collapse = " ")) 
    )
  }) %>% t %>% return
}

# function to strip left and right part of hyphenated last name
# based on code at https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/

trap_compound <- function(mangled_names) {
  mangled_names %>% sapply(function(name) {
    split <- str_split(name, "-") %>% unlist
    original_length <- length(split)
    case_when(
      length(split) == 1 ~ c(split[1],NA),
      length(split) == 2 ~ c(split[1],split[2]),
      length(split) >  2 ~ c(split[1],
                             paste(split[2:(length(split))], 
                                   collapse = "")) 
    )
  }) %>% t %>% return
}

# function to parse name into first, middle and last.  If more than 3 segments, joins second through next to last with '-'
# from [slightly modified, changed collapse character to space]  https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/

fml <- function(mangled_names) {
  mangled_names %>% sapply(function(name) {
    split <- str_split(name, " ") %>% unlist
    original_length <- length(split)
    case_when(
      (length(split) < original_length) & 
        (length(split) == 1) ~  c(NA,
                                  NA,
                                  split[1]),
      length(split) == 1 ~ c(split[1],NA,NA),
      length(split) == 2 ~ c(split[1],NA,
                             split[2]),
      length(split) == 3 ~ c(split[1],
                             split[2],
                             split[3]),
      length(split) > 3 ~ c(split[1],
                            paste(split[2:(length(split)-1)],
                                  collapse = " "),
                            split[length(split)])
    )
  }) %>% t %>% return
}


GOBA_all_a_dataframes <- read.csv("~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes.csv", stringsAsFactors=FALSE)

df <- GOBA_all_a_dataframes

# add placenolder fields for parsed name
df$NamePart <- NA
df$Title <- NA
df$First <- NA
df$Middle <- NA
df$Last <- NA
df$Last_Right <- NA
df$Last_Left <- NA
df$Suffix <- NA

# parse, first split off title, then parse name into first, last and middle, then parse last into left and right (for hypenated)
df[,c("NamePart","Title")] <-  df$name %>% trap_title
df[,c("First","Middle","Last")] <- df$NamePart %>% fml
df[,c("Last_Left","Last_Right")] <- df$Last %>% trap_compound

# get rid of leading and trailing periods
df$Title <- rm_white(df$Title)
df$First <- rm_white(df$First)
df$Middle <- rm_white(df$Middle)
df$Last <- rm_white(df$Last)
df$Last_Right <- rm_white(df$Last_Right)
df$Last_Left <- rm_white(df$Last_Left)
df$Suffix <- rm_white(df$Suffix)

df$Last <- gsub("-","",df$Last)

df$First <- gsub('^\\.|\\.$', '', df$First)
df$Middle <- gsub('^\\.|\\.$', '', df$Middle)
df$Title <- gsub('\\.','',df$Title)


#convert to uppercase
df$First <- toupper(df$First)
df$Middle <- toupper(df$Middle)
df$Last <- toupper(df$Last)
df$Last_Left <- toupper(df$Last_Left)
df$Last_Right <- toupper(df$Last_Right)


df[,c("Suffix","Title")] <- df$Title %>% trap_suffix
df$Suffix <- toupper(df$Suffix)

#add region infoNULL
df <- df[!is.na(df$state),] 
Regions <- read.csv("~/Dropbox/Pharma_Influence/Data/Regions.csv", stringsAsFactors=FALSE)

df$Region <- NA

for (j in 1:nrow(Regions))
  
{
  
  match_state = Regions[j,"State"]
  match_region = Regions[j,"Region"]
  
  df[df$state == match_state ,"Region"] = match_region
  
}

#cleanup and write output
GOBA_all_a_dataframes_1 <- df
rm(df)
rm(GOBA_all_a_dataframes)
rm(Regions)

write.csv(GOBA_all_a_dataframes_1,"~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv",row.names = FALSE, na="")

rm(list=ls()) 