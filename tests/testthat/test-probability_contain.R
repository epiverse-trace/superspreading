test_that("probability_contain works as expected for deterministic", {
  expect_snapshot(probability_contain(R = 1.5, k = 0.5, num_init_infect = 1))
})

test_that("probability_contain works as expected for simulate", {
  expect_snapshot_value(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, simulate = TRUE
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

test_that("probability_contain works as expected for simulate pop control", {
  expect_snapshot_value(
    probability_contain(
      R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1, simulate = TRUE
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
      simulate = TRUE,
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
      simulate = TRUE,
      n = 1e4,
      stat_threshold = 50
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain works with <epiparameter>", {
  skip_if_not_installed(pkg = "epiparameter")
  od <- suppressMessages(
    epiparameter::epiparameter_db(
      disease = "SARS",
      epi_name = "offspring distribution",
      author = "Lloyd-Smith",
      single_epiparameter = TRUE
    )
  )
  expect_snapshot(
    probability_contain(
      num_init_infect = 1,
      pop_control = 0.1,
      offspring_dist = od
    )
  )

  expect_snapshot(
    probability_contain(
      num_init_infect = 1,
      ind_control = 0.1,
      offspring_dist = od
    )
  )

  expect_snapshot(
    probability_contain(
      num_init_infect = 5,
      ind_control = 0.1,
      pop_control = 0.1,
      offspring_dist = od
    )
  )
})

test_that("probability_contain works with generation_time", {
  expect_snapshot_value(
    probability_contain(
      R = 1,
      k = 0.5,
      num_init_infect = 1,
      simulate = TRUE,
      outbreak_time = 10,
      generation_time = function(x) rlnorm(n = x, meanlog = 1, sdlog = 1)
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain works for outbreak_time & num_init_infect > 1", {
  expect_snapshot_value(
    probability_contain(
      R = 1,
      k = 0.5,
      num_init_infect = 5,
      simulate = TRUE,
      outbreak_time = 10,
      generation_time = function(x) rlnorm(n = x, meanlog = 1, sdlog = 1)
    ),
    style = "json2",
    tolerance = 0.05
  )
})

test_that("probability_contain fails as expected", {
  expect_error(
    probability_contain(
      R = 1,
      k = 1,
      num_init_infect = 2,
      ind_control = 1,
      simulate = TRUE
    ),
    regexp =
      "individual-level control not yet implemented for `simulate` calculation"
  )
})

test_that("probability_contain fails using dots with incorrect name", {
  expect_error(
    probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, random = 100),
    regexp = "Arguments supplied in `...` not valid"
  )
})

test_that("probability_contain fails without R and k or <epiparameter>", {
  expect_error(
    probability_contain(num_init_infect = 1, pop_control = 0.5),
    regexp = "Only one of R and k or <epiparameter> must be supplied."
  )
})

test_that("probability_contain fails with outbreak_time & no generation_time", {
  expect_error(
    probability_contain(
      R = 2, k = 0.5, num_init_infect = 1, outbreak_time = 100
    ),
    regexp = "(`generation_time` is required)*(within an `outbreak_time`)"
  )
})
