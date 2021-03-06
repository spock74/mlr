#' @title Result of tuning.
#'
#' @description
#' Container for results of hyperparameter tuning.
#' Contains the obtained point in search space, its performance values
#' and the optimization path which lead there.
#'
#' Object members:
#' \describe{
#' \item{learner [\code{\link{Learner}}]}{Learner that was optimized.}
#' \item{control [\code{\link{TuneControl}}]}{Control object from tuning.}
#' \item{x [\code{list}]}{Named list of hyperparameter values identified as optimal.
#'   Note that when you have trafos on some of your params, \code{x} will always be
#'   on the TRANSFORMED scale so you directly use it.}
#' \item{y [\code{numeric}]}{Performance values for optimal \code{x}.}
#' \item{opt.path [\code{\link[ParamHelpers]{OptPath}}]}{Optimization path which lead to \code{x}.
#'   Note that when you have trafos on some of your params, the opt.path always contains the
#'   UNTRANSFORMED values on the original scale. You can simply call \code{trafoOptPath(opt.path)} to
#'   transform them, or, \code{as.data.frame{trafoOptPath(opt.path)}}}
#' }
#' @name TuneResult
#' @rdname TuneResult
NULL
makeTuneResult = function(learner, control, x, y, opt.path) {
  makeOptResult(learner, control, x, y, opt.path, "TuneResult")
}

makeTuneResultFromOptPath = function(learner, par.set, measures, control, opt.path) {
  i = getOptPathBestIndex(opt.path, measureAggrName(measures[[1]]), ties = "random")
  e = getOptPathEl(opt.path, i)
  x = trafoValue(par.set, e$x)
  x = removeMissingValues(x)
  makeTuneResult(learner, control, x, e$y, opt.path)
}


#'@export
print.TuneResult = function(x, ...) {
  catf("Tune result:")
  catf("Op. pars: %s", paramValueToString(x$opt.path$par.set, x$x))
  catf("%s", perfsToString(x$y))
}
