#' Code Target Looking
#'
#' This function scores each look as left, right, away based on gaze coordinates (gaze_x and gaze_y_cartesian).
#'
#' @description \code{code_target_looking()} is used to add 1, 0, 0.5 codes (hits, misses, aways) to looking behavior bins for Tobii eyetracking data
#' @param df_et A data frame of eye tracking data with looks that have been
#'   coded as left, right, away by \code{code_aoi_looking()} function.
#' @export
#' @examples
#' \dontrun{d <- code_target_looking(df_et, aois_list = aois)}

code_target_looking <- function(df_et) {
  df_et %>%
    dplyr::mutate(target_looking = case_when(
      aoi_looking == "left" & target_side == "l" ~ 1,
      aoi_looking == "right" & target_side == "r" ~ 1,
      aoi_looking == "away" ~ 0.5,
      TRUE ~ 0
    ))
}
