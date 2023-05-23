test_that("dpoislnorm works as expected", {
  expect_equal(dpoislnorm(x = 1, meanlog = 1, sdlog = 1), 0.1757334228)
  expect_equal(
    dpoislnorm(x = 1:10, meanlog = 1, sdlog = 1),
    c(0.17573342280, 0.14691182498, 0.11325600664, 0.08550611509,
      0.06458689240, 0.04920389792, 0.03791369334, 0.02956797114,
      0.02333243044, 0.01861789729)
  )
})

test_that("ppoislnorm works as expected", {
  expect_equal(ppoislnorm(q = 1, meanlog = 1, sdlog = 1), 0.332737598)
  expect_equal(
    ppoislnorm(q = 1:10, meanlog = 1, sdlog = 1),
    c(0.3327375980, 0.4796494230, 0.5929054296, 0.6784115447, 0.7429984371,
      0.7922023350, 0.8301160284, 0.8596839995, 0.8830164300, 0.9016343273)
  )
})

test_that("dpisweibull works as expected", {
  expect_equal(dpoisweibull(x = 1, shape = 1, scale = 1), 0.25)
  expect_equal(
    dpoisweibull(x = 1:10, shape = 1, scale = 1),
    c(0.2499999999994, 0.1250000000315, 0.0625000001326, 0.0312500000001,
      0.0156250000000, 0.0078124999997, 0.0039062500000, 0.0019531250000,
      0.0009765625000, 0.0004882812527)
  )
})

test_that("ppoisweibull works as expected", {
  expect_equal(ppoisweibull(q = 1, shape = 1, scale = 1), 0.7499999996)
  expect_equal(
    ppoisweibull(q = 1:10, shape = 1, scale = 1),
    c(0.7499999996, 0.8749999996, 0.9374999998, 0.9687499998, 0.9843749998,
      0.9921874998, 0.9960937498, 0.9980468748, 0.9990234373, 0.9995117185)
  )
})
