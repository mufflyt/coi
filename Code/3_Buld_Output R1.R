# Input
# StudyGroupR3.csv [updated to R3 10/6/19]
# prescriber.csv
# PaySum.csv
# Payment_Class.csv
# Prescription_Class.csv


setwd("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file")

# Installing
install.packages("readr")
install.packages("qdapRegex")
install.packages("sqldf")
install.packages("tidyverse")
install.packages('reshape')
install.packages('reshape2')

# Loading
library("sqldf", lib.loc="~/R/win-library/3.2")
library("qdapRegex", lib.loc="~/R/win-library/3.2")
library("sqldf", lib.loc="~/R/win-library/3.2")
library("readr")
library(tidyverse)
library(Hmisc)
library(reshape)
library(reshape2)


#load data (in case this is run independantly)
StudyGroup <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/StudyGroupR3.csv", stringsAsFactors=FALSE)

Prescriber <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Prescriber.csv", stringsAsFactors=FALSE)

PaySum <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)


#normalize column names, change drug names to lower case
names(PaySum) <- c("PPI", "ManName", "ManID","TotalPay","DrugName", "DrugNDC", "Year", "DrugCount" )
PaySum$DrugName <- tolower(PaySum$DrugName)

Prescriber <- Prescriber[,c(1,5,8,9,13,22)]
names(Prescriber) <- c("NPI","State", "DrugName", "GenericName", "TotalDaySupply", "Year")
Prescriber$DrugName <- tolower(Prescriber$DrugName)
Prescriber$GenericName <- tolower(Prescriber$GenericName)

#Load Class Data
Payment_Class <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Payment_Class.csv", stringsAsFactors=FALSE)

Prescription_Class <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Prescription_Class.csv", stringsAsFactors=FALSE)

ClassList <- sqldf('select Payment_Class.Class from Payment_Class group by Payment_Class.Class')

#(rev. 10/17/19) 
#make list of years for cross tab 
years<- c(2013, 2014, 2015, 2016, 2017)
years <- as.data.frame(years)

#Load Class Strings (for column titles in cross tabs)


# add class info to Payments and Prescriptions

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]
PaySum <- sqldf('select PaySum.*, StudyGroup.NPI from PaySum left outer join StudyGroup on PaySum.PPI = StudyGroup.PPI')

Prescriber <- sqldf('select Prescriber.*, Prescription_Class.Class, Prescription_Class.Drug from Prescriber left outer join Prescription_Class on Prescriber.DrugName = Prescription_Class.DrugName')
Prescriber <- Prescriber[!is.na(Prescriber$Class),]
#Build cross tabs - payments
classvar = "class_Anti_infective"

#(rev. 10/17/19) 
#add years column
T1 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]

Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]

#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')

