# probability_contain works as expected for deterministic

    Code
      probability_contain(R = 1.5, k = 0.5, num_init_infect = 1)
    Output
      [1] 0.7675919

# probability_contain works as expected for stochastic

    {
      "type": "double",
      "attributes": {},
      "value": [0.76625]
    }

# probability_contain works as expected for population control

    Code
      probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1)
    Output
      [1] 0.8213172

# probability_contain works as expected for individual control

    Code
      probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1)
    Output
      [1] 0.8391855

# probability_contain works as expected for stochastic pop control

    {
      "type": "double",
      "attributes": {},
      "value": [0.81856]
    }

# probability_contain works as expected for both controls

    Code
      probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1,
        pop_control = 0.1)
    Output
      [1] 0.8915076

# probability_contain works as expected for ind control multi init

    Code
      probability_contain(R = 1.5, k = 0.5, num_init_infect = 5, ind_control = 0.1)
    Output
      [1] 0.4161882

# probability_contain works as expected for pop control multi init

    Code
      probability_contain(R = 1.5, k = 0.5, num_init_infect = 5, pop_control = 0.1, )
    Output
      [1] 0.3737271

# probability_contain works as expected for different threshold

    {
      "type": "double",
      "attributes": {},
      "value": [0.76148]
    }

# probability_contain works as when using dots

    {
      "type": "double",
      "attributes": {},
      "value": [0.7636]
    }

# probability_contain works as when using dots with incorrect name

    {
      "type": "double",
      "attributes": {},
      "value": [0.76759189]
    }

# probability_contain works with <epidist>

    Code
      probability_contain(num_init_infect = 1, pop_control = 0.1, offspring_dist = edist)
    Output
      [1] 0.9037105

---

    Code
      probability_contain(num_init_infect = 1, ind_control = 0.1, offspring_dist = edist)
    Output
      [1] 0.9133394

---

    Code
      probability_contain(num_init_infect = 5, ind_control = 0.1, pop_control = 0.1,
        offspring_dist = edist)
    Output
      [1] 0.7168911

