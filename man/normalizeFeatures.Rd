% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/normalizeFeatures.R
\name{normalizeFeatures}
\alias{normalizeFeatures}
\title{Normalize features}
\usage{
normalizeFeatures(task, method = "standardize", exclude = character(0L),
  range = c(0, 1))
}
\arguments{
\item{task}{[\code{\link{Task}}]\cr
The task.}

\item{method}{[\code{character(1)}]\cr
Normalizing method.\cr
Available are:\cr
\dQuote{center}: centering of each feature\cr
\dQuote{scale}: scaling of each feature\cr
\dQuote{standardize}: centering and scaling\cr
\dQuote{range}: Scale the data to a given range.\cr}

\item{exclude}{[\code{character}]\cr
Names of the columns to exclude.
The target does not have to be included here.
Default is none.}

\item{range}{[\code{numeric(2)}]\cr
Range the features should be scaled to. Default is \code{c(0,1)}.}
}
\value{
[\code{\link{Task}}].
}
\description{
Normalize features by different methods. Internally \code{\link{normalize}} is used.
Non numerical features will be left untouched and passed to the result.
}
\seealso{
Other eda_and_preprocess: \code{\link{capLargeValues}};
  \code{\link{createDummyFeatures}};
  \code{\link{dropFeatures}};
  \code{\link{mergeSmallFactorLevels}};
  \code{\link{removeConstantFeatures}};
  \code{\link{summarizeColumns}}
}

