#' Estimate what proportion of cases that cause a certain proportion of
#' transmission
#'
#' @description Calculates the proportion of cases that cause a certain
#' percentage of transmission.
#'
#' It is commonly estimated what proportion of cases cause 80% of transmission
#' (i.e. secondary cases).
#' This can be calculated using `proportion_transmission()` at varying values of
#' \eqn{R} and for different values of percentage transmission.
#'
#' @details Multiple values of R and k can be supplied and a `<data.frame>` of
#' every combination of these will be returned.
#'
#' The numerical calculation uses random number generation to simulate secondary
#' contacts so the answers may minimally vary between calls. The number of
#' simulation replicates is fixed to `1e5`.
#'
#' @inheritParams probability_epidemic
#' @param percent_transmission A `number` of the percentage transmission
#' for which a proportion of cases has produced.
#' @param sim A `logical` whether the calculation should be done numerically
#' (i.e. simulate secondary contacts) or analytically.
#'
#' @return A `<data.frame>` with the value for the proportion of cases for a
#' given value of R and k.
#' @export
#'
#' @references
#'
#' The analytical calculation is from:
#'
#' Endo, A., Abbott, S., Kucharski, A. J., & Funk, S. (2020)
#' Estimating the overdispersion in COVID-19 transmission using outbreak
#' sizes outside China. Wellcome Open Research, 5.
#' \doi{10.12688/wellcomeopenres.15842.3}
#'
#' @examples
#' # example of single values of R and k
#' percent_transmission <- 0.8 # 80% of transmission
#' R <- 2
#' k <- 0.5
#' proportion_transmission(
#'   R = R,
#'   k = k,
#'   percent_transmission = percent_transmission
#' )
#'
#' # example with multiple values of k
#' k <- c(0.1, 0.2, 0.3, 0.4, 0.5, 1)
#' proportion_transmission(
#'   R = R,
#'   k = k,
#'   percent_transmission = percent_transmission
#' )
#'
#' # example with vectors of R and k
#' R <- c(1, 2, 3)
#' proportion_transmission(
#'   R = R,
#'   k = k,
#'   percent_transmission = percent_transmission
#' )
proportion_transmission <- function(R, k,
                                    percent_transmission,
                                    sim = FALSE,
                                    ...,
                                    offspring_dist) {
  input_params <- missing(R) && missing(k)
  if (!xor(input_params, missing(offspring_dist))) {
    stop("One of R and k or <epidist> must be supplied.", call. = FALSE)
  }

  # check inputs
  chkDots(...)
  if (input_params) {
    checkmate::assert_class(offspring_dist, classes = "epidist")
    R <- get_epidist_param(epidist = offspring_dist, parameter = "R")
    k <- get_epidist_param(epidist = offspring_dist, parameter = "k")
  }
  checkmate::assert_numeric(R, lower = 0, finite = TRUE)
  checkmate::assert_numeric(k, lower = 0)
  checkmate::assert_number(percent_transmission, lower = 0, upper = 1)
  checkmate::assert_logical(sim, any.missing = FALSE, len = 1)

  df <- expand.grid(R = R, k = k, NA_real_)
  colnames(df) <- c("R", "k", paste0("prop_", percent_transmission * 100))

  for (i in seq_len(nrow(df))) {
    if (sim) {
      prop <- .prop_transmission_numerical(
        R = df[i, "R"],
        k = df[i, "k"],
        percent_transmission = percent_transmission
      )
    } else {
      prop <- .prop_transmission_analytical(
        R = df[i, "R"],
        k = df[i, "k"],
        percent_transmission = percent_transmission
      )
    }

    # df is ways i x 3 so insert value into col 3
    df[i, 3] <- paste0(round(prop * 100, digits = 1), "%")
  }
  return(df)
}

#' Analytical calculation of proportion of cases that cause \eqn{x} percent
#' of transmission
#'
#' @return A numeric
#' @keywords internal
#' @noRd
.prop_transmission_analytical <- function(R, k, percent_transmission) {

  xm1 <- stats::qnbinom(1 - percent_transmission, k + 1, mu = R * (k + 1) / k)
  remq <- 1 - percent_transmission -
    stats::pnbinom(xm1 - 1, k + 1, mu = R * (k + 1) / k)
  remx <- remq / stats::dnbinom(xm1, k + 1, mu = R * (k + 1) / k)
  x <- xm1 + 1
  out <- 1 - stats::pnbinom(x - 1, k, mu = R) -
    stats::dnbinom(x, k, mu = R) * remx
  return(out)
}

#' Numerical calculation of proportion of cases that cause \eqn{x} percent
#' of transmission
#'
#' @return A numeric
#' @keywords internal
#' @noRd
.prop_transmission_numerical <- function(R, k, percent_transmission) {

  nsim <- 1e5
  simulate_secondary <- stats::rnbinom(
    n = nsim,
    mu = R,
    size = k
  )

  # percentage of cases
  percent_cases <- percent_transmission * sum(simulate_secondary)

  # cumulative sum of simulated secondary cases
  cumsum_secondary <- cumsum(sort(simulate_secondary, decreasing = TRUE))

  # proportion causing case
  out <- sum(cumsum_secondary <= percent_cases) / nsim

  return(out)
}
