% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class.R
\docType{class}
\name{penfaPenalty-class}
\alias{penfaPenalty-class}
\title{S4 Class for describing the penalization process}
\description{
The \code{penfaPenalty} class provides information on the
penalization process, such as the user-specified penalty functions, the
optimal values of the tuning parameters, and the penalty matrices at
convergence.
}
\section{Slots}{

\describe{
\item{\code{strategy}}{Character. The strategy used for the selection of the tuning
parameter(s). If \code{strategy = "auto"}, the optimal values of the tuning
parameters are determined via the automatic tuning parameter procedure; if
\code{strategy = "fixed"}, a penalized factor model with the values of the
tuning parameters stored in the option \code{eta} is estimated.}

\item{\code{penalty}}{List. A list of the user-specified penalty functions for
sparsity ("shrink") and parameter equivalence ("diff").}

\item{\code{tuning}}{List. A named list containing the optimal values of the tuning
parameter(s) if \code{strategy = "auto"} or the user-specified fixed
values of the tuning parameter(s) if \code{strategy = "fixed"}. The list
has two components with names "shrink" and "diff", and refers to the tuning
parameters used for shrinkage and group equivalence, respectively. The
components of the list are, in turn, the named vectors specifying the type
of parameter matrices or vectors that were penalized.}

\item{\code{pmat}}{List. A named list containing the names of the parameter matrices
and vectors that were penalized for sparsity ("shrink") and/or group
equivalence ("diff").}

\item{\code{pen.idx}}{List. A named list with the indices of the parameters that were
penalized for sparsity ("shrink") and/or group equivalence ("diff").}

\item{\code{Sh.info}}{List. A list of the penalization terms, vectors and matrices
evaluated at the optimal values of the tuning parameters. In particular,
its argument \code{S.h} returns the estimated penalty matrix. If the factor
model is penalized only through a shrinkage penalty (i.e.,
\code{pen.shrink} is not \code{'none'}), and there is no penalization on
the differences (i.e., \code{pen.diff = 'none'}), then \code{S.h} is a
diagonal matrix whose elements precisely quantify the extent to which each
model parameter has been penalized.}

\item{\code{extra}}{List. A list possibly containing additional information on the
penalization process, such as the hyperparameter values for some penalty
functions (e.g., for the alasso, the value of the exponent and the adaptive
weights.)}

\item{\code{automatic}}{List. If \code{strategy = "auto"}, it contains information on
the automatic multiple tuning parameter procedure, such as the optimal
values of the tuning parameters, the convergence status, the specified
value of the influence factor, the number of necessary iterations, and the
tolerance level.}
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

alasso_fit@Penalize

str(alasso_fit@Penalize)

}
\seealso{
\code{\link{penfa}}
}
