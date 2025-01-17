% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class.R
\docType{class}
\name{penfaData-class}
\alias{penfaData-class}
\title{S4 Class for describing the input data}
\description{
The \code{penfaData} class gives information on the data set
provided in input for analysis. This class is an adaptation of the
\code{lavData} class from the
\href{https://CRAN.R-project.org/package=lavaan}{lavaan} package.
}
\section{Slots}{

\describe{
\item{\code{ngroups}}{Integer. The number of groups.}

\item{\code{group}}{Character. The observed variables defining the groups.}

\item{\code{group.label}}{Character. The group labels, that is, the values of the
\code{group} variable, if any.}

\item{\code{std.ov}}{Logical indicating whether the observed variables should be
standardized.}

\item{\code{nobs}}{List of the effective number of observations in each group.}

\item{\code{norig}}{List of the original number of observations in each group.}

\item{\code{ov.names}}{List of the observed variable names in each group.}

\item{\code{ov}}{List of details at the observed variable level.}

\item{\code{case.idx}}{List of the case (i.e., observation) indices in each group.}

\item{\code{X}}{List. Local copy of the input data set split into groups.}
}}

\examples{

data(ccdata)

syntax = 'help  =~   h1 + h2 + h3 + h4 + h5 + h6 + h7 + 0*v1 + v2 + v3 + v4 + v5
          voice =~ 0*h1 + h2 + h3 + h4 + h5 + h6 + h7 +   v1 + v2 + v3 + v4 + v5'

alasso_fit <- penfa(## factor model
                    model  = syntax,
                    data   = ccdata,
                    std.lv = TRUE,
                    ## penalization
                    pen.shrink = "alasso",
                    eta = list(shrink = c("lambda" = 0.01), diff = c("none" = 0)),
                    ## automatic procedure
                    strategy = "auto")

alasso_fit@Data
str(alasso_fit@Data)


}
\seealso{
\code{\link{penfa}}
}
