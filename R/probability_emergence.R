#' Calculate the probability a disease will emerge and cause a sustained
#' outbreak (\eqn{R > 1}) based on R
#'
#' @description The method for the evolution of pathogen emergence described in
#' Antia et al. (2003) (\doi{10.1038/nature02104}). The model is a multi-type
#' branching process model with an initial (wild-type) reproduction number,
#' usually below 1, and a evolved reproduction number that is
#' greater than 1, and thus can cause a sustained human-to-human epidemic.
#' The reproduction number for a pathogen changes at the `mutation_rate`.
#'
#' @param R_wild  A `number` specifying the R parameter (i.e. average
#' secondary cases per infectious individual) for the wild-type pathogen.
#' @param R_mutant  A `number` specifying the R parameter (i.e. average
#' secondary cases per infectious individual) for the mutant pathogen.
#' @param mutation_rate A `number` specifying the mutation rate (\eqn{\mu}),
#' must be between zero and one.
#' @param tol A `number` for the tolerance of the numerical convergence.
#' Default is `1e-10`
#' @param max_iter A `number` for the maximum number of iterations for the
#' optimisation. Default is `1000`.
#'
#' @return A value with the probability of a disease emerging and causing an
#' outbreak.
#' @export
#' @seealso [probability_epidemic()], [probability_extinct()]
#'
#' @references
#'
#' Antia, R., Regoes, R., Koella, J. & Bergstrom, C. T. (2003).
#' The role of evolution in the emergence of infectious diseases.
#' Nature 426, 658–661. \doi{10.1038/nature02104}
#'
#' @examples
#' probability_emergence(R_wild = 0.5, R_mutant = 1.5, mutation_rate = 0.5)
probability_emergence <- function(R_wild,
                                  R_mutant,
                                  mutation_rate = 0,
                                  tol = 1e-10,
                                  max_iter = 1000) {

  checkmate::assert_number(R_wild, upper = 1)
  checkmate::assert_number(R_mutant, lower = 1)
  checkmate::assert_number(mutation_rate, lower = 0, upper = 1)

  # Initialize extinction probabilities
  q1 <- 0.5
  q2 <- 0.5

  for (i in 1:max_iter) {
    q1_new <- exp(-(1 - mutation_rate) * R_wild * (1 - q1)) *
      exp(-mutation_rate * R_wild * (1 - q2))
    q2_new <- exp(-R_mutant * (1 - q2))

    if (abs(q1_new - q1) < tol && abs(q2_new - q2) < tol) break

    q1 <- q1_new
    q2 <- q2_new
  }

  # probability of emergence from probability of extinction of wild type
  prob_emerge <- 1 - q1

  return(prob_emerge)
}
