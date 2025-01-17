% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/penfa.R
\name{penfa}
\alias{penfa}
\title{Single- and multiple-group penalized factor analysis}
\usage{
penfa(
  model = NULL,
  data = NULL,
  group = NULL,
  pen.shrink = "alasso",
  pen.diff = "none",
  eta = list(shrink = c(lambda = 0.01), diff = c(none = 0)),
  strategy = "auto",
  ...
)
}
\arguments{
\item{model}{A description of a user-specified model. It takes the form of a
lavaan-like model syntax. See below for additional details on how to
specify a model syntax.}

\item{data}{A data frame containing the (continuous) observed variables used
in the model. Except for the \code{group} variable, all variables are
treated as numeric.}

\item{group}{Character. An optional variable name in the data frame defining
the groups in a multiple-group analysis.}

\item{pen.shrink}{Character. The type of penalty function used for shrinking
a subset of the model parameters (see the \code{eta} argument for details
on how to specify which model parameters shall be penalized). Possible
values for \code{pen.shrink} are "lasso", "alasso" (i.e., adaptive lasso),
"scad" (i.e., smoothly clipped absolute deviation), "mcp" (i.e., minimax
concave penalty), "ridge", and "none" in case of no shrinkage penalization.}

\item{pen.diff}{Character. The type of penalty function used for shrinking
certain parameter differences across groups, and thus encouraging parameter
equivalence across groups (see the \code{eta} argument for details on how
to specify which model parameters shall be encouraged to be equivalent).
Possible values for \code{pen.diff} are "lasso", "alasso" (i.e., adaptive
lasso), "scad" (i.e., smoothly clipped  absolute deviation), "mcp" (i.e.,
minimax concave penalty), "ridge", and "none" in case of no difference
penalization. Note that the specification of \code{pen.diff} is only valid
for multiple-group factor analyses when a \code{group} variable is defined.
If a difference penalty is requested, the groups must have the same
parameters.}

\item{eta}{A named list containing the starting value(s) of the tuning
parameter(s) if the automatic procedure is requested (\code{strategy =
  "auto"}) or the fixed value(s) of the tuning parameter(s) to be used during
optimization if \code{strategy = "fixed"}. The list has two components with
names "shrink" and "diff", which refer to the tuning parameters to be used
for shrinkage and group equivalence, respectively. The components of the
list are, in turn, named vectors specifying the type of parameter matrices
or vectors to be penalized. Common choices are "lambda" for the loading
matrix and "tau" for the intercept vector of the observed variables. Other
possible values are "phi" for the factor covariance matrix, "psi" for the
covariance matrix of the unique factors, and "kappa" for the factor means.
All non-fixed elements of the specified matrix/vector are penalized. When
\code{strategy = "fixed"} and the tuning values in \code{eta} are equal to
zero, specifying both list names as "none" results in ordinary maximum
likelihood estimation (no penalization).}

\item{strategy}{Character. The strategy used for the selection of the tuning
parameter(s). If \code{strategy = "auto"}, the optimal values of the tuning
parameters are determined via an automatic tuning parameter procedure; if
\code{strategy = "fixed"}, a penalized factor model with the values of the
tuning parameters stored in the option \code{eta} is estimated.}

\item{...}{Additional options that can be defined using \code{name =
"value"}. For a complete list, please refer to \code{\link{penfaOptions}}.}
}
\value{
An object of class \code{\linkS4class{penfa}}, for which several
methods are available. See the manual pages of \code{summary,penfa-method},
\code{show,penfa-method}, \code{coef,penfa-method}, and
\code{fitted,penfa-method} for details.
}
\description{
The function \code{penfa} fits single- and multiple-group
\emph{PENalized Factor Analysis} models via a trust-region algorithm with
integrated automatic multiple tuning parameter selection.

In a single-group analysis, \code{penfa} can automatically shrink a subset
of the factor loadings to zero. In a multiple-group analysis, it can
encourage sparse loading matrices and invariant factor loadings and
intercepts. The currently supported penalty functions are lasso, adaptive
lasso, scad, mcp, and ridge. Except for the latter, all penalties can
achieve sparsity.
}
\section{Data set vs Sample Moments}{
The \code{penfa} function currently takes as input a data set, as opposed to
the sample moments (i.e., covariance matrices and mean vectors). Future
implementations will allow \code{penfa} to additionally take as input sample
covariance matrices and sample means. For now, if only sample moments are
available, users can generate multivariate data from those sample moments,
and apply the \code{penfa} function on the generated data.  \cr All variables
(except for the \code{group} variable in multiple-group analyses) are treated
as continuous. \cr Categorical items are not currently supported. \cr
}

