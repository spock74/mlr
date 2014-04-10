#' @S3method makeRLearner classif.rrlda
makeRLearner.classif.rrlda = function() {
  makeRLearnerClassif(
    cl = "classif.rrlda",
    package = "rrlda",
    par.set = makeParamSet(
      makeNumericVectorLearnerParam(id="prior", len=NA_integer_),
      makeNumericLearnerParam(id="lambda", default=0.5, lower=0),
      makeNumericLearnerParam(id="hp", default=0.75, lower=0),
      makeIntegerLearnerParam(id="nssamples", default=30L, lower=1L),
      makeIntegerLearnerParam(id="maxit", default=50L, lower=1L),
      makeDiscreteLearnerParam(id="penalty", default="L2", values=c("L1", "L2"))  
    ),
    twoclass = TRUE,
    multiclass = TRUE,
    missings = FALSE,
    numerics = TRUE,
    factors = FALSE,
    prob = FALSE,
    weights = FALSE
  )
}

#' @S3method trainLearner classif.rrlda
trainLearner.classif.rrlda = function(.learner, .task, .subset, .weights,  ...) {
  d = getTaskData(.task, .subset, target.extra=TRUE)
  rrlda(x=d$data, grouping=d$target, ...)
}

#' @S3method predictLearner classif.rrlda
predictLearner.classif.rrlda = function(.learner, .model, .newdata, ...) {
  p = as.factor(predict(.model$learner.model, x=.newdata, ...)$class)
}