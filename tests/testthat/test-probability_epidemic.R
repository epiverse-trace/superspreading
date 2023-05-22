test_that("probability_epidemic works for R < 1", {
  expect_equal(probability_epidemic(R = 0.5, k = 0.5, a = 1), 0L)
  expect_equal(probability_epidemic(R = 0.5, k = 0.1, a = 1), 0L)
  expect_equal(probability_epidemic(R = 0.5, k = 0.5, a = 50), 0L)
})

test_that("probability_epidemic works for R > 1", {
  expect_equal(probability_epidemic(R = 1.5, k = 0.5, a = 1), 0.232)
})

test_that("probability_epidemic works for k == Inf", {
  expect_equal(probability_epidemic(R = 1.5, k = Inf, a = 1), 0.583)
})

test_that("probability_epidemic works for different k & a", {
  res1 <- probability_epidemic(R = 1.5, k = 0.5, a = 1)
  res2 <- probability_epidemic(R = 1.5, k = 0.2, a = 1)
  res3 <- probability_epidemic(R = 1.5, k = 0.5, a = 2)
  res4 <- probability_epidemic(R = 1.5, k = 0.2, a = 2)
  expect_true((res2 < res1) && (res4 < res3))
})

test_that("probability_epidemic fails correctly", {
  expect_error(
    probability_epidemic(R = "1", k = 1, a = 1),
    regexp = "(Assertion on 'R' failed)"
  )
  expect_error(
    probability_epidemic(R = 1, k = "1", a = 1),
    regexp = "(Assertion on 'k' failed)"
  )
  expect_error(
    probability_epidemic(R = 1, k = 1, a = "1"),
    regexp = "(Assertion on 'a' failed)"
  )
})

test_that("probability_extinct works for R < 1", {
  expect_equal(probability_extinct(R = 0.5, k = 0.5, a = 1), 1L)
  expect_equal(probability_extinct(R = 0.5, k = 0.1, a = 1), 1L)
  expect_equal(probability_extinct(R = 0.5, k = 0.5, a = 50), 1L)
})

test_that("probability_epidemic works for R > 1", {
  expect_equal(probability_extinct(R = 1.5, k = 0.5, a = 1), 0.768)
})
