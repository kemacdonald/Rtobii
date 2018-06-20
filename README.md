# Rtobii

Rtobii is a R-package that contains utility functions for
reading and parsing data files for eyetracking studies in
the Language Learning Lab at Stanford University.

## Setup

### Install Rtobii
Install `Rtobii` from this GitHub repository:

```S
install.packages('devtools')
devtools::install_github("kemacdonald/Rtobii")
```

## Usage 

The following code snippet shows how to build an iChart using `make_iChart()`. `make_iChart()` is a wrapper function for a sequence of functions that take raw Tobii eyetracking data and converts it to a wide format that plays nicely with the Language Learning Lab's RScripts.

```r
library(Rtobii)
library(tidyverse)
theme_set(theme_minimal())

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
aois_list <- list(l_xmin=7, l_xmax=396, l_ymin=1749, l_ymax=2044,
                  r_xmin=1289, r_xmax=1685, r_ymin=1751, r_ymax=2044)

d_wide <- make_iChart(d_tsv, d_meta, d_vcx, d_timing, aois_list = aois_list, make_wide = T)

####### Exploratory Plots to Check Data Processing ##############
d_long <- make_iChart(d_tsv, d_meta, d_vcx, d_timing, aois_list = aois_list, make_wide = F)

## fixations plot with AOIs to see how things look
plot_fixations(d_long, frac_size = .05, aois_list)

## plot coordinate as a function of time
plot_timecourses(d_long, n_subs = 3, n_trials = 10)
```

#### You can also perform each step of the data processing pipeline separately. 

```r
## merge meta and ps info with eyetracking data
d_final <- d_tsv %>% left_join(d_meta, by = c("trial_number"))

## filter unused trials
d_final <- d_final %>% filter(used == "yes")

## add time from noun onset
d_final <- add_time_crit_onset(d_final, d_timing, onset_type = "noun")

## create time bins +/- 17 ms relative to noun onset (F0)
d_final <- add_time_bins(d_final)

## code each fixation as left, right, or away based on aoi list (hit = 1, miss = 0, away = 0.5)
aois_list <- list(l_xmin=7, l_xmax=396, l_ymin=1749, l_ymax=2044,
                  r_xmin=1289, r_xmax=1685, l_ymin=1751, l_ymax=2044)

d_final <- code_aoi_looking(d_final, aois_list = aois_list)
d_final <- code_target_looking(d_final)

## identify "response" as D, T or A, based on "hit" or "miss" or "off" at F0
d_final <- identify_responses(d_final)

## convert to wide format one trial per row, from picture on to picture off, 
## aligning each trial at critical onset (F0)
df_wide <- convert_to_wide(d_final)

## can also convert back to long format
df_long <- convert_to_long(df_wide)
```
