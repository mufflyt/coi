# Setup ----
# Set libPaths.
rm(list = setdiff(ls(), lsf.str()))

# Loading
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("paulhendricks/anonymizer")
library(anonymizer)

devtools::install_github("tidyverse/glue")
library(glue)

install.packages("backports")
library(backports)

devtools::install_github("exploratory-io/exploratory_func")
library(exploratory)

# Load required packages.
library(geosphere)
library(gmapsdistance)
library(R.utils)
library(janitor)
library(lubridate)
library(hms)
library(tidyr)
library(stringr)
library(readr)
library(forcats)
library(RcppRoll)
library(dplyr)
library(tibble)
library(bit64)
library(tidyverse)
library(Hmisc)

# Read in all data of GOBA scrapes ----
# We start with a list of FPMRS physicians and the year that they were boarded called all_bound_together.csv.  The data is filtered for providers who are retired, not in the United States, and has a unique random id.  

# #Read directly from Dropbox, workforce, scraper, Scraper_results_2019
a1 <- read.csv(url("https://www.dropbox.com/s/81s4sfltiqwymq1/Downloaded%20%289035315-9050954%29%20%282019-08-13%2022.csv?raw=1"))
a2 <- read.csv(url("https://www.dropbox.com/s/x2q4kn9w0z92em0/Downloaded%20%289037771-9050954%29%20%282019-08-27%2019-21-01%29.csv?raw=1"))
a3 <- read.csv(url("https://www.dropbox.com/s/p7eggr3w9trhoka/Physicians%20%281-100%29%20%282019-09-06%2017-29-12%29.csv?raw=1"))
a4 <- read.csv(url("https://www.dropbox.com/s/jke52sy6j0mhyg9/Physicians%20%289e%2B05-6e%2B05%29%20%282019-09-09%2006-29-19%29.csv?raw=1"))
a5 <- read.csv(url("https://www.dropbox.com/s/gv5qh8jp0mnsoii/Physicians%20%289e%2B06-9032700%29%20%282019-09-08%2006-48-56%29.csv?raw=1"))
a6 <- read.csv(url("https://www.dropbox.com/s/0lfpdmz7wnj4dae/Physicians%20%28100-10000%29%20%282019-09-06%2019-31-29%29.csv?raw=1"))
a7 <- read.csv(url("https://www.dropbox.com/s/6ym2y1b4pf1ustt/Physicians%20%2810000-29000%29%20%282019-09-06%2022-53-42%29.csv?raw=1"))
a8 <- read.csv(url("https://www.dropbox.com/s/6ym2y1b4pf1ustt/Physicians%20%2810000-29000%29%20%282019-09-06%2022-53-42%29.csv?raw=1"))
a9 <- read.csv(url("https://www.dropbox.com/s/awa08ncbs3c27vg/Physicians%20%28971758-9032700%29%20%282019-09-09%2006-29-59%29.csv?raw=1"))
a10 <- read.csv(url("https://www.dropbox.com/s/35cte66ijjkwixv/Physicians%20%289000023-8995000%29%20%282019-09-08%2008-54-45%29.csv?raw=1"))
a11 <- read.csv(url("https://www.dropbox.com/s/og76ky1qolmfo36/Physicians%20%289001120-9032700%29%20%282019-09-08%2014-56-13%29.csv?raw=1"))
a12 <- read.csv(url("https://www.dropbox.com/s/xep4t7vrmy0so5f/Physicians%20%289014500-9016500%29%20%282019-09-09%2017-29-37%29.csv?raw=1"))
a13 <- read.csv(url("https://www.dropbox.com/s/0fdaeiqcdxuu4p3/Physicians%20%289014500-90146500%29%20%282019-09-09%2017-25-04%29.csv?raw=1"))
a14 <- read.csv(url("https://www.dropbox.com/s/1kjeumeyc6rkqaw/Physicians%20%289016500-9019500%29%20%282019-09-09%2017-37-30%29.csv?raw=1"))
a15 <- read.csv(url("https://www.dropbox.com/s/npak5lc1oqgzxff/Physicians%20%289019500-9029500%29%20%282019-09-09%2017-58-01%29.csv?raw=1"))
a16 <- read.csv(url("https://www.dropbox.com/s/pu9n1cz62s9rw33/Physicians%20%289029500-9059500%29%20%282019-09-09%2018-12-26%29.csv?raw=1"))
a17 <- read.csv(url("https://www.dropbox.com/s/afy2x8sn5aiwhls/Physicians%20%289035315-9032700%29%20%282019-09-08%2007-36-38%29.csv?raw=1"))
a18 <- read.csv(url("https://www.dropbox.com/s/yyb56grdml8r3u2/Physicians%20%289035315-9032700%29%20%282019-09-08%2010-52-04%29.csv?raw=1"))
a19 <- read.csv(url("https://www.dropbox.com/s/eb2ys0rhrej57gi/Physicians%20%289035315-9032700%29%20%282019-09-08%2010-57-51%29.csv?raw=1"))
a20 <- read.csv(url("https://www.dropbox.com/s/0icba0c7fiykfg6/Physicians%20%289050954-9030000%29%20%282019-09-07%2021-56-03%29.csv?raw=1"))
a21 <- read.csv(url("https://www.dropbox.com/s/3myst0596aqn96e/Physicians_total_drop_na_29.csv?raw=1"))
a22 <- read.csv(url("https://www.dropbox.com/s/bdxfcw0iq9etp77/Physicians_total_left_join_27.csv?raw=1"))

