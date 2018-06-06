#' Plot Fixations With AOIs for PEEK Tobii Data
#'
#' This function allows you to make an exploratory plot of the Tobii .tsv eyetracking data with
#' the AOIs read from the AOI .txt file.
#'
#' @description \code{plot_fixations()} is a \code{ggplot()}.
#'    It's useful for doing a quick check that your AOIs look reasonable when plotted
#'    with the raw eyetracking data.
#' @param et_df A data frame of Tobii data, usually created by the \code{read_all_tsvs()} function.
#' @param frac_size A double indicating the fraction of rows (fixations) to plot for each participant.
#'   Useful for controlling how long the plot will take to render.
#' @param aois An AOI data frame indicating the AOI coordinates, usually this object is created
#'   by the \code{read_aois()} function.
#' @param ... Additional arguments, typically used to control the \code{read_delim() function}.
#' @export
#' @examples
#' \dontrun{plot_fixations(tsv_data, frac_size = .05, aois)}

plot_fixations <- function(et_df, frac_size = 0.05, aois, ...) {
  x1_left <- aois$coord_value[1]
  x2_left <- aois$coord_value[2]
  y1_left <- aois$coord_value[3]
  y2_left <- aois$coord_value[4]
  x1_right <- aois$coord_value[5]
  x2_right <- aois$coord_value[6]
  y1_right <- aois$coord_value[7]
  y2_right <- aois$coord_value[8]

  et_df %>%
    dplyr::group_by(ParticipantName) %>%
    dplyr::sample_frac(size = 0.05) %>%
    ggplot2::ggplot(aes(x = gaze_x, y = gaze_y_cartesian)) +
    ggplot2::labs(x = "x", y = "y") +
    ggplot2::geom_point(alpha = 0.3, size = 2) +
    ggplot2::geom_rect(aes(xmin=x1_left, xmax=x2_left,
                           ymin=y1_left, ymax=y2_left),
                       color="red", fill=NA, size = 1) +
    ggplot2::geom_rect(aes(xmin=x1_right, xmax=x2_right,
                           ymin=y1_right, ymax=y2_right),
                       color="red", fill=NA, size = 1) +
    ggplot2::facet_wrap(~ParticipantName)
}
