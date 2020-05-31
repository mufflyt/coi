# start with GOB_Match and NOD_Match from 2_1_Match_GOBA_NOD
# pull in fuzzy_R1.csv
# update NOD and GOB datasets
# match on full NPPES dataset
#
library("sqldf")
library("RSQLite")
library("qdapRegex")

NOD_Match <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Match_ALL.csv", stringsAsFactors=FALSE) #filtered dataset
GOB_Match <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL.csv", stringsAsFactors=FALSE)
Fuzzy_Match <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/Fuzzy_R1.csv", stringsAsFactors=FALSE)

NOD_Match[is.na(NOD_Match$GOB_ID),"GOB_ID"] <- ""
GOB_Match[is.na(GOB_Match$NPI),"NPI"] <- ""

#
#update GOB
#
GOB_Match <- sqldf('select GOB_Match.*, Fuzzy_Match.[GOB_ID] as m_ID, Fuzzy_Match.[NPI] as m_NPI  from GOB_Match LEFT OUTER JOIN Fuzzy_Match on GOB_Match.[ID] = Fuzzy_Match.[GOB_ID]')
GOB_Match[!is.na(GOB_Match$m_ID),"NPI"] <-  GOB_Match[!is.na(GOB_Match$m_ID),"m_NPI"]
GOB_Match[!is.na(GOB_Match$m_ID),"Type"] <- "Fuzzy_R1"
GOB_Match$m_ID<- NULL
GOB_Match$m_NPI <- NULL
#
# save new list of matches
#
GOBA_Match_NPPES <- subset(GOB_Match,select = c("ID","NPI", "Type"))
GOBA_Match_NPPES_Matched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI!= "",]
GOBA_Match_NPPES_UnMatched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI == "",]
#
# load NOD file without Taxonomy filter
#
NOD_Match_old <- NOD_Match
NOD_Match <- read.csv("~/Dropbox/Pharma_Influence/Data/NPPES_Data_Dissemination_April_2020/npidata_pfile_20050523-20200412_1.csv", stringsAsFactors=FALSE) #filtered dataset
NOD_Match$GOB_ID <- ""
NOD_Match$Type <- ""
#
#update NOD_Match
#
NOD_Match <- sqldf('select NOD_Match.*, Fuzzy_Match.[GOB_ID] as m_ID, Fuzzy_Match.[NPI] as m_NPI from NOD_Match LEFT OUTER JOIN Fuzzy_Match on NOD_Match.[NPI] = Fuzzy_Match.[NPI]')
NOD_Match[!is.na(NOD_Match$m_ID),"GOB_ID"] <-  NOD_Match[!is.na(NOD_Match$m_ID),"m_ID"]
NOD_Match[!is.na(NOD_Match$m_ID),"Type"] <- "Fuzzy_R1"
NOD_Match$m_ID<- NULL
NOD_Match$m_NPI <- NULL
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
# Load Functions for Matching (only ones including state .. 2 and 4)
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
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
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
# Load city data into State Field
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
GOB_Match$oldState <- GOB_Match$state
GOB_Match$state <- paste(GOB_Match$city,GOB_Match$state, sep = " ")

NOD_Match$oldState <- NOD_Match$State
NOD_Match$State <- paste(NOD_Match$City,NOD_Match$State, sep = " ")
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
# Start Matching
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
matchcount <- 0
priormatchcount <- 1
loops <- 1

while (priormatchcount != matchcount) {
  priormatchcount <- matchcount
  #######################
  #######################
  print (paste(loops," loops.  Start time this loop: ",Sys.time()) )
  
  #######################
  #######################
  
#
# Match on full NPPES set, but include City in Matching----------------------------------------------------------------------------------------------------------
# 


returnvals <- match2("[Full.Name.1]","[Full.Name.1]","G_FN1_N_FN1 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.2]","G_FN1_N_FN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.3]","G_FN1_N_FN3 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.1]","[Full.Name.4]","G_FN1_N_FN4 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.1]","G_FN2_N_FN1 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.2]","G_FN2_N_FN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.3]","G_FN2_N_FN3 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.2]","[Full.Name.4]","G_FN2_N_FN4 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.1]","G_FN3_N_FN1 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.2]","G_FN3_N_FN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.3]","G_FN3_N_FN3 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.3]","[Full.Name.4]","G_FN3_N_FN4 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.1]","G_FN4_N_FN1 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.2]","G_FN4_N_FN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.3]","G_FN4_N_FN3 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match2("[Full.Name.4]","[Full.Name.4]","G_FN4_N_FN4 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiNLaN CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiNLaN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiNLaN CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiNLaN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN1LaN CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiNLaN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name]","G_FiN1LaN1_N_FiN2LaN CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.1]","[Last_Name_2]","G_FiN1LaN1_N_FiN2LaN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name]","G_FiN1LaN2_N_FiN2LaN CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.2]","[Last_Name_2]","G_FiN1LaN2_N_FiN2LaN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name]","G_FiN1LaN3_N_FiN2LaN CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]


returnvals <- match4("[First.Name.1]","[First_Name_2]","[Last.Name.3]","[Last_Name_2]","G_FiN1LaN3_N_FiN2LaN2 CS ALLNPPES",GOB_Match,NOD_Match)
GOB_Match <- returnvals[[1]]
NOD_Match <- returnvals[[2]]
matchcount <- matchcount + returnvals[[3]]

