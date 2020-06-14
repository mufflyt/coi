# Input
# StudyGroup_Final.csv
# prescriber.csv
# PaySum.csv
# Payment_Class.csv
# Prescription_Class.csv

# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("tidyverse")
install.packages('reshape')
install.packages('reshape2')

# Loading
library(sqldf)
library(qdapRegex)
library(sqldf)
library(readr)
library(tidyverse)
library(Hmisc)
library(reshape)
library(reshape2)


#load data 
StudyGroup <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/StudyGroup_Final.csv", stringsAsFactors=FALSE)
Prescriber <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)
PaySum <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)

#normalize column names, change drug names to lower case
names(PaySum) <- c("PPI", "ManName", "ManID","TotalPay","DrugName", "DrugNDC", "Year", "DrugCount" )
PaySum$DrugName <- tolower(PaySum$DrugName)

Prescriber <- Prescriber[,c(1,5,8,9,13,22)]
names(Prescriber) <- c("NPI","State", "DrugName", "GenericName", "TotalDaySupply", "Year")
Prescriber$DrugName <- tolower(Prescriber$DrugName)
Prescriber$GenericName <- tolower(Prescriber$GenericName)

#Load Class Data
Payment_Class <- read.csv("~/Dropbox/Pharma_Influence/Data/Category_Data/Payment_Class.csv", stringsAsFactors=FALSE)
Prescription_Class <- read.csv("~/Dropbox/Pharma_Influence/Data/Category_Data/Prescription_Class.csv", stringsAsFactors=FALSE)
ClassList <- sqldf('select Payment_Class.Class from Payment_Class group by Payment_Class.Class')

#make list of years for cross tab 
years<- c(2013, 2014, 2015, 2016, 2017)
years <- as.data.frame(years)

# add class info to Payments and Prescriptions

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]
PaySum <- sqldf('select PaySum.*, StudyGroup.NPI from PaySum left outer join StudyGroup on PaySum.PPI = StudyGroup.PPI')

Prescriber <- sqldf('select Prescriber.*, Prescription_Class.Class, Prescription_Class.Drug from Prescriber left outer join Prescription_Class on Prescriber.DrugName = Prescription_Class.DrugName')
Prescriber <- Prescriber[!is.na(Prescriber$Class),]

#Build cross tabs - payments

