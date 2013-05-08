\name{hugeRR_update}
\alias{hugeRR_update}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Updating a hugeRR fit to be a heteroscedastic effects model (HEM) fit}
\description{
  This function updates the hugeRR-obtained bigRR object into a new object with heteroscedasticity assumption.
}
\usage{
hugeRR_update(obj, Z.name, Z.index, family = gaussian(link = identity), 
              tol.err = 1e-6, tol.conv = 1e-8, save.cache = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{A \code{bigRR} object.}
  \item{Z.name}{ file name to be combined with \code{Z.index} for the design matrix associated with shrinkage parameters (i.e. random effects in the mixed model framework). The files should be in \code{DatABEL} format (see \bold{Details}).}
  \item{Z.index}{ file index/indices to be combined with \code{Z.name}. See \bold{Details}.}
  \item{family}{ the distribution family of \code{y}, see \code{help('family')} for more details.}
  \item{tol.err}{ internal tolerance level for extremely small values; default value is 1e-6.}
  \item{tol.conv}{ tolerance level in convergence; default value is 1e-8.}
  \item{save.cache}{ logical; specify whether internal cache files should be saved for fast future repeating analyses. If \code{TRUE}, some R data files will be saved in the current working directory, so that in the future, analyses involving the same cache data can substantially speed up.}
}
\details{
The function does a similar job as the \code{bigRR_update} function, but allows huge size of data (the \code{Z} matrix) that cannot be loaded into computer memory as a whole.
Instead of specifying the entire design matrix for random effects (\code{Z} in \code{bigRR}), the \code{Z} can be split as \code{Z = cbind(Z1, Z2, ..., Zk)}, and each piece of \code{Z} is stored in \code{DatABEL} format with file names specified by the arguments \code{Z.name} and \code{Z.index}.
For example (see also \bold{Examples}), if the genotype data for each chromosome is stored in \code{DatABEL} format with file names \code{chr1.fvd} & \code{chr1.fvi}, ..., \code{chr22.fvd} & \code{chr22.fvi}, the input argument should be specified as \code{Z.name = 'chr'} and \code{Z.index = 1:22}.  
}
\references{
Shen X, Alam M, Fikse F and Ronnegard L (2013). \bold{A novel generalized ridge regression method for quantitative genetics}. \emph{Genetics}, \bold{193}, 1255-1268.
}
\author{Xia Shen}

\examples{
# --------------------------------------------- #  
#              Arabidopsis example              #
# --------------------------------------------- #  
\dontrun{
require(bigRR)
data(Arabidopsis)
X <- matrix(1, length(y), 1)

# splitting the genotype data into two pieces and re-saving in DatABEL format
#
dimnames(Z) <- list(NULL, NULL)
Z <- scale(Z)
matrix2databel(Z[,1:100000], 'part1')
matrix2databel(Z[,100001:ncol(Z)], 'part2')

# fitting SNP-BLUP, i.e. a ridge regression on all the markers across the genome
#
SNP.BLUP.result <- hugeRR(y = y, X = X, Z.name = 'part', Z.index = 1:2, 
                          family = binomial(link = 'logit'), save.cache = TRUE)
                          
# re-run SNP-BLUP - a lot faster since cache data are stored
SNP.BLUP.result <- hugeRR(y = y, X = X, Z.name = 'part', Z.index = 1:2, 
                          family = binomial(link = 'logit'))

# fitting HEM, i.e. a generalized ridge regression with marker-specific shrinkage
#
HEM.result <- hugeRR_update(SNP.BLUP.result, Z.name = 'part', Z.index = 1:2, 
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
