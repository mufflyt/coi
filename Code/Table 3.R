install.packages('reshape')
library(reshape)
install.packages('reshape2')
library(reshape2)
library(summarize)
#load data (in case this is run independantly)

PaySum <- read.csv("https://www.dropbox.com/s/sw34j1tm86kwcib/paymentSummary.csv?raw=1", stringsAsFactors=FALSE)

#normalize column names, change drug names to lower case
names(PaySum) <- c("PPI", "ManName", "ManID","TotalPay","DrugName", "DrugNDC", "Year", "DrugCount" )
PaySum$DrugName <- tolower(PaySum$DrugName)

#Load Class Data
Payment_Class <- read.csv("https://www.dropbox.com/s/jy8axcdrggp60iq/Payment_Class.csv?raw=1", stringsAsFactors=FALSE)

# add class info to Payments and Prescriptions

PaySum <- sqldf('select PaySum.*, Payment_Class.Class, Payment_Class.Drug from PaySum left outer join Payment_Class on PaySum.DrugName = Payment_Class.DrugName')
PaySum <- PaySum[!is.na(PaySum$Class),]

# combine on years prior to calculating medians
PaySum_combined <- sqldf(' select PPI, Class, Drug, sum(TotalPay) as "TotalPay" from PaySum group by PPI, Class, Drug')

#Can't fun this medIQR line below - Tyler
T3<-  (medIQR(TotalPay ~  Drug,PaySum_combined   ))

write.csv(T3,"T3.csv")
