#' Get a parameter out of <epiparameter>
#'
#' @inheritParams probability_epidemic
#' @param parameter A character string, either `"R"` or `"k"`.
#'
#' @return An unnamed numeric.
#' @keywords internal
#' @noRd
get_epiparameter_param <- function(epiparameter,
                                   parameter = c("R", "k")) {
  # check inputs (<epiparameter> already checked)
  parameter <- match.arg(parameter)

  # extract parameters from <epiparameter>
  params <- epiparameter::get_parameters(epiparameter)

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
        paste(
          "Cannot find %s in <epiparameter>,",
          "check if parameters have correct names."
        ),
        parameter
      ),
      call. = FALSE
    )
  }

  unname(params[idx])
}

#' Helper function to create a model comparison table
#'
#' @description
#' This is a helper function for creating a model comparison `<data.frame>`
#' primarily for use in the \pkg{superspreading} vignettes. It is designed
#' specifically for handling [fitdistrplus::fitdist()] output and not a
#' generalised function. See `bbmle::ICtab()` for a more general use function
#' to create information criteria tables.
#'
#' @param ... [dots] One or more model fit results from
#'   [fitdistrplus::fitdist()].
#' @param sort_by A `character` string specifying which information criterion
#'   to order the table by, either `"AIC"` (default), `"BIC"`, or `"none"`
#'   (i.e. no ordering).
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
#'   default optimisation settings for either [optim()] or grid search. See
#'   details.
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

  fit_args <- list(
    lower = 0.001,
    upper = 0.999
  )

  func_args <- names(formals(func))
  if (fit_method == "optim") {
    optim_args <- names(formals("optim"))
    fit_args <- c(fit_args, method = "Brent")
    chk_args <- unique(c(names(fit_args), func_args, optim_args))
  } else {
    fit_args <- c(fit_args, res = 0.001)
    chk_args <- unique(c(names(fit_args), func_args))
  }
  # replace default args if in dots
  fit_args <- utils::modifyList(fit_args, dots)

  # check arguments in dots match arg list
  stopifnot(
    "Arguments supplied in `...` not valid" =
      dots_names %in% chk_args
  )

  if (fit_method == "optim") {
    optim_dots <- fit_args[!names(fit_args) %in% c("lower", "upper", "method")]
    prob_est <- do.call(
      stats::optim,
      args = c(
        par = 0.5,
        fn = func,
        gr = NULL,
        optim_dots,
        method = fit_args$method,
        lower = fit_args$lower,
        upper = fit_args$upper
      )
    )
    prob_est <- prob_est$par
  } else {
    # set up grid search
    ss <- seq(fit_args$lower, fit_args$upper, fit_args$res)
    fit_args <- c(ss = list(ss), fit_args)
    fit_args <- fit_args[!names(fit_args) %in% c("lower", "upper", "res")]
    prob_est <- do.call(func, args = fit_args)
    prob_est <- ss[which.min(prob_est)]
  }

  # return estimate
  prob_est
}

`%||%` <- function(x, y) if (is.null(x)) y else x

`%gt%` <- function(x, y) {
  if (any(x > y)) {
    # message uses var name in current frame so may not match user-defined var
    message(
      "Values of `", deparse(substitute(x)), "` > ", y, " are set to ", y,
      " due to numerical integration issues at higher values."
    )
    x[x > y] <- y
  }
  x
}

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
  stats::dgamma(x, shape = k, scale = R / k)
}

#' @name gamma
pgammaRk <- function(x, R, k) {
  stats::pgamma(x, shape = k, scale = R / k)
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
  root$root
}


