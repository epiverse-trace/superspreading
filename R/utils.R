#' Get a parameter out of <epidist>
#'
#' @inheritParams probability_epidemic
#' @param parameter A character string, either `"R"` or `"k"`.
#'
#' @return An unnamed numeric.
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

#' Helper function to create a model comparison table
#'
#' @description This is a helper function for creating a model comparison
#' `<data.frame>` primarily for use in the \pkg{superspreading} vignettes. It
#' is designed specifically for handling [fitdistrplus::fitdist()] output and
#' not a generalised function. See [bbmle::ICtab()] for a more general use
#' function to create information criteria tables.
#'
#' @param ... [dots] One or more model fit results from
#' [fitdistrplus::fitdist()].
#' @param sort_by A `character` string specifying which information criterion
#' to order the table by, either `"AIC"` (default) or `"BIC"`.
#'
#' @return A `<data.frame>`.
#' @export
ic_tbl <- function(..., sort_by = c("AIC", "BIC")) {

  sort_by <- match.arg(sort_by)
  models <- list(...)

  # input checking
  stopifnot(
    "Input objects must be <fitdist>" =
      vapply(
        models,
        checkmate::test_class,
        FUN.VALUE = logical(1),
        classes = "fitdist"
      )
  )

  distribution <- vapply(models, "[[", FUN.VALUE = character(1), "distname")
  aic <- vapply(models, "[[", FUN.VALUE = numeric(1), "aic")
  bic <- vapply(models, "[[", FUN.VALUE = numeric(1), "bic")

  delta_aic <- aic - min(aic)
  delta_bic <- bic - min(bic)

  aic_weight <- exp((-delta_aic) / 2) / sum(exp((-delta_aic) / 2))
  bic_weight <- exp((-delta_bic) / 2) / sum(exp((-delta_bic) / 2))

  model_tbl <- data.frame(
    distribution = distribution,
    AIC = aic,
    DeltaAIC = delta_aic,
    wAIC = aic_weight,
    BIC = bic,
    DeltaBIC = delta_bic,
    wBIC = bic_weight
  )

  model_tbl <- model_tbl[order(model_tbl[[sort_by]]), ]

  # return tbl
  model_tbl
}
