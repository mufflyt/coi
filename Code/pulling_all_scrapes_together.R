# Setup ----
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

all_bound_together <- all_a_dataframes %>%
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
  readr::write_csv("~/Dropbox/Pharma_Influence/Data/all_bound_together.csv")

dim(all_bound_together)
colnames(all_bound_together)
head(all_bound_together, 200)
dplyr::glimpse(all_bound_together)
View(all_bound_together)

#library("utils")
# not tested, https://stackoverflow.com/questions/33072993/read-and-cbind-second-column-of-multiple-files-in-directory

#https://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R

# (files <- list.files(path="/Volumes/Projects/Pharma_Influence/Data/Scraper"))
# 
# 
# 
# remove.packages("tidyr")
# remove.packages("tidycensus")
# remove.packages("broom")
# remove.packages("ggmap")
# remove.packages("tidyselect")
# 
# install.packages("purrr")
# library(purrr)
# require(purrr)
# library("readr")
# 
# data <- files %>%
#   purrr::map(readr::read_csv) %>%    # read in all the files individually, using
#   # the function read_csv() from the readr package
#   purrr::map(~ dplyr::select(name, city, state)) %>%
#   purrr::map(exploratory::bind_rows)        # reduce with rbind into one dataframe
# data
# 
# library(vroom)
# vroom(files)


# Adding demographics from tidycensus ----
options(tigris_class = "sf")
options(tigris_use_cache = TRUE)
getOption("tigris_use_cache")

tidycensus::census_api_key("485c6da8987af0b9829c25f899f2393b4bb1a4fb", install = TRUE)
Sys.getenv("CENSUS_API_KEY")

#Find variables in ACS and decennial census  
v17 <- tidycensus::load_variables(year = 2017, 
                                  dataset = "acs5",
                                  cache = TRUE)
v17 #All variables

female <- filter(v17, str_detect(label, fixed("Female", 
                                              ignore_case = TRUE)))


# Get a dataset of female populations from the 1-year ACS  #shift Hawaii and AK
# https://stackoverflow.com/questions/45847540/get-population-by-state-12-and-older-using-census-data#45848728
county_female_pop <- tidycensus::get_acs(geography = "county", 
                                         variables = c("B01001_039", #Female: 45 to 49 years 
                                                       "B01001_040", #Female: 50 to 54 years 
                                                       "B01001_041", #Female: 55 to 59 years
                                                       "B01001_042", # Female: 60 and 61 years
                                                       "B01001_043", #
                                                       "B01001_044", #Female: 65 and 66 years
                                                       "B01001_045", #Female: 67 to 69 years 
                                                       "B01001_046", #Female: 70 to 74 years 
                                                       "B01001_047", #Female: 75 to 79 years
                                                       "B01001_048", #Female: 80 to 84 years 
                                                       "B01001_049"), #Female: 85 years and over
                                         #survey = "acs1", #Screws everything up if this is included.  
                                         year = 2017,
                                         geometry = TRUE) #, 
#shift_geo = TRUE)
sum(is.na(county_female_pop))
dim(county_female_pop)

females_over_45 <- stats::aggregate(estimate ~ NAME, data=county_female_pop, FUN=sum, na.rm=FALSE)  #Adds all age groups
females_over_45
write_csv(females_over_45, "~/Dropbox/workforce/Rui_Project/females_over_45.csv")

total_females <- tidycensus::get_acs(geography = "county", 
                                     variables = c("B01001_026"), #Total female of all ages
                                     #survey = "acs1", 
                                     year = 2017,
                                     geometry = TRUE) %>% 
  dplyr::select(GEOID, NAME, estimate) 
names(total_females)
class(total_females)
head(total_females)

female_county_proportion <- females_over_45 %>%
  dplyr::left_join(total_females, by = c("NAME" = "NAME")) %>%
  dplyr::rename(total_females_all_ages = estimate.y, female_population_over_45 = estimate.x) %>%
  dplyr::mutate(proportion_of_women_over_45_years = (female_population_over_45/total_females_all_ages)*100) %>%
  sf::st_as_sf()
View(female_county_proportion)

female_county_proportion <- st_as_sf(female_county_proportion)
names(female_county_proportion)
class(female_county_proportion)

#Bring in female population demographics to each county
demographics_for_FPMRS_counties <- locations_with_fips %>% 
  #dplyr::left_join(county_female_pop, by = c( "fips" = "GEOID")) %>%
  dplyr::left_join(females_over_45, by = c("united_county_state" = "NAME"), ignorecase=TRUE) %>%
  dplyr::rename(estimate_of_females_over_45_years_old = estimate) %>%
  dplyr::left_join(total_females, by = c("fips" = "GEOID"), ignorecase=TRUE) %>%
  dplyr::rename(estimate_of_total_females_in_county = estimate) %>%  
  dplyr::select(-NAME, -geometry) %>%
  readr::write_csv("~/Dropbox/workforce/Rui_Project/demographics_for_FPMRS_counties.csv")

dim(demographics_for_FPMRS_counties)
View(head(demographics_for_FPMRS_counties))
invisible(gc())

