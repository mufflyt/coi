library(dplyr)
applicants <- read.csv(url("https://www.dropbox.com/s/o4j1h7tqbmb5746/pull_All_Years_rename_56.csv?raw=1"))%>% pull(x)
residents <- read.csv(url("https://www.dropbox.com/s/7v67tpo8v52q58k/pull_residents_distinct_23.csv?raw=1")) %>% pull(x)
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
