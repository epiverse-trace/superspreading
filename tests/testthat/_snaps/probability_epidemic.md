# probability_epidemic works for R > 1

    Code
      probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1)
    Output
      [1] 0.2324081

---

    Code
      probability_extinct(R = 1.5, k = 0.5, num_init_infect = 1)
    Output
      [1] 0.7675919

# probability_epidemic works for k == Inf

    Code
      probability_epidemic(R = 1.5, k = Inf, num_init_infect = 1)
    Output
      [1] 0.5828111

# probability_epidemic works with individual-level control

    Code
      probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.2)
    Output
      [1] 0.09070598

# probability_epidemic works with population-level control

    Code
      probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.2)
    Output
      [1] 0.1133825

# probability_epidemic works with both control measures

    Code
      probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1,
        pop_control = 0.1)
    Output
      [1] 0.1084924

# probability_epidemic works with <epidist>

    Code
      probability_epidemic(num_init_infect = 1, offspring_dist = edist)
    Output
      [1] 0.1198705

# probability_epidemic works with grid

    Code
      probability_epidemic(R = 1.5, k = 1, num_init_infect = 5, ind_control = 0.1,
        pop_control = 0.1, fit_method = "grid")
    Output
      [1] 0.5792928

# probability_epidemic works with spliced list

    Code
      probability_epidemic(R = 1.5, k = 1, num_init_infect = 5, ind_control = 0.1,
        pop_control = 0.1, !!!list(fit_method = "grid"))
    Output
      [1] 0.5792928