states <- (c("AL",	"AK",	"AZ",	"AR",	"CA",	"CO",	"CT",	"DE",	"FL",	"GA",	"HI",	"ID",	"IL",	"IN",	"IA",	"KS",	"KY",	"LA",	"ME",	"MD",	"MA",	"MI",	"MN",	"MS",	"MO",	"MT",	"NE",	"NV",	"NH",	"NJ",	"NM",	"NY",	"NC",	"ND",	"OH",	"OK",	"OR",	"PA",	"PR", "RI",	"SC",	"SD",	"TN",	"TX",	"UT",	"VT",	"VA",	"WA",	"WV",	"WI",	"WY"))
my_states <- (c("AL",	"AK",	"AZ",	"AR",	"CA",	"CO",	"CT",	"DE",	"FL",	"GA",	"HI",	"ID", "IL"))
my_states2 <- (c("IN",	"IA",	"KS",	"KY",	"LA",	"ME",	"MD",	"MA"))
my_states4 <- (c("MI", "MN",	"MS",	"MO",	"MT"))
my_states3 <- (c("NE",	"NV",	"NH",	"NJ",	"NM",	"NY",	"NC",	"ND",	"OH",	"OK",	"OR",	"PA",	"PR", "RI",	"SC",	"SD",	"TN",	"TX",	"UT",	"VT",	"VA",	"WA",	"WV",	"WI",	"WY"))

#https://www.socialexplorer.com/data/ACS2017_5yr/metadata/?ds=ACS17_5yr, MUST ADD THE UNDERSCORE BETWEEN TABLE AND VARIABLE

my_vars <- c(
  total_pop = "B01003_001",
  median_income = "B19013_001", 
  Sex_by_Age_45_to_49 = "B01001_039",
  Sex_by_Age_50_to_54 = "B01001_040",
  Sex_by_Age_55_to_59 = "B01001_041", 
  Sex_by_Age_60_to_61 = "B01001_042", 
  Sex_by_Age_62_to_64 = "B01001_043",   
  Sex_by_Age_65_to_66 = "B01001_044", 
  Sex_by_Age_67_to_69 = "B01001_045", 
  Sex_by_Age_70_to_74 = "B01001_046", 
  Sex_by_Age_75_to_79 = "B01001_047", 
  Sex_by_Age_80_to_84 = "B01001_048", 
  Sex_by_Age_85_an_over = "B01001_049", 
  Sex_Female_all_ages = "B01001_026",
  Median_Age_Female = "B01002_003",
  Total_population_male_and_female = "B01003_001", 
  Poverty_Status_in_the_Past_12_Months_by_Sex_by_Age_Total = "B17001_017",
  Poverty_Status_in_the_Past_12_Months_by_Sex_by_Age_45_to_54 = "B17001_027",
  Poverty_Status_in_the_Past_12_Months_by_Sex_by_Age_55_to_64 = "B17001_028",
  Poverty_Status_in_the_Past_12_Months_by_Sex_by_Age_65_to_74 = "B17001_029",
  Poverty_Status_in_the_Past_12_Months_by_Sex_by_Age_75_and_over = "B17001_030",
  Household_Income_in_the_Past_12_Months_Total = "B19001_001",
  Household_Income_in_the_Past_12_Months_Less_than_10000 = "B19001_002",
  Household_Income_in_the_Past_12_Months_Total_10000_to_14999 = "B19001_003",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total = "B27001_030",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_45_to_64 = "B27001_046",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_45_to_64_no_insurance = "B27001_048",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_55_to_64 = "B27001_049",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_65_to_74 = "B27001_052",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_65_to_74_no_insurance = "B27001_054",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_75_and_older = "B27001_055",
  Health_Insurance_Coverage_Status_by_Sex_by_Age_Total_75_and_older_no_insurance = "B27001_057"
) 

tract_demographic_data <- tidycensus::get_acs(geography = "county",
                                              variables = my_vars,
                                              year = 2017,
                                              state = states,
                                              geometry = TRUE,
                                              cache_table = TRUE)
#write_csv(tract_demographic_data, "~/Dropbox/workforce/Data/tract_demographic_states.csv")
readr::write_rds(tract_demographic_data, "~/Dropbox/Rui/tract_demographic_states.rds")

# Steps to produce the output
all_states_demographics <- exploratory::read_rds_file("~/Dropbox/Rui/tract_demographic_states.rds") 
dim(all_states_demographics)
View(head(all_states_demographics))


all_states_demographics <- 
  readr::read_rds("~/Dropbox/Rui/tract_demographic_states.rds") %>%
  select(-moe) %>%
  spread(variable, estimate, drop = TRUE) %>%
  mutate(GEOID = as.character(GEOID))
#View(head(all_states_demographics))
class(all_states_demographics$GEOID)


total_demographics_per_county_with_FPMRS <- 
  readr::read_csv("~/Dropbox/Rui/demographics_for_FPMRS_counties.csv")%>%     
  dplyr::left_join(all_states_demographics, by=c("fips" = "GEOID")) %>%
  #Demographics from the ACS 2017 at the county level
  dplyr::select(-NAME, -geometry.y) 

