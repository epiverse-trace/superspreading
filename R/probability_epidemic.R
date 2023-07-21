#' Calculate the probability a disease will cause an outbreak based on R, k
#' and initial cases
#'
#' @description Calculates the probability a branching process will cause an
#' epidemic (i.e. probability will fail to go extinct) based on R, k and
#' initial cases
#'
#' @param R A `number` specifying the R parameter (i.e. average secondary cases
#' per infectious individual)
#' @param k A `number` specifying the  k parameter (i.e. overdispersion in
#' offspring distribution from fitted negative binomial)
#' @param num_init_infect A `count` specifying the number of initial infections
#' @param ... [`dots`] not used, extra arguments supplied will cause a warning.
#' @param epidist An `<epidist>` object. An S3 class for working with
#' epidemiological parameters/distributions, see [`epiparameter::epidist()`]
#'
#' @return A value with the probability of a large epidemic
#' @export
#' @seealso [probability_extinct()]
#'
#' @references
#'
#' Kucharski, A. J., Russell, T. W., Diamond, C., Liu, Y., Edmunds, J.,
#' Funk, S. & Eggo, R. M. (2020). Early dynamics of transmission and control
#' of COVID-19: a mathematical modelling study. The Lancet Infectious Diseases,
#' 20(5), 553-558. \doi{10.1016/S1473-3099(20)30144-4}
#'
#' @examples
#' probability_epidemic(R = 1.5, k = 0.1, num_init_infect = 10)
probability_epidemic <- function(R, k, num_init_infect, ..., epidist) {
  input_params <- missing(R) && missing(k)
  if (!xor(input_params, missing(epidist))) {
    stop("One of R and k or <epidist> must be supplied.", call. = FALSE)
  }

  # check inputs
  chkDots(...)
  if (input_params) {
    epiparameter::is_epidist(epidist)
    R <- get_epidist_param(epidist = epidist, parameter = "R")
    k <- get_epidist_param(epidist = epidist, parameter = "k")
  }

  checkmate::assert_number(R, lower = 0, finite = TRUE)
  checkmate::assert_number(k, lower = 0)
  checkmate::assert_count(num_init_infect)

  # change Inf k to 1e10 to prevent issue with grid search
  if (is.infinite(k)) k <- 1e10

  # calculate probability of outbreak based solving g(s)=s in
  # generating function for branching process
  if (R <= 1) prob_est <- 1 # If R<=1, P(extinction)=1

  # If R < 1, P(extinction) < 1
  if (R > 1) {
    # set up grid search
    ss <- seq(0.001, 0.999, 0.001)
    # define loss function
    calculate_prob <- abs((1 + (R / k) * (1 - ss))^(-k) - ss)
    # calculate probability of extinction
    prob_est <- ss[which.min(calculate_prob)]
  }

  # calculate P(epidemic) given 'num_init_infect' introductions
  prob_epidemic <- 1 - prob_est^num_init_infect

  return(prob_epidemic)
}

#' Calculates the probability a branching process will go extinct based on
#' R, k and initial cases
#'
#' @description Calculates the probability a branching process will not causes
#' an epidemic and will go extinct. This is the complement of the probability
#' of a disease causing an epidemic ([`probability_epidemic()`]).
#'
#' @inheritParams probability_epidemic
#'
#' @return A value with the probability of going extinct
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
probability_extinct <- function(R, k, num_init_infect, ..., epidist) {
  # input checking done in probability_epidemic
  1 - probability_epidemic(
    R = R, k = k, num_init_infect = num_init_infect, ..., epidist = epidist
  )
}
