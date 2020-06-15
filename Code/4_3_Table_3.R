install.packages('reshape')
library(reshape)
install.packages('reshape2')
library(reshape2)
install.packages("summarize", repos="http://R-Forge.R-project.org")
library(summarize)

PaySum <- read.csv("~/Dropbox/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)

#normalize column names, change drug names to lower case
names(PaySum) <- c("PPI", "ManName", "ManID","TotalPay","DrugName", "DrugNDC", "Year", "DrugCount" )
PaySum$DrugName <- tolower(PaySum$DrugName)

#Load Class Data
Payment_Class <- read.csv("~/Dropbox/Pharma_Influence/Data/Category_Data/Payment_Class.csv", stringsAsFactors=FALSE)

# add class info to Payments and Prescriptions

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]

# combine on years prior to calculating medians
PaySum_combined <- sqldf(' select PPI, Class, Drug, sum(TotalPay) as "TotalPay" from PaySum group by PPI, Class, Drug')

T3<-  (medIQR(TotalPay ~  Drug,PaySum_combined   ))

write.csv(T3,"~/Dropbox/Pharma_Influence/Guido_Working_file/T3.csv")