#Read directly from Dropbox, workforce, scraper, GOBA_December_2019_Pull
a23 <- read.csv(url("https://www.dropbox.com/s/0tia58u15r6deok/Physicians%20%289017048-9007048%29%20%282019-12-23%2008-40-42%29.csv?raw=1"))
a24 <- read.csv(url("https://www.dropbox.com/s/xzx12mxjjoetf5m/Physicians%20%289027048-9017048%29%20%282019-12-22%2016-53-04%29.csv?raw=1"))
a25 <- read.csv(url("https://www.dropbox.com/s/3lssg0qzhvvvnac/Physicians%20%289029730-9050000%29%20%282020-01-27%2006-53-03%29.csv?raw=1"))
a26 <- read.csv(url("https://www.dropbox.com/s/dwjfszn6rbgcxd3/Physicians%20%289032048-9027048%29%20%282019-12-22%2014-30-40%29.csv?raw=1"))
a27 <- read.csv(url("https://www.dropbox.com/s/yiqm06tooy6skpj/Physicians%20%289037048-9032048%29%20%282019-12-22%2013-22-42%29.csv?raw=1"))
a28 <- read.csv(url("https://www.dropbox.com/s/bjbvq6xi6izbwl4/Physicians%20%289038000-1%29%20%282020-01-03%2017-06-20%29.csv?raw=1"))
a29 <- read.csv(url("https://www.dropbox.com/s/lrkgxasq1u8979b/Physicians%20%289041048-9037048%29%20%282019-12-22%2012-25-57%29.csv?raw=1"))
a30 <- read.csv(url("https://www.dropbox.com/s/fa43ujcfl60ir93/Physicians%20%289041048-9042048%29%20%282019-12-21%2016-51-37%29.csv?raw=1"))
a31 <- read.csv(url("https://www.dropbox.com/s/y01mt2zt1y7vrex/Physicians%20%289041048-9043048%29%20%282019-12-21%2017-14-39%29.csv?raw=1"))
a32 <- read.csv(url("https://www.dropbox.com/s/a7n3lby7velswmn/Physicians%20%289041048-9043048%29%20%282019-12-22%2008-51-01%29.csv?raw=1"))
a33 <- read.csv(url("https://www.dropbox.com/s/y5fc6qcjsdox89k/Physicians%20%289050000-9038000%29%20%282020-01-03%2018-20-19%29.csv?raw=1"))


