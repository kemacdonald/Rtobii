#' Add Critical Onset Values And Compute Relative Time In Trial
#'
#' This function allows you to add critical onsets (sound on, noun on) to Tobii eyetracking data
#' based on timing coded in an external timing file.
#'
#' @description \code{add_time_crit_onset()} is used to add time relative to critical points
#'  in each trial. The two critical points include: sound and noun.
#' @param df_et A data frame of eye tracking data
#' @param df_timing A data frame of trial timing information
#' @param onset_type A string indicating the type of onset to compute ("sound" or "noun").
#' @export
#' @examples
#' \dontrun{d <- add_time_crit_onset(df_et, d_timing, onset_type = "noun")}
#'

add_time_crit_onset <- function(df_et, df_timing, onset_type = "noun") {
  if(onset_type == "noun") {
    onsets <- df_timing %>%
      dplyr::filter(landmark_type == "noun_on", !is.na(.data$time_ms)) %>%
      dplyr::select(trial_number, time_ms) %>%
      dplyr::rename(noun_onset = time_ms)

    df_et %>%
      dplyr::left_join(onsets, by = "trial_number") %>%
      dplyr::mutate(timestamp_trial_noun_on = timestamp_trial - noun_onset)

  } else if (onset_type == "sound") {
    onsets <- df_timing %>%
      dplyr::filter(landmark_type == "sound_on", !is.na(time_ms)) %>%
      dplyr::select(trial_number, time_ms) %>%
      dplyr::rename(sound_onset = time_ms)

    df_et %>%
      dplyr::left_join(onsets, by = "trial_number") %>%
      dplyr::mutate(timestamp_trial_sound_on = timestamp_trial - sound_onset)
  }
}