loops <- loops + 1
}
# 
# Return state to prior value (back out city + state)
#
GOB_Match$state <- GOB_Match$oldState 
NOD_Match$State <- NOD_Match$oldState 

#
# match on full name fields and state
#

matchcount <- 0
priormatchcount <- 1
loops <- 1

while (priormatchcount != matchcount) {
  priormatchcount <- matchcount
  #######################
  #######################
  print (paste(loops," loops.  Start time this loop: ",Sys.time()) )
  
  #######################
  #######################
  
  #
  # Match on full NPPES set, but include City in Matching----------------------------------------------------------------------------------------------------------
  # 
  
  
  returnvals <- match2("[Full.Name.1]","[Full.Name.1]","G_FN1_N_FN1 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.1]","[Full.Name.2]","G_FN1_N_FN2 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.1]","[Full.Name.3]","G_FN1_N_FN3 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.1]","[Full.Name.4]","G_FN1_N_FN4 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.2]","[Full.Name.1]","G_FN2_N_FN1 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.2]","[Full.Name.2]","G_FN2_N_FN2 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.2]","[Full.Name.3]","G_FN2_N_FN3 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.2]","[Full.Name.4]","G_FN2_N_FN4 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.3]","[Full.Name.1]","G_FN3_N_FN1 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.3]","[Full.Name.2]","G_FN3_N_FN2 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.3]","[Full.Name.3]","G_FN3_N_FN3 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.3]","[Full.Name.4]","G_FN3_N_FN4 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.4]","[Full.Name.1]","G_FN4_N_FN1 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.4]","[Full.Name.2]","G_FN4_N_FN2 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.4]","[Full.Name.3]","G_FN4_N_FN3 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  
  returnvals <- match2("[Full.Name.4]","[Full.Name.4]","G_FN4_N_FN4 S ALLNPPES",GOB_Match,NOD_Match)
  GOB_Match <- returnvals[[1]]
  NOD_Match <- returnvals[[2]]
  matchcount <- matchcount + returnvals[[3]]
  
  loops <- loops + 1
}

#
# End of Matching--------------------------------------------------------------------------------------------------------------------------------
# 

# compile and write final outputs

GOBA_Match_NPPES <- subset(GOB_Match,select = c("ID","NPI", "Type"))
GOBA_Match_NPPES_Matched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI!= "",]
GOBA_Match_NPPES_UnMatched <- GOBA_Match_NPPES[GOBA_Match_NPPES$NPI == "",]

#
# write output, cleanup workspace
#

write.csv(GOBA_Match_NPPES_Matched, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_Matched_1.csv",row.names = FALSE)
write.csv(GOBA_Match_NPPES_UnMatched,"~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_NPPES_UnMatched_1.csv",row.names = FALSE)
write.csv(GOB_Match, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Match_ALL_1.csv",row.names = FALSE)
write.csv(NOD_Match, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Match_ALL_1.csv",row.names = FALSE)

NOD_Fuzzy <- NOD_Match[NOD_Match$GOB_ID == "",c("NPI", "Full.Name.2")]
NOD_Fuzzy_dup_names <- data.frame(NOD_Fuzzy[duplicated(NOD_Fuzzy$Full.Name.2),2])
names(NOD_Fuzzy_dup_names) = c("Full.Name.2")
NOD_Fuzzy <- fn$sqldf('select NOD_Fuzzy.*, NOD_Fuzzy_dup_names.[Full.Name.2] as dup_name  from NOD_Fuzzy LEFT OUTER JOIN NOD_Fuzzy_dup_names on NOD_Fuzzy_dup_names.[Full.Name.2] = NOD_Fuzzy.[Full.Name.2] ')
NOD_Fuzzy <- NOD_Fuzzy[is.na(NOD_Fuzzy$dup_name),]
NOD_Fuzzy$dup_name <- NULL
names(NOD_Fuzzy)[2] <- "FullName"

GOB_Fuzzy <- GOB_Match[GOB_Match$NPI == "",c("userid","NamePart")]
GOB_Fuzzy_dup_names <- data.frame(GOB_Fuzzy[duplicated(GOB_Fuzzy$NamePart),2])
names(GOB_Fuzzy_dup_names) = c("NamePart")
GOB_Fuzzy <- fn$sqldf('select GOB_Fuzzy.*, GOB_Fuzzy_dup_names.[NamePart] as dup_name  from GOB_Fuzzy LEFT OUTER JOIN GOB_Fuzzy_dup_names on GOB_Fuzzy_dup_names.[NamePart] = GOB_Fuzzy.[NamePart] ')
GOB_Fuzzy <- GOB_Fuzzy[is.na(GOB_Fuzzy$dup_name),]
GOB_Fuzzy$dup_name <- NULL
names(GOB_Fuzzy)[2] <- "FullName"
names(GOB_Fuzzy)[1] <- "GOB_ID"


write.csv(GOB_Fuzzy, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/GOBA_Fuzzy_1.csv",row.names = FALSE, na="")
write.csv(NOD_Fuzzy, "~/Dropbox/Pharma_Influence/Guido_Working_file/GOBA_Match_NPPES/NOD_Fuzzy_1.csv",row.names = FALSE, na="")

rm(list=ls()) 