#Read directly from Dropbox, workforce, scraper, Old Mac GOBA Pulls
a34 <- read.csv(url("https://www.dropbox.com/s/h4bpf3tysmklq18/Physicians%20%289041048-9043048%29%20%282019-12-21%2017-14-39%29.csv?raw=1"))
a35 <- read.csv(url("https://www.dropbox.com/s/94lih4dnxel8o2s/Physicians%20%281-9050542%29%20%282019-10-22%2019-52-47%29.csv?raw=1"))
a36 <- read.csv(url("https://www.dropbox.com/s/ivm9cdr42fsye9l/Physicians%20%289041048-9042048%29%20%282019-12-21%2016-51-37%29.csv?raw=1"))
a37 <- read.csv(url("https://www.dropbox.com/s/uc3frk69k0eiybv/Physicians%20%289041048-9043048%29%20%282019-12-22%2008-51-01%29.csv?raw=1"))
a38 <- read.csv(url("https://www.dropbox.com/s/upyiagiijk1dz1n/Physicians%20%2817479-9050542%29%20%282019-10-26%2012-03-15%29.csv?raw=1"))
a39 <- read.csv(url("https://www.dropbox.com/s/whxdypbi3q1eg89/Physicians%20%289e%2B06-9032700%29%20%282019-09-08%2006-48-56%29.csv?raw=1"))
a40 <- read.csv(url("https://www.dropbox.com/s/tdu6js4jgmlgzk3/Physicians%20%289017048-9007048%29%20%282019-12-23%2008-40-42%29.csv?raw=1"))
a41 <- read.csv(url("https://www.dropbox.com/s/ecoddjv1ivu8tkb/Physicians%20%289050000-9038000%29%20%282020-01-03%2018-20-19%29.csv?raw=1"))
a42 <- read.csv(url("https://www.dropbox.com/s/p0t6tfevsklsxx9/Physicians%20%289032048-9027048%29%20%282019-12-22%2014-30-40%29.csv?raw=1"))
a43 <- read.csv(url("https://www.dropbox.com/s/z5z3m9vbxmdd8hf/Physicians%20%2824456-9050542%29%20%282019-10-28%2020-35-42%29.csv?raw=1"))
a44 <- read.csv(url("https://www.dropbox.com/s/0zizjata2bdohdo/Physicians%20%289037048-9032048%29%20%282019-12-22%2013-22-42%29.csv?raw=1"))
a45 <- read.csv(url("https://www.dropbox.com/s/gpz31s436i9ev06/Physicians%20%289027048-9017048%29%20%282019-12-22%2016-53-04%29.csv?raw=1"))
a46 <- read.csv(url("https://www.dropbox.com/s/jngn8o513mtawif/Physicians%20%289e%2B05-6e%2B05%29%20%282019-09-09%2006-29-19%29.csv?raw=1"))
a47 <- read.csv(url("https://www.dropbox.com/s/qc3nmzgbv2lo5as/Physicians%20%289038000-1%29%20%282020-01-03%2017-06-20%29.csv?raw=1"))
a48 <- read.csv(url("https://www.dropbox.com/s/uw6oj0ofkkvxi6n/Physicians%20%28100-10000%29%20%282019-09-06%2019-31-29%29.csv?raw=1"))
a49 <- read.csv(url("https://www.dropbox.com/s/ucvzbcmenatfatx/Physicians%20%2810000-29000%29%20%282019-09-06%2022-53-42%29.csv?raw=1"))
a50 <- read.csv(url("https://www.dropbox.com/s/kxbtov4x0t0pd6q/Physicians%20%2824456-9050542%29%20%282019-10-29%2006-54-22%29.csv?raw=1"))
a51 <- read.csv(url("https://www.dropbox.com/s/mdmjy2vjclb8l5f/Physicians%20%289041048-9037048%29%20%282019-12-22%2012-25-57%29.csv?raw=1"))

