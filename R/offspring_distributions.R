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
#' @examples
#' dpoislnorm(x = 10, meanlog = 1, sdlog = 2)
#' dpoislnorm(x = 1:10, meanlog = 1, sdlog = 2)
dpoislnorm <- Vectorize(function(x, meanlog, sdlog) {

  # cannot input check with asserts due to {fitdistrplus}

  integrand <- function(lambda) {
    lambda ^ (x - 1) / (factorial(x) * sdlog * sqrt(2 * pi)) *
      exp(-lambda - ((log(lambda) - meanlog)^2) / (2 * sdlog^2))
  }

  out <- tryCatch(
    stats::integrate(f = integrand, lower = 0, upper = Inf)$value,
    error = function(cnd) return(0),
    warning = function(cnd) return(0)
  )

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
#' @examples
#' ppoislnorm(q = 10, meanlog = 1, sdlog = 2)
#' ppoislnorm(q = 1:10, meanlog = 1, sdlog = 2)
ppoislnorm <- Vectorize(function(q, meanlog, sdlog) {
  if (is.nan(q)) return(NaN)
  if (is.na(q)) return(NA)
  if (!(checkmate::test_number(q, lower = 0, finite = TRUE, null.ok = FALSE)))
    return(0)
  sum(dpoislnorm(x = seq(0, q, by = 1), meanlog = meanlog, sdlog = sdlog))
})

#' Density of the poisson-Weibull compound distribution
#'
#' @details The function is vectorised so a vector of quantiles can be input
#' and the output will have an equal length.
#'
#' @param x A `number` for the quantile of the distribution
#' @param shape A `number` for the shape parameter of the distribution
#' @param scale A `number` for the scale parameter of the distribution
#'
#' @return A `numeric` vector of the density of the poisson-Weibull
#' distribution.
#' @export
#'
#' @examples
#' dpoisweibull(x = 10, shape = 1, scale = 2)
#' dpoisweibull(x = 1:10, shape = 1, scale = 2)
dpoisweibull <- Vectorize(function(x, shape, scale) {

  # cannot input check with asserts due to {fitdistrplus}

  integrand <- function(lambda) {
    exp(-lambda - (lambda / scale)^shape) * lambda ^ (x + shape - 1)
  }

  out <- tryCatch(
    stats::integrate(
      f = integrand,
      lower = 0,
      upper = Inf
    )$value * (shape / (factorial(x) * scale^shape)),
    error = function(cnd) return(0),
    warning = function(cnd) return(0)
  )

  return(out)
})

#' Cumulative distribution function of the poisson-Weibull compound
#' distribution
#'
#' @details The function is vectorised so a vector of quantiles can be input
#' and the output will have an equal length.
#'
#' @param q A `number` for the quantile of the distribution
#' @inheritParams dpoisweibull
#'
#' @return A `numeric` vector of the distribution function.
#' @export
#'
#' @examples
#' ppoisweibull(q = 10, shape = 1, scale = 2)
#' ppoisweibull(q = 1:10, shape = 1, scale = 2)
ppoisweibull <- Vectorize(function(q, shape, scale) {
  if (is.nan(q)) return(NaN)
  if (is.na(q)) return(NA)
  if (!(checkmate::test_number(q, lower = 0, finite = TRUE, null.ok = FALSE)))
    return(0)
  sum(dpoisweibull(x = seq(0, q, by = 1), shape = shape, scale = scale))
})
