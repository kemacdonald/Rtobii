#' Make iChart Names Match iChartAnalyzeR formatting
#'
#' This function changes the column names in the Tobii eye tracking data to match those in iChartAnalyzeR functions.
#'
#' @description \code{make_iChart_names()} is used to make column names that work for iChartAnalyzeR functions
#' @param df A data frame of eye tracking data in wide format
#' @export
#' @examples
#' \dontrun{d <- make_iChart_names(df)}

make_iChart_names <- function(df) {
  df <- df %>%
    mutate(RT = NA) %>% # create empty RT column for iChartAnalyzeR package to work
    rename(
      Sub.Num = ParticipantName,
      Months = age,
      Tr.Num = trial_number,
      L.image = left_image,
      C.image = center_image,
      R.image = right_image,
      Prescreen.Notes = prescreen_notes,
      Condition = condition,
      Response = response,
      Target.Side = target_side,
      CritOnSet = noun_onset)

  df %>% rename_time_cols()

}

## some helper functions for renaming just the timestamp columns in a wide formatted
## data frame
rename_time_cols <- function(df) {
  all_col_names <- colnames(df)
  new_time_col_names <- make_time_cols(all_col_names)
  first_timestamp_colidx <- which(str_detect(all_col_names, pattern = "[:digit:]"))[1]
  last_timestamp_colidx <- which(colnames(df) == "RT") - 1 # hacky way to find the last time column index
  colnames(df)[first_timestamp_colidx:last_timestamp_colidx] <- new_time_col_names
  df
}

make_time_cols <- function(colnames_string) {
  colnames_string %>%
    str_subset(pattern = "[:digit:]") %>%
    paste0("F", .)
}
