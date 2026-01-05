# Probability that an outbreak will be contained

Outbreak containment is defined as outbreak extinction when
`simulate = FALSE`. When `simulate = FALSE`, `probability_contain()` is
equivalent to calling
[`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md).

When `simulate = TRUE`, outbreak containment is defined by the
`case_threshold` (default = 100) and `outbreak_time` arguments. Firstly,
`case_threshold` sets the size of the transmission chain below which the
outbreak is considered contained. Secondly, `outbreak_time` sets the
time duration from the start of the outbreak within which the outbreak
is contained if there is no more onwards transmission beyond this time.
When setting an `outbreak_time`, a `generation_time` is also required.
`case_threshold` and `outbreak_time` can be jointly set. Overall, when
`simulate = TRUE`, containment is defined as the size and time duration
of a transmission chain not reaching the `case_threshold` and
`outbreak_time`, respectively.

## Usage

``` r
probability_contain(
  R,
  k,
  num_init_infect,
  ind_control = 0,
  pop_control = 0,
  simulate = FALSE,
  ...,
  case_threshold = 100,
  outbreak_time = Inf,
  generation_time = NULL,
  offspring_dist
)
```

## Arguments

- R:

  A `number` specifying the \\R\\ parameter (i.e. average secondary
  cases per infectious individual).

- k:

  A `number` specifying the \\k\\ parameter (i.e. dispersion in
  offspring distribution from fitted negative binomial).

- num_init_infect:

  An `integer` (or at least
  ["integerish"](https://rlang.r-lib.org/reference/is_integerish.html)
  if stored as double) specifying the number of initial infections.

- ind_control:

  A `numeric` specifying the strength of individual-level control
  measures. These control measures assume that infected individuals do
  not produce any secondary infections with probability `ind_control`,
  thus increasing the proportion of cases that do not create any
  subsequent infections. The control measure is between `0` (default)
  and `1` (maximum).

- pop_control:

  A `numeric` specifying the strength of population-level control
  measures that reduce the transmissibility of all cases by a constant
  factor. Between `0` (default) and `1` (maximum).

- simulate:

  A `logical` boolean determining whether the probability of containment
  is calculated analytically or numerically using a stochastic branching
  process model. Default is `FALSE` which calls
  [`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md),
  setting to `TRUE` uses a branching process and enables setting the
  `case_threshold`, `outbreak_time` and `generation_time` arguments.

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Named elements to replace default arguments in
  [`.chain_sim()`](https://epiverse-trace.github.io/superspreading/dev/reference/dot-chain_sim.md).
  See details.

- case_threshold:

  A number for the threshold of the number of cases below which the
  epidemic is considered contained. `case_threshold` is only used when
  `simulate = TRUE`.

- outbreak_time:

  A number for the time since the start of the outbreak to determine if
  outbreaks are contained within a given period of time. `outbreak_time`
  is only used when `simulate = TRUE`.

- generation_time:

  A `function` to generate generation times. The function must have a
  single argument and return a `numeric` vector with generation times.
  See details for example. The `function` can be defined or anonymous.
  `generation_time` is only used when `simulate = TRUE`.

- offspring_dist:

  An `<epiparameter>` object. An S3 class for working with
  epidemiological parameters/distributions, see
  [`epiparameter::epiparameter()`](https://epiverse-trace.github.io/epiparameter/reference/epiparameter.html).

## Value

A `number` for the probability of containment.

## Details

When using `simulate = TRUE`, the default arguments to simulate the
transmission chains with
[`.chain_sim()`](https://epiverse-trace.github.io/superspreading/dev/reference/dot-chain_sim.md)
are 10⁵ replicates, a negative binomial (`nbinom`) offspring
distribution, parameterised with `R` (and `pop_control` if \> 0) and
`k`.

When setting the `outbreak_time` argument, the `generation_time`
argument is also required. The `generation_time` argument requires a
random number generator function. For example, if we assume the
generation time is lognormally distributed with `meanlog = 1` and
`sdlog = 1.5`, then we can define the `function` to pass to
`generation_time` as:

    function(x) rlnorm(x, meanlog = 1, sdlog = 1.5)

## References

Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005)
Superspreading and the effect of individual variation on disease
emergence. Nature, 438(7066), 355-359.
[doi:10.1038/nature04153](https://doi.org/10.1038/nature04153)

## See also

[`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md)

## Examples

``` r
# population-level control measures
probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, pop_control = 0.1)
#> [1] 0.8213172

# individual-level control measures
probability_contain(R = 1.5, k = 0.5, num_init_infect = 1, ind_control = 0.1)
#> [1] 0.8391855

# both levels of control measures
probability_contain(
  R = 1.5,
  k = 0.5,
  num_init_infect = 1,
  ind_control = 0.1,
  pop_control = 0.1
)
#> [1] 0.8915076

# multi initial infections with population-level control measures
probability_contain(R = 1.5, k = 0.5, num_init_infect = 5, pop_control = 0.1)
#> [1] 0.3737271

# probability of containment within a certain amount of time
# this requires parameterising a generation time
gt <- function(n) {
  rlnorm(n, meanlog = 1, sdlog = 1.5)
}
probability_contain(
  R = 1.2,
  k = 0.5,
  num_init_infect = 1,
  simulate = TRUE,
  case_threshold = 50,
  outbreak_time = 20,
  generation_time = gt
)
#> [1] 0.73942
```
