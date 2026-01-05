# Calculate the probability a branching process will go extinct based on R, k and initial cases

Calculates the probability a branching process will not causes an
epidemic and will go extinct. This is the complement of the probability
of a disease causing an epidemic
([`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)).

## Usage

``` r
probability_extinct(
  R,
  k,
  num_init_infect,
  ind_control = 0,
  pop_control = 0,
  ...,
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

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Named elements to replace default optimisation settings. Currently
  only `"fit_method"` is accepted and can be either `"optim"` (default)
  or `"grid"` for numerical optimisation routine or grid search,
  respectively.

- offspring_dist:

  An `<epiparameter>` object. An S3 class for working with
  epidemiological parameters/distributions, see
  [`epiparameter::epiparameter()`](https://epiverse-trace.github.io/epiparameter/reference/epiparameter.html).

## Value

A value with the probability of going extinct.

## References

Lloyd-Smith, J. O., Schreiber, S. J., Kopp, P. E., & Getz, W. M. (2005)
Superspreading and the effect of individual variation on disease
emergence. Nature, 438(7066), 355-359.
[doi:10.1038/nature04153](https://doi.org/10.1038/nature04153)

## See also

[`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)

## Examples

``` r
probability_extinct(R = 1.5, k = 0.1, num_init_infect = 10)
#> [1] 0.4963112
```
