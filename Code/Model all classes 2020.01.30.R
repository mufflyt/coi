# AF and TM
# 1.21.2020
# MCMC multi response Poisson model
rm(list =ls())


library(MCMCglmm)
setwd("~/Dropbox/Pharma_Influence/Guido_Working_file/")


# LOAD DATA-----------------------------------
load_anti_inf <- read.csv(file = 'class_Anti_infective.csv', header = T)
load_antichol <- read.csv(file = 'class_Anticholinergics_for_overactive_bladder.csv', header = T)
load_antiviral <- read.csv(file = 'class_Antiviral.csv', header = T)
load_bisph <- read.csv(file = 'class_Bisphosphonates.csv', header = T)
load_hormone <- read.csv(file = 'class_Hormone_therapy_single_ingredient_therapy.csv', header = T)
load_oral <- read.csv(file = 'class_Oral_Combined_Estrogen_and_Progestin_Products_for_Hormone_Therapy.csv', header = T)
load_transderm <- read.csv(file = 'class_Transdermal_estrogen.csv', header = T)
load_vaginal <- read.csv(file = 'class_Vaginal_Estrogen_Hormone_Therapy.csv', header = T)



# CLEAN DATA AND RUN THE POISSON MODEL----------
runmodel <- function(loaddata){
  
  # --- CLEAN DATA ---
  # put year period into ref dataset
  ref <- loaddata[loaddata$NPI == 0,]
  ref <- ref[,2, drop = F]
  # remove first empty rows
  loaddata <- loaddata[loaddata$NPI != 0,]
  # pull all ids
  id <- as.data.frame(unique(loaddata$NPI))
  colnames(id) <- 'NPI'
  # merge with year to get complete reference
  cref <- merge(ref, id)
  # merge cref onto data to have instances for every year for every id
  dat <- merge(x=loaddata, y=cref, by = c('NPI', 'Year'), all = T)
  # turn all missing to zeros
  dat[is.na(dat)] <- 0
  
  # wide to long 
  columns <- grep(c("^P"), names(loaddata))
  datl <- reshape(dat, direction = "long", idvar = c("NPI", "Year"), sep = '_', timevar = 'drug',
                  varying = columns)
  datl$NPI2 <- as.factor(datl$NPI)
  
  # sort and add cumulative payment column
  datl <- datl[order(datl$NPI2, datl$drug, datl$Year),]
  datl$Cpay <- ave(datl$Pay, datl$NPI2, datl$drug, FUN=cumsum)
  
  
  # --- MODEL --- 
  model <<-MCMCglmm(data=datl, Pre~ drug + Cpay, random = ~NPI2, 
                    family="poisson",burnin=5000,nitt=50000,thin=10) 
  return(model)
}

# they take around 3 hours each
result_anti_inf <- runmodel(loaddata=load_anti_inf)
result_antichol <- runmodel(loaddata=load_antichol)
result_antiviral <- runmodel(loaddata=load_antiviral)
result_bisp <- runmodel(loaddata=load_bisp)
result_hormone <- runmodel(loaddata=load_hormone)
result_oral <- runmodel(loaddata=load_oral)
result_transderm <- runmodel(loaddata=load_transderm)
result_vaginal <- runmodel(loaddata=load_vaginal)


# SAVE MODEL RESULTS-----------------------------
saveRDS(result_anti_inf, "anti_inf.5000.50000.10.poisson.rds")
saveRDS(result_antichol, "antichol.5000.50000.10.poisson.rds")
saveRDS(result_antiviral, "antiviral.5000.50000.10.poisson.rds")
saveRDS(result_bisp, "bisp.5000.50000.10.poisson.rds")
saveRDS(result_hormone, "hormone.5000.50000.10.poisson.rds")
saveRDS(result_oral, "oral.5000.50000.10.poisson.rds")
saveRDS(result_transderm, "transderm.5000.50000.10.poisson.rds")
saveRDS(result_vaginal, "vaginal.5000.50000.10.poisson.rds")


summary(result_antichol)
plot(result_vaginal$Sol) # fixed effects trace plots
plot(result_vaginal$VCV) # random effects trace plots




# SUMMARY-----------------------------------------
# anti_inf:   cpay not sig, drug plots not great
# antichol:   cpay sig, some plots not great, most fine
# antiviral:  no cpay, see warning message, no payments in data
# hormone:    cpay sig but negative, a couple not great, most fine
# oral:       cpay sig but negative, plots perfect
# transderm:  no cpay, probably same warning message
# vaginal:    cpay sig, couple not great, most good

# warning message: 
# some fixed effects are not estimable and have been removed. 
# Use singular.ok=TRUE to sample these effects, but use an informative prior!



# READ IN ---------------------------------------
result_anti_inf <- readRDS("anti_inf.5000.50000.10.poisson.rds")
result_antichol <- readRDS("antichol.5000.50000.10.poisson.rds")
result_antiviral<- readRDS("antiviral.5000.50000.10.poisson.rds")
result_bisp     <- readRDS("bisph.5000.50000.10.poisson.rds")
result_hormone  <- readRDS("hormone.5000.50000.10.poisson.rds")
result_oral     <- readRDS("oral.5000.50000.10.poisson.rds")
result_transderm<- readRDS("transderm.5000.50000.10.poisson.rds")
result_vaginal  <- readRDS("vaginal.5000.50000.10.poisson.rds")



# ABBREVIATIONS---------------------------------
# anti_inf:  Anti infective
# antichol:  Anticholinergics for overactive bladder
# antiviral: Antiviral
# bisph:     Bisphosphonates
# hormone:   Hormone therapy single ingredient 
# oral:      Oral combined estrogen and progestin products for hormone therapy
# transderm: Transdermal estrogen
# vaginal:   Vaginal estrogen hormone therapy




