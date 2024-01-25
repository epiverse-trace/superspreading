if (requireNamespace("epiparameterr", quietly = TRUE)) {
  edist <- suppressMessages(
    epiparameter::epidist_db(
      disease = "SARS",
      epi_dist = "offspring distribution",
      author = "Lloyd-Smith",
      single_epidist = TRUE
    )
  )
}

test_that("get_param works as expected", {
  skip_if_not_installed(pkg = "epiparameter")
  expect_type(get_epidist_param(epidist = edist, parameter = "R"), "double")
  expect_type(get_epidist_param(epidist = edist, parameter = "k"), "double")
})

test_that("get_param fails as expected", {
  skip_if_not_installed(pkg = "epiparameter")
  expect_error(
    get_epidist_param(epidist = edist, parameter = "random"),
    regexp = "(arg)*(should be one of)*(R)*(k)"
  )
  expect_error(get_epidist_param(epidist = list(), parameter = "R"))
})

test_that("get_param fails as expected with incorrect parameters", {
  skip_if_not_installed(pkg = "epiparameter")
  edist <- suppressMessages(
    epiparameter::epidist_db(
      disease = "COVID-19",
      epi_dist = "incubation period",
      author = "Linton",
      single_epidist = TRUE
    )
  )
  expect_error(
    get_epidist_param(epidist = edist, parameter = "R"),
    regexp = "(arg)*(should be one of)*(R)*(k)"
  )
})

test_that("ic_tbl works as expected", {
  skip_if_not_installed(pkg = "fitdistrplus")
  set.seed(1)
  cases <- rnbinom(n = 100, mu = 5, size = 0.7)
  pois_fit <- fitdistrplus::fitdist(data = cases, distr = "pois")
  geom_fit <- fitdistrplus::fitdist(data = cases, distr = "geom")
  nbinom_fit <- fitdistrplus::fitdist(data = cases, distr = "nbinom")
  expect_snapshot(ic_tbl(pois_fit, geom_fit, nbinom_fit))
})

test_that("ic_tbl works as expected with sort_by = BIC", {
  skip_if_not_installed(pkg = "fitdistrplus")
  set.seed(1)
  cases <- rnbinom(n = 100, mu = 5, size = 0.7)
  pois_fit <- fitdistrplus::fitdist(data = cases, distr = "pois")
  geom_fit <- fitdistrplus::fitdist(data = cases, distr = "geom")
  nbinom_fit <- fitdistrplus::fitdist(data = cases, distr = "nbinom")
  expect_snapshot(ic_tbl(pois_fit, geom_fit, nbinom_fit, sort_by = "BIC"))
})

test_that("ic_tbl works as expected with sort_by = none", {
  skip_if_not_installed(pkg = "fitdistrplus")
  set.seed(1)
  cases <- rnbinom(n = 100, mu = 5, size = 0.7)
  pois_fit <- fitdistrplus::fitdist(data = cases, distr = "pois")
  geom_fit <- fitdistrplus::fitdist(data = cases, distr = "geom")
  nbinom_fit <- fitdistrplus::fitdist(data = cases, distr = "nbinom")
  expect_snapshot(ic_tbl(pois_fit, geom_fit, nbinom_fit, sort_by = "none"))
})

test_that("ic_tbl fails as expected", {
  skip_if_not_installed(pkg = "fitdistrplus")
  cases <- rnbinom(n = 100, mu = 5, size = 0.7)
  pois_fit <- fitdistrplus::fitdist(data = cases, distr = "pois")
  geom_fit <- fitdistrplus::fitdist(data = cases, distr = "geom")
  nbinom_fit <- fitdistrplus::fitdist(data = cases, distr = "nbinom")
  expect_error(
    ic_tbl(pois_fit, geom_fit, nbinom_fit, sort_by = "WIC"),
    regexp = "(arg)*(should be one of)*(AIC)*(BIC)"
  )

  pois_fit <- unclass(pois_fit)
  expect_error(ic_tbl(pois_fit), regexp = "Input objects must be <fitdist>")
})

test_that(".fit works as expected" ,{
  func <- function(x) {
    (x - 3)^2 + 5
  }
  expect_equal(.fit(func = func, fit_method = "optim", upper = 5), 3)
})

test_that(".fit fails as expected", {
  expect_error(
    .fit(func = "function", fit_method = "optim"),
    regexp = "func must be a function"
  )
  func <- function(x) {
    (x - 3)^2 + 5
  }
  expect_error(
    .fit(func = func, fit_method = "other"),
    regexp = "(arg)*(should be one of)*(optim)*(grid)"
  )
  expect_error(
    .fit(func = func, fit_method = "optim", a = 1, a = 2),
    regexp = "(Arguments)*(must have unique names)"
  )
  expect_error(
    .fit(func = func, fit_method = "optim", mthod = "L-BFGS-B"),
    regexp = "Arguments supplied in `...` not valid"
  )
  expect_error(
    .fit(func = func, fit_method = "grid", method = "L-BFGS-B"),
    regexp = "Arguments supplied in `...` not valid"
  )
})
