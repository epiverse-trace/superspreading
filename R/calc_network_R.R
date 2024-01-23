#' Calculate the reproduction number (\eqn{R}) for a (heterogeneous)
#' network
#'
#' @description The calculation of the reproduction number adjusting for
#' heterogeneity in number of contacts.
#'
#' @param mean_num_contact A `numeric`, mean (average) number of new contacts
#' per unit time.
#' @param sd_num_contact A `numeric`, standard deviation of the number of new
#' contacts per unit time.
#' @param infect_duration A `numeric`, the duration of infectiousness.
#' @param prob_transmission A `numeric` probability of transmission per contact,
#' also known as \eqn{\beta}.
#' @param age_range A `numeric` vector with two elements, the lower and upper
#' age limits of individuals in the network. Default is 16 - 74 (`c(16, 74)`).
#'
#' @return A named `numeric` vector of length 2, the unadjusted (`R`)
#' and corrected (`R_var`) estimates of \eqn{R}.
#' @export
#'
#' @examples
#' # example using NATSAL data
#' calc_network_R(
#'   mean_num_contact = 14.1,
#'   sd_num_contact = 69.6,
#'   infect_duration = 1,
#'   prob_transmission = 1,
#'   age_range = c(16, 74)
#' )
calc_network_R <- function(mean_num_contact,
                           sd_num_contact,
                           infect_duration,
                           prob_transmission,
                           age_range = c(16, 74)) {
  checkmate::assert_number(mean_num_contact, lower = 0, finite = TRUE)
  checkmate::assert_number(sd_num_contact, lower = 0, finite = TRUE)
  checkmate::assert_number(infect_duration, lower = 0, finite = TRUE)
  checkmate::assert_number(prob_transmission, lower = 0, finite = TRUE)
  checkmate::assert_numeric(age_range, len = 2, lower = 0, finite = TRUE)

  # define measured sexual contacts
  # normalise by years sexually active
  scale_by_active <- 1 / (max(age_range) - min(age_range))
  # calculate new partners per year
  contacts_per_year <- c(
    mean = mean_num_contact * scale_by_active,
    var = sd_num_contact^2 * scale_by_active^2
  )

  beta <- prob_transmission

  # calculate R0 with and without correction
  R <- beta * contacts_per_year[["mean"]] * infect_duration
  R_var <- beta * infect_duration *
    (contacts_per_year[["mean"]] + contacts_per_year[["var"]] /
      contacts_per_year[["mean"]])

  # return R0 with and without variance correction
  c(R = R, R_var = R_var)
}
