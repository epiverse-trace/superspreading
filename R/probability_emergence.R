#' Calculate the probability a disease will emerge and cause a sustained
#' outbreak (\eqn{R > 1}) based on R
#'
#' @description
#' The method for the evolution of pathogen emergence described in
#' Antia et al. (2003) (\doi{10.1038/nature02104}). The model is a multi-type
#' branching process model with an initial (wild-type) reproduction number,
#' usually below 1, and a evolved reproduction number that is
#' greater than 1, and thus can cause a sustained human-to-human epidemic.
#' The reproduction number for a pathogen changes at the `mutation_rate`.
#'
#' @details
#' Following Antia et al. (2003), we assume that the mutation rate for all
#' variants is the same.
#'
#' @param R_wild  A `number` specifying the R parameter (i.e. average
#'   secondary cases per infectious individual) for the wild-type pathogen.
#' @param R_mutant  A `number` or vector of `numbers` specifying the R
#'   parameter (i.e. average secondary cases per infectious individual) for the
#'   mutant pathogen(s). If there is more than one value supplied to `R_mutant`,
#'   then the first element is the reproduction number for \eqn{m - 1} mutant
#'   and the last element is the reproduction number for the \eqn{m} mutant
#'   (i.e. fully evolved).
#' @param mutation_rate A `number` specifying the mutation rate (\eqn{\mu}),
#'   must be between zero and one.
#' @param tol A `number` for the tolerance of the numerical convergence.
#'   Default is `1e-10`.
#' @param max_iter A `number` for the maximum number of iterations for the
#'   optimisation. Default is `1000`.
#'
#' @return A value with the probability of a disease emerging and causing an
#'   outbreak.
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

  checkmate::assert_number(R_wild)
  checkmate::assert_numeric(R_mutant)
  checkmate::assert_number(mutation_rate, lower = 0, upper = 1)
  checkmate::assert_number(tol, lower = 0)
  checkmate::assert_integerish(max_iter, lower = 0)

  if (R_wild <= 1 && mutation_rate == 0) {
    # If R<=1, P(extinction)=1
    return(0)
  }

  # one R vector for indexing in equations
  R0 <- c(R_wild, R_mutant)
  m <- length(R0)
  # initialise extinction probabilities
  extinct_prob <- rep(0.5, m)

  for (i in seq_len(max_iter)) {
    # create vector to hold new values for fixed-point convergence check
    extinct_prob_new <- numeric(m)

    # wild type
    extinct_prob_new[1] <-
      exp(-(1 - mutation_rate) * R0[1] * (1 - extinct_prob[1])) *
      exp(-mutation_rate * R0[1] * (1 - extinct_prob[2]))

    if (m > 2) {
      # intermediate types (excludes wild-type and fully evolved mutant)
      for (j in 2:(m - 1)) {
        extinct_prob_new[j] <-
          exp(-(1 - mutation_rate) * R0[j] * (1 - extinct_prob[j])) *
          exp(-mutation_rate * R0[j] * (1 - extinct_prob[j + 1]))
      }
    }

    # fully evolved mutant
    extinct_prob_new[m] <- exp(-R0[m] * (1 - extinct_prob[m]))

    if (max(abs(extinct_prob_new - extinct_prob)) < tol) break
    extinct_prob <- extinct_prob_new
  }

  # probability of emergence from probability of extinction of wild type
  prob_emerge <- 1 - extinct_prob[1]

  return(prob_emerge)
}
