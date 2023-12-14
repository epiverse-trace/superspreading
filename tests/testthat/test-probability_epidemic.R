test_that("probability_epidemic works for R < 1", {
  expect_identical(
    probability_epidemic(R = 0.5, k = 0.5, num_init_infect = 1),
    0
  )
  expect_identical(
    probability_epidemic(R = 0.5, k = 0.1, num_init_infect = 1),
    0
  )
  expect_identical(
    probability_epidemic(R = 0.5, k = 0.5, num_init_infect = 50),
    0
  )
})

test_that("probability_epidemic works for R > 1", {
  expect_equal(
    probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1),
    0.232
  )
})

test_that("probability_epidemic works for k == Inf", {
  expect_equal(
    probability_epidemic(R = 1.5, k = Inf, num_init_infect = 1),
    0.583
  )
})

test_that("probability_epidemic works for different k & num_init_infect", {
  res1 <- probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1)
  res2 <- probability_epidemic(R = 1.5, k = 0.2, num_init_infect = 1)
  res3 <- probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 2)
  res4 <- probability_epidemic(R = 1.5, k = 0.2, num_init_infect = 2)
  expect_true((res2 < res1))
  expect_true((res4 < res3))
})

test_that("probability_epidemic works with individual-level control", {
  expect_equal(
    probability_epidemic(
      R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.2
    ),
    0.091
  )
})

test_that("probability_epidemic works with population-level control", {
  expect_equal(
    probability_epidemic(
      R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.2
    ),
    0.113
  )
})

test_that("probability_epidemic works with both control measures", {
  expect_equal(
    probability_epidemic(
      R = 1.5,
      k = 0.5,
      num_init_infect = 1,
      ind_control = 0.1,
      pop_control = 0.1
    ),
    0.108
  )
})

test_that("probability_epidemic fails correctly", {
  expect_error(
    probability_epidemic(R = "1", k = 1, num_init_infect = 1),
    regexp = "(Assertion on 'R' failed)"
  )
  expect_error(
    probability_epidemic(R = 1, k = "1", num_init_infect = 1),
    regexp = "(Assertion on 'k' failed)"
  )
  expect_error(
    probability_epidemic(R = 1, k = 1, num_init_infect = "1"),
    regexp = "(Assertion on 'num_init_infect' failed)"
  )
})

test_that("probability_extinct works for R < 1", {
  expect_identical(
    probability_extinct(R = 0.5, k = 0.5, num_init_infect = 1),
    1
  )
  expect_identical(
    probability_extinct(R = 0.5, k = 0.1, num_init_infect = 1),
    1
  )
  expect_identical(
    probability_extinct(R = 0.5, k = 0.5, num_init_infect = 50),
    1
  )
})

test_that("probability_epidemic works for R > 1", {
  expect_equal(
    probability_extinct(R = 1.5, k = 0.5, num_init_infect = 1),
    0.768
  )
})

test_that("probability_epidemic works with <epidist>", {
  edist <- suppressMessages(
    epiparameter::epidist_db(
      disease = "SARS",
      epi_dist = "offspring distribution",
      author = "Lloyd-Smith",
      single_epidist = TRUE
    )
  )
  expect_equal(
    probability_epidemic(num_init_infect = 1, offspring_dist = edist),
    0.12
  )
})

test_that("probability_epidemic fails without R and k or <epidist>", {
  expect_error(
    probability_epidemic(num_init_infect = 1),
    regexp = "One of R and k or <epidist> must be supplied."
  )
})
