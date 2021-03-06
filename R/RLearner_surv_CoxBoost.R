#' @export
makeRLearner.surv.CoxBoost = function() {
  makeRLearnerSurv(
    cl = "surv.CoxBoost",
    package = "CoxBoost",
    par.set = makeParamSet(
      makeIntegerLearnerParam(id = "maxstepno", default = 100, lower = 0),
      makeIntegerLearnerParam(id = "K", default = 10, lower = 1),
      makeDiscreteLearnerParam(id = "type", default = "verweij", values = c("verweij", "naive")),
      makeIntegerLearnerParam(id = "stepno", default = 100L, lower = 1),
      makeNumericLearnerParam(id = "penalty", lower = 0),
      makeLogicalLearnerParam(id = "standardize", default = TRUE),
      makeDiscreteLearnerParam(id = "criterion", default = "pscore", values = c("pscore", "score", "hpscore", "hscore")),
      makeNumericLearnerParam(id = "stepsize.factor", default = 1, lower = 0),
      makeDiscreteLearnerParam(id = "sf.scheme", default = "sigmoid", values = c("sigmoid", "linear")),
      makeLogicalLearnerParam(id = "return.score", default = TRUE)
    ),
    par.vals = list(return.score = FALSE),
    properties = c("numerics", "factors", "ordered", "weights", "rcens"),
    name = "Cox Proportional Hazards Model with Componentwise Likelihood based Boosting",
    short.name = "coxboost",
    note = "Factors automatically get converted to dummy columns, ordered factors to integer"
  )
}

#' @export
trainLearner.surv.CoxBoost = function(.learner, .task, .subset, .weights = NULL, penalty = NULL, ...) {
  data = getTaskData(.task, subset = .subset, target.extra = TRUE, recode.target = "rcens")
  info = getFixDataInfo(data$data, factors.to.dummies = TRUE, ordered.to.int = TRUE)
  data$data = as.matrix(fixDataForLearner(data$data, info))

  if (is.null(penalty))
    penalty = 9 * sum(data$target[, 2L])

  attachTrainingInfo(CoxBoost::CoxBoost(
    time = data$target[, 1L],
    status = data$target[, 2L],
    x = data$data,
    weights = .weights,
    penalty = penalty,
    ...
  ), info)
}

#' @export
predictLearner.surv.CoxBoost = function(.learner, .model, .newdata, ...) {
  info = getTrainingInfo(.model)
  .newdata = as.matrix(fixDataForLearner(.newdata, info))
  if(.learner$predict.type == "response")
    as.numeric(predict(.model$learner.model, newdata = .newdata, type = "lp"))
  else
    stop("Unknown predict type")
}
