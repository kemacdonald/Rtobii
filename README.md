# Rtobii

Rtobii is a R-package that contains utility functions for
reading and parsing data files for eyetracking studies in
the Language Learning Lab at Stanford University.

## Setup

Install `Rtobii` from this GitHub repository:

```S
install.packages('devtools')
devtools::install_github("kemacdonald/Rtobii")
```

## Usage 

The following code snippet shows how to build an iChart using `make_iChart()`. 
`make_iChart()` is a wrapper function for a sequence of functions that 
take raw Tobii eyetracking data and converts it to a wide format that 
plays nicely with the Language Learning Lab's analysis workflow using the 
companion R package iChartAnalyzeR.

```r
library(Rtobii)
library(tidyverse)
theme_set(ggthemes::theme_base())

####### READ IN INPUTS FOR iCHART #################

# root of data directory
root_data_path <- "~/Desktop/tobii_to_ichart_test/Cohort5_ClipsMovies"

# set up file paths
timing_path <- file.path(root_data_path, "processing/Habla2_25_Clips/Habla2_25_Clips_timing.txt")
vcx_path <- file.path(root_data_path, "vcx")
order_path <- file.path(root_data_path, "processing/Habla2_25_Clips/Habla2_25_Clips_order.txt")

## read data inputs
d_tsv <- read_tobii(file = file.path(root_data_path, "H3_25m_n6.tsv"), tidy = T, y_max = 2048)
d_meta <- read_order_file(order_path)
d_vcx <- read_all_vcx(vcx_path)
d_timing <- read_timing_file(timing_path)

####### PULL IT ALL TOGETHER #################
aois_list <- list(l_xmin=0, l_xmax=400, l_ymin=1648, l_ymax=2048,
                  r_xmin=1285, r_xmax=1685, r_ymin=1648, r_ymax=2048)

d_wide <- make_iChart(d_tsv, d_meta, d_vcx, d_timing, aois_list = aois_list, 
                      make_wide = T,
                      make_iChart_names = T)

####### WRITE TO .TXT FILE  #################

write_delim(d_wide, path = "Habla2_25_iChart_wide.txt", delim = '\t')
```

## Reading data in long format 

You can also read in the eye movement data in long format by setting `make_wide = F` and `make_iChart_names = F`.
This will allow you to use two plotting functions that come with `Rtobii`.

```r
## read data in long format
d_long <- make_iChart(d_tsv, d_meta, d_vcx, d_timing, aois_list = aois_list, 
                      make_iChart_names = F,
                      make_wide = F)

## plot fixations on the x-y coordinate plane wrt AOIs
d_long %>%
  filter(prescreen_notes == "good_trial") %>%
  plot_fixations(frac_size = .05, aois_list)

## plot X-coordinate looking behavior wrt time
d_long %>%
  filter(prescreen_notes == "good_trial") %>%
  plot_timecourses(n_subs = 3, n_trials = 6)
```
