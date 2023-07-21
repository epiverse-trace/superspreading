#' Probability that an outbreak will be contained
#'
#' @description Containment is defined as the size of the transmission chain
#' not reaching the `case_threshold` (default = 100).
#'
#' @inheritParams probability_epidemic
#' @param control Control strength, 0 is no control measures, 1 is complete
#' control.
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
#' Nature, 438(7066), 355-359. \doi{10.1038/nature04153}
#'
#' @examples
#' probability_contain(R = 1.5, k = 0.5, control = 1)
probability_contain <- function(R, k, num_init_infect = 1, control,
                                control_type = c("population", "individual"),
                                stochastic = TRUE,
                                ...,
                                case_threshold = 100,
                                epidist) {
  input_params <- missing(R) && missing(k)
  if (!xor(input_params, missing(epidist))) {
    stop("One of R and k or <epidist> must be supplied.", call. = FALSE)
  }
  # check inputs
  if (input_params) {
    epiparameter::is_epidist(epidist)
    R <- get_epidist_param(epidist = epidist, parameter = "R")
    k <- get_epidist_param(epidist = epidist, parameter = "k")
  }
  checkmate::assert_number(R, lower = 0, finite = TRUE)
  checkmate::assert_number(k, lower = 0)
  checkmate::assert_count(num_init_infect)
  checkmate::assert_number(control, lower = 0, upper = 1)
  checkmate::assert_logical(stochastic, any.missing = FALSE, len = 1)
  checkmate::assert_number(case_threshold, lower = 1)

  control_type <- match.arg(control_type)
  if (control_type == "population") {
    R <- (1 - control) * R
  } else {
    stop("individual-level controls not yet implemented", call. = FALSE)
  }

  if (num_init_infect != 1) {
    stop(
      "Multiple introductions is not yet implemented for probability_contain",
      call. = FALSE
    )
  }

  if (stochastic) {
    # arguments for chain_sim()
    args <- list(
      n = 1e5,
      offspring = "nbinom",
      size = k,
      mu = R,
      infinite = case_threshold
    )

    # replace default args if in dots (remove args not for chain_sim)
    args <- utils::modifyList(args, list(...)[...names() %in% names(args)])

    chain_size <- do.call(
      bpmodels::chain_sim,
      args
    )

    prob_contain <- sum(!is.infinite(chain_size)) / length(chain_size)
  } else {
    prob_contain <- probability_extinct(
      R = R, k = k, num_init_infect = num_init_infect
    )
  }
  return(prob_contain)
}
