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

```r
library(Rtobii)
library(tidyverse)
theme_set(theme_minimal())

# root of data directory
root_data_path <- "~/Desktop/tobii_to_ichart_test/Cohort5_ClipsMovies"

# set up file paths
timing_path <- file.path(root_data_path, "processing/Habla2_25_Clips/Habla2_25_Clips_timing.txt")
tsv_dir <- file.path(root_data_path, "tsv")
vcx_path <- file.path(root_data_path, "vcx")
aoi_path <- file.path(root_data_path, "processing/Habla2_25_Clips/Habla2_25_Clips_aoi.txt")
order_path <- file.path(root_data_path, "processing/Habla2_25_Clips/Habla2_25_Clips_order.txt")

## read input files
d_tsv <- read_all_tsvs(tsv_dir, tidy = TRUE, y_max = 2048)
aois <- read_aois(aoi_path, tidy = T)
d_meta <- read_order_file(order_path)
d_vcx <- read_all_vcx(vcx_path)
d_timing <- read_timing_file(timing_path)

####### START PULLING IT ALL TOGETHER #################

## fixations plot with AOIs to see how things look
plot_fixations(d_tsv, frac_size = .05, aois)

## merge meta and ps info with eyetracking data
d_final <- d_tsv %>% left_join(d_meta, by = c("trial_number"))

## filter unused trials
d_final <- d_final %>% filter(used == "yes")

## add time from noun onset
d_final <- add_time_crit_onset(d_final, d_timing, onset_type = "noun")

## code each fixation as left, right, or away based on aoi file

## identify "response" as D, T or A, based on "hit" or "miss" or "off" at F0;

## convert to wide format one trial per row, from picture on to picture off,
# aligning each trial at critical onset (F0);
```
