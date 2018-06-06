#' Read And Parse PEEK Trial Timing File
#'
#' This function allows you to read and parse a single raw timing file generated
#' by human coders marking key points in the trial
#' @description \code{read_timing_file()} is a special case of \code{read_delm()}.
#'    It's useful for converting the \code{00:01:22} (min, sec, frames) format
#'    to milliseconds for each key event in the trial (e.g., Sound On, Noun On, etc.)
#'    If you set \code{tidy = FALSE}, the function behaves like the default \code{read_delim()}.
#'    Note that you are able to pass along any arguments that you would use with \code{read_delim()}.
#' @param file Either a path to a file, a connection, or literal data.
#' @param tidy A boolean, if \code{tidy = FALSE} this functions behaves just \code{read_delim()}.
#' @param fps An double indicating the frame rate used when making the timing file.
#' @param ... Additional arguments, typically used to control the \code{read_tsv() function}.
#' @export
#' @examples
#' \dontrun{d <- read_order_file(file = "Habla2_25_Clips_order.txt", tidy = TRUE)}


read_timing_file <- function(file, tidy = TRUE, fps = 29.97, ...) {
  if(tidy) {
    d_timing <- read_delim(file, delim = '\t')
    names(d_timing) <- names(d_timing) %>% make.names(unique = TRUE)
    names(d_timing) <- stringr::str_replace(names(d_timing), "[:punct:]", "_") %>% stringr::str_to_lower()
    # # convert 01:02:22 format (minutes, seconds, frames) to milliseconds for each landmark
    d_timing %>%
      split(.$trial) %>%
      purrr::map_df(compute_onsets_trial) %>%
      dplyr::rename(trial_number = trial)
  } else {
    readr::read_delim(time_path, delim = '\t')
  }
}

compute_onsets_trial <- function(trial_df, fps = 29.97) {
  ms_in_sec <- 1000
  trial_df %>%
    dplyr::select(-pic_on) %>%
    tidyr::gather(key = landmark_type, value = time, sound_on:pic_off, -trial) %>%
    tidyr::separate(col = time,
                    into = c("min", "sec", "frames"),
                    sep = ":") %>%
    dplyr::mutate(time_ms = (as.integer(sec) * ms_in_sec) + (as.integer(frames) * fps)) %>%
    dplyr::arrange(time_ms)
}
