# Simulate transmission chains using a stochastic branching process

Code modified from the `bpmodels::chain_sim()` function. The function
`chain_sim()` function from bpmodels is reused with permission and
licensed under MIT as is bpmodels. bpmodels is not on CRAN and is
retired.

## Usage

``` r
.chain_sim(
  n,
  offspring,
  stat = c("size", "length"),
  stat_threshold = Inf,
  generation_time,
  tf = Inf,
  ...
)
```

## Arguments

- n:

  Number of simulations to run.

- offspring:

  Offspring distribution: a character string corresponding to the R
  distribution function (e.g., "pois" for Poisson, where
  [`rpois()`](https://rdrr.io/r/stats/Poisson.html) is the R function to
  generate Poisson random numbers).

- stat:

  String; Statistic to calculate. Can be one of:

  - "size": the total number of offspring.

  - "length": the total number of ancestors.

- stat_threshold:

  A size or length above which the simulation results should be set to
  `Inf`. Defaults to `Inf`, resulting in no results ever set to `Inf`.

- generation_time:

  The generation time generator function; the name of a user-defined
  named or anonymous function with only one argument `n`, representing
  the number of generation times to generate.

- tf:

  End time (if `generation_time` interval is given).

- ...:

  Parameters of the offspring distribution as required by R.

## Value

A `<data.frame>` with columns `n` (simulation ID), `id` (a unique ID
within each simulation for each individual element of the chain),
`ancestor` (the ID of the ancestor of each element), and `generation`. A
`time` column is also appended if the generation_time interval is
supplied to `serial`.

## Author

Sebastian Funk, James M. Azam, Joshua W. Lambert
