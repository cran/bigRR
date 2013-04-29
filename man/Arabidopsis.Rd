\name{Arabidopsis}
\docType{data}
\alias{Arabidopsis}
\title{Arabidopsis thaliana data set from Atwell et al. 2010 \emph{Nature}}
\description{
The \sQuote{Arabidopsis} data contains a binary disease-related phenotype of Arabidopsis and an incidence matrix of genotypes from a 250K SNP chip. 
}
\format{ The \sQuote{Arabidopsis} data set contains a phenotype vector \code{y} and a genotype matrix \code{Z}:
 \describe{
 \item{y}{Binary vector of phenotype \emph{AvrRpm1} for 84 inbred lines. See Atwell et al. 2010 \emph{Nature} for details.}
 \item{Z}{A 84 times 216100 matrix of genotypes of the 84 inbred lines, with two different homozygotes coded as -1 and 1. 30 SNPs in the original data set that are fixed to only one homozygotic genotype were removed.}
}
}
\source{Atwell, S., Y. S. Huang, B. J. Vilhjalmsson, G. Willems, M. Horton, et al., 2010. Genome-wide association study of 107 phenotypes in Arabidopsis thaliana inbred lines. \emph{Nature} 465: 627-631.}
\references{Atwell, S., Y. S. Huang, B. J. Vilhjalmsson, G. Willems, M. Horton, et al., 2010. Genome-wide association study of 107 phenotypes in Arabidopsis thaliana inbred lines. \emph{Nature} 465: 627-631.}
\keyword{datasets}