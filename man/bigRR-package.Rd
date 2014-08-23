\name{bigRR-package}
\alias{bigRR-package}
\docType{package}
\title{
Generalized Ridge Regression (with special advantage for p >> n cases)
}
\description{
The package fits large-scale (generalized) ridge regression for various distributions of response. The shrinkage parameters (lambdas) can be pre-specified or estimated using an internal update routine (fitting a heteroscedastic effects model, or HEM). It gives possibility to shrink any subset of parameters in the model. It has special computational advantage for the cases when the number of shrinkage parameters exceeds the number of observations. For example, the package is very useful for fitting large-scale omics data, such as high-throughput genotype data (genomics), gene expression data (transcriptomics), metabolomics data, etc.
}
\details{
\tabular{ll}{
Package: \tab bigRR\cr
Type: \tab Package\cr
Version: \tab 1.3-10\cr
Date: \tab 2014-08-23\cr
Depends: \tab R (>= 2.10.0), utils, hglm, DatABEL\cr
License: \tab GPL (>= 2)\cr
LazyLoad: \tab yes\cr
}
}
\author{
Authors: Xia Shen, Moudud Alam, Lars Ronnegard\cr
Maintainer: Xia Shen <xia.shen@ki.se>
}
\references{
Shen X, Alam M, Fikse F and Ronnegard L (2013). \bold{A novel generalized ridge regression method for quantitative genetics}. \emph{Genetics}, \bold{193}, 1255-1268.
}

