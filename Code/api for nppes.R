# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")
# install.packages("memoise")

# I have a list of  names that I would like to search for their NPI number using the NPI API (https://npiregistry.cms.hhs.gov/registry/help-api).  NPI number is a unique identifier number.  There are about 45,000 names that I want to see if there is a match in the csv file to the API.  There is documentation of the API listed above and this is also helpful (https://npiregistry.cms.hhs.gov/api/demo?version=2.1).  My goal is to get the correct NPI and all data as possible from the API.  The example API call would be: https://npiregistry.cms.hhs.gov/api/?number=&enumeration_type=NPI-1&taxonomy_description=&first_name=kale&use_first_name_alias=&last_name=turner&organization_name=&address_purpose=&city=&state=&postal_code=&country_code=&limit=&skip=&version=2.1.  Ultimately I want to use the location data for geocoding and to create a map.  

#Deliverables include: 1) A csv file of the original given names and API potential matches.  2) The R code with brief annotation on how you performed this.  

setwd("~/Dropbox/workforce/scraper")
options(stringsAsFactors = FALSE)

require("jsonlite")
require("dplyr")
library("magrittr") 
library("memoise")
require("httr")

fc <- cache_filesystem(file.path(".cache"))
GET_m <- memoise(httr::GET, cache = fc)

## User Inputs
download.file("https://www.dropbox.com/s/bdxfcw0iq9etp77/Physicians_total_left_join_27.csv?raw=1", "Physicians_total_left_join_27.csv", quiet=F, cacheOK = TRUE)
library(readr)
GOBA_names <- read_csv("Physicians_total_left_join_27.csv")

## Outputs
Physicians <- NULL
WrongIDs <- NULL

id_list <- (GOBA_names$firstname)
last_list <- (GOBA_names$Last_name)

for(i in id_list) {    #i is loop for first name
  for (j in last_list) { #j is loop for the last name/surname
  #find the url
  url <- paste0("https://npiregistry.cms.hhs.gov/api/?version=2.1&first_name=", i, "&last_name=", j)
  ph_r <- GET_m(url=url) 
  ph_json <- content(ph_r, as = "text") 
  ph_data <- fromJSON(ph_json, flatten = TRUE)
  if(length(ph_data) != 0) {
    
  Physicians <- data.frame(matrix(unlist(ph_data), nrow=length(ph_data), byrow=T))
  } else {
    WrongIDs <- c(WrongIDs, i)
  }
  Sys.sleep(0.1)
  print(i)}}

View(Physicians) # view captured data



#https://masterr.org/r/how-to-find-consecutive-repeats-in-r/
set.seed(201)
rnums = rnorm(100)
runs = rle(rnums > 0)
myruns = which(runs$values == TRUE & runs$lengths >= 5)
# check if myruns has any value in it 
any(myruns) 
runs.lengths.cumsum = cumsum(runs$lengths)
ends = runs.lengths.cumsum[myruns]

newindex = ifelse(myruns>1, myruns-1, 0)
starts = runs.lengths.cumsum[newindex] + 1
if (0 %in% newindex) starts = c(1,starts)

print(starts)
print(ends)
print(rnums[starts[1]:ends[1]])