\section{Model syntax}{
The model syntax in the \code{model} argument describes the factor analysis
model to be estimated, and specifies the relationships between the observed
and latent variables (i.e., the common factors). To facilitate its
formulation, the rules for the syntax specification broadly follow the ones in
the \href{https://CRAN.R-project.org/package=lavaan}{\code{lavaan}} package.

The model syntax is composed of one or multiple formula-like expressions
describing specific parts of the model. The model syntax can be specified as
a literal string enclosed by single quotes as in the example below.

\preformatted{model_syntax <- '
                # Common factors
                factor1 =~ x1 + x2 + x3 + x4 + x5 + x6
                factor2 =~ x1 + x2 + x3 + x4 + x5 + x6

                # Factor variances and covariances
                factor1 ~~ factor1
                factor1 ~~ factor2

                # Unique variances and covariances
                x1 ~~ x1
                x1 ~~ x2

                # Intercepts and factor means
                x1 ~ 1
                factor1 ~ 1
                '
}
Blank lines and comments can be used in between formulas, and formulas can be
split over multiple lines. Multiple formulas can be placed on
a single line if they are separated by a semicolon (;).

The current implementation allows for the following types of formula-like
expressions in the model syntax: \enumerate{ \item Common factors: The
\code{"=~"} operator can be used to define the continuous common factors
(latent variables). The name of the factor (e.g., factor1) is on the left of
the \code{"=~"} operator, whereas the terms on the right (e.g., \code{x1 + x2
+ x3 + x4 + x5 + x6}), separated by \code{"+"} operators, are the indicators
of the factor. The operator \code{"=~"} can be read as "is measured by".

\item Variances and covariances: The \code{"~~"} ("double tilde") operator
specifies the (residual) variance of an observed or latent variable, or a set
of covariances between one variable, and several other variables (either
observed or latent). The distinction between variances and residual variances
is made automatically. Covariances between unique factors are currently only
allowed when \code{information = "fisher"}.

\item Intercepts and factor means: We can specify an intercept for an
observed variable (\code{x1 ~ 1}) or a common factor (\code{factor1 ~ 1}).
The variable name appears on the left of the \code{"~"} operator. On the
right-hand side, there is the number "1", which stands for the
intercept/mean. Including an intercept/mean formula in the model
automatically implies \code{meanstructure = TRUE}. The distinction between
observed variable intercepts and factor means is made automatically.

}

Usually, only a single variable name appears on the left side of an operator.
However, if multiple variable names are specified, separated by the "+"
operator, the formula is repeated for each element on the left side. For
instance, the formula

\preformatted{
 x1 + x2 + x3 + x4 ~ 1}

specifies an intercept for variables \code{x1, x2, x3} and \code{x4}.

On the right-hand side of these formula-like expressions, each element can be
modified (using the \code{"*"} operator) by a numeric constant or the special
function start(). This provides the user with a mechanism to fix
parameters and provide alternative starting values, respectively. All
\code{"*"} expressions are referred to as modifiers, and are explained in
detail in the sections below.

Each parameter in a model is automatically given a name consisting of three
parts, that are coerced to a single character vector. The first part is the
name of the variable on the left-hand side of the formula where the parameter
is implied. The middle part is based on the special "operator" used in the
formula (e.g., \code{"=~"}, \code{"~"} or \code{"~~"}). The third part is the
name of the variable on the right-hand side of the formula where the
parameter is implied, or "1" if it is an intercept. The three parts are
pasted together in a single string. For example, the name of the factor
loading of \code{x2} on \code{factor1} is the string \code{"factor1~x2"}.
The name of the parameter corresponding to the factor covariance between
\code{factor1} and \code{factor2} is the string \code{"factor1~~factor2"}.
\subsection{Fixing parameters}{

It is often desirable to fix a model parameter that is otherwise (by default)
estimated. Any parameter in a model can be fixed by using a modifier
resulting in a numerical constant. For instance:

\itemize{

\item Fixing factor loadings for scale setting or identification
restrictions:

\preformatted{
factor1 ~ 0.8*x1 + x2 + x3 +   0*x4 + x5 + x6
factor2 ~   0*x1 + x2 + x3 + 0.8*x4 + x5 + x6}

\item Specifying an orthogonal (zero) covariance between two factors:

\preformatted{factor1 ~~ 0*factor2}

}

Notice that multiplying a certain parameter by \code{NA} forces it to be
estimated.
}

\subsection{Starting values}{

User-defined starting values can be provided through the special function
start(), containing a numeric constant. For instance, the formula below
provides a starting value equal to 0.8 to the loading of \code{x2} on
\code{factor1}.

\preformatted{
factor1 ~ x1 + start(0.8)*x2 + x3 + x4 + x5 + x6}
}

\subsection{Multiple groups}{

In a multiple group factor analysis, the modifiers containing a single element
should be replaced by a vector of the same length as the number of groups.
If a single element is provided, it is used for all groups. In the
example below with two groups, the factor loadings of \code{x1} on
\code{factor1} are fixed to 0.8 in both groups, whereas the factor loadings
of \code{x4} are fixed to 0.75 and 0.85 in the first and second group,
respectively.

\preformatted{
multigroup_syntax <- '
 factor1 ~  0.8*x1 + x2 + x3 +               x4 + x5 + x6
 factor2 ~      x1 + x2 + x3 + c(0.75, 0.85)*x4 + x5 + x6 '}
}
}

\section{Algorithm}{
Penalized factor analysis allows to produce parsimonious models using largely
an automated procedure. The use of sparsity-inducing penalty functions leads
to optimally sparse factor structures supported by the data. The resulting
models are less prone to instability in the estimation process and are easier
to interpret and generalize than their unpenalized counterparts.
Multiple-group penalized factor analysis can be used to automatically
ascertain the differences and similarities of parameter estimates across
groups.

In \code{penfa}, estimation is achieved via a penalized likelihood-based
framework that builds upon differentiable approximations of
non-differentiable penalties, a theoretically founded definition of degrees
of freedom, and an algorithm with automatic multiple tuning parameter
selection (see section below for details).

The \code{penfa} function uses a
\href{https://CRAN.R-project.org/package=trust}{\code{trust-region}}
algorithm approach. This strategy constructs a model function whose behavior
near the current point and within a trust-region (usually a ball) is similar
to that of the actual objective function. The algorithm exploits second-order
analytical derivative information. This can come in the form of the penalized
Hessian matrix (if \code{information = "hessian"}) or the penalized Fisher
information matrix (if \code{information = "fisher"}). Models with a
mean structure can be only estimated with the penalized Fisher information
matrix, which exhibits similar performances to the penalized Hessian at a
reduced computational cost. \cr
}

\section{Tuning parameter selection}{
The selection of the tuning parameters is a crucial issue in penalized
estimation strategies, as the tuning parameters are responsible for the
optimal balance between goodness of fit and sparsity.
\subsection{Automatic procedure}{

The penalized framework discussed above is easily integrated with automatic
multiple tuning parameter selection (if \code{strategy = "auto"}). The tuning
parameters are chosen to minimize an approximate AIC. See below for
additional details on how to introduce more sparsity, if desired. The
automatic procedure is fast, efficient, and scales well with the number of
tuning parameters. It also eliminates the need for time-consuming and
computationally intensive grid-searches.

\strong{Note:} Only lasso, adaptive lasso and ridge penalties can be used
with the automatic procedure.

The automatic procedure returns the optimal value of the tuning parameter.
Notice, however, that the parameter estimates from this model will slightly
differ from the ones one would obtain by setting \code{strategy = "fixed"} and
\code{eta} equal to that optimal tuning value. This is due to the different
starting values employed in the two scenarios. In the automatic procedure,
the starting values of the final model come from the ones of the previous
model in the optimization loop; in the fixed-tuning context, the starting
values come from the default ones in \code{penfa}.
}

\subsection{Grid-search}{

If \code{strategy = "fixed"}, \code{penfa} estimates a penalized factor model
with the value of the tuning parameter stored in \code{eta}. This is useful
if users wish to make multiple calls to the \code{penfa} function using a
range of values for the tuning parameter. Then, the optimal penalized model
can be picked on the basis of information criteria, which are easily computed
by calling the \code{AIC} and \code{BIC} functions. It is often convenient
to use the (Generalized) Bayesian Information Criterion as a selector, due to
its recurrent use in sparse settings.

These information criteria use the theoretical definition of the effective
degrees of freedom (\emph{edf}) as their bias terms. This is because the use
of differentiable penalty approximations make the objective function
twice-continuously differentiable. The total \code{edf} are as the sum of the
effective degree of freedom for each model parameter, which in turn ranges
from 0 to 1 and quantifies the extend to which each parameter has been
penalized. \cr
}
}

\section{Penalization}{
The \code{penfa} function penalizes every element in the parameter
matrix/vector specified in the \code{eta} argument. For instance, if
\code{eta = list("shrink" = c("lambda" = 0.01), "diff" = c("none" = 0))} all
factor loadings are penalized through a shrinkage penalty.
\subsection{Choosing the penalty function}{

It may be beneficial to try out different penalties, and see which one works
best for the problem at hand. It is also useful to keep the following in mind:
\itemize{
\item \strong{Shrinkage}: lasso, alasso, scad, and mcp are able to shrink parameters
to zero, contrarily to the ridge penalty whose purpose is just regularizing
the estimation process.
\item \strong{Unbiasedness}: alasso, scad, and mcp enjoy the so-called "oracle"
property. On the contrary, the lasso is biased since it applies the same
penalization to all parameters.
\item \strong{Automatic procedure:} only lasso, alasso, and ridge are supported by the
automatic procedure. This means that these penalties are a convenient choice
with all the analyses requiring multiple penalty terms (e.g., multiple-group
analyses), for which the automatic procedure is the only feasible alternative
to otherwise computationally intensive multi-dimensional grid-searches.
}

Geminiani, Marra, and Moustaki (2021) performed numerical and
empirical examples to evaluate and compare the performance of single- and
multiple-group penalized factor models under different penalty functions. The
alasso penalty generally produced the best trade-off between sparsity and
goodness of fit. However, unlike other penalties, the alasso requires a set
of adaptive weights. In some situations, the weights might not be available,
or might be difficult to obtain. If this is the case, users are encouraged to
resort to simpler penalties. \cr
}

\subsection{More sparsity}{

The penalized model automatically tries to generate the optimal trade-off
between goodness of fit and model complexity (if \code{strategy = "auto"}).
As a result of this delicate balance, it may not provide the sparsest factor
solution. If users desire more sparsity, they can follow the guidelines
below.

\itemize{

\item Influence factor: increase the value of the influence factor stored in
the option \code{gamma}. As a rule of thumb, in our experience, common values
for obtaining sparse solutions usually range between 3.5 and 4.5.

\item Penalties: some penalties rely on a second tuning parameter. It may be
helpful to try out different values for it, and see which one performs best.
For instance, increasing the value or the exponent of the alasso (by
specifying, for instance, \code{a.alasso = 2}) leads to sparser solutions. }

In case users fitted a penalized model with a fixed tuning parameter
(\code{strategy = "fixed"}), they can manually and subjectively increase its
value in the option \code{eta} to encourage more sparsity. When doing so, it
is helpful to first do some trials and understand a reasonable range of
values that the tuning parameter can take. \cr
}

\subsection{Ordinary Maximum Likelihood}{

If \code{strategy = "fixed"}, \code{pen.shrink = "none"}, \code{pen.diff =
"none"}, and \code{eta = list("shrink" = c("none" = 0), "diff" = c("none" =
0))}, no penalization is applied, and the model is estimated through ordinary
maximum likelihood. \cr
}
}

\section{Convergence & Admissibility}{
The function \code{penfa} internally assesses the convergence of the fitted
model, and the admissibility of the final solution.
\subsection{Convergence}{

The convergence checks assess whether the penalized gradient vector is close
to zero and the penalized Hessian/Fisher information matrix is positive
definite. In case of convergence issues, \code{penfa} warns the users with
explanatory messages. \cr \strong{Note:} Due to the presence of possibly
multiple penalty terms, our experiments highlighted that the penalized
gradient need not be strictly close to zero to obtain meaningful results. It
is enough that its elements do not exceed a pre-specified threshold, whose
value can be changed through the \code{optim.dx.tol} option.
}

\subsection{Admissibility}{

The admissibility checks are carried out to determine whether the final
solution is \emph{admissible}. Specifically, the \code{penfa} function
sequentially checks whether:
\enumerate{

\item The final model includes any negative unique variances (Heywood cases);
\item The final model includes any negative factor variances;
\item The estimated common factor covariance matrix is positive definite;
\item The estimated unique factor covariance matrix is positive definite;
\item The estimated factor loading matrix is of full column rank;
\item The estimated factor loading matrix does not contain any null rows.
}

In case of multiple-group analyses, the function checks the admissibility of
the parameter matrices of each group. If any of the above conditions are not
satisfied, the \code{penfa} function warns the user with explanatory
messages on the reasons why. \cr
}
}

\section{Warnings & Errors}{
Occasionally the \code{penfa} function may print out warnings or produce
errors. If the errors concern convergence issues, it may be helpful to go
through the following steps:

\enumerate{ \item Identification: please make sure that at least the
minimum identification restrictions are satisfied. This implies fixing the
scale and the origin of every factor in each group. In addition, other
constraints - which usually come in the form of zero-restricted loadings -
are necessary due to rotational freedom.
\item Starting values: the choice of the starting values is of paramount
importance when it comes to convergence. The starting values internally used
by \code{penfa} correspond to the ones used by the
\href{https://CRAN.R-project.org/package=lavaan}{\code{lavaan}} package for
\code{confirmatory factor analysis}. If users have some prior knowledge or
intuition about possible values for some of the parameters, it might be
beneficial to include this information by providing the starting values for
those parameters in the syntax specification (see below for additional
details). For instance, depending on the case, specifying the starting values
of the primary loadings equal to 1 (\code{start(1)*x1 + ...}) often results
in more stable optimization processes, especially when dealing with
complicated models that require the estimation of many parameters, as in
multiple-group penalized factor analysis.
\item Sample size: the penalized models fitted by \code{penfa} have
a larger number of parameters than confirmatory factor analytic applications.
This complexity should be accompanied by a reasonable sample size. If the
sample size is too small for the complexity of the model, convergence issues
will arise. In case of small sample sizes, it might in principle be more
reliable to select the tuning parameter through a grid-search with the GBIC
instead of using the automatic procedure.
\item Automatic procedure: if the starting values of the tuning parameters
prevent the automatic procedure from finding the optimal estimates of the
tuning parameters, the procedure is repeated with different starting values.
If this fails, an error is printed out.
\item Adaptive weights: when using the alasso penalty, it is suggested to
manually provide a vector of adaptive weights, especially for complex models.
The adaptive weights often come in the form of (unpenalized) maximum
likelihood estimates. If no vector of weights is provided, the \code{penfa}
function internally estimates an unpenalized MLE model whose parameter
estimates will serve as weights. If the unpenalized model does not converge,
the \code{penfa} function internally estimates a ridge-regularized factor
model and uses the resulting estimates as weights. If even this estimation
fails, an error is printed out. \cr

}

Ultimately, if none of the above succeeds, users shall consider re-specifying
the model, either by simplifying the hypothesized factor structure or
considering a subset of the observed variables. Increasing the number of
restrictions (for instance, by specifying some additional fixed loadings)
might be advantageous. Also, as a general practice, when conducting a
multiple-group analysis, make sure beforehand that the groups share similar
factor structures: if the groups have different factor configurations, the
final results will be distorted.

It is always important to assess whether the distributional assumptions of
the normal linear factor model hold. The \code{penfa} function fits penalized
factor models to continuous observed variables; this excludes categorical
items or items with a few number of categories that would instead require
tailored approaches that specifically take into account the qualitative
nature of the data. \cr
}

\section{Standard Errors}{
The standard errors are derived from the inverse of the penalized Fisher
information matrix (if \code{information = "fisher"}) or penalized Hessian
(if \code{information = "hessian"}), which relies on the Bayesian result for
the covariance matrix of the estimated parameters. The implemented framework
allows to have a standard error for every model parameter. However, users
should take extra caution when using the standard errors associated with the
penalized parameters that were shrunken to zero. \cr
}

\section{Vignettes and Tutorials}{
To learn more about \code{penfa}, start with the vignettes and tutorials at
\code{browseVignettes(package = "penfa")} and
\url{https://egeminiani.github.io/penfa/articles/}.
}

\examples{

data(ccdata)

### Single-group analysis (no mean-structure, unit factor variances)
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
                    strategy = "auto",
                    gamma = 4)



### Multiple-group analysis (mean structure, marker-variable approach, starting values)
syntax_mg = '
help  =~ 1*h1 +          h2 +          h3 + h4 + h5 + h6 + h7 + 0*v1 + v2 + v3 + v4 + v5
voice =~ 0*h1 + start(0)*h2 + start(0)*h3 + h4 + h5 + h6 + h7 + 1*v1 + v2 + v3 + v4 + v5
h1 + v1 ~ 0*1 '

# Compute weights for alasso from unpenalized model
mle_fitMG <- penfa(model = syntax_mg,
                   data  = ccdata,
                   group = "country",
                   int.ov.free = TRUE,
                   int.lv.free = TRUE,
                   pen.shrink = "none",
                   pen.diff = "none",
                   eta = list(shrink = c("lambda" = 0), diff = c("none" = 0)),
                   strategy = "fixed")
mle_weightsMG <- coef(mle_fitMG)

# Fit model
alasso_fitMG <- penfa(## factor model
                      model = syntax_mg,
                      data = ccdata,
                      group = "country",
                      int.ov.free = TRUE,
                      int.lv.free = TRUE,
                      ## penalization
                      pen.shrink = "alasso",
                      pen.diff = "alasso",
                      eta = list(shrink = c("lambda" = 0.01),
                      diff = c("lambda" = 0.1, "tau" = 0.01)),
                      ## automatic procedure
                      strategy = "auto",
                      gamma = 4,
                      ## alasso
                      weights = mle_weightsMG)

### For additional examples, see the vignettes and tutorials at
### browseVignettes(package = "penfa") and https://egeminiani.github.io/penfa/articles/


}
\references{
Geminiani, E., Marra, G., & Moustaki, I. (2021). "Single- and Multiple-Group
Penalized Factor Analysis: A Trust-Region Algorithm Approach with Integrated
Automatic Multiple Tuning Parameter Selection." Psychometrika, 86(1), 65-95.
\doi{10.1007/s11336-021-09751-8}

Geminiani E. (2020), "A penalized likelihood-based framework for single and
multiple-group factor analysis models" (Doctoral dissertation, University of
Bologna). Available at \url{http://amsdottorato.unibo.it/9355/}.
}
\seealso{
\code{\link{penfa-class}}
}
\author{
Elena Geminiani \email{geminianielena@gmail.com}.
}
