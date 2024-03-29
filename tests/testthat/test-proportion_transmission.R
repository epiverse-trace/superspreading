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

test_that("proportion_transmission works with <epidist>", {
  skip_if_not_installed(pkg = "epiparameter")
  edist <- suppressMessages(
    epiparameter::epidist_db(
      disease = "SARS",
      epi_dist = "offspring distribution",
      author = "Lloyd-Smith",
      single_epidist = TRUE
    )
  )
  expect_snapshot(
    proportion_transmission(
      percent_transmission = 0.8,
      offspring_dist = edist
    )
  )
})

test_that("proportion_transmission fails without R and k or <epidist>", {
  expect_error(
    proportion_transmission(percent_transmission = 0.8),
    regexp = "Only one of R and k or <epidist> must be supplied."
  )
})
