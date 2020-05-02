##### Originally was NPI3.R from Surkov
# use library so R can make an API call
setwd("~/Dropbox/workforce/scraper/Scraper_results_2019")
options(stringsAsFactors = FALSE)

#Instead of having complicated 12 round joins with PCND I wanted to try this NPPES API to see if the majority of the work could be done here.  

library("stringr")
require("jsonlite")
require("dplyr")
library("magrittr") 
library("memoise")
require("httr")
library("humaniformat")

## User Inputs
# download.file("https://www.dropbox.com/s/bdxfcw0iq9etp77/Physicians_total_left_join_27.csv?raw=1", "~/Dropbox/workforce/scraper/Physicians_total_left_join_27.csv", quiet=F, cacheOK = TRUE)

download.file("https://www.dropbox.com/s/t5hhxhy1m6kgutl/all_bound_together.csv?raw=1", destfile = "~/Dropbox/Pharma_Influence/Data/all_bound_together_downloaded.csv", quiet=F, cacheOK = TRUE)

#input_output_file_path = "~/Dropbox/workforce/scraper/Physicians_total_left_join_27.csv"
input_file_path = "~/Dropbox/Pharma_Influence/Data/all_bound_together_downloaded.csv"

input <- read.csv(input_file_path) %>%
  separate(name, into = c("name", "suffix"), sep = "\\s*\\,\\s*", convert = TRUE) %>% #separate out suffix based on comma earlier because it was getting confused with the last name
  mutate(firstname = humaniformat::first_name(name)) %>%  #splits out first and last names for API to recognize
  mutate(middlename = humaniformat::middle_name(name)) %>%
  mutate(lastname = humaniformat::last_name(name)) %>%
  mutate(lastname = stringr::str_remove_all(lastname, "[[:punct:]]+$")) %>% #removes commas from the END of last names
  mutate(firstname = stringr::str_remove_all(firstname, "[^a-zA-Z]+")) %>%
  mutate(middlename = stringr::str_remove_all(middlename, "[^a-zA-Z]+")) %>%
  mutate(suffix = stringr::str_remove_all(suffix, "[^a-zA-Z]+")) 
  #mutate(lastname = str_remove_all(`American Congress of Obstetricians and Gynecologists District`, "[[:punct:]]+$"))

#View(input)
names(input)
dim(input)
head(input)
input$lastname


output <- "output.csv"

#create function trim that removes white spaces before and after value. One of the standard procedures in data preparation
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# ONLY FOR QUICK TESTING. ONLY TAKES FIRST 100 ROWS FOR QUICK RESULT. 
# YOU CAN DELETE THIS LINE SO THE SCRIPT WILL CHECK ENTIRE INPUT
input<- tail(input, 5000)

#Ok so this errors out at about 1180 records in to the search.  So we can start at the bottom with (tail(input, 5000)) instead

