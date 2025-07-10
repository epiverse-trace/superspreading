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

test_that("probability_emergence is approx 1 for for R >> 1", {
  expect_equal(
    probability_emergence(R_wild = 10, R_mutant = 10, mutation_rate = 0.1),
    1,
    tolerance = 0.01
  )
})
