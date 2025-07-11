# proportion_transmission works as expected for single R and k

    Code
      proportion_transmission(R = 2, k = 0.5, prop_transmission = 0.8)
    Output
        R   k prop_80
      1 2 0.5   26.4%

# proportion_transmission works as expected for multiple R

    Code
      proportion_transmission(R = c(1, 2, 3), k = 0.5, prop_transmission = 0.8)
    Output
        R   k prop_80
      1 1 0.5   22.6%
      2 2 0.5   26.4%
      3 3 0.5     28%

# proportion_transmission works as expected for multiple R & k

    Code
      proportion_transmission(R = c(1, 2, 3), k = c(0.1, 0.2, 0.3),
      prop_transmission = 0.8)
    Output
        R   k prop_80
      1 1 0.1   8.69%
      2 2 0.1   9.21%
      3 3 0.1   9.39%
      4 1 0.2   14.3%
      5 2 0.2   15.6%
      6 3 0.2     16%
      7 1 0.3   18.2%
      8 2 0.3   20.3%
      9 3 0.3     21%

# proportion_transmission works as expected for format_prop = FALSE

    Code
      proportion_transmission(R = c(1, 2, 3), k = c(0.1, 0.2, 0.3),
      prop_transmission = 0.8, format_prop = FALSE)
    Output
        R   k    prop_80
      1 1 0.1 0.08693433
      2 2 0.1 0.09208820
      3 3 0.1 0.09389299
      4 1 0.2 0.14293729
      5 2 0.2 0.15561248
      6 3 0.2 0.16024765
      7 1 0.3 0.18158065
      8 2 0.3 0.20282175
      9 3 0.3 0.21039108

# proportion_transmission works as expected for Inf k

    Code
      proportion_transmission(R = 2, k = Inf, prop_transmission = 0.8)
    Message
      Infinite values of k are being approximated by 1e+05 for calculations.
    Output
        R     k prop_80
      1 2 1e+05   52.9%

# proportion_transmission works for k > 1e7 for method = t_20

    Code
      proportion_transmission(R = 2, k = 1e+10, prop_transmission = 0.8, method = "t_20")
    Message
      Values of `k` > 1e+07 are set to 1e+07 due to numerical integration issues at higher values.
    Output
        R     k prop_80
      1 2 1e+10   80.4%

# proportion_transmission works for prop_transmission > 0.99

    Code
      proportion_transmission(R = 2, k = 0.5, prop_transmission = 0.9999, method = "p_80")
    Output
        R   k prop_99.99
      1 2 0.5      55.3%

---

    Code
      proportion_transmission(R = 2, k = 0.5, prop_transmission = 0.9999, method = "t_20")
    Message
      Values of `prop_transmission` > 0.99 are set to 0.99 due to numerical integration issues at higher values.
    Output
        R   k prop_99.99
      1 2 0.5       100%

# .prop_transmission_numerical works as expected

    {
      "type": "double",
      "attributes": {},
      "value": [0.26347]
    }

# .prop_transmission_analytical works as expected

    Code
      .prop_transmission_analytical(R = 2, k = 0.5, prop_transmission = 0.8)
    Output
      [1] 0.264419

# proportion_transmission works with <epiparameter>

    Code
      proportion_transmission(prop_transmission = 0.8, offspring_dist = od)
    Output
           R    k prop_80
      1 1.63 0.16     13%

