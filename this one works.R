# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")
# install.packages("memoise")

#Make retirement curves for OBGYNs
setwd("~/Dropbox/workforce/scraper")
require("httr")
require("jsonlite")
require("dplyr")

library("memoise")
fc <- cache_filesystem(file.path(".cache"))
GET_m <- memoise(httr::GET, cache = fc)

## User Inputs

startID <- 9019500+10000
endID <-   9019500+40000

#9001120 to 9032700

id_list <- c(startID:endID)

## API Inputs

# r <- "https://api.abog.org/diplomate/9011381/verify"
base <- "https://api.abog.org/"
endpoint <- "diplomate/"
action <- "/verify"

## Security Inputs
torPort <- 9150

## Outputs
Physicians <- NULL
WrongIDs <- NULL


for(id in id_list) {
  r <- paste(base, endpoint, format(id, scientific = FALSE), action, sep = "")
  ph_r <- GET_m(r, use_proxy(paste0("socks5://localhost:", torPort)))
  ph_json <- content(ph_r, "text")
  ph_data <- fromJSON(ph_json, flatten = TRUE)
  if(length(ph_data) != 0) {
    ph_data <- ph_data %>%
      mutate(ID = id) %>%
      mutate(DateTime = Sys.time())
    
    Physicians <- Physicians %>%
      bind_rows(ph_data)
  } else {
    WrongIDs <- c(WrongIDs, id)
  }
  print(endID - id)
  Sys.sleep(0.1)
}

Physicians
write.csv(Physicians, gsub(":", "-" , paste0("Physicians (", startID, "-", endID, ") (", Sys.time(), ").csv")), row.names = FALSE)
write.csv(data.frame(WrongIDs = WrongIDs), gsub(":", "-" , paste0("Wrong IDs (", startID, "-", endID, ") (", Sys.time(), ").csv")), row.names = FALSE)
