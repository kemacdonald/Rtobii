#' Add Time Bins Relative to Noun Onset
#'
#' This function allows you to add time bins for Tobii eyetracking data. This function ensures
#' that the timestamps will be similar across participants and trials.
#'
#' @description \code{add_time_bins()} is used to add time bins to Tobii eyetracking data
#' @param df_et A data frame of eye tracking data
#' @export
#' @examples
#' \dontrun{d <- add_time_bins(df_et)}

# this function handles the splitting and nesting of the trial level data
add_time_bins <- function(df_et) {
  d_nest <- df_et %>% dplyr::group_by(.data$ParticipantName, .data$trial_number) %>% tidyr::nest()
  d_nest <- d_nest %>%
    dplyr::mutate(trial_time_bins = purrr::map(data, create_time_bins_trial))

  tidyr::unnest(d_nest, trial_time_bins)
}

# this function takes a trial level data frame and
# computes the timebins relative to noun onset
create_time_bins_trial <- function(df_trial) {
  # split trial into two phases (pre and post noun onset)
  d_neg <- df_trial %>% dplyr::filter(timestamp_trial_noun_on < 0)
  d_pos <- df_trial %>% dplyr::filter(timestamp_trial_noun_on >= 0)
  # create timebins relative to F0 -- note that there is some variability in the tracker timestamps (16 vs. 17 ms)
  d_pos_final <- d_pos %>%
    dplyr::mutate(prev_time = dplyr::lag(timestamp_trial_noun_on, default = 0),
           time_diff = timestamp_trial_noun_on - prev_time,
           time_bin = dplyr::case_when(
             timestamp_trial_noun_on == min(timestamp_trial_noun_on) ~ 0,
             TRUE ~ 17),
           time_bin = cumsum(time_bin))

  d_neg_final <- d_neg %>%
    dplyr::mutate(prev_time = dplyr::lag(timestamp_trial_noun_on,
                                         default = min(timestamp_trial_noun_on)),
                  time_diff = timestamp_trial_noun_on - prev_time,
                  time_bin = case_when(
                    timestamp_trial_noun_on == max(timestamp_trial_noun_on) ~ -17,
                    TRUE ~ -17)) %>%
    dplyr::filter(time_diff > 10 | time_diff %in% c(0, 16, 17)) %>%
    dplyr::arrange(desc(timestamp_trial_noun_on)) %>%
    dplyr::mutate(time_bin = cumsum(time_bin)) %>%
    dplyr::arrange(time_bin)

  # bring the dataframes back together; final version should remove the intermediate time columns
  dplyr::bind_rows(d_neg_final, d_pos_final)# %>% select(-time_diff, -prev_time)
}
