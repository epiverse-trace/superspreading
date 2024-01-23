test_that("probability_contain works as expected for deterministic", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1
  )
  expect_equal(prob_contain, 0.76759189)
})

test_that("probability_contain works as expected for stochastic", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, stochastic = TRUE
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.76791, tolerance = 1e-2)
})

test_that("probability_contain works as expected for population control", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1
  )
  expect_equal(prob_contain, 0.821317195)
})

test_that("probability_contain works as expected for individual control", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1
  )
  expect_equal(prob_contain, 0.839185481)
})

test_that("probability_contain works as expected for stochastic pop control", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1, stochastic = TRUE
  )
  expect_equal(prob_contain, 0.81881, tolerance = 1e-2)
})

test_that("probability_contain works as expected for both controls", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1, pop_control = 0.1
  )
  expect_equal(prob_contain, 0.891507615)
})

test_that("probability_contain works as expected for ind control multi init", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 5, ind_control = 0.1
  )
  expect_equal(prob_contain, 0.416188242)
})

test_that("probability_contain works as expected for pop control multi init", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 5, pop_control = 0.1,
  )
  expect_equal(prob_contain, 0.373727087, tolerance = 1e-2)
})

test_that("probability_contain works as expected for different threshold", {
  prob_contain <- probability_contain(
    R = 1.5,
    k = 0.5,
    num_init_infect = 1,
    stochastic = TRUE,
    case_threshold = 50
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.76455, tolerance = 1e-2)
})

test_that("probability_contain works as when using dots", {
  prob_contain <- probability_contain(
    R = 1.5,
    k = 0.5,
    num_init_infect = 1,
    n = 1e4,
    infinite = 50
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.76759189, tolerance = 0.1)
})

test_that("probability_contain works as when using dots with incorrect name", {
  prob_contain <- probability_contain(
    R = 1.5, k = 0.5, num_init_infect = 1, random = 100
  )
  # larger tolerance for stochastic variance
  expect_equal(prob_contain, 0.76759189, tolerance = 1e-2)
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
      num_init_infect = 1,
      pop_control = 0.1,
      offspring_dist = edist
    ),
    0.903710478
  )

  expect_equal(
    probability_contain(
      num_init_infect = 1,
      ind_control = 0.1,
      offspring_dist = edist
    ),
    0.913339427
  )

  expect_equal(
    probability_contain(
      num_init_infect = 5,
      ind_control = 0.1,
      pop_control = 0.1,
      offspring_dist = edist
    ),
    0.716891142
  )
})

test_that("probability_contain fails as expected", {
  expect_error(
    probability_contain(
      R = 1,
      k = 1,
      num_init_infect = 2,
      ind_control = 1,
      stochastic = TRUE
    ),
    regexp =
      "individual-level control not yet implemented for stochastic calculation"
  )
})

test_that("probability_contain fails without R and k or <epidist>", {
  expect_error(
    probability_contain(num_init_infect = 1, pop_control = 0.5),
    regexp = "One of R and k or <epidist> must be supplied."
  )
})