classvar = "class_Anti_infective"
T1 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T1 <- merge(T1,Tx, all = TRUE)
T1 <- dcast(T1,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar = "class_Anticholinergics_for_overactive_bladder"
T2 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T2 <- merge(T2,Tx, all = TRUE)
T2 <- dcast(T2,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar =  "class_Antiviral"
T3 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T3 <- merge(T3,Tx, all = TRUE)
T3 <- dcast(T3,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar =  "class_Bisphosphonates"
T4 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T4 <- merge(T4,Tx, all = TRUE)
T4 <- dcast(T4,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar =  "class_Hormone_therapy_single_ingredient_therapy"
T5 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T5 <- merge(T5,Tx, all = TRUE)
T5 <- dcast(T5,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar =  "class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy"
T6 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T6 <- merge(T6,Tx, all = TRUE)
T6 <- dcast(T6,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar =  "class_Transdermal_estrogen"
T7 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T7 <- merge(T7,Tx, all = TRUE)
T7 <- dcast(T7,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

classvar =  "class_Vaginal_Estrogen_Hormone_Therapy"
T8 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T8 <- merge(T8,Tx, all = TRUE)
T8 <- dcast(T8,NPI + Year ~ Drug,sum,value.var = "TotalPay")
rm(Tx)

#Build cross tabs - prescription
classvar = "class_Anti_infective"
PR1 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR1 <- merge(PR1,PRx, all = TRUE)
PR1 <- dcast(PR1,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Anticholinergics_for_overactive_bladder"
PR2 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR2 <- merge(PR2,PRx, all = TRUE)
PR2 <- dcast(PR2,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Antiviral"
PR3 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR3 <- merge(PR3,PRx, all = TRUE)
PR3 <- dcast(PR3,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Bisphosphonates"
PR4 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR4 <- merge(PR4,PRx, all = TRUE)
PR4 <- dcast(PR4,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Hormone_therapy_single_ingredient_therapy"
PR5 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR5 <- merge(PR5,PRx, all = TRUE)
PR5 <- dcast(PR5,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy"
PR6 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR6 <- merge(PR6,PRx, all = TRUE)
PR6 <- dcast(PR6,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Transdermal_estrogen"
PR7 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR7 <- merge(PR7,PRx, all = TRUE)
PR7 <- dcast(PR7,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

classvar = "class_Vaginal_Estrogen_Hormone_Therapy"
PR8 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR8 <- merge(PR8,PRx, all = TRUE)
PR8 <- dcast(PR8,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")

#merge data

names(T1)[3:5] <- paste("Pay_", names(T1)[3:5],sep="")
names(PR1)[3:5] <- paste("Pre_", names(PR1)[3:5],sep="")
class_Anti_infective <- merge(T1,PR1, all = TRUE)
write.csv(class_Anti_infective,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Anti_infective.csv",row.names = FALSE,na="")

names(T2)[3:13] <- paste("Pay_", names(T2)[3:13],sep="")
names(PR2)[3:13] <- paste("Pre_", names(PR2)[3:13],sep="")
class_Anticholinergics_for_overactive_bladder <- merge(T2,PR2, all = TRUE)
write.csv(class_Anticholinergics_for_overactive_bladder,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Anticholinergics_for_overactive_bladder.csv",row.names = FALSE,na="")

names(T3)[3:4] <- paste("Pay_", names(T3)[3:4],sep="")
names(PR3)[3:4] <- paste("Pre_", names(PR3)[3:4],sep="")
class_Antiviral <- merge(T3,PR3, all = TRUE)
write.csv(class_Antiviral,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Antiviral.csv",row.names = FALSE,na="")

names(T4)[3:9] <- paste("Pay_", names(T4)[3:9],sep="")
names(PR4)[3:9] <- paste("Pre_", names(PR4)[3:9],sep="")
class_Bisphosphonates <- merge(T4,PR4, all = TRUE)
write.csv(class_Bisphosphonates,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Bisphosphonates.csv",row.names = FALSE,na="")

names(T5)[3:10] <- paste("Pay_", names(T5)[3:10],sep="")
names(PR5)[3:10] <- paste("Pre_", names(PR5)[3:10],sep="")
class_Hormone_therapy_single_ingredient_therapy <- merge(T5,PR5, all = TRUE)
write.csv(class_Hormone_therapy_single_ingredient_therapy,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Hormone_therapy_single_ingredient_therapy.csv",row.names = FALSE,na="")

names(T6)[3:12] <- paste("Pay_", names(T6)[3:12],sep="")
names(PR6)[3:12] <- paste("Pre_", names(PR6)[3:12],sep="")
class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy <- merge(T6,PR6, all = TRUE)
write.csv(class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy.csv",row.names = FALSE,na="")

names(T7)[3:6] <- paste("Pay_", names(T7)[3:6],sep="")
names(PR7)[3:6] <- paste("Pre_", names(PR7)[3:6],sep="")
class_Transdermal_estrogen <- merge(T7,PR7, all = TRUE)
write.csv(class_Transdermal_estrogen,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Transdermal_estrogen.csv",row.names = FALSE,na="")

names(T8)[3:11] <- paste("Pay_", names(T8)[3:11],sep="")
names(PR8)[3:11] <- paste("Pre_", names(PR8)[3:11],sep="")
class_Vaginal_Estrogen_Hormone_Therapy <- merge(T8,PR8, all = TRUE)
write.csv(class_Vaginal_Estrogen_Hormone_Therapy,"~/Dropbox/Pharma_Influence/Guido_Working_file/class_Vaginal_Estrogen_Hormone_Therapy.csv",row.names = FALSE,na="")

write_rds(PaySum, "~/Dropbox/Pharma_Influence/Guido_Working_file/PaySum_wClass.rds"  )
write_rds(Prescriber, "~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber_wClass.rds")
write.csv(PaySum, "~/Dropbox/Pharma_Influence/Guido_Working_file/PaySum_wClass.csv"  , row.names = FALSE)
write.csv(Prescriber, "~/Dropbox/Pharma_Influence/Guido_Working_file/Prescriber_wClass.csv", row.names = FALSE)

rm(list=ls()) 
gc()