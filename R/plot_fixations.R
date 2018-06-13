#' Plot Fixations With AOIs for PEEK Tobii Data
#'
#' This function allows you to make an exploratory plot of the Tobii .tsv eyetracking data with
#' the AOIs read from the AOI .txt file.
#'
#' @description \code{plot_fixations()} is a \code{ggplot()}.
#'    It's useful for doing a quick check that your AOIs look reasonable when plotted
#'    with the raw eyetracking data.
#' @param df_et A data frame of Tobii data, usually created by the \code{read_tobii()} function.
#' @param frac_size A double indicating the fraction of rows (fixations) to plot for each participant.
#'   Useful for controlling how long the plot will take to render.
#' @param aois_list A named list of AOI coordinates with the structure:
#'   \code{aois_list <- list(l_xmin=7, l_xmax=396, l_ymin=1749, l_ymax=2044, r_xmin=1289, r_xmax=1685, l_ymin=1751, l_ymax=2044)}
#' @param ... Additional arguments, typically used to pass along to ggplot.
#' @export
#' @examples
#' \dontrun{plot_fixations(df_et, frac_size = .05, aois_list)}

plot_fixations <- function(df_et, frac_size = 0.05, aois_list, ...) {
  df_et %>%
    dplyr::group_by(ParticipantName) %>%
    dplyr::sample_frac(size = frac_size) %>%
    ggplot2::ggplot(aes(x = gaze_x, y = gaze_y_cartesian)) +
    ggplot2::labs(x = "x", y = "y") +
    ggplot2::geom_point(alpha = 0.3, size = 2) +
    ggplot2::geom_rect(aes(xmin=aois_list$l_xmin, xmax=aois_list$l_xmax,
                           ymin=aois_list$l_ymin, ymax=aois_list$l_ymax),
                       color="red", fill=NA, size = 1) +
    ggplot2::geom_rect(aes(xmin=aois_list$r_xmin, xmax=aois_list$r_xmax,
                           ymin=aois_list$r_ymin, ymax=aois_list$r_ymax),
                       color="red", fill=NA, size = 1) +
    ggplot2::facet_wrap(~ParticipantName)
}