names(total_demographics_per_county_with_FPMRS)
View(head(total_demographics_per_county_with_FPMRS))


#Pulling race variables from ACS ----
#From Datacamp, #Assign Census variables vector to race_vars 
gc()
race_vars <- c(White = "B03002_003", Black = "B03002_004", Native = "B03002_005", 
               Asian = "B03002_006", HIPI = "B03002_007", Hispanic = "B03002_012")

states <- (c("AL",	"AK",	"AZ",	"AR",	"CA",	"CO",	"CT",	"DE",	"FL",	"GA",	"HI",	"ID",	"IL",	"IN",	"IA",	"KS",	"KY",	"LA",	"ME",	"MD",	"MA",	"MI",	"MN",	"MS",	"MO",	"MT",	"NE",	"NV",	"NH",	"NJ",	"NM",	"NY",	"NC",	"ND",	"OH",	"OK",	"OR",	"PA",	"PR", "RI",	"SC",	"SD",	"TN",	"TX",	"UT",	"VT",	"VA",	"WA",	"WV",	"WI",	"WY"))

# Request race variables state-by-state from the ACS
usa_race <- tidycensus::get_acs(geography = "county",  #used to be tract but I changed it to county
                                variables = race_vars, 
                                #summary_var = "B03002_001",
                                state = states,
                                geometry = TRUE,
                                #shift_geo = TRUE, 
                                year = 2017,
                                cache_table = TRUE) %>%
  dplyr::select(-moe, -geometry, -NAME)
#View(usa_race)
names(usa_race)
tail(usa_race)

# Calculate a new percentage column and check the result
usa_race_pct <- usa_race %>%
  mutate(pct = 100 * (estimate / summary_est))
head(usa_race_pct)
#View(usa_race_pct)
class(usa_race_pct)

usa_race_pct <- usa_race_pct %>%
  select(-GEOID, -NAME, -estimate, -moe, -summary_est, -summary_moe, -pct) %>%
  filter(variable %in% c("White", "Black", "Hispanic", "Asian")) %>%
  mutate(group = variable) 

names(usa_race_pct)
#View(usa_race_pct)
class(usa_race_pct)

usa_tracts <- tigris::tracts(state = "CO", year = 2017, cb=TRUE)
usa_zcta <- tigris::zctas(state = "CO", year = 2017, cb=TRUE)


#
library(sf)
library(mapview)

locations_sf <- sf::st_as_sf(locations, coords = c("lon", "lat"), crs = 4326)
mapview::mapview(locations_sf)

#Merge Rui's data set with the data set thhat has lat and long
geocoded_partialproviderallnewpts_2017 <- partialproviderallnewpts_2017 %>%
  dplyr::left_join(locations, by = c("npi" = "npi")) %>%
  dplyr::select(-nppes_provider_country, -firstlastname.y) %>%
  as_tibble %>%
  filter(complete.cases(lon) & complete.cases(lat)) %>% # we have to have complete lat and long numbers for the map
  tidyr::unite(FPMRS_city_state, nppes_provider_city, nppes_provider_state, sep = ", ", remove = FALSE, na.rm = FALSE)

print("Number of lost providers without a match by lat and long:")
nrow(partialproviderallnewpts_2017) - nrow(geocoded_partialproviderallnewpts_2017)
colnames(geocoded_partialproviderallnewpts_2017)
dim(geocoded_partialproviderallnewpts_2017)
#View(head(geocoded_partialproviderallnewpts_2017, 100))
readr::write_csv(geocoded_partialproviderallnewpts_2017, "~/Dropbox/Rui/geocoded_partialproviderallnewpts_2017_sp_TMM.csv")


df <- geocoded_partialproviderallnewpts_2017


# create georeferenced FPMRS data
df_spatial <- df %>%
  st_as_sf(coords = c("lon", "lat"), crs=4326) %>%
  mutate(merged_99205_99204 = total99205+total99204) %>%
  mutate(proportion_of_total_99205_99204 = (merged_99205_99204/totalnewpts) * 100)



# Start mapping ----
# Original data is leaflet_map_GK.R #

## load libraries
#install.packages(c("leaflet", "leaflet.minicharts", "leaflet.extras", "sf", "tidyverse", "ggmap", "wesanderson", "shiny", "htmltools", "htmlwidgets", "sf"))
library(leaflet) # create interactive geographic maps
library(sf) # processing of geospatial data
library(tidyverse) # data processing tools
library(wesanderson) # color palettes
library(shiny) # creation of GUI, needed to change leaflet layers with dropdowns
library(htmltools) #added for saving html widget
#devtools::install_github('ramnathv/htmlwidgets')
library(htmlwidgets)
library (leaflet.extras)
library (leaflet.minicharts)
library(formattable)

## load data

# determine cut points for attribute visualization
# age_ranges <- c(25, 40, 55, 85)
# graduation_ranges <- c(1960, 1990,2000, 2015)
# last_year_of_residency_ranges <- c(1960, 1990,2000, 2015)
# practice_member_ranges <- c(1, 100 , 1000, 10000)

