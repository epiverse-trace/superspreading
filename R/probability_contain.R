#' Probability that an outbreak will be contained
#'
#' @description
#' Containment is defined as not reaching 100 cases
#'
#'
#' @inheritParams probability_epidemic
#' @param c Control strength, 0 is no control measures, 1 is complete control.
#' @param control_type Either `"population"` or `"individual"` for
#' population-level or individual-level control measures.
#' @param stochastic Whether to use a stochastic branching process model or the
#' probability of extinction.
#' @param ... arguments to be passed to [bpmodels::chain_sim()].
#' @param case_threshold A number for the threshold of the number of cases below
#' which the epidemic is considered contained.
#'
#' @return A number for the probability of containment
#' @export
#'
#' @references
#'
#' Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005)
#' Superspreading and the effect of individual variation on disease emergence.
#' Nature, 438(7066), 355-359. <https://doi.org/10.1038/nature04153>
#'
#' @examples
#' probability_contain(R = 1.5, k = 0.5, c = 1)
probability_contain <- function(R, k, a = 1, c, # nolint
                                control_type = c("population", "individual"),
                                stochastic = TRUE,
                                ...,
                                case_threshold = 100) {
  control_type <- match.arg(control_type)
  if (control_type == "population") {
    R <- (1 - c) * R # nolint
  } else {
    stop("individual-level controls not yet implemented")
  }

  if (a != 1) {
    stop(
      "Multiple introductions is not yet implemented for probability_contain"
    )
  }

  if (stochastic) {
    chain_size <- bpmodels::chain_sim(
      n = 1e5,
      offspring = "nbinom",
      size = k,
      mu = R,
      infinite = case_threshold,
      ...
    )
    prob_contain <- sum(!is.infinite(chain_size)) / length(chain_size)
  } else {
    prob_contain <- probability_extinct(R = R, k = k, a = a)
  }
  return(prob_contain)
}
