% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/probability_epidemic.R
\name{probability_epidemic}
\alias{probability_epidemic}
\title{Calculate the probability a disease will cause an outbreak based on R, k
and initial cases}
\usage{
probability_epidemic(
  R,
  k,
  num_init_infect,
  ind_control = 0,
  pop_control = 0,
  ...,
  offspring_dist
)
}
\arguments{
\item{R}{A \code{number} specifying the \eqn{R} parameter (i.e. average
secondary cases per infectious individual).}

\item{k}{A \code{number} specifying the  \eqn{k} parameter (i.e. dispersion in
offspring distribution from fitted negative binomial).}

\item{num_init_infect}{An \code{integer} (or at least
\href{https://rlang.r-lib.org/reference/is_integerish.html}{"integerish"} if
stored as double) specifying the number of initial infections.}

\item{ind_control}{A \code{numeric} specifying the strength of individual-level
control measures. These control measures assume that infected individuals
do not produce any secondary infections with probability \code{ind_control},
thus increasing the proportion of cases that do not create any subsequent
infections. The control measure is between \code{0} (default) and \code{1} (maximum).}

\item{pop_control}{A \code{numeric} specifying the strength of population-level
control measures that reduce the transmissibility of all cases by a
constant factor. Between \code{0} (default) and \code{1} (maximum).}

\item{...}{<\code{\link[rlang:dyn-dots]{dynamic-dots}}> Named elements to replace
default optimisation settings. Currently only \code{"fit_method"} is accepted
and can be either \code{"optim"} (default) or \code{"grid"} for numerical
optimisation routine or grid search, respectively.}

\item{offspring_dist}{An \verb{<epiparameter>} object. An S3 class for working
with epidemiological parameters/distributions, see
\code{\link[epiparameter:epiparameter]{epiparameter::epiparameter()}}.}
}
\value{
A value with the probability of a large epidemic.
}
\description{
Calculates the probability a branching process will cause an epidemic
(i.e. probability will fail to go extinct) based on R, k and initial cases.
}
\examples{
probability_epidemic(R = 1.5, k = 0.1, num_init_infect = 10)
}
\references{
Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005)
Superspreading and the effect of individual variation on disease emergence.
Nature, 438(7066), 355-359. \doi{10.1038/nature04153}

Kucharski, A. J., Russell, T. W., Diamond, C., Liu, Y., Edmunds, J.,
Funk, S. & Eggo, R. M. (2020) Early dynamics of transmission and control
of COVID-19: a mathematical modelling study. The Lancet Infectious Diseases,
20(5), 553-558. \doi{10.1016/S1473-3099(20)30144-4}
}
\seealso{
\code{\link[=probability_extinct]{probability_extinct()}}
}
