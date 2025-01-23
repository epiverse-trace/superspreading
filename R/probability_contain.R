#' Probability that an outbreak will be contained
#'
#' @description Outbreak containment is defined as outbreak extinction when
#' `simulate = FALSE`. When `simulate = FALSE`, [probability_contain()] is
#' equivalent to calling [probability_extinct()].
#'
#' When `simulate = TRUE`, outbreak containment is defined by the
#' `case_threshold` (default = 100) and `outbreak_time` arguments.
#' Firstly, `case_threshold` sets the size of the transmission chain below
#' which the outbreak is considered contained. Secondly, `outbreak_time` sets
#' the time duration from the start of the outbreak within which the outbreak
#' is contained if there is no more onwards transmission beyond this time.
#' When setting an `outbreak_time`, a `generation_time` is also required.
#' `case_threshold` and `outbreak_time` can be jointly set.
#' Overall, when `simulate = TRUE`, containment is defined as the size and
#' time duration of a transmission chain not reaching the `case_threshold`
#' and `outbreak_time`, respectively.
#'
#' @details
#' When using `simulate = TRUE`, the default arguments to simulate the
#' transmission chains with [.chain_sim()] are `r NSIM` replicates,
#' a negative binomial (`nbinom`) offspring distribution, parameterised with
#' `R` (and `pop_control` if > 0) and `k`.
#'
#' When setting the `outbreak_time` argument, the `generation_time` argument is
#' also required. The `generation_time` argument requires a random number
#' generator function. For example, if we assume the generation time is
#' lognormally distributed with `meanlog = 1` and `sdlog = 1.5`, then we can
#' define the `function` to pass to `generation_time` as:
#' ```r
#' function(x) rlnorm(x, meanlog = 1, sdlog = 1.5)
#' ```
#'
#'
#' @inheritParams probability_epidemic
#' @param simulate A `logical` boolean determining whether the probability
#' of containment is calculated analytically or numerically using a stochastic
#' branching process model. Default is `FALSE` which calls
#' [probability_extinct()], setting to `TRUE` uses a branching process and
#' enables setting the `case_threshold`, `outbreak_time` and `generation_time`
#' arguments.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Named elements to replace
#' default arguments in [.chain_sim()]. See details.
#' @param case_threshold A number for the threshold of the number of cases below
#' which the epidemic is considered contained. `case_threshold` is only used
#' when `simulate = TRUE`.
#' @param outbreak_time A number for the time since the start of
#' the outbreak to determine if outbreaks are contained within a given period
#' of time. `outbreak_time` is only used when `simulate = TRUE`.
#' @param generation_time A `function` to generate generation times. The
#' function must have a single argument and return a `numeric` vector with
#' generation times. See details for example. The `function` can be defined or
#' anonymous. `generation_time` is only used when `simulate = TRUE`.
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
#'
#' # probability of containment within a certain amount of time
#' # this requires parameterising a generation time
#' gt <- function(n) {
#'   rlnorm(n, meanlog = 1, sdlog = 1.5)
#' }
#' probability_contain(
#'   R = 1.5,
#'   k = 0.5,
#'   num_init_infect = 1,
#'   simulate = TRUE,
#'   case_threshold = 50,
#'   outbreak_time = 20,
#'   generation_time = gt
#' )
probability_contain <- function(R,
                                k,
                                num_init_infect,
                                ind_control = 0,
                                pop_control = 0,
                                simulate = FALSE,
                                ...,
                                case_threshold = 100,
                                outbreak_time = Inf,
                                generation_time = NULL,
                                offspring_dist) {
  # capture dynamic dots
  dots <- rlang::dots_list(..., .ignore_empty = "none", .homonyms = "error")
  dots_names <- names(dots)
  bp_args <- names(formals(.chain_sim))
  # check arguments in dots match arg list
  stopifnot(
    "Arguments supplied in `...` not valid" =
      all(dots_names %in% bp_args)
  )

  missing_params <- missing(R) && missing(k)
  .check_input_params(
    missing_params = missing_params,
    missing_offspring_dist = missing(offspring_dist)
  )
  # check inputs
  if (missing_params) {
    checkmate::assert_class(offspring_dist, classes = "epiparameter")
    R <- get_epiparameter_param(epiparameter = offspring_dist, parameter = "R")
    k <- get_epiparameter_param(epiparameter = offspring_dist, parameter = "k")
  }
  checkmate::assert_number(R, lower = 0, finite = TRUE)
  checkmate::assert_number(k, lower = 0)
  checkmate::assert_count(num_init_infect)
  checkmate::assert_number(ind_control, lower = 0, upper = 1)
  checkmate::assert_number(pop_control, lower = 0, upper = 1)
  checkmate::assert_logical(simulate, any.missing = FALSE, len = 1)
  checkmate::assert_number(case_threshold, lower = 1)
  checkmate::assert_number(outbreak_time, lower = 0)

  if (ind_control > 0 && simulate) {
    stop(
      "individual-level control not yet implemented for `simulate` calculation",
      call. = FALSE
    )
  }
  if (is.finite(outbreak_time) && is.null(generation_time)) {
    stop(
      "`generation_time` is required to calculate the probability of ",
      "containment within an `outbreak_time`",
      call. = FALSE
    )
  }

  if (simulate) {
    # arguments for .chain_sim()
    args <- list(
      n = NSIM,
      offspring = "nbinom",
      size = k,
      mu = (1 - pop_control) * R,
      stat_threshold = case_threshold
    )
    if (!is.null(generation_time)) {
      args$generation_time <- generation_time
    }

    # replace default args if in dots
    args <- utils::modifyList(args, dots)

    # simulate independent transmission chain for each initial infection
    chain <- lapply(
      seq_len(num_init_infect),
      function(x) do.call(.chain_sim, args)
    )

    # size is the total offspring produced by a chain
    chain_size <- lapply(
      chain,
      function(x) as.vector(table(x$n), mode = "numeric")
    )

    # sum multiple chains if multiple initial initial infections
    chain_size <- Reduce(f = `+`, x = chain_size)

    if (is.finite(outbreak_time)) {
      # subset chains that were under case_threshold by outbreak_time
      contain_within_t <- lapply(chain, function(x) {
        stats::aggregate(
          time ~ n,
          data = x,
          FUN = function(y) max(y) < outbreak_time
        )$time
      })
      # for an outbreak to be contained within t all chains must have stopped
      contain_within_t <- Reduce(f = `+`, x = contain_within_t)
      contain_within_t <- contain_within_t == num_init_infect

      # controlled outbreak has fewer cases and shorter time than thresholds
      control_chain_size <- sum(contain_within_t & chain_size < case_threshold)
    } else {
      control_chain_size <- sum(chain_size < case_threshold)
    }
    prob_contain <- control_chain_size / NSIM
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