# determine cut attributes for easier visualization
# df_spatial <- df_spatial %>%
#   mutate(Age.range = cut(Age, breaks = age_ranges),
#          Graduation.year.range = 
#            cut(`Graduation year`,
#                breaks = graduation_ranges, dig.lab = 5),
#          Year.of.residency.range = 
#            cut(`Last Year Of Residency`,
#                breaks = last_year_of_residency_ranges, dig.lab = 5),
#          Practice.member.range =
#            cut(`Number of Group Practice members`,
#                breaks = practice_member_ranges, dig.lab = 5))
# df_spatial <- df_spatial %>%
#   mutate(gender = as.factor(gender))

# associate attribute column name with attribute names
# fpmrs_attributes <- c("gender",
#                       "Age.range",
#                       "Year.of.residency.range",
#                       "Graduation.year.range",
#                       "Practice.member.range")
# names(fpmrs_attributes) <- c("Gender of FPMRS Physicians",
#                              "Age of FPMRS Physicians",
#                              "Last year of Residency",
#                              "Graduation year",
#                              "Number of group practice members")
# 
# #create color palette for initial map
pal <- colorFactor(palette = as.character(wes_palette("Darjeeling1", 2)))


# create legend for markers of fellowship programs
#html_legend <- "<img src='https://unpkg.com/leaflet@1.3.1/dist/images/marker-icon.png'> FPMRS Physician"

# create initial map
map <- df_spatial %>%
  leaflet () %>%
  addProviderTiles("CartoDB.PositronNoLabels") %>%  
  #https://leaflet-extras.github.io/leaflet-providers/preview/
  setView(lat = 39.8282, lng = -98.5795, zoom = 4) %>%
  clearBounds() %>% clearMarkers() %>%
  addCircleMarkers(data = df_spatial, 
                   radius = ~log(merged_99205_99204), fill=T,
                   fillOpacity = 0.1, popup = df$firstlastname.x) %>%
  # addCircleMarkers(radius = 5, fill=T,
  #                  fillOpacity = 0.4)
  # popup = paste("Name:", df_spatial$fullname1, "<br>",
  #               "Address:", df_spatial$complete_address, "<br>",
  #               "Age:", df_spatial$Age, "<br>",
  #               "Gender:", df_spatial$gender, "<br>",
  #               "Residency Type:", df_spatial$Specialty, "<br>",
  #               "NPI Number:", df_spatial$NPI, "<br>",
  #               "Medical School Training:", df_spatial$`Medical school name`,"<br>")) %>%
  # addLegend(pal = pal, values = c("Female", "Male"), opacity = 0.5,
  #           title = "Gender of FPMRS Physicians", position = "topright") %>%
addControl(html = html_legend, position = "bottomright") %>%
  addScaleBar(position = "bottomleft", options = scaleBarOptions()) %>%
  mapOptions(zoomToLimits = "first") #%>%
# addMarkers(
#    clusterOptions = markerClusterOptions())  #Added cluster option here.  
map
# popupOptions(maxWidth = 300, minWidth = 50, maxHeight = NULL,
#             keepInView = FALSE, closeButton = TRUE, closeOnClick = TRUE)
htmlwidgets::saveWidget(widget=map, file="~/Dropbox/workforce/Rui_Project/first_draft.html", selfcontained = TRUE)
map




########  Clustering Map
cluster1 <- df_spatial %>% 
  leaflet() %>% 
  addTiles(options=tileOptions(useCache=TRUE, crossOrigin=TRUE)) %>%
  addProviderTiles("CartoDB.PositronNoLabels") %>%
  # Sanitize any html in our labels
  addCircleMarkers(radius = 20, label = ~htmlEscape(fullname1),
                   # Color code colleges by sector using the `pal` color palette
                   color = ~pal(gender),
                   # Cluster all colleges using `clusterOptions`
                   clusterOptions = markerClusterOptions(), 
                   popup = paste("Name:", df_spatial$fullname1, "<br>",
                                 "Address:", df_spatial$complete_address, "<br>",
                                 "Age:", df_spatial$Age, "<br>",
                                 "Gender:", df_spatial$gender, "<br>",
                                 "Residency Type:", df_spatial$Specialty, "<br>",
                                 "NPI Number:", df_spatial$NPI, "<br>",
                                 "Medical School Training:", df_spatial$`Medical school name`, "<br>"))
cluster1
saveWidget(cluster1, file="FPMRS_cluster1.html")

###Base MAP
base <- leaflet () %>%
  clearMarkers() %>%
  setView(lat = 39.8282, lng = -98.5795, zoom = 4) %>%
  addTiles(options=tileOptions(useCache=TRUE, crossOrigin=TRUE)) %>%
  addProviderTiles("CartoDB.PositronNoLabels") %>%
  addCircleMarkers(data = df_spatial, radius = 5, stroke = FALSE,
                   fill=T, fillOpacity = 0.4,
                   popup = paste("Name:", df_spatial$fullname1, "<br>",
                                 "Address:", df_spatial$complete_address, "<br>",
                                 "Age:", df_spatial$Age, "<br>",
                                 "Gender:", df_spatial$gender, "<br>",
                                 "Residency Type:", df_spatial$Specialty, "<br>",
                                 "NPI Number:", df_spatial$NPI, "<br>",
                                 "Medical School Training:",
                                 df_spatial$`Medical school name`, "<br>"))
