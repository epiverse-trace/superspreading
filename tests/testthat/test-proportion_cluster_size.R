test_that("proportion_cluster_size works as expected for single R and k", {
  res <- proportion_cluster_size(R = 2, k = 0.5, cluster_size = 5)

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(1L, 3L))
  expect_identical(
    unname(vapply(res, class, FUN.VALUE = character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_cluster_size works as expected for multiple R", {
  res <- proportion_cluster_size(
    R = c(1, 2, 3),
    k = 0.5,
    cluster_size = 5
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(3L, 3L))
  expect_identical(
    unname(vapply(res, class, FUN.VALUE = character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_cluster_size works as expected for multiple R & k", {
  res <- proportion_cluster_size(
    R = c(1, 2, 3),
    k = c(0.1, 0.2, 0.3),
    cluster_size = 5
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(9L, 3L))
  expect_identical(
    unname(vapply(res, class, FUN.VALUE = character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_cluster_size works as expected for multiple R & k & cs", {
  res <- proportion_cluster_size(
    R = c(1, 2, 3),
    k = c(0.1, 0.2, 0.3),
    cluster_size = c(5, 10, 25)
  )

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(9L, 5L))
  expect_identical(
    unname(vapply(res, class, FUN.VALUE = character(1))),
    c("numeric", "numeric", "character", "character", "character")
  )
})

test_that("proportion_cluster_size works as expected for format_prop = FALSE", {
  expect_snapshot_value(
    proportion_cluster_size(
      R = c(1, 2, 3),
      k = c(0.1, 0.2, 0.3),
      cluster_size = c(5, 10, 25),
      format_prop = FALSE
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("proportion_cluster_size fails as expected", {
  expect_error(
    proportion_cluster_size(R = "1", k = 0.1, cluster_size = 5),
    regexp = "Assertion on 'R' failed"
  )

  expect_error(
    proportion_cluster_size(R = 1, k = "0.1", cluster_size = 5),
    regexp = "Assertion on 'k' failed"
  )

  expect_error(
    proportion_cluster_size(R = 1, k = 0.1, cluster_size = "5"),
    regexp = "Assertion on 'cluster_size' failed"
  )
})

test_that("proportion_cluster_size works with <epiparameter>", {
  skip_if_not_installed(pkg = "epiparameter")
  od <- suppressMessages(
    epiparameter::epiparameter_db(
      disease = "SARS",
      epi_name = "offspring distribution",
      author = "Lloyd-Smith",
      single_epiparameter = TRUE
    )
  )
  res <- proportion_cluster_size(cluster_size = 20, offspring_dist = od)

  expect_s3_class(res, "data.frame")
  expect_identical(dim(res), c(1L, 3L))
  expect_identical(
    unname(vapply(res, class, FUN.VALUE = character(1))),
    c("numeric", "numeric", "character")
  )
})

test_that("proportion_cluster_size fails without R and k or <epiparameter>", {
  expect_error(
    proportion_cluster_size(cluster_size = 10),
    regexp = "Only one of `R` and `k` or `offspring_dist` must be supplied."
  )
})
