test_that("calc_network_R works as expected", {
  R <- calc_network_R(
    mean_num_contact = 15,
    sd_num_contact = 50,
    infect_duration = 1,
    prob_transmission = 1,
    age_range = c(15, 75)
  )
  expect_equal(R, c(R = 0.25, R_net = 3.0277778))
})

test_that("calc_network_R gives equal values when sd is zero", {
  R <- calc_network_R(
    mean_num_contact = 15,
    sd_num_contact = 0,
    infect_duration = 1,
    prob_transmission = 1,
    age_range = c(15, 75)
  )
  expect_equal(R, c(R = 0.25, R_net = 0.25))
})

