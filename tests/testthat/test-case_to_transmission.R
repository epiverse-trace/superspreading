test_that("proportion_transmission works as expected for single R and k", {
  res <- proportion_transmission(R = 2, k = 0.5, percent_transmission = 0.8)

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(1L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )

  res <- proportion_transmission(
    R = 2,
    k = 0.5,
    percent_transmission = 0.8,
    sim = TRUE
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(1L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_transmission works as expected for multiple R", {
  res <- proportion_transmission(
    R = c(1, 2, 3),
    k = 0.5,
    percent_transmission = 0.8
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(3L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )

  res <- proportion_transmission(
    R = c(1, 2, 3),
    k = 0.5,
    percent_transmission = 0.8,
    sim = TRUE
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(3L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_transmission works as expected for multiple R & k", {
  res <- proportion_transmission(
    R = c(1, 2, 3),
    k = c(0.1, 0.2, 0.3),
    percent_transmission = 0.8
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(9L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
  )

  res <- proportion_transmission(
    R = c(1, 2, 3),
    k = c(0.1, 0.2, 0.3),
    percent_transmission = 0.8,
    sim = TRUE
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(9L, 3L))
  expect_identical(
    unname(vapply(res, class, character(1))),
    c("numeric", "numeric", "character")
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
    proportion_transmission(R = 1, k = 0.1, percent_transmission = 0.8, sim = 1),
    regexp = "Assertion on 'sim' failed"
  )
})

test_that(".proportion_transmission_numerical works as expected", {
  res <- .proportion_transmission_numerical(
    R = 2,
    k = 0.5,
    percent_transmission = 0.8
  )
  expect_type(res, "double")
  expect_length(res, 1)
})

test_that(".proportion_transmission_analytical works as expected", {
  res <- .proportion_transmission_analytical(
    R = 2,
    k = 0.5,
    percent_transmission = 0.8
  )
  expect_type(res, "double")
  expect_length(res, 1)
})