base

###OVERLAY MAP
#Group for overlays

# Create data frame called male with only female FPMRS
females <- filter(df_spatial, gender == "Female")  

# Create a dataframe of males called males 
males <- filter(df_spatial, gender == "Male")  

#leaflet() %>%
#  addTiles() %>%
#  addMarkers(data = coffee_shops, group = "Food & Drink") %>%
#  addMarkers(data = restaurants, group = "Food & Drink") %>%
#  addMarkers(data = restrooms, group = "Restrooms")

gender <- base %>% clearMarkers() %>% clearMarkerClusters() %>% 
  
  addCircleMarkers(data = males, radius = 3, label = ~htmlEscape(fullname1),
                   color = ~pal(gender), group = "Male",
                   popup = paste(
                     "Name:", males$fullname1, "<br>",
                     "Address:", males$complete_address, "<br>", 
                     "Age:", males$Age, "<br>",
                     "Gender:", males$gender, "<br>", 
                     "Residency Type:", males$Specialty, "<br>", 
                     "NPI Number:", males$NPI, "<br>", 
                     "Medical School Training:", 
                     males$`Medical school name`, "<br>")) %>%
  
  addCircleMarkers(data = females, radius = 3, label = ~htmlEscape(fullname1),
                   color = ~pal(gender), group = "Female",
                   popup = paste(
                     "Name:", females$fullname1, "<br>",
                     "Address:", females$complete_address, "<br>",
                     "Age:", females$Age, "<br>",
                     "Gender:", females$gender, "<br>",
                     "Residency Type:", females$Specialty, "<br>",
                     "NPI Number:", females$NPI, "<br>",
                     "Medical School Training:", 
                     females$`Medical school name`, "<br>")) %>%
  addLayersControl(
    overlayGroups = c("Female", "Male"), 
    options = layersControlOptions(collapsed = FALSE))
gender
saveWidget(gender, file="FPMRS_gender_layers.html")

# Layers control
#addLayersControl(
#  baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
#  overlayGroups = c("Quakes", "Outline"),
#  options = layersControlOptions(collapsed = FALSE)

#leaflet() %>%
#  addTiles() %>%
#  addMarkers(data = coffee_shops, group = "Food & Drink") %>%
#  addMarkers(data = restaurants, group = "Food & Drink") %>%
#  addMarkers(data = restrooms, group = "Restrooms")

obgyn <- filter (df_spatial, Specialty == "OBGYN")
urology <- filter (df_spatial, Specialty == "Urology")

pal2 <- colorFactor(palette = as.character(wes_palette("Darjeeling1", 2)),
                    levels = c("OBGYN", "Urology"))

all <- base %>% 
  clearMarkers() %>%
  addCircleMarkers(data = obgyn, radius = 3, label = ~htmlEscape(fullname1),
                   color = ~pal2(Specialty), group = "OBGYN Residency Training",
                   popup = paste("Name:", obgyn$fullname1, "<br>",
                                 "Address:", obgyn$complete_address, "<br>",
                                 "Age:", obgyn$Age, "<br>",
                                 "Gender:", obgyn$gender, "<br>",
                                 "Residency Type:", obgyn$Specialty, "<br>",
                                 "NPI Number:", obgyn$NPI, "<br>",
                                 "Medical School Training:", 
                                 obgyn$`Medical school name`, "<br>")) %>%
  addCircleMarkers(data = urology, radius = 3, label = ~htmlEscape(fullname1),
                   color = ~pal2(Specialty), group = "Urology Residency Training",
                   popup = paste("Name:", urology$fullname1, "<br>",
                                 "Address:", urology$complete_address, "<br>",
                                 "Age:", urology$Age, "<br>",
                                 "Gender:", urology$gender, "<br>",
                                 "Residency Type:", urology$Specialty, "<br>",
                                 "NPI Number:", urology$NPI, "<br>",
                                 "Medical School Training:",
                                 urology$`Medical school name`, "<br>")) %>%
  addLayersControl(
    overlayGroups = c("OBGYN Residency Training", "Urology Residency Training"), 
    options = layersControlOptions(collapsed = FALSE))
all
saveWidget(all, file="FPMRS_all_layers.html", selfcontained = TRUE)

###Choropleth maps
#Tutorial: http://rstudio.github.io/leaflet/choropleths.html
# https://blog.exploratory.io/creating-geojson-out-of-shapefile-in-r-40bc0005857d
#install.packages("sp")
#install.packages("geojsonio")
#install.packages("rgdal")
#install.packages("spdplyr")
#install.packages("rmapshaper")
#install.packages("stringi")
#install.packages("lawn")
#devtools::install_github("walkerke/tidycensus")
#install.packages("tigris")
#install.packages("tidyverse")
#devtools::install_github("exploratory-io/exploratory_func")
#install.packages("magrittr")

