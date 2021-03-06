#' Read And Parse Tobii File
#'
#' This function allows you to read and parse a single raw tsv file generated by Tobii
#'
#' @description \code{read_tobii()} is a special case of \code{read_tsv()}. It's useful for doing minor data
#'    processing on the raw tsv file that is unique to the Language Learning Lab.
#'    If you set \code{tidy = FALSE}, the function behaves like the default \code{read_tsv()}. Note that
#'    you are able to pass along any arguments that you would use with \code{read_tsv()}.
#' @param file Either a path to a file, a connection, or literal data.
#' @param tidy A boolean, if tidy = FALSE this functions behaves just \code{read_tsv()}.
#' @param y_max An integer value indicating the largest y-coordinate in the data set. Used to create a
#'   gaze_y_cartesian column.
#' @param ... Additional arguments, typically used to control the \code{read_tsv() function}.
#' @export
#' @examples
#' \dontrun{d <- read_tobii(file = "187_Habla2_25_Clips.tsv", tidy = TRUE, y_max = 2048)}

read_tobii <- function(file, tidy = FALSE, y_max = 2048, ...) {
  if (tidy) {
    readr::read_tsv(file = file, col_types = readr::cols(.default = "c"), ...) %>%
      clean_tobii_variables(y_max = y_max) %>%
      make_tobii_trials() %>%
      add_trial_timestamps()
  } else {
    readr::read_tsv(file = file, col_types = readr::cols(.default = "c"), ...)
  }
}

clean_tobii_variables <- function(df, y_max) {
  df %>%
    dplyr::select(.data$ParticipantName,
                  .data$StudioEvent,
                  .data$MediaName,
                  .data$RecordingTimestamp,
                  tidyselect::contains("GazePoint")) %>%
    dplyr::mutate(gaze_x = .data$`GazePointX (ADCSpx)` %>% as.numeric(),
                  gaze_y = .data$`GazePointY (ADCSpx)` %>% as.numeric(),
                  RecordingTimestamp = as.integer(.data$RecordingTimestamp)) %>%
    dplyr::mutate(gaze_y_cartesian = y_max - .data$gaze_y) %>%
    dplyr::select(-.data$`GazePointX (ADCSpx)`, -.data$`GazePointY (ADCSpx)`)
}

process_trial_timestamps <- function(trial_df) {
  first_time_step <- min(trial_df$RecordingTimestamp)
  trial_df %>%
    dplyr::mutate(prev_time_stamp = dplyr::lag(.data$RecordingTimestamp, default = first_time_step),
                  time_diff = .data$RecordingTimestamp - .data$prev_time_stamp,
                  timestamp_trial = cumsum(.data$time_diff)) %>%
    dplyr::select(-.data$prev_time_stamp, -.data$time_diff)
}

add_trial_timestamps <- function(df) {
  df_nest <- df %>%
    dplyr::group_by(.data$ParticipantName, .data$trial_number) %>%
    tidyr::nest()

  df_nest <- df_nest %>%
    dplyr::mutate(trial_timestamp = purrr::map(data, process_trial_timestamps))

  tidyr::unnest(df_nest, trial_timestamp)
}

make_tobii_trials <- function(df) {
  df %>%
    dplyr::filter(!is.na(.data$MediaName),
                 !(StudioEvent %in% c("MovieStart", "MovieEnd"))) %>%
    dplyr::mutate(MediaName = clean_trial_name(MediaName),
                  trial_number = as.integer(stringr::str_extract(MediaName, "[[:digit:]]+")))
}

clean_trial_name <- function(trial_name) {
  trial_name <- stringr::str_replace(trial_name, ".avi", "")
  trial_name <- stringr::str_replace(trial_name, " ", "_")
  trial_name <- stringr::str_to_lower(trial_name)
  trial_name
}
