#' Code Responses For Each Trial
#'
#' This function identifies each trial "response" as D, T or A, based on "hit" or "miss" or "off" at F0.
#'
#' @description \code{identify_responses()} is used to code looking behavior based on user-specified AOIs for
#'  Tobii eyetracking data
#' @param df_et A data frame of eye tracking data
#' @export
#' @examples
#' \dontrun{d <- identify_responses(df_et)}

identify_responses <- function(df_et) {
  d_response <- df_et %>%
    dplyr::filter(.data$time_bin == 0) %>%
    dplyr::mutate(response = case_when(
      target_looking == 1 ~ "T",
      target_looking == 0 ~ "D",
      target_looking == 0.5 ~ "A"
    )) %>%
    dplyr::select(ParticipantName, trial_number, response)

  df_et %>% left_join(d_response)
}
