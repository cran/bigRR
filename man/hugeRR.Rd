\name{hugeRR}
\alias{hugeRR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Fitting big ridge regression}
\description{
  Function fits big ridge regression with special computational advantage for the cases when number of shrinkage parameters exceeds number of observations. The shrinkage parameter, lambda, can be pre-specified or estimated along with the model. Any subset of model parameter can be shrunk.   

}
\usage{
hugeRR(y, X, Z.name, Z.index, weight = NULL, family = gaussian(link = identity), 
       lambda = NULL, only.estimates = FALSE, tol.err = 1e-6, tol.conv = 1e-8, 
       save.cache = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{ the vector of response variable.}
  \item{X}{ the design matrix related to the parameters not to be shrunk (i.e. fixed effects in the mixed model framework).}
  \item{Z.name}{ file name to be combined with \code{Z.index} for the design matrix associated with shrinkage parameters (i.e. random effects in the mixed model framework). The files should be in \code{DatABEL} format (see \bold{Details}).}
  \item{Z.index}{ file index/indices to be combined with \code{Z.name}. See \bold{Details}.}
  \item{family}{ the distribution family of \code{y}, see \code{help('family')} for more details.}
  \item{weight}{ a vector of prior weights for each of the shrinkage parameters.}
  \item{lambda}{ the shrinkage parameter determines the amount of shrinkage. Default is \code{NULL} meaning that it is to be estimated along with other model parameters. }
  \item{only.estimates}{logical; \code{TRUE} if hat values are to be returned. Default is \code{FALSE} and the hat values are not returned.}
  \item{tol.err}{ internal tolerance level for extremely small values; default value is 1e-6.}
  \item{tol.conv}{ tolerance level in convergence; default value is 1e-8.}
  \item{save.cache}{ logical; specify whether internal cache files should be saved for fast future repeating analyses. If \code{TRUE}, some R data files will be saved in the current working directory, so that in the future, analyses involving the same cache data can substantially speed up.}
  \item{\dots}{ unused arguments. }
}
\details{
The function does the same job as the \code{bigRR} function, but allows huge size of data (the \code{Z} matrix) that cannot be loaded into computer memory as a whole.
Instead of specifying the entire design matrix for random effects (\code{Z} in \code{bigRR}), the \code{Z} can be split as \code{Z = cbind(Z1, Z2, ..., Zk)}, and each piece of \code{Z} is stored in \code{DatABEL} format with file names specified by the arguments \code{Z.name} and \code{Z.index}.
For example (see also \bold{Examples}), if the genotype data for each chromosome is stored in \code{DatABEL} format with file names \code{chr1.fvd} & \code{chr1.fvi}, ..., \code{chr22.fvd} & \code{chr22.fvi}, the input argument should be specified as \code{Z.name = 'chr'} and \code{Z.index = 1:22}.  
}
\value{
  Returns a list of object class \code{bigRR} containing the following values: (see \bold{Examples} for how to use the estimated parameters for a prediction purpose.) 
 
  \item{phi}{estimated residual variance (Non-genetic variance component).}
  \item{lambda}{estimated random effect variance (Genetic variance component). which is proportional to the usual \code{lambda} parameter of the ridge regression representing the amount of shrinkage.}
  \item{beta}{fixed effects estimates - subset of model parameters which is/are not shrunk, i.e. those associated with the \code{X} matrix.}
  \item{u}{random effects estimates (genetic effects of each marker) - subset of model parameters which are shrunk, i.e. those associated with the \code{Z} matrix.}
  \item{leverage}{hat values for the random effects.}
  \item{hglm}{the internal fitted \code{hglm} object for the linear mixed model.}
  \item{Call}{how the bigRR was called.}
}
\references{
Shen X, Alam M, Fikse F and Ronnegard L (2013). \bold{A novel generalized ridge regression method for quantitative genetics}. \emph{Genetics}, \bold{193}, 1255-1268.\cr

Ronnegard L, Shen X and Alam M (2010): \bold{hglm: A Package for Fitting Hierarchical Generalized Linear Models}. \emph{The R Journal}, \bold{2}(2), 20-28.
}
\author{Xia Shen}

\seealso{\code{lm.ridge} in MASS library.}

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