# Loop through each row (from 1 to the total number of rows) in the dataframe with users
for(i in 1:nrow(input)){
  
  # grab firstname, lastname, state from each row/person
  # write grabbed values into variables to be passed onto API call
  first_name <- input$firstname[i]
  middle_name <- input$middlename[i]
  last_name <- input$lastname[i]
  state <- input$state[i]
  
  # make API call for each row by dynamically populating API's querry with firstname, lastname, state for each row/person
  api_call <-  GET("https://npiregistry.cms.hhs.gov/api/", query = list(enumeration_type = "NPI-1", first_name=first_name, last_name=last_name,state=state, version=2.1))
  # convert API call resulting object into R's list object
  api_content <-  content(api_call)
  # grab the value of the total return result per search and write into variable
  api_content_count <-  api_content$result_count
  
  
  # if API call returns more than 0 results, add columns to the output:
  if(api_content_count>0){
    # reset the iteratorso we don't go out of bounds when selecting elements later 
    n = 1  
    # if we get more than 1 result per search
    if (api_content_count > 1){
      #loop though all results per search
      for (j in 1:length(api_content$results)){
        # if middle name returned in any result per search AND it is equal to the middle name in the input, PULL the NPI info for that user with matching middlename, otherwise pick the first result
        # functions around are just for more precise results like making sure to handle NA's, case sensitivity, no white spaces
        if(!is.null(api_content$results[[j]]$basic$middle_name) && trim(tolower(api_content$results[[j]]$basic$middle_name)) == trim(tolower(ifelse(is.na(middle_name), '', as.character(middle_name))))){
          # assigns the position of the middlename match to n
          n = j
          # optional, sets MatchCount to 1 since now the search is narrowed down
          api_content_count <- 1
          #breaking the search for matching middlename loop if successfully found the match so the n selector points to correct value
          break
        }
        else{
          # if not middlename searches matched, set the default selector value to 1 to pick the first API result for search parameters
          n = 1
        }
        #cat(j, trim(tolower(api_content$results[[j]]$basic$middle_name)), "\n")
      }
    }
    
    # RESULT_NPI column with NPI number from API for that row/person
    input$RESULT_NPI[i] <- api_content$results[[n]]$number
    # RESULT_Address1 column with Address1 value from API for that row/person
    input$RESULT_Address1[i] <- api_content$results[[n]]$addresses[[1]]$address_1
    # RESULT_City column with City value from API for that row/person
    input$RESULT_City[i] <- api_content$results[[n]]$addresses[[1]]$city
    # RESULT_IsPresent column with TRUE/FALSE flag where input row/user has been found in API
    input$RESULT_IsPresent[i] <- 'True'
    # IMPORTANT: RESULT_MatchCount column shows how many people were found in NPI with the SAME firsname, lastname living in the same state
    input$RESULT_MatchCount[i] <- api_content_count
    
    # Adding all possible result columns from API
    input$RESULT_enumeration_type[i] <- api_content$results[[n]]$enumeration_type
    input$RESULT_last_updated_epoch[i] <- api_content$results[[n]]$last_updated_epoch
    input$RESULT_created_epoch[i] <- api_content$results[[n]]$created_epoch
    input$RESULT_first_name[i] <- api_content$results[[n]]$basic$first_name
    input$RESULT_last_name[i] <- api_content$results[[n]]$basic$last_name
    input$RESULT_sole_proprietor[i] <- api_content$results[[n]]$basic$sole_proprietor
    input$RESULT_gender[i] <- api_content$results[[n]]$basic$gender
    input$RESULT_enumeration_date[i] <- api_content$results[[n]]$basic$enumeration_date
    input$RESULT_last_updated[i] <- api_content$results[[n]]$basic$last_updated
    input$RESULT_status[i] <- api_content$results[[n]]$basic$status
    input$RESULT_name[i] <- api_content$results[[n]]$basic$name
    input$RESULT_country_code[i] <- api_content$results[[n]]$addresses[[1]]$country_code
    input$RESULT_country_name[i] <- api_content$results[[n]]$addresses[[1]]$country_name
    input$RESULT_address_purpose[i] <- api_content$results[[n]]$addresses[[1]]$address_purpose
    input$RESULT_address_type[i] <- api_content$results[[n]]$addresses[[1]]$address_type
    input$RESULT_address_2[i] <- api_content$results[[n]]$addresses[[1]]$address_2
    input$RESULT_state[i] <- api_content$results[[n]]$addresses[[1]]$state
    input$RESULT_postal_code[i] <- api_content$results[[n]]$addresses[[1]]$postal_code
    input$RESULT_telephone_number[i] <- api_content$results[[n]]$addresses[[1]]$telephone_number
    input$RESULT_code[i] <- api_content$results[[n]]$taxonomies[[1]]$code
    input$RESULT_desc[i] <- api_content$results[[n]]$taxonomies[[1]]$desc
    input$RESULT_primary[i] <- api_content$results[[n]]$taxonomies[[1]]$primary
    input$RESULT_taxonomystate[i] <- api_content$results[[n]]$taxonomies[[1]]$state
    input$RESULT_license[i] <- api_content$results[[n]]$taxonomies[[1]]$license
    
    
    
  }
  # if API call returns 0 results, add columns to the output with respective values instead of above
  else{
    input$RESULT_NPI[i] = 'NA'
    input$RESULT_Address1[i] <- 'NA'
    input$RESULT_City[i] <- 'NA'
    input$RESULT_IsPresent[i] <- 'False'
    input$RESULT_MatchCount[i] <- api_content_count
    
    input$RESULT_enumeration_type[i] <- 'NA'
    input$RESULT_last_updated_epoch[i] <- 'NA'
    input$RESULT_created_epoch[i] <- 'NA'
    input$RESULT_first_name[i] <- 'NA'
    input$RESULT_last_name[i] <- 'NA'
    input$RESULT_sole_proprietor[i] <- 'NA'
    input$RESULT_gender[i] <- 'NA'
    input$RESULT_enumeration_date[i] <- 'NA'
    input$RESULT_last_updated[i] <- 'NA'
    input$RESULT_status[i] <- 'NA'
    input$RESULT_name[i] <- 'NA'
    input$RESULT_country_code[i] <- 'NA'
    input$RESULT_country_name[i] <- 'NA'
    input$RESULT_address_purpose[i] <- 'NA'
    input$RESULT_address_type[i] <- 'NA'
    input$RESULT_address_2[i] <- 'NA'
    input$RESULT_state[i] <- 'NA'
    input$RESULT_postal_code[i] <- 'NA'
    input$RESULT_telephone_number[i] <- 'NA'
    input$RESULT_code[i] <- 'NA'
    input$RESULT_desc[i] <- 'NA'
    input$RESULT_primary[i] <- 'NA'
    input$RESULT_taxonomystate[i] <- 'NA'
    input$RESULT_license[i] <- 'NA'
  }
  
  # optional line of code. Shows progress. Countdown of rows
  cat("\r", " Row: ", nrow(input), "\r")
  Sys.sleep(0.1)
}

# write output into output.csv file stored in the working directory
write.csv(input, output, row.names=FALSE)

View(input)

