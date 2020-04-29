# Do doctors prescribe more of a drug if they receive money from a pharmaceutical company tied to it?

*Hypotheses and Specific Aims: *
Hypothesis:  We hypothesize that OBGYN physicians who receive pharmaceutical industry non-research payments are more likely to prescribe medications created by the company from which they received payments, compared to their peers who do not receive pharmaceutical industry non-research payments.*
 
*Aim 1:   To evaluate whether OBGYN physicians who receive pharmaceutical non-industry payments, including general payments and payments in the form of ownership or investments, are more likely than their peer to prescribe medications created by the company from which they received payments.*
 
*Aim 2:  To assess whether prescribing rates for certain medications differ depending on which type of industry payments OBGYN physicians received including: payments for travel and lodging, food and beverage, consulting, charitable contributions, serving as faculty or as a speaker, royalties or licenses, space rentals or facility fees, honoraria, gifts, and education. *
 
*Aim 3:  To identify if there is a measurable monetary threshold at which there is an association between pharmaceutical payments to OBGYN physicians and prescribing practices.  
.*

OBJECTIVE:
To characterize industry payments to physician specialists who prescribe gynecologic drugs in the Medicare program.  Pharmacetical companies spend more than a billion dollars annually to maket their treatments, and a significant portion is targeted at doctors.  These interactions between doctors and pharmaceutical companies include sponsored meals, promotional speaking, consulting and travel expenses.  Other research has found correlations between industry interactions and prescribing for certain classes of drugs, including opioids, urology drugs, oncology treatments, inflammatory bowel disease treatments and heartburn medication. 

DESIGN, SETTING, AND PARTICIPANTS:
This study was a cross-sectional analysis of Centers for Medicare & Medicaid Services 2015, 2016, 2017 Part D prescribing data linked to 2015, 2016, 2017 Open Payments data.  We utliized a Markov Chain Monte Carlo for a generalized linear mix model.  MCMCglmm::MCMCglmm(Pre~drug + Cpay, random = ~NPI2, family = "poisson", burnin=5000, nitt=50000000, thin = 10)
The Pre~drug + Cpay is a formula to predict the number of prescriptions based on the drug class and cumulative financial payments from drug companies to that physician.  (https://projects.propublica.org/graphics/d4dpartd-methodology)

Our analysis uses data from the 2015 to 2017 calendar years. The prescription drug landscape has changed somewhat between 2017 and the performance of this analysis in 2020. Some drugs listed above have gone off patent, and competitors and generics have come to market.

All together, these x drugs accounted for about y% of all prescriptions under Part D.

(https://projects.propublica.org/graphics/d4dpartd-methodology) We chose to use a measure of total dollar value of the interactions. Typically the value of industry interactions for a particular doctor and drug were quite small, and the most common type of interaction was sponsored meals. Prior medical and psychology literature has established that even small gifts influence behavior, and therefore we were most interested in capturing whether any interaction occurred, regardless of the value. Additionally, there were outliers whose interactions were worth thousands or tens of thousands of dollars. A binary measure of industry interaction avoided outlier issues.


(https://projects.propublica.org/graphics/d4dpartd-methodology) Only providers with 11 or more claims for the drug were included in this model specification. Providers with fewer than 11 claims but who had industry interactions were excluded. This was necessary because we had no good comparison for such providers. Doctors with no industry interactions and who had fewer than 11 claims for a drug were not identifiable in our data.


(https://projects.propublica.org/graphics/d4dpartd-methodology) This model controlled for practice volume using doctors’ total Part D prescribing for all drugs other than the drug of interest. To avoid using a covariate that also measured the outcome variable, which was claims for the drug of interest, the covariate was defined as total Part D prescribing for all drugs minus prescribing for the drug of interest.



CONCLUSIONS AND RELEVANCE:
Pending!
