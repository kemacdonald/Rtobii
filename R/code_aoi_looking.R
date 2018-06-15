#' Code AOI Looking
#'
#' This function scores each look as left, right, away based on gaze coordinates (gaze_x and gaze_y_cartesian).
#'
#' @description \code{code_aoi_looking()} is used to code looking behavior based on user-specified AOIs for
#'  Tobii eyetracking data
#' @param df_et A data frame of eye tracking data
#' @param aois_list A names list of AOI values of the following format.
#'   \code{aois_list <- list(l_xmin=7, l_xmax=396, l_ymin=1749, l_ymax=2044, r_xmin=1289, r_xmax=1685, l_ymin=1751, l_ymax=2044)}
#' @export
#' @examples
#' \dontrun{d <- code_aoi_looking(df_et, aois_list = aois)}

code_aoi_looking <- function(df_et, aois_list) {
  df_et %>%
    mutate(aoi_looking = dplyr::case_when(
      gaze_x >= aois_list$l_xmin & gaze_x <= aois_list$l_xmax & gaze_y_cartesian >= aois_list$l_ymin & gaze_y_cartesian <= aois_list$l_ymax ~ "left",
      gaze_x >= aois_list$r_xmin & gaze_x <= aois_list$r_xmax & gaze_y_cartesian >= aois_list$r_ymin & gaze_y_cartesian <= aois_list$r_ymax ~ "right",
      TRUE ~ "away"
    ))
}