#' Simulate transmission chains using a stochastic branching process
#'
#' @description
#' Code modified from the `bpmodels::chain_sim()` function.
#' The function `chain_sim()` function from \pkg{bpmodels} is reused with
#' permission and licensed under MIT as is \pkg{bpmodels}.
#' \pkg{bpmodels} is not on CRAN and is retired.
#'
#' @author Sebastian Funk, James M. Azam, Joshua W. Lambert
#'
#' @param n Number of simulations to run.
#' @param offspring Offspring distribution: a character string corresponding to
#'   the R distribution function (e.g., "pois" for Poisson, where
#'   [rpois()] is the R function to generate Poisson random numbers).
#' @param stat String; Statistic to calculate. Can be one of:
#' \itemize{
#'   \item "size": the total number of offspring.
#'   \item "length": the total number of ancestors.
#' }
#' @param stat_threshold A size or length above which the simulation results
#'   should be set to `Inf`. Defaults to `Inf`, resulting in no results
#'   ever set to `Inf`
#' @param generation_time The generation time generator function; the name of a
#'   user-defined named or anonymous function with only one argument `n`,
#'   representing the number of generation times to generate.
#' @param tf End time (if `generation_time` interval is given).
#' @param ... Parameters of the offspring distribution as required by R.
#'
#' @return A `<data.frame>` with columns `n` (simulation ID), `id` (a unique
#'   ID within each simulation for each individual element of the chain),
#'   `ancestor` (the ID of the ancestor of each element), and `generation`. A
#'   `time` column is also appended if the generation_time interval is supplied
#'   to `serial`.
#' @keywords internal
.chain_sim <- function(n, offspring, stat = c("size", "length"), # nolint cyclocomp_linter
                      stat_threshold = Inf, generation_time, tf = Inf, ...) {
  stat <- match.arg(stat)

  # first, get random function as given by `offspring`
  if (!is.character(offspring)) {
    stop(
      sprintf("%s %s",
              "Object passed as 'offspring' is not a character string.",
              "Did you forget to enclose it in quotes?"
      ),
      call. = FALSE
    )
  }

  roffspring_name <- paste0("r", offspring)
  if (!(exists(roffspring_name)) || !is.function(get(roffspring_name))) {
    stop("Function ", roffspring_name, " does not exist.", call. = FALSE)
  }
  # If both parameters of the negative binomial are zero, you get NaNs
  if (roffspring_name == "rnbinom" && all(c(...) == 0)) {
    stop(
      "The negative binomial parameters must have at least one ",
      "non-zero parameter.",
      call. = FALSE
    )
  }

  if (!missing(generation_time)) {
    if (!is.function(generation_time)) {
      stop(
        sprintf("%s %s",
                "The `generation_time` argument must be a function",
                "(see details in ?.chain_sim)."
        ),
        call. = FALSE
      )
    }
  } else if (!missing(tf)) {
    stop(
      "If `tf` is specified, `generation_time` must be specified too.",
      call. = FALSE
    )
  }

  stat_track <- rep(1, n) # track length or size (depending on `stat`)
  n_offspring <- rep(1, n) # current number of offspring
  sim <- seq_len(n) # track chains that are still being simulated

  # initialise data frame to hold the trees
  generation <- 1L
  tdf <-
    data.frame(
      n = seq_len(n),
      id = 1L,
      ancestor = NA_integer_,
      generation = generation
    )

  ancestor_ids <- rep(1, n)
  if (!missing(generation_time)) {
    tdf$time <- 0
    times <- tdf$time
  }

  # next, simulate n chains
  while (length(sim) > 0) {
    # simulate next generation
    next_gen <- get(roffspring_name)(n = sum(n_offspring[sim]), ...)
    if (any(next_gen %% 1 > 0)) {
      stop("Offspring distribution must return integers", call. = FALSE)
    }

    # record indices corresponding to the number of offspring
    indices <- rep(sim, n_offspring[sim])

    # initialise number of offspring
    n_offspring <- rep(0, n)
    # assign offspring sum to indices still being simulated
    n_offspring[sim] <- tapply(next_gen, indices, sum)

    # track size/length
    if (stat == "size") {
      stat_track <- stat_track + n_offspring
    } else if (stat == "length") {
      stat_track <- stat_track + pmin(1, n_offspring)
    }

    # record times/ancestors
    if (sum(n_offspring[sim]) > 0) {
      ancestors <- rep(ancestor_ids, next_gen)
      current_max_id <- unname(tapply(ancestor_ids, indices, max))
      indices <- rep(sim, n_offspring[sim])
      ids <- rep(current_max_id, n_offspring[sim]) +
        unlist(lapply(n_offspring[sim], seq_len))
      generation <- generation + 1L
      new_df <-
        data.frame(
          n = indices,
          id = ids,
          ancestor = ancestors,
          generation = generation
        )
      if (!missing(generation_time)) {
        times <- rep(times, next_gen) + generation_time(sum(n_offspring))
        current_min_time <- unname(tapply(times, indices, min))
        new_df$time <- times
      }
      tdf <- rbind(tdf, new_df)
    }

    # only continue to simulate chains that offspring and aren't of
    # infinite size/length
    sim <- which(n_offspring > 0 & stat_track < stat_threshold)
    if (length(sim) > 0) {
      if (!missing(generation_time)) {
        # only continue to simulate chains that don't go beyond tf
        sim <- intersect(sim, unique(indices)[current_min_time < tf])
      }
      if (!missing(generation_time)) {
        times <- times[indices %in% sim]
      }
      ancestor_ids <- ids[indices %in% sim]
    }
  }

  if (!missing(tf)) {
    tdf <- tdf[tdf$time < tf, ]
  }
  rownames(tdf) <- NULL
  tdf
}

#' Check if input parameters are correctly specified by user
#'
#' @param missing_params A `logical` boolean.
#' @param missing_offspring_dist A `logical` boolean.
#'
#' @return Invisibly returns `missing_params` or errors. Called for
#'   side-effect.
#' @keywords internal
#' @noRd
.check_input_params <- function(missing_params, missing_offspring_dist) {
  if (!xor(missing_params, missing_offspring_dist)) {
    stop(
      "Only one of `R` and `k` or `offspring_dist` must be supplied.",
      call. = FALSE
    )
  }
  invisible(missing_params)
}

#' Constants used in \pkg{superspreading}
#'
#' @name constants
#'
#' @description
#' `FINITE_INF` is a large finite number used to approximate `Inf`.
#'
#' `NSIM` is the number of simulations run when generating random samples or
#' branching process simulation replicates.

#' @rdname constants
FINITE_INF <- 1e5

#' @rdname constants
NSIM <- 1e5
