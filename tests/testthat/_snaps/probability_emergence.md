# probability_emergence works for R_mutant > 1

    Code
      probability_emergence(R_wild = 0.5, R_mutant = 1.5, mutation_rate = 0.1,
        num_init_infect = 1)
    Output
      [1] 0.05057598

# probability_emergence works for multi-type 

    Code
      probability_emergence(R_wild = 0.5, R_mutant = c(0.5, 0.5, 1.5), mutation_rate = 0.1,
      num_init_infect = 1)
    Output
      [1] 0.000416088

