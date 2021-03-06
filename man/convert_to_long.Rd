% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert_to_long.R
\name{convert_to_long}
\alias{convert_to_long}
\title{Convert To Long Format}
\usage{
convert_to_long(df_et_wide)
}
\arguments{
\item{df_et_wide}{A data frame of eye tracking data in wide format}
}
\description{
\code{convert_to_long()} is used to convert processed Tobii data from wide to long format
}
\details{
This function converts Tobii eye tracking data from wide back to long or "tidy" format. Time bin becomes a
single column.
}
\examples{
\dontrun{d <- convert_to_long(df_et_wide)}
}