T1 <- merge(T1,Tx, all = TRUE)
T1 <- dcast(T1,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T1 <- T1[T1$NPI != 0,]

#Tp <- T1
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T1p <- pcts

classvar = "class_Anticholinergics_for_overactive_bladder"
T2 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T2 <- merge(T2,Tx, all = TRUE)
T2 <- dcast(T2,NPI + Year ~ Drug,sum,value.var = "TotalPay")

#T2 <- T2[T2$NPI != 0,]

#Tp <- T2
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T2p <- pcts

classvar =  "class_Antiviral"
T3 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T3 <- merge(T3,Tx, all = TRUE)
T3 <- dcast(T3,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T3 <- T3[T3$NPI != 0,]

#Tp <- T3
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T3p <- pcts


classvar =  "class_Bisphosphonates"
T4 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T4 <- merge(T4,Tx, all = TRUE)
T4 <- dcast(T4,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T4 <- T4[T4$NPI != 0,]

#Tp <- T4
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T4p <- pcts

classvar =  "class_Hormone_therapy_single_ingredient_therapy"
T5 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T5 <- merge(T5,Tx, all = TRUE)
T5 <- dcast(T5,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T5 <- T5[T5$NPI != 0,]

#Tp <- T5
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T5p <- pcts

classvar =  "class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy"
T6 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T6 <- merge(T6,Tx, all = TRUE)
T6 <- dcast(T6,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T6 <- T6[T6$NPI != 0,]

#Tp <- T6
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T6p <- pcts

classvar =  "class_Transdermal_estrogen"
T7 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T7 <- merge(T7,Tx, all = TRUE)
T7 <- dcast(T7,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T7 <- T7[T7$NPI != 0,]

#Tp <- T7
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T7p <- pcts

classvar =  "class_Vaginal_Estrogen_Hormone_Therapy"
T8 <- PaySum[PaySum$Class == classvar,c(7,11,10,4)]
Tx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
Tx$NPI <- 0
Tx$TotalPay <- 0 
Tx <- Tx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
Tx <- sqldf('select years.years as "Year",Tx.* from Tx join years')
T8 <- merge(T8,Tx, all = TRUE)
T8 <- dcast(T8,NPI + Year ~ Drug,sum,value.var = "TotalPay")
#T8 <- T8[T8$NPI != 0,]

#Tp <- T8
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#T8p <- pcts

rm(Tx)
#rm(pcts)

#Build cross tabs - prescription
classvar = "class_Anti_infective"
PR1 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR1 <- merge(PR1,PRx, all = TRUE)
PR1 <- dcast(PR1,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR1 <- PR1[PR1$NPI != 0,]

#Tp <- PR1
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR1p <- pcts

classvar = "class_Anticholinergics_for_overactive_bladder"
PR2 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR2 <- merge(PR2,PRx, all = TRUE)
PR2 <- dcast(PR2,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR2 <- PR2[PR2$NPI != 0,]

#Tp <- PR2
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR2p <- pcts

classvar = "class_Antiviral"
PR3 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR3 <- merge(PR3,PRx, all = TRUE)
PR3 <- dcast(PR3,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR3 <- PR3[PR3$NPI != 0,]

#Tp <- PR3
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR3p <- pcts

classvar = "class_Bisphosphonates"
PR4 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR4 <- merge(PR4,PRx, all = TRUE)
PR4 <- dcast(PR4,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR4 <- PR4[PR4$NPI != 0,]

#Tp <- PR4
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR4p <- pcts

classvar = "class_Hormone_therapy_single_ingredient_therapy"
PR5 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR5 <- merge(PR5,PRx, all = TRUE)
PR5 <- dcast(PR5,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR5 <- PR5[PR5$NPI != 0,]

#Tp <- PR5
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR5p <- pcts

classvar = "class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy"
PR6 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR6 <- merge(PR6,PRx, all = TRUE)
PR6 <- dcast(PR6,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR6 <- PR6[PR6$NPI != 0,]

#Tp <- PR6
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR6p <- pcts

classvar = "class_Transdermal_estrogen"
PR7 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR7 <- merge(PR7,PRx, all = TRUE)
PR7 <- dcast(PR7,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR7 <- PR7[PR7$NPI != 0,]

#Tp <- PR7
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR7p <- pcts

classvar = "class_Vaginal_Estrogen_Hormone_Therapy"
PR8 <- Prescriber[Prescriber$Class == classvar,c(6,1,8,5)]
PRx <- Payment_Class[Payment_Class$Class == classvar,c(1,2)]
PRx$NPI <- 0
PRx$TotalDaySupply <- 0 
PRx <- PRx[,c(3,2,4)]
#(rev. 10/17/19) 
#add years to dummy list
PRx <- sqldf('select years.years as "Year",PRx.* from PRx join years')
PR8 <- merge(PR8,PRx, all = TRUE)
PR8 <- dcast(PR8,NPI + Year ~ Drug,sum,value.var = "TotalDaySupply")
#PR8 <- PR8[PR8$NPI != 0,]

#Tp <- PR8
#total_col = apply(Tp[,-1], 1, sum)
#pcts = lapply(Tp[,-1], function(x) {
#  x / total_col
#})
#pcts = as.data.frame(pcts)
#pcts$NPI = Tp$NPI
#PR8p <- pcts


#merge data

names(T1)[3:5] <- paste("Pay_", names(T1)[3:5],sep="")
names(PR1)[3:5] <- paste("Pre_", names(PR1)[3:5],sep="")
#T1p <- T1p[,c(4,1:3)]
#names(T1p)[2:4] <- paste("Pay_", names(T1p)[2:4],sep="")
#PR1p <- PR1p[,c(4,1:3)]
#names(PR1p)[2:4] <- paste("Pre_", names(PR1p)[2:4],sep="")
class_Anti_infective <- merge(T1,PR1, all = TRUE)
#class_Anti_infectivep <- merge(T1p,PR1p, all = TRUE)
write.csv(class_Anti_infective,"class_Anti_infective.csv",row.names = FALSE,na="")
#write.csv(class_Anti_infectivep,"class_Anti_infectivep.csv",row.names = FALSE,na="")

names(T2)[3:13] <- paste("Pay_", names(T2)[3:13],sep="")
names(PR2)[3:13] <- paste("Pre_", names(PR2)[3:13],sep="")
#T2p <- T2p[,c(12,1:11)]
#names(T2p)[2:12] <- paste("Pay_", names(T2p)[2:12],sep="")
#PR2p <- PR2p[,c(12,1:11)]
#names(PR2p)[2:12] <- paste("Pre_", names(PR2p)[2:12],sep="")
class_Anticholinergics_for_overactive_bladder <- merge(T2,PR2, all = TRUE)
#class_Anticholinergics_for_overactive_bladderp <- merge(T2p,PR2p, all = TRUE)
write.csv(class_Anticholinergics_for_overactive_bladder,"class_Anticholinergics_for_overactive_bladder.csv",row.names = FALSE,na="")
#write.csv(class_Anticholinergics_for_overactive_bladderp,"class_Anticholinergics_for_overactive_bladderp.csv",row.names = FALSE,na="")

names(T3)[3:4] <- paste("Pay_", names(T3)[3:4],sep="")
names(PR3)[3:4] <- paste("Pre_", names(PR3)[3:4],sep="")
#T3p <- T3p[,c(3,1:2)]
#names(T3p)[2:3] <- paste("Pay_", names(T3p)[2:3],sep="")
#PR3p <- PR3p[,c(3,1:2)]
#names(PR3p)[2:3] <- paste("Pre_", names(PR3p)[2:3],sep="")
class_Antiviral <- merge(T3,PR3, all = TRUE)
#class_Antiviralp <- merge(T3p,PR3p, all = TRUE)
write.csv(class_Antiviral,"class_Antiviral.csv",row.names = FALSE,na="")
#write.csv(class_Antiviralp,"class_Antiviralp.csv",row.names = FALSE,na="")

names(T4)[3:9] <- paste("Pay_", names(T4)[3:9],sep="")
names(PR4)[3:9] <- paste("Pre_", names(PR4)[3:9],sep="")
#T4p <- T4p[,c(8,1:7)]
#names(T4p)[2:8] <- paste("Pay_", names(T4p)[2:8],sep="")
#PR4p <- PR4p[,c(8,1:7)]
#names(PR4p)[2:8] <- paste("Pre_", names(PR4p)[2:8],sep="")
class_Bisphosphonates <- merge(T4,PR4, all = TRUE)
#class_Bisphosphonatesp <- merge(T4p,PR4p, all = TRUE)
write.csv(class_Bisphosphonates,"class_Bisphosphonates.csv",row.names = FALSE,na="")
#write.csv(class_Bisphosphonatesp,"class_Bisphosphonatesp.csv",row.names = FALSE,na="")

names(T5)[3:10] <- paste("Pay_", names(T5)[3:10],sep="")
names(PR5)[3:10] <- paste("Pre_", names(PR5)[3:10],sep="")
#T5p <- T5p[,c(9,1:8)]
#names(T5p)[2:9] <- paste("Pay_", names(T5p)[2:9],sep="")
#PR5p <- PR5p[,c(9,1:8)]
#names(PR5p)[2:9] <- paste("Pre_", names(PR5p)[2:9],sep="")
class_Hormone_therapy_single_ingredient_therapy <- merge(T5,PR5, all = TRUE)
#class_Hormone_therapy_single_ingredient_therapyp <- merge(T5p,PR5p, all = TRUE)
write.csv(class_Hormone_therapy_single_ingredient_therapy,"class_Hormone_therapy_single_ingredient_therapy.csv",row.names = FALSE,na="")
#write.csv(class_Hormone_therapy_single_ingredient_therapyp,"class_Hormone_therapy_single_ingredient_therapyp.csv",row.names = FALSE,na="")

names(T6)[3:12] <- paste("Pay_", names(T6)[3:12],sep="")
names(PR6)[3:12] <- paste("Pre_", names(PR6)[3:12],sep="")
#T6p <- T6p[,c(11,1:10)]
#names(T6p)[2:11] <- paste("Pay_", names(T6p)[2:11],sep="")
#PR6p <- PR6p[,c(11,1:10)]
#names(PR6p)[2:11] <- paste("Pre_", names(PR6p)[2:11],sep="")
class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy <- merge(T6,PR6, all = TRUE)
#class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapyp <- merge(T6p,PR6p, all = TRUE)
write.csv(class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy,"class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy.csv",row.names = FALSE,na="")
#write.csv(class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapyp,"class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapyp.csv",row.names = FALSE,na="")

names(T7)[3:6] <- paste("Pay_", names(T7)[3:6],sep="")
names(PR7)[3:6] <- paste("Pre_", names(PR7)[3:6],sep="")
#T7p <- T7p[,c(5,1:4)]
#names(T7p)[2:5] <- paste("Pay_", names(T7p)[2:5],sep="")
#PR7p <- PR7p[,c(5,1:4)]
#names(PR7p)[2:5] <- paste("Pre_", names(PR7p)[2:5],sep="")
class_Transdermal_estrogen <- merge(T7,PR7, all = TRUE)
#class_Transdermal_estrogenp <- merge(T7p,PR7p, all = TRUE)
write.csv(class_Transdermal_estrogen,"class_Transdermal_estrogen.csv",row.names = FALSE,na="")
#write.csv(class_Transdermal_estrogenp,"class_Transdermal_estrogenp.csv",row.names = FALSE,na="")

names(T8)[3:11] <- paste("Pay_", names(T8)[3:11],sep="")
names(PR8)[3:11] <- paste("Pre_", names(PR8)[3:11],sep="")
#T8p <- T8p[,c(10,1:9)]
#names(T8p)[2:10] <- paste("Pay_", names(T8p)[2:10],sep="")
#PR8p <- PR8p[,c(10,1:9)]
#names(PR8p)[2:10] <- paste("Pre_", names(PR8p)[2:10],sep="")
class_Vaginal_Estrogen_Hormone_Therapy <- merge(T8,PR8, all = TRUE)
#class_Vaginal_Estrogen_Hormone_Therapyp <- merge(T8p,PR8p, all = TRUE)
write.csv(class_Vaginal_Estrogen_Hormone_Therapy,"class_Vaginal_Estrogen_Hormone_Therapy.csv",row.names = FALSE,na="")
#write.csv(class_Vaginal_Estrogen_Hormone_Therapyp,"class_Vaginal_Estrogen_Hormone_Therapyp.csv",row.names = FALSE,na="")

write_rds(PaySum, "PaySum_wClass.rds"  )
write_rds(Prescriber, "Prescriber_wClass.rds")

write.csv(PaySum, "PaySum_wClass.csv"  , row.names = FALSE)
write.csv(Prescriber, "Prescriber_wClass.csv", row.names = FALSE)