library(geojsonio)
library (rgdal)
library (spdplyr)
library (rmapshaper)
library(stringi)
library(lawn)
library(sp)
library(leaflet)
library(tidycensus)
# tidycensus::census_api_key("485c6da8987af0b9829c25f899f2393b4bb1a4fb", install=T)
Sys.getenv("CENSUS_API_KEY")
library(tigris)
library(tidyverse)
library(magrittr)
library(exploratory)

##Datacamp:  https://campus.datacamp.com/courses/analyzing-us-census-data-in-r/census-data-in-r-with-tidycensus?ex=1

#Search for data sets using tidycensus
#https://censusreporter.org
# v16 <- load_variables(year = 2016,
#                       dataset = "acs5",
#                       cache = TRUE)
# 
# #Search for female variables
# search <- filter(v16, str_detect(label, fixed("female", 
#                                               ignore_case = TRUE)))
# 
# totalfemalepop <- get_acs(geography = "county", 
#                           variables = c(population_female = "B01001_026", 
#                                         ages_45_to_49 = "B01001_039",
#                                         ages_50_to_54 = "B01001_040",
#                                         ages_55_to_59 = "B01001_041",
#                                         ages_60_to_61 = "B01001_042",
#                                         ages_62_to_64 = "B01001_043",
#                                         ages_65_and_66 = "B01001_044",
#                                         ages_67_to_69 = "B01001_045",
#                                         ages_70_to_74 = "B01001_046",
#                                         ages_75_to_79 = "B01001_047",
#                                         ages_80_to_84 = "B01001_048",
#                                         ages_85_and_over = "B01001_049"),
#                           output = "wide")
# totalfemalepop <- select(totalfemalepop, -ends_with("M"))
# 
# totalfemalepop <- totalfemalepop %>% mutate(olderfemalepop = ages_45_to_49E + ages_50_to_54E + ages_55_to_59E + ages_60_to_61E + ages_62_to_64E + ages_65_and_66E + ages_67_to_69E + ages_70_to_74E + ages_75_to_79E + ages_80_to_84E + ages_85_and_overE) 
# totalfemalepop$GEOID <- as.numeric(as.character(totalfemalepop$GEOID))
# #technical data on the variable found at https://www.socialexplorer.com/data/ACS2014_5yr/metadata/?ds=ACS14_5yr&var=B01001026
# write_csv(totalfemalepop, "../Referenced_data/totalfemalepop.csv")

totalfemalepop <- read_csv(file="../Referenced_data/totalfemalepop.csv")
totalfemalepop$GEOID 

##Import shapefile
tmp <- tempdir()
url <- "http://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_county_500k.zip"
file <- basename(url)
download.file(url, file)
unzip(file, exdir = tmp)

#Import shapefile
county <- readOGR(dsn = "../Referenced_data/shapefiles/county/", layer = "cb_2017_us_county_500k")
county$GEOID <- as.numeric(as.character(county$GEOID))
# dim(county)
# 
county <- left_join(county, totalfemalepop, by = "GEOID")
# glimpse(county)
# dim(county)
# summary (county@data[["olderfemalepop"]])
# 
# county_json <- geojson_json(county)
# county_json_simplified <- ms_simplify(county_json)
# county_json_clipped <- ms_clip(county_json_simplified, bbox = c(-170, 15, -55, 72))
# geojson_write(county_json_clipped, file = "../Referenced_data/shapefiles/county/county.geojson")

county_geojson <- geojsonio::geojson_read("../Referenced_data/shapefiles/county/county.geojson", what = "sp")
glimpse(county_geojson)


##Create choropleth map

m <- county_geojson %>%
  leaflet () %>%
  addProviderTiles("CartoDB.PositronNoLabels") %>%
  setView(lat = 39.8282, lng = -98.5795, zoom = 4)
m %>% addPolygons()
bins <- c(0, 1000, 2000, 5000, 10000, 50000, 100000, 2000000, Inf)
pal <- colorBin("YlOrRd", domain = county_geojson$olderfemalepop, bins = bins)


m %>% addPolygons(
  fillColor = ~pal(olderfemalepop),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7)

m %>% addPolygons(
  fillColor = ~pal(olderfemalepop),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE))

labels <- sprintf(
  "<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
  county$NAME.x, county$olderfemalepop
) %>% lapply(htmltools::HTML)

m <- m %>% addPolygons(
  fillColor = ~pal(olderfemalepop),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto")
)
m

m %>% addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")


####https://rpubs.com/walkerke/leaflet_choropleth
library(rgdal)
library(leaflet)
tmp <- tempdir()
url <- "http://www2.census.gov/geo/tiger/GENZ2017/shp/cb_2017_us_county_500k.zip"
file <- basename(url)
download.file(url, file)
unzip(file, exdir = tmp)

mexico <- readOGR(dsn = tmp, layer = "cb_2017_us_county_500k", encoding = "UTF-8")
head(mexico@data)
mexico$ALAND <- as.numeric(mexico$ALAND)
pal <- colorQuantile("YlGn", NULL, n = 5)
state_popup <- paste0("<strong>Estado: </strong>", 
                      mexico$NAME, 
                      "<br><strong>Area of land: </strong>", 
                      mexico$ALAND)
