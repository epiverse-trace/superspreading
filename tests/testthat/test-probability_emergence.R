test_that("probability_emergence works for R <= 1 & mutation_rate = 0", {
  expect_identical(
    probability_emergence(R_wild = 0.5, R_mutant = 1.5, mutation_rate = 0),
    0
  )
})

test_that("probability_emergence works for R_mutant > 1", {
  expect_snapshot(
    probability_emergence(R_wild = 0.5, R_mutant = 1.5, mutation_rate = 0.1)
  )
})

test_that("probability_emergence works for multi-type ", {
  expect_snapshot(
    probability_emergence(
      R_wild = 0.5,
      R_mutant = c(0.5, 0.5, 1.5),
      mutation_rate = 0.1
    )
  )
})

test_that("probability_emergence is approx 1 for R >> 1", {
  expect_equal(
    probability_emergence(R_wild = 10, R_mutant = 10, mutation_rate = 0.1),
    1,
    tolerance = 0.01
  )
})

test_that("emergence is equal to epidemic for R > 1 & no mutation", {
  emerge <- c()
  epidemic <- c()
  for (R_i in c(2, 5, 10)) {
    emerge <- c(
      emerge,
      probability_emergence(R_wild = R_i, R_mutant = R_i, mutation_rate = 0)
    )
    epidemic <- c(
      epidemic,
      probability_epidemic(R = R_i, k = Inf, num_init_infect = 1)
    )
  }
  expect_equal(emerge, epidemic, tolerance = 0.01)
})
