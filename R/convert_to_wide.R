#' Convert From Long To Wide Format
#'
#' This function converts Tobii eye tracking data from long to wide format where time bins become columns and each
#' row is a trial.
#'
#' @description \code{convert_to_wide()} is used to convert processed Tobii data from long to wide format
#' @param df_et_long A data frame of eye tracking data in long format
#' @export
#' @examples
#' \dontrun{d <- convert_to_wide(df_et_long)}

convert_to_wide <- function(df_et_long) {
  df_wide <- df_et_long %>%
    dplyr::select(ParticipantName, trial_number, trialonset:noun_onset, response, time_bin, target_looking) %>%
    tidyr::spread(time_bin, target_looking)
}
