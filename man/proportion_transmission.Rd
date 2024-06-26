% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proportion_transmission.R
\name{proportion_transmission}
\alias{proportion_transmission}
\title{Estimate what proportion of cases cause a certain proportion of
transmission}
\usage{
proportion_transmission(
  R,
  k,
  percent_transmission,
  simulate = FALSE,
  ...,
  offspring_dist,
  format_prop = TRUE
)
}
\arguments{
\item{R}{A \code{number} specifying the R parameter (i.e. average secondary cases
per infectious individual).}

\item{k}{A \code{number} specifying the  k parameter (i.e. overdispersion in
offspring distribution from fitted negative binomial).}

\item{percent_transmission}{A \code{number} of the percentage transmission
for which a proportion of cases has produced.}

\item{simulate}{A \code{logical} whether the calculation should be done
numerically (i.e. simulate secondary contacts) or analytically. Default is
\code{FALSE} which uses the analytical calculation.}

\item{...}{\link{dots} not used, extra arguments supplied will cause a warning.}

\item{offspring_dist}{An \verb{<epidist>} object. An S3 class for working with
epidemiological parameters/distributions, see \code{\link[epiparameter:epidist]{epiparameter::epidist()}}.}

\item{format_prop}{A \code{logical} determining whether the proportion column
of the \verb{<data.frame>} returned by the function is formatted as a string with
a percentage sign (\verb{\%}), (\code{TRUE}, default), or as a \code{numeric} (\code{FALSE}).}
}
\value{
A \verb{<data.frame>} with the value for the proportion of cases for a
given value of R and k.
}
\description{
Calculates the proportion of cases that cause a certain
percentage of transmission.

It is commonly estimated what proportion of cases cause 80\% of transmission
(i.e. secondary cases).
This can be calculated using \code{proportion_transmission()} at varying values of
\eqn{R} and for different values of percentage transmission.
}
\details{
Multiple values of R and k can be supplied and a \verb{<data.frame>} of
every combination of these will be returned.

The numerical calculation uses random number generation to simulate secondary
contacts so the answers may minimally vary between calls. The number of
simulation replicates is fixed to \code{1e5}.
}
\examples{
# example of single values of R and k
percent_transmission <- 0.8 # 80\% of transmission
R <- 2
k <- 0.5
proportion_transmission(
  R = R,
  k = k,
  percent_transmission = percent_transmission
)

# example with multiple values of k
k <- c(0.1, 0.2, 0.3, 0.4, 0.5, 1)
proportion_transmission(
  R = R,
  k = k,
  percent_transmission = percent_transmission
)

# example with vectors of R and k
R <- c(1, 2, 3)
proportion_transmission(
  R = R,
  k = k,
  percent_transmission = percent_transmission
)
}
\references{
The analytical calculation is from:

Endo, A., Abbott, S., Kucharski, A. J., & Funk, S. (2020)
Estimating the overdispersion in COVID-19 transmission using outbreak
sizes outside China. Wellcome Open Research, 5.
\doi{10.12688/wellcomeopenres.15842.3}
}
