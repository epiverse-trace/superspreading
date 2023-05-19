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
#'
#' @examples
#' probability_extinct(1.5, 0.1, 10)
probability_extinct <- function(R, k, a) {
  # input checking done in probability_epidemic
  1 - probability_epidemic(R = R, k = k, a = a)
}
