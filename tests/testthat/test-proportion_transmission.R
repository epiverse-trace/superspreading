test_that("proportion_transmission works as expected for single R and k", {
  expect_snapshot(
    proportion_transmission(R = 2, k = 0.5, percent_transmission = 0.8)
  )

  res <- proportion_transmission(
    R = 2,
    k = 0.5,
    percent_transmission = 0.8,
    simulate = TRUE
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(1L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_transmission works as expected for multiple R", {
  expect_snapshot(
    proportion_transmission(
      R = c(1, 2, 3),
      k = 0.5,
      percent_transmission = 0.8
    )
  )

  res <- proportion_transmission(
    R = c(1, 2, 3),
    k = 0.5,
    percent_transmission = 0.8,
    simulate = TRUE
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(3L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_transmission works as expected for multiple R & k", {
  expect_snapshot(
    proportion_transmission(
      R = c(1, 2, 3),
      k = c(0.1, 0.2, 0.3),
      percent_transmission = 0.8
    )
  )

  res <- proportion_transmission(
    R = c(1, 2, 3),
    k = c(0.1, 0.2, 0.3),
    percent_transmission = 0.8,
    simulate = TRUE
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(9L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_transmission works as expected for format_prop = FALSE", {
  expect_snapshot(
    proportion_transmission(
      R = c(1, 2, 3),
      k = c(0.1, 0.2, 0.3),
      percent_transmission = 0.8,
      format_prop = FALSE
    )
  )
})

test_that("proportion_transmission fails as expected", {
  expect_error(
    proportion_transmission(R = "1", k = 0.1, percent_transmission = 0.8),
    regexp = "Assertion on 'R' failed"
  )

  expect_error(
    proportion_transmission(R = 1, k = "0.1", percent_transmission = 0.8),
    regexp = "Assertion on 'k' failed"
  )

  expect_error(
    proportion_transmission(R = 1, k = 0.1, percent_transmission = "0.8"),
    regexp = "Assertion on 'percent_transmission' failed"
  )

  expect_error(
    proportion_transmission(
      R = 1,
      k = 0.1,
      percent_transmission = 0.8,
      simulate = 1
    ),
    regexp = "Assertion on 'simulate' failed"
  )
})

test_that(".prop_transmission_numerical works as expected", {
  expect_snapshot_value(
    .prop_transmission_numerical(
      R = 2,
      k = 0.5,
      percent_transmission = 0.8
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that(".prop_transmission_analytical works as expected", {
  expect_snapshot(
    .prop_transmission_analytical(
      R = 2,
      k = 0.5,
      percent_transmission = 0.8
    )
  )
})

test_that("proportion_transmission works with <epiparameter>", {
  skip_if_not_installed(pkg = "epiparameter")
  od <- suppressMessages(
    epiparameter::epiparameter_db(
      disease = "SARS",
      epi_dist = "offspring distribution",
      author = "Lloyd-Smith",
      single_epiparameter = TRUE
    )
  )
  expect_snapshot(
    proportion_transmission(
      percent_transmission = 0.8,
      offspring_dist = od
    )
  )
})

test_that("proportion_transmission works for t_20 method", {
  # R0 = 3 and k = 1, the upper 20% most infectious individuals are expected
  # to produce 52% of all transmissions
  df <- proportion_transmission(
    R = 3,
    k = 1,
    percent_transmission = 0.2,
    method = "t_20",
    format_prop = FALSE
  )
  expect_equal(df$prop_20, expected = 0.52, tolerance = 0.1)

  df <- proportion_transmission(
    R = 2,
    k = 10e4,
    percent_transmission = 0.2,
    method = "t_20",
    format_prop = FALSE
  )
  expect_equal(df$prop_20, expected = 0.20, tolerance = 0.1)
})

test_that("proportion_transmission fails without R and k or <epiparameter>", {
  expect_error(
    proportion_transmission(percent_transmission = 0.8),
    regexp = "Only one of R and k or <epiparameter> must be supplied."
  )
})
