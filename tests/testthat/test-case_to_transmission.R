test_that("cases_to_transmission works as expected for single R and k", {
  res <- cases_to_transmission(R = 2, k = 0.5, percent_transmission = 0.8)

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(1L, 3L))
  expect_identical(
    unname(sapply(res, class)),
    c("numeric", "numeric", "character")
  )
})

test_that("cases_to_transmission works as expected for multiple R", {
  res <- cases_to_transmission(
    R = c(1, 2, 3),
    k = 0.5,
    percent_transmission = 0.8
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(3L, 3L))
  expect_identical(
    unname(sapply(res, class)),
    c("numeric", "numeric", "character")
  )
})

test_that("cases_to_transmission works as expected for multiple R & k", {
  res <- cases_to_transmission(
    R = c(1, 2, 3),
    k = c(0.1, 0.2, 0.3),
    percent_transmission = 0.8
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(9L, 3L))
  expect_identical(
    unname(sapply(res, class)),
    c("numeric", "numeric", "character")
  )
})

test_that("cases_to_transmission fails as expected", {
  expect_error(
    cases_to_transmission(R = "1", k = 0.1, percent_transmission = 0.8),
    regexp = "Assertion on 'R' failed"
  )

  expect_error(
    cases_to_transmission(R = 1, k = "0.1", percent_transmission = 0.8),
    regexp = "Assertion on 'k' failed"
  )

  expect_error(
    cases_to_transmission(R = 1, k = 0.1, percent_transmission = "0.8"),
    regexp = "Assertion on 'percent_transmission' failed"
  )
})

