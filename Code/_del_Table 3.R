install.packages('reshape')
library(reshape)
install.packages('reshape2')
library(reshape2)
library(summarize)
#load data (in case this is run independantly)

PaySum <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/paymentSummary.csv", stringsAsFactors=FALSE)

#normalize column names, change drug names to lower case
names(PaySum) <- c("PPI", "ManName", "ManID","TotalPay","DrugName", "DrugNDC", "Year", "DrugCount" )
PaySum$DrugName <- tolower(PaySum$DrugName)

#Load Class Data
Payment_Class <- read.csv("C:/Users/jguido/Dropbox (Personal)/Pharma_Influence/Guido_Working_file/Payment_Class.csv", stringsAsFactors=FALSE)

# add class info to Payments and Prescriptions

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]

# combine on years prior to calculating medians
PaySum_combined <- sqldf(' select PPI, Class, Drug, sum(TotalPay) as "TotalPay" from PaySum group by PPI, Class, Drug')

T3<-  (medIQR(TotalPay ~  Drug,PaySum_combined   ))

write.csv(T3,"T3.csv")