# PLOTS-----------------------------------------
# cant do antiviral and transderm because no cumulative payments


cleandrug <- function(data, payN){
  
  save <- data.frame(summary(data)$solutions)  #save coefficents
  numbers <<- setNames(data.frame(t((save[3:nrow(save)-1,1]))), row.names(save)[3:nrow(save)-1])  
  numbersrep <<- numbers[rep(seq_len(nrow(numbers)), each = payN),] + save[1,1] #repeat and add intercept
  numberspay <<- save[nrow(save),1]*c(1:payN) #Cpay times payments
  numbersadd <<- sweep(numbersrep, 1, numberspay, "+") #add to every drug column
  numbersexp <<- exp(numbersadd)   # exponentiate
  numbersexp$pay <<- c(1:payN)
  return(numbersexp)
}




# bisph: Bisphosphonates---------------------------------
summary(result_bisp)
dat_bisp <- cleandrug(result_bisp, 5000)
plot(dat_bisp$pay, dat_bisp[,6], type = 'l', ylim = c(0, max(dat_bisp[,6])))
lines(dat_bisp$pay, dat_bisp[,1], col = "red")
lines(dat_bisp$pay, dat_bisp[,2], col = "blue")

plot(dat_bisp$pay, dat_bisp[,2], type = 'l', ylim = c(0, max(dat_bisp[,2])))
lines(dat_bisp$pay, dat_bisp[,5], col = "green")
lines(dat_bisp$pay, dat_bisp[,3], col = "red")

# so small, and they the different drugs are on way different scales,
# but too small to be meaningful



# anti_inf: Anti infective--------------------------------
summary(result_anti_inf)
dat_anti_inf <- cleandrug(result_anti_inf, 1500)
plot(dat_anti_inf$pay, dat_anti_inf[,1], type = 'l', ylim = c(0, max(dat_anti_inf[,1])))
lines(dat_anti_inf$pay, dat_anti_inf[,2], col = "green")

plot(dat_anti_inf$pay, dat_anti_inf[,2], type = 'l', ylim = c(0, max(dat_anti_inf[,2])), col= "green")

# tinidazole does start shooting up to meaningful numbers ($1500, 30 rx)
# but metronidazole is so much larger ($1500 and 150,000,000 Rx)



# antichol:  Anticholinergics for overactive bladder-------
summary(result_antichol)
dat_anitchol <- cleandrug(result_antichol, 5000)
plot(dat_anitchol$pay, dat_anitchol[,3], type = 'l', ylim = c(0, max(dat_anitchol[,3])))
lines(dat_anitchol$pay, dat_anitchol[,9], col = "blue")
lines(dat_anitchol$pay, dat_anitchol[,1], col = "green")

plot(dat_anitchol$pay, dat_anitchol[,1], type = 'l', ylim = c(0, max(dat_anitchol[,1])), col = "green")
lines(dat_anitchol$pay, dat_anitchol[,9], col = "blue")





# hormone:   Hormone therapy single ingredient ------------
dat_hormone  <- cleandrug(result_hormone, 1000)
summary(result_hormone)
plot(dat_hormone$pay, dat_hormone[,5], type = 'l', ylim = c(0, max(dat_hormone[,5])))
lines(dat_hormone$pay, dat_hormone[,7], col = "blue")

# Cpay is negative so numbers going down, doesn't look meaningful



# oral: Oral combined estrogen and progestin products for hormone therapy---
dat_oral  <- cleandrug(result_oral, 1000)
summary(result_oral)
plot(dat_oral$pay, dat_oral[,9], type = 'l', ylim = c(0, max(dat_oral[,9])))

# again cpay is negative, and bigger negative effect than the last



# vaginal: Vaginal estrogen hormone therapy-----------------------
summary(result_vaginal)
dat_vaginal  <- cleandrug(result_vaginal, 5000)
plot(dat_vaginal$pay, dat_vaginal[,6], type = 'l', ylim = c(0, max(dat_vaginal[,6])))
lines(dat_vaginal$pay, dat_vaginal[,1], col = "blue")
lines(dat_vaginal$pay, dat_vaginal[,7], col = "green")
lines(dat_vaginal$pay, dat_vaginal[,8], col = "red")

# even biggest effects arent meaningful until getting up really high payments








# WRITE OUT COEFFICIENTS FROM EACH MODEL--------------------------------------
save_bisp <- data.frame(summary(result_bisp)$solutions)  #save coefficents
write.csv(save_bisp, "bisph_coeff.csv")

save_anti_inf <- data.frame(summary(result_anti_inf)$solutions)  #save coefficents
write.csv(save_anti_inf, "anti_inf_coeff.csv")

save_antichol <- data.frame(summary(result_antichol)$solutions)  #save coefficents
write.csv(save_antichol, "antichol_coeff.csv")

save_antiviral <- data.frame(summary(result_antiviral)$solutions)  #save coefficents
write.csv(save_antiviral, "antiviral_coeff.csv")

save_hormone <- data.frame(summary(result_hormone)$solutions)  #save coefficents
write.csv(save_hormone, "hormone_coeff.csv")

save_oral <- data.frame(summary(result_oral)$solutions)  #save coefficents
write.csv(save_oral, "oral_coeff.csv")

save_transderm <- data.frame(summary(result_transderm)$solutions)  #save coefficents
write.csv(save_transderm, "transderm_coeff.csv")

save_vaginal <- data.frame(summary(result_vaginal)$solutions)  #save coefficents
write.csv(save_vaginal, "vaginal_coeff.csv")




