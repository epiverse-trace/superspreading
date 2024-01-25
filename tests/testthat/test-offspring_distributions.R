test_that("dpoislnorm works as expected", {
  expect_snapshot(dpoislnorm(x = 1, meanlog = 1, sdlog = 1))
  expect_snapshot(dpoislnorm(x = 1:10, meanlog = 1, sdlog = 1))
})

test_that("ppoislnorm works as expected", {
  expect_snapshot(ppoislnorm(q = 1, meanlog = 1, sdlog = 1))
  expect_snapshot(ppoislnorm(q = 1:10, meanlog = 1, sdlog = 1))
  expect_true(is.nan(ppoislnorm(q = NaN, meanlog = 1, sdlog = 1)))
  expect_true(is.na(ppoislnorm(q = NA, meanlog = 1, sdlog = 1)))
  expect_identical(unname(ppoislnorm(q = "1", meanlog = 1, sdlog = 1)), 0)
})

test_that("dpisweibull works as expected", {
  expect_snapshot(dpoisweibull(x = 1, shape = 1, scale = 1))
  expect_snapshot(dpoisweibull(x = 1:10, shape = 1, scale = 1))
})

test_that("ppoisweibull works as expected", {
  expect_snapshot(ppoisweibull(q = 1, shape = 1, scale = 1))
  expect_snapshot(ppoisweibull(q = 1:10, shape = 1, scale = 1))
  expect_true(is.nan(ppoisweibull(q = NaN, shape = 1, scale = 1)))
  expect_true(is.na(ppoisweibull(q = NA, shape = 1, scale = 1)))
  expect_identical(unname(ppoisweibull(q = "1", shape = 1, scale = 1)), 0)
})
