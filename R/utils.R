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
#' to order the table by, either `"AIC"` (default), `"BIC"`, or `"none"`
#' (i.e. no ordering).
#'
#' @return A `<data.frame>`.
#' @export
#' @examples
#' if (requireNamespace("fitdistrplus", quietly = TRUE)) {
#'   cases <- rnbinom(n = 100, mu = 5, size = 0.7)
#'   pois_fit <- fitdistrplus::fitdist(data = cases, distr = "pois")
#'   geom_fit <- fitdistrplus::fitdist(data = cases, distr = "geom")
#'   nbinom_fit <- fitdistrplus::fitdist(data = cases, distr = "nbinom")
#'   ic_tbl(pois_fit, geom_fit, nbinom_fit)
#' }
ic_tbl <- function(..., sort_by = c("AIC", "BIC", "none")) {

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

  if (sort_by != "none") {
    model_tbl <- model_tbl[order(model_tbl[[sort_by]]), ]
    row.names(model_tbl) <- NULL
  }


  # return tbl
  model_tbl
}

#' Optimise a function using either numerical optimisation or grid search
#'
#' @details
#' Arguments passed through [dots] depend on whether `fit_method` is set to
#' `"optim"` or `"grid"`. For `"optim"`, arguments are passed to [optim()],
#' for `"grid"`, the variable arguments are `lower`, `upper` (lower and
#' upper bounds on the grid search for the parameter being optimised, defaults
#' are `lower = 0.001` and `upper = 0.999`), and `"res"` (the resolution of
#' grid, default is `res = 0.001`).
#'
#' @param func A `function`.
#' @param fit_method A `character` string, either `"optim"` or `"grid"`.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Named elements to replace
#' default optimisation settings for either [optim()] or grid search. See
#' details.
#'
#' @return A single `numeric`.
#' @keywords internal
.fit <- function(func,
                 fit_method = c("optim", "grid"),
                 ...) {
  if (!is.function(func)) {
    stop("func must be a function", call. = FALSE)
  }
  fit_method <- match.arg(fit_method)

  # capture dynamic dots
  dots <- rlang::dots_list(..., .ignore_empty = "none", .homonyms = "error")
  dots_names <- names(dots)

  args <- list(
    lower = 0.001,
    upper = 0.999
  )

  func_args <- names(formals(func))
  if (fit_method == "optim") {
    optim_args <- names(formals("optim"))
    args <- c(args, method = "Brent")
    chk_args <- unique(c(names(args), func_args, optim_args))
  } else {
    args <- c(args, res = 0.001)
    chk_args <- unique(c(names(args), func_args))
  }
  # replace default args if in dots
  args <- utils::modifyList(args, dots)

  # check arguments in dots match arg list
  stopifnot(
    "Arguments supplied in `...` not valid" =
      all(dots_names %in% chk_args)
  )

  if (fit_method == "optim") {
    optim_dots <- args[!names(args) %in% c("lower", "upper", "method")]
    prob_est <- do.call(
      stats::optim,
      args = c(
        par = 0.5,
        fn = func,
        gr = NULL,
        optim_dots,
        method = args$method,
        lower = args$lower,
        upper = args$upper
      )
    )
    prob_est <- prob_est$par
  } else {
    # set up grid search
    ss <- seq(args$lower, args$upper, args$res)
    args <- c(ss = list(ss), args)
    args <- args[!names(args) %in% c("lower", "upper", "res")]
    prob_est <- do.call(func, args = args)
    prob_est <- ss[which.min(prob_est)]
  }

  # return estimate
  prob_est
}

`%||%` <- function(x, y) if (is.null(x)) y else x

#' Defines the gamma functions in terms of the mean reproductive number
#' (R) and the dispersion parameter (k)
#'
#' @description
#' * [dgammaRk()] for the gamma density function
#' * [pgammaRk()] for the gamma distribution function
#' * [fvx()] fore the gamma probability density function (pdf) describing the
#' individual reproductive number \eqn{\nu} given R0 and k
#'
#' @inheritParams stats::dgamma
#' @inheritParams probability_epidemic
#'
#' @keywords internal
#' @name gamma
dgammaRk <- function(x, R, k) {
  out <- stats::dgamma(x, shape = k, scale = R / k)
  return(out)
}

#' @name gamma
pgammaRk <- function(x, R, k) {
  out <- stats::pgamma(x, shape = k, scale = R / k)
  return(out)
}

#' @name gamma
fvx <- function(x, R, k) {
  dgammaRk(x = x, R = R, k = k)
}


#' Generates a log scaled sequence of real numbers
#'
#' @inheritParams base::seq
#'
#' @inherit base::seq return
#' @keywords internal
lseq <- function(from, to, length.out) {
  exp(seq(log(from), log(to), length.out = length.out))
}

#' Unitroot solver for the solution to u, or the value of x from the gamma CDF
#' given the desired proportion of transmission
#'
#' @return A `numeric` with the location of the root.
#' @keywords internal
#' @noRd
solve_for_u <- function(prop, R, k) {
  f <- function(x, prop) {
    res <- 1 - pgammaRk(x, R, k)
    res - prop
  }
  # Initial interval for u
  lower <- 0
  upper <- 1
  # Find the root using uniroot
  root <- stats::uniroot(
    f,
    prop = prop,
    interval = c(lower, upper),
    extendInt = "yes"
  )
  return(root$root)
}