leaflet(data = mexico) %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(lat = 39.8282, lng = -98.5795, zoom = 4) %>%
  addPolygons(fillColor = ~pal(ALAND), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1, 
              popup = state_popup)



#Fix thhe fact that there are no padding zeros before the zip codes.  
partialproviderallnewpts_2017$nppes_provider_zip[263]  #Exasmple of the problem
partialproviderallnewpts_2017$nppes_provider_zip <- zipcode::clean.zipcodes(partialproviderallnewpts_2017$nppes_provider_zip) 
partialproviderallnewpts_2017$nppes_provider_zip[263]

#Shorten the zip codes from 9 to 5 digits.  
partialproviderallnewpts_2017$nppes_provider_zip[1] #Example of problem we are trying to fix
partialproviderallnewpts_2017 <- partialproviderallnewpts_2017 %>%
  dplyr::mutate(nppes_provider_zip = stringr::str_sub(nppes_provider_zip, "1","5"))   #limit zip codes to only the first 5 digits
partialproviderallnewpts_2017$nppes_provider_zip[1]

nrow(partialproviderallnewpts_2017) #Number of physicians
sum(complete.cases(partialproviderallnewpts_2017))  #Number of physicians with complete information in all columns/observations

###Clean zip codes
library(zipcode)
data(zipcode)
zipcode$zip <- as.character(zipcode$zip)
zipcode %>%
  dplyr::distinct(zip, .keep_all = TRUE) 

USZipCodeCountyCityStateGeocodeMappingTable <- exploratory::read_delim_file("/Users/tylermuffly/Dropbox/workforce/scraper/US Zip Code - County - City - State - Geocode Mapping Table.csv" , ",", quote = "\"", skip = 0 , col_names = TRUE , na = c('','NA') , locale=readr::locale(encoding = "UTF-8", decimal_mark = ".", grouping_mark = "," ), trim_ws = TRUE , progress = FALSE) %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
  unite(CITY_STATE, CITY, STATE, sep = " ", remove = FALSE) %>%
  distinct(CITY_STATE, .keep_all = TRUE) %>%
  mutate(ZIP = as.character(ZIP), ZIP = str_pad(ZIP, pad="0", side="left", width=5))%>%
  dplyr::select(ZIP, CITY, STATE, latitude, longitude) #%>% 
#dplyr::filter(STATE == "CT") %>%  #Test to make sure that Hartford, CT zip codes were padded with a zero
#dplyr::filter(CITY == "Hartford") 

class(USZipCodeCountyCityStateGeocodeMappingTable$ZIP)

# USZipCodeCountyCityStateGeocodeMappingTable <- read.csv(url("https://www.dropbox.com/s/mkt9qccs5boe3yf/US%20Zip%20Code%20-%20County%20-%20City%20-%20State%20-%20Geocode%20Mapping%20Table.csv?raw=1"))





# Find the county with Google Maps associated with address by reverse geocoding lat/long ----
#https://developers.google.com/maps/documentation/geocoding/intro
#https://blog.exploratory.io/reverse-geocoding-part-2-using-google-maps-api-with-r-e676db36fee6
# Reverse geocoding#
# find_pref2: A function to find prefecture names for 
# the long/lat combinations using Google Maps API
#
#
# find_pref2: A function to find prefecture names for 
# the long/lat combinations using Google Maps API

find_pref2 <- function(long, lat, apiKey = NULL) {
  # Request URL parameters
  parameters <- ""
  # Add API Key in the parameters if available.
  if (!is.null(apiKey)) {
    parameters <- str_c("&key=", apiKey)
  }
  # Construct Google Maps APIs request URL.
  apiRequests <- iconv(str_c("https://maps.googleapis.com/maps/api/geocode/json?latlng=", lat, ",", long, parameters), "", "UTF-8")
  # Prefecture names will be stored to this.
  result <- c()
  # Iterate longitude/latitude combinations.
  for(i in 1:length(lat)) {
    # Avoid calling API too often.
    Sys.sleep(0.1)
    # Call Google Maps API.
    conn <- httr::GET(URLencode(apiRequests[i]))
    # Parse the JSON response. 
    apiResponse <- jsonlite::fromJSON(httr::content(conn, "text"))
    # Look at the address_components of the 1st address.
    ac <- apiResponse$results$address_components[[1]]
    # Prefecture name
    prefecture <- ""
    # If address_components is available, look for 
    # the prefecture name. 
    if (!is.null(ac)) {
      # Iterate the types of the current address_components.
      for (j in 1:length(ac$types)) {
        # Look for the administrative_area_level_1 in 
        # types of the address_components. In case of Japan, 
        # prefecture = administrative_area_level_1.  
        # if (ac$types[[j]][[1]] == "administrative_area_level_1") {  #returns the US state name
        #if (ac$types[[j]][[1]] == "locality") {                       #returns the US city name
        if (ac$types[[j]][[1]] == "administrative_area_level_2") {    #returns the US country name
          
          # If we find the prefecture address_components, 
          # pick the long_name and save it. 
          prefecture <- ac$long_name[[j]]
        }
      }
    }    
    result[i] <- prefecture
  }
  # Return the result vector.
  return(result)
}




