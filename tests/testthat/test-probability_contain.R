test_that("probability_contain works as expected", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, control = 0
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.7672, tolerance = 1e-2)
})

test_that("probability_contain works as expected for deterministic", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, control = 0, stochastic = FALSE
  )
  expect_equal(prob_contain, 0.768)
})

test_that("probability_contain works as expected for different threshold", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, control = 0, case_threshold = 50
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.76255, tolerance = 1e-2)
})

test_that("probability_contain works as when using dots", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, control = 0, n = 1e4, infinite = 50
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.7606, tolerance = 0.1)
})

test_that("probability_contain works as when using dots with incorrect name", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, control = 0, random = 100
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.76669, tolerance = 1e-2)
})

test_that("probability_contain fails as expected", {
  expect_error(
    probability_contain(R = 1, k = 1, num_init_infect = 2, control = 1),
    regexp = "(Multiple introductions is not yet implemented)"
  )

  expect_error(
    probability_contain(
      R = 1,
      k = 1,
      num_init_infect = 2,
      control = 1,
      control_type = "individual"
    ),
    regexp = "individual-level controls not yet implemented"
  )
})

test_that("probability_contain works with <epidist>", {
  edist <- suppressMessages(
    epiparameter::epidist_db(
      disease = "SARS",
      epi_dist = "offspring distribution",
      author = "Lloyd-Smith",
      single_epidist = TRUE
    )
  )
  expect_equal(
    probability_contain(
      num_init_infect = 1, control = 0.1, stochastic = FALSE, epidist = edist
    ),
    0.904
  )
})

test_that("probability_contain fails without R and k or <epidist>", {
  expect_error(
    probability_contain(num_init_infect = 1, control = 0.5),
    regexp = "One of R and k or <epidist> must be supplied."
  )
})
