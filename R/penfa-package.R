#' penfa: Single- and Multiple-Group Penalized Factor Analysis
#'
#' The \code{penfa} package (a short form for *PENalized Factor Analysis*) provides
#' several routines for single- and multiple-group penalized factor analysis for
#' continuous data. The models are estimated via a trust-region algorithm with
#' integrated automatic multiple tuning parameter selection. The available
#' penalties include lasso, adaptive lasso, scad, mcp, and ridge. \cr\cr
#' The main function of the package is \code{\link{penfa}}. To learn more about
#' it, start with the vignettes and tutorials at \code{browseVignettes(package = "penfa")} and
#' [https://egeminiani.github.io/penfa/articles/](https://egeminiani.github.io/penfa/articles/).
#'
#'
#' @details
#'
#' Penalized factor analysis allows to produce parsimonious models using largely
#' an automated procedure. In the single-group case, a typical penalty function
#' will automatically shrink a subset of the factor loadings to zero. The use of
#' sparsity-inducing penalty functions leads to optimally sparse factor
#' structures supported by the data. The resulting models are less prone to
#' instability in the estimation process and are easier to interpret and
#' generalize than their unpenalized counterparts.
#'
#' In the multiple-group scenario, penalized factor analysis can be used to
#' automatically ascertain differences and similarities of parameter
#' estimates across groups. Typical penalties will automatically encourage
#' sparse loading matrices and invariant factor loadings and intercepts.
#'
#' In \code{penfa}, estimation is achieved via a penalized likelihood-based
#' framework that builds upon differentiable approximations of
#' non-differentiable penalties, a theoretically founded definition of degrees
#' of freedom, and an algorithm with integrated automatic multiple tuning
#' parameter selection. The estimation is based on a trust-region algorithm
#' approach exploiting second-order analytical derivative information. The
#' standard errors for the model parameters are derived using a Bayesian
#' approach.
#'
#' The selection of the tuning parameters is a crucial issue in penalized
#' estimation strategies, as the tuning parameters are responsible for the
#' optimal balance between goodness of fit and sparsity. In \code{penfa}, the
#' optimal values of the tuning parameters can be determined through the
#' automatic procedure or grid-searches.
#'
#' In addition to the fitting function \code{\link{penfa}}, the package provides
#' several methods for examining the parameter estimates, monitoring
#' the optimization process, and inspecting the structures of the penalty
#' matrices through interactive visualizations.
#'
#'
#' @author
#'
#' Authors: Elena Geminiani, Giampiero Marra, Irini Moustaki
#'
#' Maintainer: Elena Geminiani. Please address any query or comment to
#' \email{geminianielena@@gmail.com}.
#'
#'
#'
#' @references
#'
#' Geminiani, E., Marra, G., & Moustaki, I. (2021). "Single- and Multiple-Group
#' Penalized Factor Analysis: A Trust-Region Algorithm Approach with Integrated
#' Automatic Multiple Tuning Parameter Selection." Psychometrika, 86(1), 65-95.
#' \doi{10.1007/s11336-021-09751-8}
#'
#' Geminiani E. (2020), "A penalized likelihood-based framework for single and
#' multiple-group factor analysis models" (Doctoral dissertation, University of
#' Bologna). Available at \url{http://amsdottorato.unibo.it/9355/}.
#'
#'
#' @seealso \code{\link{penfa}}, \code{\link{penfa-class}}
#'
#'
#' @docType package
#' @name penfa-package
NULL


#' @importFrom methods new is .hasSlot setClass setGeneric setRefClass setMethod
#'   show
#' @importFrom stats as.formula coef complete.cases cov fitted na.omit qnorm var
#'  logLik
#' @importFrom utils combn modifyList packageDescription packageVersion read.csv
#'   str write.table
#' @importFrom grDevices colorRampPalette
NULL

