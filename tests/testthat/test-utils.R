library(epiparameter)
edist <- suppressWarnings(
  epidist_db(
    disease = "SARS",
    epi_dist = "offspring_distribution",
    author = "Lloyd-Smith_etal"
  ),
)

test_that("get_param works as expected", {
  expect_type(get_epidist_param(epidist = edist, parameter = "R"), "double")
  expect_type(get_epidist_param(epidist = edist, parameter = "k"), "double")
})

test_that("get_param fails as expected", {
  expect_error(
    get_epidist_param(epidist = edist, parameter = "random"),
    regexp = "(arg)*(should be one of)*(R)*(k)"
  )
  expect_error(get_epidist_param(epidist = list(), parameter = "R"))
})

test_that("get_param fails as expected with incorrect parameters", {
  edist <- suppressWarnings(
    epidist_db(
      disease = "COVID-19",
      epi_dist = "incubation_period",
      author = "Linton_etal"
    )
  )
  expect_error(
    get_epidist_param(epidist = edist, parameter = "R"),
    regexp = "(arg)*(should be one of)*(R)*(k)"
  )
})
