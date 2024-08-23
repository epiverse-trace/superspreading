# proportion_transmission works as expected for single R and k

    Code
      proportion_transmission(R = 2, k = 0.5, percent_transmission = 0.8)
    Output
        R   k prop_80
      1 2 0.5   26.4%

# proportion_transmission works as expected for multiple R

    Code
      proportion_transmission(R = c(1, 2, 3), k = 0.5, percent_transmission = 0.8)
    Output
        R   k prop_80
      1 1 0.5   22.6%
      2 2 0.5   26.4%
      3 3 0.5     28%

# proportion_transmission works as expected for multiple R & k

    Code
      proportion_transmission(R = c(1, 2, 3), k = c(0.1, 0.2, 0.3),
      percent_transmission = 0.8)
    Output
        R   k prop_80
      1 1 0.1    8.7%
      2 2 0.1    9.2%
      3 3 0.1    9.4%
      4 1 0.2   14.3%
      5 2 0.2   15.6%
      6 3 0.2     16%
      7 1 0.3   18.2%
      8 2 0.3   20.3%
      9 3 0.3     21%

# proportion_transmission works as expected for format_prop = FALSE

    Code
      proportion_transmission(R = c(1, 2, 3), k = c(0.1, 0.2, 0.3),
      percent_transmission = 0.8, format_prop = FALSE)
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

# .prop_transmission_numerical works as expected

    {
      "type": "double",
      "attributes": {},
      "value": [0.26347]
    }

# .prop_transmission_analytical works as expected

    Code
      .prop_transmission_analytical(R = 2, k = 0.5, percent_transmission = 0.8)
    Output
      [1] 0.264419

# proportion_transmission works with <epiparameter>

    Code
      proportion_transmission(percent_transmission = 0.8, offspring_dist = od)
    Output
           R    k prop_80
      1 1.63 0.16     13%

