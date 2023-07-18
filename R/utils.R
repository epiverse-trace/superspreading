#' Get a parameter out of <epidist>
#'
#' @inheritParams probability_epidemic
#' @param parameter A character string, either `"R"` or `"k"`.
#'
#' @return An unnamed numeric
#' @keywords internal
#' @noRd
get_epidist_param <- function(epidist,
                              parameter = c("R", "k")) {
  # check inputs (<epidist> already checked)
  parameter <- match.arg(parameter)

  # extract parameters from <epidist>
  params <- epiparameter::get_parameters(epidist)

  regexpr_pattern <- switch(parameter,
    R = "^r$|^r0$|^mean$",
    k = "^k$|^dispersion$|^overdispersion$"
  )

  idx <- grep(
    pattern = regexpr_pattern,
    x = names(params),
    ignore.case = TRUE
  )

  if (length(idx) == 0) {
    stop(
      sprintf(
        "Cannot find %s in <epidist>, check if parameters have correct names.",
        parameter
      ),
      call. = FALSE
    )
  }

  return(unname(params[idx]))
}
