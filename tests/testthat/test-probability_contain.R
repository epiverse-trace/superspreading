test_that("probability_contain works as expected for deterministic", {
  expect_snapshot(probability_contain(R = 1.5, k = 0.5, num_init_infect = 1))
})

test_that("probability_contain works as expected for stochastic", {
  expect_snapshot_value(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, stochastic = TRUE
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain works as expected for population control", {
  expect_snapshot(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1
    )
  )
})

test_that("probability_contain works as expected for individual control", {
  expect_snapshot(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1
    )
  )
})

test_that("probability_contain works as expected for stochastic pop control", {
  expect_snapshot_value(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1, stochastic = TRUE
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain works as expected for both controls", {
  expect_snapshot(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1, pop_control = 0.1
    )
  )
})

test_that("probability_contain works as expected for ind control multi init", {
  expect_snapshot(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 5, ind_control = 0.1
    )
  )
})

test_that("probability_contain works as expected for pop control multi init", {
  expect_snapshot(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 5, pop_control = 0.1,
    )
  )
})

test_that("probability_contain works as expected for different threshold", {
  expect_snapshot_value(
    probability_contain(
      R = 1.5,
      k = 0.5,
      num_init_infect = 1,
      stochastic = TRUE,
      case_threshold = 50
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain works as when using dots", {
  expect_snapshot_value(
    probability_contain(
      R = 1.5,
      k = 0.5,
      num_init_infect = 1,
      stochastic = TRUE,
      n = 1e4,
      infinite = 50
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain works with <epidist>", {
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
    probability_contain(
      num_init_infect = 1,
      pop_control = 0.1,
      offspring_dist = edist
    )
  )

  expect_snapshot(
    probability_contain(
      num_init_infect = 1,
      ind_control = 0.1,
      offspring_dist = edist
    )
  )

  expect_snapshot(
    probability_contain(
      num_init_infect = 5,
      ind_control = 0.1,
      pop_control = 0.1,
      offspring_dist = edist
    )
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

test_that("probability_contain fails using dots with incorrect name", {
  expect_error(
    probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, random = 100),
    regexp = "Arguments supplied in `...` not valid"
  )
})

test_that("probability_contain fails without R and k or <epidist>", {
  expect_error(
    probability_contain(num_init_infect = 1, pop_control = 0.5),
    regexp = "Only one of R and k or <epidist> must be supplied."
  )
})
