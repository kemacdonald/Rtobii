#' Convert To Long Format
#'
#' This function converts Tobii eye tracking data from wide back to long or "tidy" format. Time bin becomes a
#' single column.
#'
#' @description \code{convert_to_long()} is used to convert processed Tobii data from wide to long format
#' @param df_et_wide A data frame of eye tracking data in wide format
#' @export
#' @examples
#' \dontrun{d <- convert_to_long(df_et_wide)}

convert_to_long <- function(df_et_wide) {
  df_et_wide %>%
    gather(key = time_bin, value = target_looking, -ParticipantName:-response) %>%
    filter(!(is.na(target_looking)))
}
