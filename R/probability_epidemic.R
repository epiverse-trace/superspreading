#' Calculate the probability a disease will cause an outbreak based on R, k
#' and initial cases
#'
#' @description Calculates the probability a branching process will cause an
#' epidemic (i.e. probability will fail to go extinct) based on R, k and
#' initial cases.
#'
#' @param R A `number` specifying the R parameter (i.e. average secondary cases
#' per infectious individual).
#' @param k A `number` specifying the  k parameter (i.e. overdispersion in
#' offspring distribution from fitted negative binomial).
#' @param num_init_infect A `count` specifying the number of initial infections.
#' @param ind_control A `numeric` specifying the strength of individual-level
#' control measures. Between `0` (default) and `1` (maximum).
#' @param pop_control A `numeric` specifying the strength of population-level
#' control measures. Between `0` (default) and `1` (maximum).
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Named elements to replace
#' default optimisation settings. Currently only `"fit_method"` is accepted
#' and can be either `"optim"` (default) or `"grid"` for numerical
#' optimisation routine or grid search, respectively.
#' @param offspring_dist An `<epidist>` object. An S3 class for working with
#' epidemiological parameters/distributions, see [epiparameter::epidist()].
#'
#' @return A value with the probability of a large epidemic.
#' @export
#' @seealso [probability_extinct()]
#'
#' @references
#'
#' Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005)
#' Superspreading and the effect of individual variation on disease emergence.
#' Nature, 438(7066), 355-359. \doi{10.1038/nature04153}
#'
#' Kucharski, A. J., Russell, T. W., Diamond, C., Liu, Y., Edmunds, J.,
#' Funk, S. & Eggo, R. M. (2020). Early dynamics of transmission and control
#' of COVID-19: a mathematical modelling study. The Lancet Infectious Diseases,
#' 20(5), 553-558. \doi{10.1016/S1473-3099(20)30144-4}
#'
#' @examples
#' probability_epidemic(R = 1.5, k = 0.1, num_init_infect = 10)
probability_epidemic <- function(R,
                                 k,
                                 num_init_infect,
                                 ind_control = 0,
                                 pop_control = 0,
                                 ...,
                                 offspring_dist) {
  # input checking done in probability_extinct
  1 - probability_extinct(
    R = R,
    k = k,
    num_init_infect = num_init_infect,
    ind_control = ind_control,
    pop_control = pop_control,
    ...,
    offspring_dist = offspring_dist
  )
}

#' Calculate the probability a branching process will go extinct based on
#' R, k and initial cases
#'
#' @description Calculates the probability a branching process will not causes
#' an epidemic and will go extinct. This is the complement of the probability
#' of a disease causing an epidemic ([probability_epidemic()]).
#'
#' @inheritParams probability_epidemic
#'
#' @return A value with the probability of going extinct.
#' @export
#' @seealso [probability_epidemic()]
#'
#' @references
#'
#' Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005).
#' Superspreading and the effect of individual variation on disease emergence.
#' Nature, 438(7066), 355-359. \doi{10.1038/nature04153}
#'
#' @examples
#' probability_extinct(R = 1.5, k = 0.1, num_init_infect = 10)
probability_extinct <- function(R,
                                k,
                                num_init_infect,
                                ind_control = 0,
                                pop_control = 0,
                                ...,
                                offspring_dist) {
  input_params <- missing(R) && missing(k)
  if (!xor(input_params, missing(offspring_dist))) {
    stop("One of R and k or <epidist> must be supplied.", call. = FALSE)
  }

  # check inputs
  if (input_params) {
    checkmate::assert_class(offspring_dist, classes = "epidist")
    R <- get_epidist_param(epidist = offspring_dist, parameter = "R")
    k <- get_epidist_param(epidist = offspring_dist, parameter = "k")
  }

  checkmate::assert_number(R, lower = 0, finite = TRUE)
  checkmate::assert_number(k, lower = 0)
  checkmate::assert_count(num_init_infect)
  checkmate::assert_number(ind_control, lower = 0, upper = 1)
  checkmate::assert_number(pop_control, lower = 0, upper = 1)

  # capture dynamic dots
  dots <- rlang::dots_list(..., .ignore_empty = "none", .homonyms = "error")

  # change Inf k to 1e10 to prevent issue with grid search
  if (is.infinite(k)) k <- 1e10

  if (R <= 1) {
    # If R<=1, P(extinction)=1
    return(1)
  }

  # If R < 1, P(extinction) < 1
  # calculate probability of outbreak based solving g(s)=s in
  # generating function for branching process
  # define loss function
  calculate_prob <- function(ss, R, k, ind_control, pop_control) {
    abs(ind_control + (1 - ind_control) *
          (1 + (((1 - pop_control) * R) / k) * (1 - ss))^(-k) - ss
    )
  }

  fit_method <- dots$fit_method %||% "optim"

  prob_extinct <- .fit(
    func = calculate_prob,
    fit_method = fit_method,
    R = R,
    k = k,
    ind_control = ind_control,
    pop_control = pop_control
  )

  # calculate P(extinction) given 'num_init_infect' introductions
  prob_extinct <- prob_extinct^num_init_infect

  return(prob_extinct)
}
