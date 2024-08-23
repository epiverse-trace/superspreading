#' Probability that an outbreak will be contained
#'
#' @description Containment is defined as the size of the transmission chain
#' not reaching the `case_threshold` (default = 100).
#'
#' @details
#' When using `stochastic = TRUE`, the default arguments to simulate the
#' transmission chains with [bpmodels::chain_sim()] are `1e5` replicates,
#' a negative binomial (`nbinom`) offspring distribution, parameterised with
#' `R` (and `pop_control` if > 0) and `k`.
#'
#' @inheritParams probability_epidemic
#' @param stochastic Whether to use a stochastic branching process model or the
#' analytical probability of extinction. Default (`FALSE`) is to use the
#' analytical calculation.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Named elements to replace
#' default arguments in [bpmodels::chain_sim()]. See details.
#' @param case_threshold A number for the threshold of the number of cases below
#' which the epidemic is considered contained.
#'
#' @return A `number` for the probability of containment.
#' @export
#' @seealso [probability_extinct()]
#'
#' @references
#'
#' Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005)
#' Superspreading and the effect of individual variation on disease emergence.
#' Nature, 438(7066), 355-359. \doi{10.1038/nature04153}
#'
#' @examples
#' # population-level control measures
#' probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1)
#'
#' # individual-level control measures
#' probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1)
#'
#' # both levels of control measures
#' probability_contain(
#'   R = 1.5,
#'   k = 0.5,
#'   num_init_infect = 1,
#'   ind_control = 0.1,
#'   pop_control = 0.1
#' )
#'
#' # multi initial infections with population-level control measures
#' probability_contain(R = 1.5, k = 0.5, num_init_infect = 5, pop_control = 0.1)
probability_contain <- function(R,
                                k,
                                num_init_infect,
                                ind_control = 0,
                                pop_control = 0,
                                stochastic = FALSE,
                                ...,
                                case_threshold = 100,
                                offspring_dist) {
  # capture dynamic dots
  dots <- rlang::dots_list(..., .ignore_empty = "none", .homonyms = "error")
  dots_names <- names(dots)

  # bpmodels::chain_sim cannot be called within formals() as it's not in base
  bp_func <- bpmodels::chain_sim
  bp_args <- names(formals(bp_func))
  # check arguments in dots match arg list
  stopifnot(
    "Arguments supplied in `...` not valid" =
      all(dots_names %in% bp_args)
  )

  input_params <- missing(R) && missing(k)
  if (!xor(input_params, missing(offspring_dist))) {
    stop(
      "Only one of R and k or <epiparameter> must be supplied.",
      call. = FALSE
    )
  }
  # check inputs
  if (input_params) {
    checkmate::assert_class(offspring_dist, classes = "epiparameter")
    R <- get_epiparameter_param(epiparameter = offspring_dist, parameter = "R")
    k <- get_epiparameter_param(epiparameter = offspring_dist, parameter = "k")
  }
  checkmate::assert_number(R, lower = 0, finite = TRUE)
  checkmate::assert_number(k, lower = 0)
  checkmate::assert_count(num_init_infect)
  checkmate::assert_number(ind_control, lower = 0, upper = 1)
  checkmate::assert_number(pop_control, lower = 0, upper = 1)
  checkmate::assert_logical(stochastic, any.missing = FALSE, len = 1)
  checkmate::assert_number(case_threshold, lower = 1)

  if (ind_control > 0 && stochastic) {
    stop(
      "individual-level control not yet implemented for stochastic calculation",
      call. = FALSE
    )
  }

  if (stochastic) {
    # arguments for chain_sim()
    args <- list(
      n = 1e5,
      offspring = "nbinom",
      size = k,
      mu = (1 - pop_control) * R,
      infinite = case_threshold
    )

    # replace default args if in dots
    args <- utils::modifyList(args, dots)

    chain_size <- lapply(
      seq_len(num_init_infect),
      function(x) do.call(bpmodels::chain_sim, args)
    )
    control_chain_size <- lapply(chain_size, is.infinite)
    control_chain_size <- Reduce(f = `+`, x = control_chain_size)
    prob_contain <- sum(control_chain_size == 0) / length(control_chain_size)
  } else {
    prob_contain <- probability_extinct(
      R = R,
      k = k,
      num_init_infect = num_init_infect,
      ind_control = ind_control,
      pop_control = pop_control
    )
  }
  return(prob_contain)
}
