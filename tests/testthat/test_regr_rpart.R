context("regr_rpart")

test_that("regr_rpart", {
  library(rpart)
  parset.list = list(
    list(),
    list(minsplit=10, cp=0.005),
    list(minsplit=50, cp=0.05),
    list(minsplit=50, cp=0.999),
    list(minsplit=1, cp=0.0005)
  )
  
  old.predicts.list = list()
  old.probs.list = list()
  
  for (i in 1:length(parset.list)) {
    parset = parset.list[[i]]
    pars = list(formula=regr.formula, data=regr.train)
    pars = c(pars, parset)
    set.seed(getOption("mlr.debug.seed"))
    m = do.call(rpart, pars)
    p  = predict(m, newdata=regr.test)
    old.predicts.list[[i]] = p
  }
  
  testSimpleParsets("regr.rpart", regr.df, regr.target, regr.train.inds, old.predicts.list, parset.list)
  
  tt = "rpart"
  tp = function(model, newdata) predict(model, newdata)
  
  testCVParsets("regr.rpart", regr.df, regr.target, tune.train=tt, tune.predict=tp, parset.list=parset.list)
})

