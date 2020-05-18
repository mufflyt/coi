
# function to strip off everything after the first comma
# based on code at https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/

trap_title <- function(mangled_names) {
  titles <- c("MASTER", "MR", "MISS", "MRS", "MS", 
              "MX", "JR", "SR", "M", "SIR", "GENTLEMAN", 
              "SIRE", "MISTRESS", "MADAM", "DAME", "LORD", 
              "LADY", "ESQ", "EXCELLENCY","EXCELLENCE", 
              "HER", "HIS", "HONOUR", "THE", 
              "HONOURABLE", "HONORABLE", "HON", "JUDGE")
  mangled_names %>% sapply(function(name) {
    split <- str_split(name, ",") %>% unlist
    original_length <- length(split)
    split <- split[which(!split %>% 
                           toupper %>% 
                           str_replace_all('[^A-Z]','')
                         %in% titles)]
    case_when(
      (length(split) < original_length) & (length(split) == 1) ~  c(split[1],NA),
      length(split) == 1 ~ c(split[1],NA),
      length(split) == 2 ~ c(split[1],split[2]),
      length(split) > 2 ~ c(split[1], split[length(split)])
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
      length(split) > 2 ~ c(split[1], split[length(split)])
    )
  }) %>% t %>% return
}

# function to parse name into first, middle and last.  If more than 3 segments, joins second through next to last with '-'
# from [slightly modified, changed collapse character to space]  https://www.r-bloggers.com/split-intermixed-names-into-first-middle-and-last/

fml <- function(mangled_names) {
  titles <- c("MASTER", "MR", "MISS", "MRS", "MS", 
              "MX", "JR", "SR", "M", "SIR", "GENTLEMAN", 
              "SIRE", "MISTRESS", "MADAM", "DAME", "LORD", 
              "LADY", "ESQ", "EXCELLENCY","EXCELLENCE", 
              "HER", "HIS", "HONOUR", "THE", 
              "HONOURABLE", "HONORABLE", "HON", "JUDGE")
  mangled_names %>% sapply(function(name) {
    split <- str_split(name, " ") %>% unlist
    original_length <- length(split)
    split <- split[which(!split %>% 
                           toupper %>% 
                           str_replace_all('[^A-Z]','')
                         %in% titles)]
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

# parse, first split off title, then parse name into first, last and middle, then parse last into left and right (for hypenated)
df[,c("NamePart","Title")] <-  df$name %>% trap_title
df[,c("First","Middle","Last")] <- df$NamePart %>% fml
df[,c("Last_Left","Last_Right")] <- df$Last %>% trap_compound

# get rid of leading and trailing periods
df$First <- gsub('^\\.|\\.$', '', df$First)
df$Middle <- gsub('^\\.|\\.$', '', df$Middle)
df$Title <- gsub('\\.','',df$Title)

#convert to lowercase
df$First <- tolower(df$First)
df$Middle <- tolower(df$Middle)
df$Last <- tolower(df$Last)
df$Last_Left <- tolower(df$Last_Left)
df$Last_Right <- tolower(df$Last_Right)


#add region info
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
rm(Region)

write.csv(GOBA_all_a_dataframes_1,"~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes_1.csv",row.names = FALSE)
