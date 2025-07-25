#' Estimate what proportion of new cases originated within a transmission
#' event of a given size
#'
#' @description
#' Calculates the proportion of new cases that originated with a transmission
#' event of a given size. It can be useful to inform backwards contact tracing
#' efforts, i.e. how many cases are associated with large clusters. Here we
#' define a cluster to as a transmission of a primary case to at least one
#' secondary case.
#'
#' @details
#' This function calculates the proportion of secondary cases that are caused
#' by transmission events of a certain size. It does not calculate the
#' proportion of transmission events that cause a cluster of secondary cases
#' of a certain size. In other words it is the number of cases above a
#' threshold divided by the total number of cases, not the number of
#' transmission events above a certain threshold divided by the number of
#' transmission events.
#'
#' @inheritParams probability_epidemic
#' @param cluster_size A `number` for the cluster size threshold.
#' @param ... [dots] not used, extra arguments supplied will cause a warning.
#' @param format_prop A `logical` determining whether the proportion column
#'   of the `<data.frame>` returned by the function is formatted as a string
#'   with a percentage sign (`%`), (`TRUE`, default), or as a `numeric`
#'   (`FALSE`).
#'
#' @return A `<data.frame>` with the value for the proportion of new cases
#'   that are part of a transmission event above a threshold for a given value
#'   of R and k.
#' @export
#'
#' @examples
#' R <- 2
#' k <- 0.1
#' cluster_size <- 10
#' proportion_cluster_size(R = R, k = k, cluster_size = cluster_size)
#'
#' # example with a vector of k
#' k <- c(0.1, 0.2, 0.3, 0.4, 0.5)
#' proportion_cluster_size(R = R, k = k, cluster_size = cluster_size)
#'
#' # example with a vector of cluster sizes
#' cluster_size <- c(5, 10, 25)
#' proportion_cluster_size(R = R, k = k, cluster_size = cluster_size)
proportion_cluster_size <- function(R, k, cluster_size, ..., offspring_dist,
                                    format_prop = TRUE) {
  missing_params <- missing(R) && missing(k)
  .check_input_params(
    missing_params = missing_params,
    missing_offspring_dist = missing(offspring_dist)
  )

  # check inputs
  chkDots(...)
  if (missing_params) {
    checkmate::assert_class(offspring_dist, classes = "epiparameter")
    R <- get_epiparameter_param(epiparameter = offspring_dist, parameter = "R")
    k <- get_epiparameter_param(epiparameter = offspring_dist, parameter = "k")
  }
  checkmate::assert_numeric(R, lower = 0, finite = TRUE)
  checkmate::assert_numeric(k, lower = 0)
  checkmate::assert_integerish(cluster_size, lower = 1)
  checkmate::assert_logical(format_prop, any.missing = FALSE, len = 1)

  params <- expand.grid(R, k)
  params <- cbind(
    params,
    as.data.frame(matrix(nrow = 1, ncol = length(cluster_size)))
  )
  colnames(params) <- c("R", "k", paste0("prop_", cluster_size))

  for (i in seq_len(nrow(params))) {
    simulate_secondary <- stats::rnbinom(
      n = NSIM,
      mu = params[i, "R"],
      size = params[i, "k"]
    )
    propn_cluster <- vapply(cluster_size, function(x) {
      sum(simulate_secondary[simulate_secondary >= x])
    }, FUN.VALUE = numeric(1)) / sum(simulate_secondary)
    if (format_prop) {
      propn_cluster <- paste0(signif(propn_cluster * 100, digits = 3), "%")
    }
    col_idx <- seq(3, 2 + length(propn_cluster), by = 1)
    params[i, col_idx] <- propn_cluster
  }
  params
}
