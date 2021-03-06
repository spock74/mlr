context("regr_blackboost")

test_that("regr_blackboost", {
  library(mboost)
  library(party)
  parset.list1 = list(
			list(family=GaussReg(), tree_controls=ctree_control(maxdepth=2)),
			list(family=GaussReg(), tree_controls=ctree_control(maxdepth=4), control=boost_control(nu=0.03))
	)
	
	parset.list2 = list(
			list(family=Gaussian(), maxdepth=2),
			list(family=Gaussian(), maxdepth=4, nu=0.03)
	)
	
	old.predicts.list = list()
	
	for (i in 1:length(parset.list1)) {
		parset = parset.list1[[i]]
		pars = list(regr.formula, data=regr.train)
		pars = c(pars, parset)
		set.seed(getOption("mlr.debug.seed"))
		m = do.call(blackboost, pars)
		set.seed(getOption("mlr.debug.seed"))
		old.predicts.list[[i]] = predict(m, newdata=regr.test)[,1]
	}
	
	testSimpleParsets("regr.blackboost", regr.df, regr.target, regr.train.inds, old.predicts.list, parset.list2)
})
