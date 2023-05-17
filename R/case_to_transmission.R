#' Estimate what proportion of cases cause a certain proportion of transmission
#'
#' @description Calculates the proportion of cases that cause a certain
#' percentage of transmission.
#'
#' It is commonly estimated what proportion of cases cause 80% of transmission
#' (i.e. secondary cases).
#' This can be calculated using `cases_to_transmission()` at varying values of
#' \eqn{R} and for different values of percentage transmission.
#'
#' @details Multiple values of R and k can be supplied and a data frame of
#' every combination of these will be returned.
#'
#' @inheritParams probability_epidemic
#' @param percent_transmission A `number` of the percentage transmission
#' for which a proportion of cases has produced
#'
#' @return A data frame with the value for the proportion of cases for a given
#' value of R and k
#' @export
#'
#' @examples
#' # example of single values of R and k
#' percent_transmission <- 0.8 # 80% of transmission
#' R <- 2
#' k <- 0.5
#' cases_to_transmission(
#'   R = R,
#'   k = k,
#'   percent_transmission = percent_transmission
#' )
#'
#' # example with multiple values of k
#' k <- c(0.1, 0.2, 0.3, 0.4, 0.5, 1)
#' cases_to_transmission(
#'   R = R,
#'   k = k,
#'   percent_transmission = percent_transmission
#' )
#'
#' # example with vectors of R and k
#' R <- c(1, 2, 3)
#' cases_to_transmission(
#'   R = R,
#'   k = k,
#'   percent_transmission = percent_transmission
#' )
cases_to_transmission <- function(R, k, percent_transmission) {

  # check input
  checkmate::assert_numeric(R)
  checkmate::assert_numeric(k)
  checkmate::assert_number(percent_transmission)

  df <- expand.grid("R" = R, "k" = k, NA_real_)
  colnames(df) <- c("R", "k", paste0("prop_", percent_transmission * 100))

  nsim <- 1e5
  for (i in seq_len(nrow(df))) {

      simulate_secondary <- stats::rnbinom(
        n = nsim,
        mu = df[i, "R"],
        size = df[i, "k"]
      )

      # percentage of cases
      percent_cases <- percent_transmission * sum(simulate_secondary)

      # cumulative sum of simulated secondary cases
      cumsum_secondary <- cumsum(sort(simulate_secondary, decreasing = T))

      # proportion causing case
      out <-  sum(cumsum_secondary <= percent_cases) / nsim

      df$prop_80[i] <- paste0(round(out * 100, digits = 1),"%")
  }
  return(df)
}




