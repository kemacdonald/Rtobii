#' \code{Rtobii} package
#'
#' RTobbi for reading and process raw eyetracking data
#'
#' @docType package
#' @name Rtobii
#' @importFrom dplyr %>%
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