#added on 3/7/2020
a53 <- read.csv(url("https://www.dropbox.com/s/uqu52z9seexace9/Physicians%20%289010000-9024666%29%20%282020-02-25%2019-44-45%29.csv?raw=1"))
a55 <- read.csv(url("https://www.dropbox.com/s/lt2vtk2d3nz4gff/Physicians%20%288000083-8041022%29%20%282020-02-23%2014-52-06%29.csv?raw=1"))
a56 <- read.csv(url("https://www.dropbox.com/s/w62lq7ootdj6tnd/Physicians%20%289010000-9024666%29%20%282020-02-25%2021-45-40%29.csv?raw=1"))
a59 <- read.csv(url("https://www.dropbox.com/s/nh4ppeg4r8q5jpi/Physicians%20%289013114-9024666%29%20%282020-02-26%2018-00-24%29.csv?raw=1"))
a60 <- read.csv(url("https://www.dropbox.com/s/e5sr31gnee0ppgz/Physicians%20%281-9060000%29%20%282020-02-22%2009-39-54%29.csv?raw=1"))
a61 <- read.csv(url("https://www.dropbox.com/s/k2h99u8fjz95cur/Physicians%20%281-9060000%29%20%282020-02-22%2009-41-10%29.csv?raw=1"))
a62 <- read.csv(url("https://www.dropbox.com/s/n5gf97s4uq4nxj4/Physicians%20%281-847312%29%20on%202-22.2020.csv?raw=1"))

#Add March 2020 scrapes 
a63 <- read.csv(url("https://www.dropbox.com/s/lhoqdltq4f0iodk/Physicians%20%289030000-9024666%29%20%282020-03-07%2016-45-56%29.csv?raw=1"))
a64 <- read.csv(url("https://www.dropbox.com/s/sx85vsvodmil8h6/Physicians%20%289040000-9030000%29%20%282020-03-08%2014-50-09%29.csv?raw=1"))
a65 <- read.csv(url("https://www.dropbox.com/s/1yzghhwt63294t1/Physicians%20%289050000-9040000%29%20%282020-03-08%2020-12-49%29.csv?raw=1"))
a66 <- read.csv(url("https://www.dropbox.com/s/rabwn7i8mo2v67p/Physicians%20%289041410-9041900%29%20%282020-05-19%2013-03-51%29.csv?raw=1"))

#ABOG 2013 from SGS Bastow project from Dropbox/ workforce/ scraper/ 2013 data
a52 <- read.csv(url("https://www.dropbox.com/s/4ml8wdoijw67n7g/abog%2012.21.2013.csv?raw=1")) %>%
  dplyr::rename(userid = ID) %>%
  dplyr::mutate(`Certification 2` = dplyr::recode(Certification.2, `Female Pelvic Medicine and Reconstructive Surgery` = "FPM")) %>%
  dplyr::rename(sub1 = Certification.2)

all_a_dataframes <- a1 %>% readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
  dplyr::bind_rows(list(a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31, a32, a33, a34, a35, a36, a37, a38, a39, a40, a41, a42, a43, a44, a45, a46, a47, a48, a49, a50, a51, a52, a53, #a54, a57, a58,
                 a55, a56,   a59, a60, a61, a62, a63, a64, a65, a66)) %>%
  dplyr::arrange(desc(userid))

readr::write_csv(all_a_dataframes, "~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes.csv")
all_a_dataframes <- readr::read_csv("~/Dropbox/Pharma_Influence/Data/GOBA/GOBA_all_a_dataframes.csv")

all_bound_together <- all_a_dataframes %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
  dplyr::distinct(userid, .keep_all = TRUE) %>%
  dplyr::select(userid:orig_bas) %>%
  dplyr::filter(sub1certStatus %nin% c("Retired", "Not Currently Certified")) %>%
  dplyr::filter(sub2certStatus %nin% c("Retired", "Not Currently Certified")) %>%
  dplyr::filter(certStatus %nin% c("Retired", "Not Currently Certified")) %>%
  dplyr::filter(!is.na(state)) %>%
  dplyr::filter(state != "ON") %>%
  dplyr::filter(clinicallyActive %nin%("No")) %>%
  dplyr::mutate(Year_Boarded = lubridate::year(orig_sub)) %>%
  dplyr::distinct(userid, .keep_all = TRUE) %>%
  dplyr::arrange(desc(userid))

dim(all_bound_together)
colnames(all_bound_together)
head(all_bound_together, 200)
dplyr::glimpse(all_bound_together)
View(all_bound_together)

# Write the final bound scraper to disk ----
readr::write_rds(all_bound_together, "~/Dropbox/workforce/scraper/Scraper_results_2019/to_evaluate_GOBA_all_a_dataframes.rds")

#We start with a list of OBGYN physicians and the year that they were boarded called all_bound_together.csv.  The data is filtered for providers who are retired, not in the United States.