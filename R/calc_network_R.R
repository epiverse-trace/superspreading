#' Calculate the reproduction number (\eqn{R}) for a (heterogeneous)
#' network
#'
#' @description
#' The calculation of the reproduction number adjusting for heterogeneity in
#' number of contacts.
#'
#' @param mean_num_contact A `numeric`, mean (average) number of new contacts
#'   per unit time.
#' @param sd_num_contact A `numeric`, standard deviation of the number of new
#'   contacts per unit time.
#' @param infect_duration A `numeric`, the duration of infectiousness.
#' @param prob_transmission A `numeric` probability of transmission per contact,
#'   also known as \eqn{\beta}.
#' @param age_range A `numeric` vector with two elements, the lower and upper
#'   age limits of individuals in the network.
#'
#' @return A named `numeric` vector of length 2, the unadjusted (`R`)
#'   and network adjusted (`R_net`) estimates of \eqn{R}.
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
                           age_range) {
  checkmate::assert_number(mean_num_contact, lower = 0, finite = TRUE)
  checkmate::assert_number(sd_num_contact, lower = 0, finite = TRUE)
  checkmate::assert_number(infect_duration, lower = 0, finite = TRUE)
  checkmate::assert_number(prob_transmission, lower = 0, finite = TRUE)
  checkmate::assert_numeric(age_range, len = 2, lower = 0, finite = TRUE)

  # define measured contacts (e.g. sexual contacts)
  # normalise by time active in the network (e.g. sexually active)
  scale_by_active <- 1 / (max(age_range) - min(age_range))
  # calculate new partners per time
  contacts_per_time <- c(
    mean = mean_num_contact * scale_by_active,
    var = sd_num_contact^2 * scale_by_active^2
  )

  # calculate R0 with and without correction
  R0 <- prob_transmission * contacts_per_time[["mean"]] * infect_duration
  R0_net <- prob_transmission * infect_duration *
    (contacts_per_time[["mean"]] + contacts_per_time[["var"]] /
      contacts_per_time[["mean"]])

  # return R0 with and without variance correction
  c(R = R0, R_net = R0_net)
}