locations_with_fips <- locations %>% 
  dplyr::mutate(prefecture = find_pref2(lon, lat, apiKey = "AIzaSyDyxsfMXJaGNMjQ52Gh7R4n37meA5uoF_8")) %>%  #finds county based on lat long
  dplyr::rename (county = prefecture)  %>%
  tidyr::unite(united_county_state, county, state, sep = ", ", remove = TRUE, na.rm = FALSE) %>% #unites the county name and state to avoid duplicates
  dplyr::inner_join(fips)  #Join the FIPS codes with the county, state names of each FPMRS

fips_plus_locations <- readr::write_csv(locations_with_fips, "/Users/tylermuffly/Dropbox/workforce/Rui_Project/fips_plus_locations.csv") %>% dplyr::distinct(npi, .keep_all = TRUE)
# FIPS is the five-digit Federal Information Processing Standard code which uniquely identifies counties and county equivalents.





# Match lat/long to county and fips code directly.  
#https://stackoverflow.com/questions/8751497/latitude-longitude-coordinates-to-state-code-in-r/8751965#8751965
library(sp)
library(maps)
library(maptools)

# The single argument to this function, pointsDF, is a data.frame in which:
#   - column 1 contains the longitude in degrees (negative in the US)
#   - column 2 contains the latitude in degrees

latlong2state <- function(pointsDF) {
  # Prepare SpatialPolygons object with one SpatialPolygon
  # per state (plus DC, minus HI & AK)
  states <- map('county', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(states$names, ":"), function(x) x[1])
  states_sp <- map2SpatialPolygons(states, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Convert pointsDF to a SpatialPoints object 
  pointsSP <- SpatialPoints(pointsDF, 
                            proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Use 'over' to get _indices_ of the Polygons object containing each point 
  indices <- over(pointsSP, states_sp)
  
  # Return the state names of the Polygons object containing each point
  stateNames <- sapply(states_sp@polygons, function(x) x@ID)
  stateNames[indices]
}

# Test the function using points in Wisconsin and Oregon.
testPoints <- data.frame(x = c(-72.685097, 41.763710), y = c(44, 44))

latlong2state(testPoints)


#Try to add in the NPI numbers
#Fewer people than in FPMRS_1269_doctors because Urology not listed on ABOG site anymore as of 2/19/2020

#Get a list of physicians who have the FPMRS taxonomy codes.  taxonomy_description = "Female Pelvic Medicine and Reconstructive Surgery"
# FPMRS taxonomy code is 207VF0040X
`npidata_pfile_20050523-20200209` <- readr::read_csv("~/Dropbox/workforce/Data/NPI/npidata_pfile_20050523-20200209.csv", 
                                                     na = c("", "NA"), 
                                                     progress = show_progress(), 
                                                     quoted_na = TRUE,
                                                     #guess_max = 1000,
                                                     trim_ws = TRUE,
                                                     #n_max = 300, 
                                                     guess_max = 300,
                                                     skip_empty_rows = TRUE) %>%
  dplyr::filter(`Entity Type Code` =="1") 

colnames(`npidata_pfile_20050523-20200209`)

npi_data <- `npidata_pfile_20050523-20200209` %>%
  dplyr::filter(`Provider Business Mailing Address Country Code (If outside U.S.)` =="US") %>%  #US only
  dplyr::mutate(`Provider Credential Text` = stringr::str_clean(`Provider Credential Text`), 
                `Provider Credential Text` = stringr::str_remove_all(`Provider Credential Text`, "[.]")) %>%
  
  dplyr::filter(`Provider Credential Text` %in% c("MD", "DO")) %>%  #filter out physicians only
  dplyr::select(NPI, 
                `Provider Business Mailing Address City Name`:`Provider Business Mailing Address Postal Code`,
                `Provider Last Name (Legal Name)`:`Provider Credential Text`, 
                contains("Taxonomy")) %>%   #select the columns to search by taxonomy codes
  dplyr::filter_all(any_vars(stringr::str_detect(., pattern = "207VF0040X")))

dim(npi_data)
View(head(npi_data, 100))
tail(npi_data)

write_csv(npi_data, "~/Dropbox/Rui/npi_data.csv")




# Steps to produce fips_plus_locations
`fips_plus_locations` <- exploratory::read_delim_file("/Users/tylermuffly/Dropbox/workforce/Rui_Project/fips_plus_locations.csv" , ",", quote = "\"", skip = 0 , col_names = TRUE , na = c('','NA') , locale=readr::locale(encoding = "UTF-8", decimal_mark = ".", grouping_mark = "," ), trim_ws = TRUE , progress = FALSE) %>%
  readr::type_convert() %>%
  exploratory::clean_data_frame() %>%
  dplyr::mutate(fips = parse_number(fips)) %>%
  dplyr::distinct(npi, .keep_all = TRUE) %>%
  dplyr::left_join(countylevelmerged, by = c("fips" = "FIPS"))




