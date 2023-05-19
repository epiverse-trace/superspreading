#' Density of the poisson-lognormal compound distribution
#'
#' @details The function is vectorised so a vector of quantiles can be input
#' and the output will have an equal length.
#'
#' @param x A `number` for the quantile of the distribution
#' @param meanlog A `number` for the mean of the distribution on the log scale
#' @param sdlog A `number` for the standard deviation of the distribution on
#' the log scale
#'
#' @return A `numeric` vector of the density of the poisson-lognormal
#' distribution.
#' @export
#'
#' @examples a = 1
dpoislnorm <- Vectorize(function(x, meanlog, sdlog) {

  #checkmate::assert_number(x, lower = 0)
  #checkmate::assert_number(meanlog)
  #checkmate::assert_number(sdlog, lower = 0)

  integrand <- function(lambda) {
    lambda ^ (x - 1) / (factorial(x) * sdlog * sqrt(2 * pi)) *
      exp(-lambda-((log(lambda) - meanlog)^2) / (2 * sdlog^2))
  }

  out <- tryCatch(
    stats::integrate(f = integrand, lower = 0, upper = Inf)$value,
    error = function(cnd) return(0),
    warning = function(cnd) return(0)
  )

  # alternative method, not used
  # integrand <- function(lambda, x) {
  #   dnorm(lambda, 0, 1) * dpois(x, exp(lambda * sdlog + meanlog))
  # }
  # out <- tryCatch(
  #   stats::integrate(f = integrand, lower = -Inf, upper = Inf, x = x)$value,
  #   error = function(cnd) return(0),
  #   warning = function(cnd) return(0)
  # )

  return(out)
})


#' Cumulative distribution function of the poisson-lognormal compound
#' distribution
#'
#' @details The function is vectorised so a vector of quantiles can be input
#' and the output will have an equal length.
#'
#' @param q A `number` for the quantile of the distribution
#' @inheritParams dpoislnorm
#'
#' @return A `numeric` vector of the distribution function.
#' @export
#'
#' @examples a = 1
ppoislnorm <- Vectorize(function(q, meanlog, sdlog) {
  if (is.nan(q)) return(NaN)
  if (is.na(q)) return(NA)
  if (!(checkmate::test_number(q, lower = 0, finite = TRUE, null.ok = FALSE)))
    return(0)
  sum(dpoislnorm(x = seq(0, q, by = 1), meanlog = meanlog, sdlog = sdlog))
})

dpoisweibull <- function(x, shape, scale) {

  integrand <- function(lambda) {
    exp(-lambda - (lambda / scale)^shape) * lambda ^ (x + shape - 1)
  }
  stats::integrate(integrand, 0, Inf)$value * shape / (factorial(x) * scale^shape)
}
