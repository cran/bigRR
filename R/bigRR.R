bigRR <-
function(formula = NULL, y = NULL, X = NULL, Z = NULL, data = NULL, shrink = NULL, weight = NULL,
		family = gaussian(link = identity), lambda = NULL, impute = FALSE, tol.err = 1e-6, 
		tol.conv = 1e-8, only.estimates = FALSE, GPU = FALSE, ...) UseMethod("bigRR")

.onAttach <- 
		function(...)
{
	packageStartupMessage('\n')
	packageStartupMessage("bigRR: Fast generalized ridge regression for p >> n data")
	packageStartupMessage('Version 1.3-6 installed')
	packageStartupMessage('Authors:    Xia Shen - xia.shen@slu.se')
	packageStartupMessage('            Moudud Alam - maa@du.se')
	packageStartupMessage('            Lars Ronnegard - lrn@du.se')
	packageStartupMessage('Maintainer: Xia Shen - xia.shen@slu.se')
	packageStartupMessage('Use citation("bigRR") to know how to cite our work.')
	packageStartupMessage('\n\n')
	packageStartupMessage('!! NOTE !! The bigRR.update() function in bigRR <= 1.3-4 is now bigRR_update().')
	packageStartupMessage('           Please replace in all your old source code.')
	packageStartupMessage('!! NOTE !! The GPU option is only available and maintained in the R-Forge versions of "bigRR".')
	options(warn = -1)
}