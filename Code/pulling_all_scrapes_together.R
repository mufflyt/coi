# Setup to Create GOBA file----
# Set libPaths.
rm(list = setdiff(ls(), lsf.str()))
.libPaths("/Users/tylermuffly/.exploratory/R/3.6")
here::set_here()

# Load required packages.
library(geosphere)
library(gmapsdistance)
library(zipcode)
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
library(exploratory)
library(RDSTK)

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
#a21 <- read.csv(url("https://www.dropbox.com/s/3myst0596aqn96e/Physicians_total_drop_na_29.csv?raw=1"))
#a22 <- read.csv(url("https://www.dropbox.com/s/bdxfcw0iq9etp77/Physicians_total_left_join_27.csv?raw=1"))

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

###
a66 <- read.csv(url("https://www.dropbox.com/s/kl1jpxbh4urfotw/Physicians%20%289041048-9043048%29%20%282019-12-22%2008-51-01%29.csv?raw=1"))

a67 <- read.csv(url("https://www.dropbox.com/s/24mnbhl0j5do660/Physicians%20%289041048-9043048%29%20%282019-12-21%2017-14-39%29.csv?raw=1"))

a68 <- read.csv(url("https://www.dropbox.com/s/i99p7gq15qk2v7a/Physicians%20%289e%2B06-9032700%29%20%282019-09-08%2006-48-56%29.csv?raw=1"))

a69 <- read.csv(url("https://www.dropbox.com/s/aiqpe1bbskhhx94/Physicians%20%289050000-9038000%29%20%282020-01-03%2018-20-19%29.csv?raw=1"))

a70 <- read.csv(url("https://www.dropbox.com/s/qcjhvp06v6fuyoo/Physicians%20%289041048-9037048%29%20%282019-12-22%2012-25-57%29.csv?raw=1"))

a71 <- read.csv(url("https://www.dropbox.com/s/cto20nxan88qgfv/Physicians%20%289037048-9032048%29%20%282019-12-22%2013-22-42%29.csv?raw=1"))

a72 <- read.csv(url("https://www.dropbox.com/s/00m2usopo2vmyx1/Physicians%20%289032048-9027048%29%20%282019-12-22%2014-30-40%29.csv?raw=1"))

a73 <- read.csv(url("https://www.dropbox.com/s/r8crl2nwola5c4o/Physicians%20%289027048-9017048%29%20%282019-12-22%2016-53-04%29.csv?raw=1"))

a74 <- read.csv(url("https://www.dropbox.com/s/o7gjhdzgy7rd5m6/Physicians%20%289017048-9007048%29%20%282019-12-23%2008-40-42%29.csv?raw=1"))

a75 <- read.csv(url("https://www.dropbox.com/s/gky96odvkwgnwrn/Physicians%20%289029730-9050000%29%20%282020-01-27%2006-53-03%29.csv?raw=1"))
###
a76 <- read.csv(url("https://www.dropbox.com/s/fwx9r9nnvnlbxv3/Physicians%20%28815002-993412%29%20%282019-09-08%2006-39-33%29.csv?raw=1"))
a77 <- read.csv(url("https://www.dropbox.com/s/k4ij7hf7rczil6u/Physicians%20%289041800-9040000%29%20%282020-05-02%2009-02-19%29.csv?raw=1"))


#REMOVED THIS ONE.......
#ABOG 2013 from SGS Bastow project from Dropbox/ workforce/ scraper/ 2013 data
a52 <- read.csv(url("https://www.dropbox.com/s/4ml8wdoijw67n7g/abog%2012.21.2013.csv?raw=1"))
#   dplyr::rename(userid = ID) %>%
#   #dplyr::mutate(`Certification 2` = dplyr::recode(Certification.2, `Female Pelvic Medicine and Reconstructive Surgery` = "FPM")) %>%
#   dplyr::rename(sub1 = Certification.2)

# # Bind together all the individual scrapes ----
# # Steps to produce the output
library(exploratory)
all_a_dataframes <- a1 %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
  bind_rows(a2, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a3, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a4, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a5, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a6, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a7, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a8, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a9, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a10, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a11, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a12, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a13, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a14, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a15, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a16, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a17, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a18, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a19, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a20, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  #bind_rows(a21, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  #bind_rows(a22, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a23, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a24, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a25, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a26, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a27, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a28, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a29, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a30, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a31, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a32, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a33, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a34, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a35, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a36, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a37, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a38, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a39, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a40, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a41, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a42, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a43, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a44, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a45, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a46, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a47, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a48, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a49, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a50, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a51, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  #bind_rows(a52, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a53, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a55, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a56, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a59, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a60, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a61, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a62, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a63, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a64, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a65, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a66, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a67, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a68, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a69, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a70, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a71, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a72, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a73, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a74, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a75, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE)%>%
  bind_rows(a76, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  bind_rows(a77, id_column_name = "ID", current_df_name = "Physicians_9037048_9032048_2019_12_22_13_22_42", force_data_type = TRUE) %>%
  dplyr::select(-starts_with("ID.new")) %>%
  dplyr::select(-X, -Message, -app_no) 

readr::write_csv(all_a_dataframes, "~/Dropbox/Pharma_Influence/Data/all_a_dataframes.csv")
dim(all_a_dataframes)

GOBA <- all_a_dataframes %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
  dplyr::distinct(userid, .keep_all = TRUE) %>%
  dplyr::select(-starts_with("ID.new")) %>%
  dplyr::arrange(desc(userid)) %>%
  dplyr::filter(sub1certStatus %nin% c("Retired")) %>%
  dplyr::filter(sub2certStatus %nin% c("Retired")) %>%
  dplyr::filter(certStatus %nin% c("Retired")) %>%
  #dplyr::filter(!is.na(state)) %>%
  dplyr::filter(state %nin% c("ON", "AB")) %>%
  dplyr::filter(clinicallyActive !="No") %>%
  dplyr::mutate(Year_Boarded = lubridate::year(orig_sub)) %>%
  readr::write_csv("~/Dropbox/Pharma_Influence/Data/GOBA.csv")

dim(GOBA)
colnames(GOBA)
head(GOBA, 200)
dplyr::glimpse(GOBA)
