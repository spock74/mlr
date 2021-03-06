context("regr_cforest")

test_that("regr_cforest", {
  library(party)
  parset.list = list(
    list(),
    list(control = cforest_unbiased(mtry = 2)),
    list(control = cforest_unbiased(ntree = 1000))
  )
  parset.list2 = list(
    list(),
    list(mtry = 2),
    list(ntree = 1000)
  )
  
  old.predicts.list = list()
  
  for (i in 1:length(parset.list)) {
    parset = parset.list[[i]]
    pars = list(regr.formula, data=regr.train)
    pars = c(pars, parset)
    set.seed(getOption("mlr.debug.seed"))
    m = do.call(cforest, pars)
    set.seed(getOption("mlr.debug.seed"))
    old.predicts.list[[i]] = as.vector(predict(m, newdata = regr.test))
  }
  
  testSimpleParsets("regr.cforest", regr.df, regr.target, regr.train.inds, old.predicts.list, parset.list2)
})
