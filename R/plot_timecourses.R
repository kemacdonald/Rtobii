#' Plot Timecourses of Raw Looking Behavior For PEEK Tobii Data
#'
#' This function allows you to make an exploratory plot of the timecourse looking from
#' Tobii .tsv eyetracking data
#'
#' @description \code{plot_timecourses()} is a \code{ggplot()}.
#'    It's useful for doing a quick check that your timecourse looking data appear reasonable
#' @param df_et A data frame of Tobii data, usually created by the \code{read_tobii()} function.
#' @param n_subs An integer indicating the number of subjects to include in the plot
#' @param n_trials An integer indicating the number of trials to include in the plot
#' @param ... Additional arguments.
#' @export
#' @examples
#' \dontrun{plot_timecourses(tsv_data, n_subs = 3, n_trials = 3)}

plot_timecourses <- function(df_et, n_subs = 3, n_trials = 3) {
  subs <- base::sample(df_et$ParticipantName %>% unique(), size = n_subs)
  trials <- base::sample(df_et$trial_number %>% unique(), size = n_trials)

  df_et %>%
    dplyr::filter(trial_number %in% trials, ParticipantName %in% subs) %>%
    ggplot2::ggplot(aes(x = time_bin, y = gaze_x, color = as.factor(target_looking))) +
    ggplot2::geom_point() +
    ggplot2::labs(x = "time bin (ms)", y = "x coordinate", color = "target looking") +
    ggplot2::geom_vline(xintercept = 0, color = "red", lty = "dashed") +
    ggplot2::facet_grid(trial_number~ParticipantName) +
    ggplot2::theme_bw()
}
