\name{bigRR}
\alias{bigRR}
\alias{bigRR.default}
\alias{bigRR.formula}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Fitting big ridge regression}
\description{
  Function fits big ridge regression with special computational advantage for the cases when number of shrinkage parameters exceeds number of observations. The shrinkage parameter, lambda, can be pre-specified or estimated along with the model. Any subset of model parameter can be shrunk.   

}
\usage{
bigRR(formula = NULL, y = NULL, X = NULL, Z = NULL, data = NULL, 
      shrink = NULL, weight = NULL, family = gaussian(link = identity), 
      lambda = NULL, impute = FALSE, tol.err = 1e-6, tol.conv = 1e-8, 
      only.estimates = FALSE, GPU = FALSE, ...)
\method{bigRR}{default}(formula = NULL, y , X , Z , data = NULL, 
      shrink = NULL, weight = NULL, family = gaussian(link = identity), 
      lambda = NULL, impute = FALSE, tol.err = 1e-6, tol.conv = 1e-8, 
      only.estimates = FALSE, GPU = FALSE, ...)
\method{bigRR}{formula}(formula = NULL, y = NULL, X = NULL, Z = NULL, data = NULL, 
      shrink = NULL, weight = NULL, family = gaussian(link = identity), 
      lambda = NULL, impute = FALSE, tol.err = 1e-6, tol.conv = 1e-8, 
      only.estimates = FALSE, GPU = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula}{ a two-sided model \code{formula}. However, matrix input is recommended since it makes the inputs clear, i.e. to define \code{y}, \code{X} and \code{Z}.}
  \item{y}{ response variable; either y or \code{formula} is to be used.}
  \item{X}{ design matrix related to the parameters not to be shrunk (i.e. fixed effects in the mixed model framework); not required if formula is already used.}
  \item{Z}{ design matrix associated with shrinkage parameters (i.e. random effects in the mixed model framework); not required if model formula is used.}
  \item{data}{ the data frame, usually useful when the input is in \code{formula}.}
  \item{shrink}{ either a numeric or a character vector specifying the position or the names if the variables whose coefficients are to be shrunk.}
  \item{weight}{ a vector of prior weights for each of the shrinkage parameters.}
  \item{family}{ the distribution family of \code{y}, see \code{help('family')} for more details.}
  \item{lambda}{ the shrinkage parameter determines the amount of shrinkage. Default is \code{NULL} meaning that it is to be estimated along with other model parameters. }
  \item{impute}{ logical; specify whether missing values (genotypes) should be imputed (see \bold{Details}).}
  \item{tol.err}{ internal tolerance level for extremely small values; default value is 1e-6.}
  \item{tol.conv}{ tolerance level in convergence; default value is 1e-8.}
  \item{only.estimates}{logical; \code{TRUE} if hat values are to be returned. Default is \code{FALSE} and the hat values are not returned.}
  \item{GPU}{ logical; specify whether GPU should be used in computation. Note that: 1. this option is only available in the R-Forge versions of \code{bigRR}; 2. the package \code{gputools} is required in this case, and the computer's graphic card needs to be CUDA-enabled. Check e.g. NVIDIA website for more information.}
  \item{\dots}{ unused arguments }
}
\details{
The function fits ridge regression (Shen et al. 2013) using the random effects model algorithm presented in Ronnegard et al. (2010). The computational intensity of the estimation depends on the number of parameters but not the number of observations.\cr \cr
The model can be specified by using \code{formula} or by design matrices. If both are used then the formula interface will be used. The shrink argument specifies the subset of parameters  to be estimated. If the model is specified by using formula and a dot (.) is used in the right hand side of the formula then \code{shrink} indicates the variables in the data frame. Otherwise it represents the respective variable in the model formula. It is ignored it model is specified by using design matrices.\cr \cr
When \code{impute = TRUE}, an easy (naive) way is used to impute the missing values in the \code{Z} matrix, i.e. missing values in each column is filled in by sampling from the distribution determined by the non-missing values. Note that observations with missing values in the response vector \code{y} are simply removed from the analysis.
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
\author{Xia Shen, Moudud Alam, Lars Ronnegard}

\seealso{\code{lm.ridge} in MASS library.}

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

