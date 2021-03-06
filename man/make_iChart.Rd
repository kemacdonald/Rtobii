% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_iChart.R
\name{make_iChart}
\alias{make_iChart}
\title{Process And Make Tobii iChart}
\usage{
make_iChart(df_et, df_metadata, df_prescreen, df_timing, aois_list,
  make_wide = TRUE, make_iChart_names = TRUE)
}
\arguments{
\item{df_et}{A data frame of Tobii eye tracking data in long format. Typically generated by \code{read_tobii()} function.}

\item{df_metadata}{A data frame of PEEK metadata. Typically generated by \code{read_order()} function.}

\item{df_prescreen}{A data frame of PEEK prescreening information Typically generated by \code{read_vcx()} function.}

\item{df_timing}{A data frame of PEEK noun onset timing information. Typically generated by \code{read_timing_file()} function.}

\item{aois_list}{A data frame of AOI information. Typically generated by \code{read_aois()} function.}

\item{make_wide}{A boolean indicating whether you want to return a wide or long formatted iChart.}

\item{make_iChart_names}{A boolean indicating whether you want to return column names specifically
formatted for the functions in iChartAnalyzeR package.}
}
\description{
\code{make_iChart()} is a wrapper function for the sequence of functions that
  take raw Tobii eyetracking data and converts it to a wide format
  that plays nicely with the Language Learning Lab's RScripts.
}
\examples{
  \dontrun{d <- make_iChart(df_et, df_metadata, df_prescreen, df_timing,
  aois_list, make_wide = TRUE, make_iChart_names = TRUE)}
}
