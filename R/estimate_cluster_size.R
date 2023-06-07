#' Calculate the parameters of an offspring distribution given a cluster size(s)
#'
#' @param x A vector of cluster sizes
#' @inheritParams probability_epidemic
#' @param offspring A specified offspring distribution
#'
#' @return A vector of named parameter values and the associated
#' maximum likleihood value
#' @export
#'
#' @examples
#' cluster_sizes <- c(rep(1, 11), rep(2, 2), rep(3, 3), 4, rep(5, 2), 24)
#' estimate_cluster_size(x = cluster_sizes, R = 2, k = 0.5)
estimate_cluster_size <- function(x, R, k, offspring = "nbinom") {
  # set up loglikelihood to optimise
  ll_func <- function(x, R, k) {
    bpmodels::chain_ll(x = x, offspring = "nbinom", size = k, mu = R)
  }

  # optimise loglikelihood
  return(
    quickfit::estimate_mle(
      log_likelihood = ll_func,
      data_in = x,
      n_param = 2,
      a_initial = 1,
      b_initial = 1
    )
  )
}
