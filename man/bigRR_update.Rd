\name{bigRR_update}
\alias{bigRR_update}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Updating a bigRR fit to be a heteroscedastic effects model (HEM) fit}
\description{
  This function updates the obtained bigRR object into a new object with heteroscedasticity assumption.
}
\usage{
bigRR_update(obj, Z, family = gaussian(link = identity), 
             tol.err = 1e-6, tol.conv = 1e-8, GPU = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{A \code{bigRR} object.}
  \item{Z}{The design matrix for the shrinkage/random effects.}
  \item{family}{ the distribution family of \code{y}, see \code{help('family')} for more details.}
  \item{tol.err}{ internal tolerance level for extremely small values; default value is 1e-6.}
  \item{tol.conv}{ tolerance level in convergence; default value is 1e-8.}
  \item{GPU}{ logical; specify whether GPU should be used in computation. Note that: 1. this option is only available in the R-Forge versions of \code{bigRR}; 2. the package \code{gputools} is required in this case, and the computer's graphic card needs to be CUDA-enabled. Check e.g. NVIDIA website for more information.}
}
\details{
 See the reference paper for details.
}
\references{
Shen X, Alam M, Fikse F and Ronnegard L (2013). \bold{A novel generalized ridge regression method for quantitative genetics}. \emph{Genetics}, \bold{193}, 1255-1268.
}
\author{Xia Shen, Lars Ronnegard}

\examples{
# --------------------------------------------- #  
#              Arabidopsis example              #
# --------------------------------------------- #  

require(bigRR)
data(Arabidopsis)
X <- matrix(1, length(y), 1)

\dontrun{
# fitting SNP-BLUP, i.e. a ridge regression on all the markers across the genome
#
SNP.BLUP.result <- bigRR(y = y, X = X, Z = scale(Z), 
                         family = binomial(link = 'logit'))

# fitting HEM, i.e. a generalized ridge regression with marker-specific shrinkage
#
HEM.result <- bigRR_update(SNP.BLUP.result, scale(Z), 
                           family = binomial(link = 'logit'))

# plot and compare the estimated effects from both methods
#
split.screen(c(1, 2))
split.screen(c(2, 1), screen = 1)
screen(3); plot(abs(SNP.BLUP.result$u), cex = .6, col = 'slateblue')
screen(4); plot(abs(HEM.result$u), cex = .6, col = 'olivedrab')
screen(2); plot(abs(SNP.BLUP.result$u), abs(HEM.result$u), cex = .6, pch = 19, 
                col = 'darkmagenta')

# create a random new genotypes for 10 individuals with the same number of markers 
# and predict the outcome using the fitted HEM
#
Z.new <- matrix(sample(c(-1, 1), 10*ncol(Z), TRUE), 10)
y.predict <- as.numeric(HEM.result$beta + Z.new \%*\% HEM.result$u)
#
# NOTE: The above prediction may not be good due to the scaling in the HEM 
#       fitting above, and alternatively, one can either remove the scaling 
#       above or scale Z.new by row-binding it with the original Z matrix.
}
}

