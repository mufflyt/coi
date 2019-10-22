setwd("~/Dropbox/workforce/scraper")
options(stringsAsFactors = FALSE)

require("jsonlite")
require("dplyr")
library("magrittr") 
library("memoise")
require("httr")

## User Inputs
download.file("https://www.dropbox.com/s/bdxfcw0iq9etp77/Physicians_total_left_join_27.csv?raw=1", "~/Dropbox/workforce/scraper/Physicians_total_left_join_27.csv", quiet=F, cacheOK = TRUE)

input_output_file_path = "~/Dropbox/workforce/scraper/Physicians_total_left_join_27.csv"
input <- read.csv(input_output_file_path)
names(input)
head(input)
input$NPI_from_NPPES <- NULL

for(i in 1:nrow(input)){
  first_name <- input$firstname[i]
  last_name <- input$Last_name[i]
  
  api_call = GET("https://npiregistry.cms.hhs.gov/api/", query = list(enumeration_type = "NPI-1", first_name=first_name, last_name=last_name, version=2.1))
  api_content = content(api_call)
  
  tryCatch({
    input$NPI_from_NPPES[i] <- api_content$results[[1]]$number
  },error = function(err){
    input$NPI_from_NPPES[i] = 'NA'
  })
  
  cat("\r", "Showing", i)
}

write.csv(input, "~/Dropbox/workforce/scraper/NPPES_API_Output.csv", row.names=FALSE)
View(input)
