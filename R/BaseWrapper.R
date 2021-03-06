makeBaseWrapper = function(id, next.learner, package = character(0L), par.set = makeParamSet(),
  par.vals = list(), learner.subclass, model.subclass) {

  if (inherits(next.learner, "OptWrapper"))
    stop("Cannot wrap an optimization wrapper with something else!")
  ns = intersect(names(par.set$pars), names(next.learner$par.set$pars))
  if (length(ns) > 0L)
    stopf("Hyperparameter names in wrapper clash with base learner names: %s", collapse(ns))

  makeS3Obj(c(learner.subclass, "BaseWrapper", "Learner"),
    id = id,
    type = next.learner$type,
    predict.type = next.learner$predict.type,
    package = union(package, next.learner$package),
    par.set = par.set,
    par.vals = par.vals,
    properties = next.learner$properties,
    fix.factors = FALSE,
    next.learner = next.learner,
    model.subclass = model.subclass
  )
}

#' @export
print.BaseWrapper = function(x, ...) {
  s = ""
  y = x
  while (inherits(y, "BaseWrapper")) {
    s = paste(s, class(y)[1L], "->", sep = "")
    y = y$next.learner
  }
  s = paste(s, class(y)[1L])
  print.Learner(x)
}


# trainLearner:
# trainLearner.BaggingWrapper = function(.learner, .task, .subset, .weights = NULL, ...)
# trainLearner is not implemented here, as no concrete code makes sense for this abstract base method.
# One word wrt. hyper pars and the "..." varargs in inheriting methods:
# train calls trainLearner, then passes ALL par.vals from all wrapped learner layers to "...".
# In trainLearner.MyWrapper the params that are of interest are usually bound by name.
# Then in trainLearner.MyWrapper usually "train" is called for next.learner.
# This does not accept "..." and we do not pass "..." down any further.
# But we do not need to do this, as the settings of learner$next.learner are
# contained in next.learner$par.vals.


#' @export
predictLearner.BaseWrapper = function(.learner, .model, .newdata, ...) {
  args = removeFromDots(names(.learner$par.vals), ...)
  do.call(predictLearner, c(
    list(.learner = .learner$next.learner, .model = .model$learner.model$next.model, .newdata = .newdata),
    args)
  )
}

#' @export
makeWrappedModel.BaseWrapper = function(learner, learner.model, task.desc, subset, features, factor.levels, time) {
  x = NextMethod()
  addClasses(x, c(learner$model.subclass, "BaseWrapperModel"))
}

##############################           BaseWrapperModel                 ##############################

#' @export
isFailureModel.BaseWrapperModel = function(model) {
  return(isFailureModel(model$learner.model$next.model))
}

#' @export
getFailureModelMsg.BaseWrapperModel = function(model) {
  return(getFailureModelMsg(model$learner.model$next.model))
}


