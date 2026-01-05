# Calculate the probability a disease will emerge and cause a sustained outbreak (\\R \> 1\\) based on R and initial cases

The method for the evolution of pathogen emergence described in Antia et
al. (2003)
([doi:10.1038/nature02104](https://doi.org/10.1038/nature02104) ). The
model is a multi-type branching process model with an initial
(wild-type) reproduction number, usually below 1, and a evolved
reproduction number that is greater than 1, and thus can cause a
sustained human-to-human epidemic. The reproduction number for a
pathogen changes at the `mutation_rate`.

## Usage

``` r
probability_emergence(
  R_wild,
  R_mutant,
  mutation_rate,
  num_init_infect,
  tol = 1e-10,
  max_iter = 1000
)
```

## Arguments

- R_wild:

  A `number` specifying the R parameter (i.e. average secondary cases
  per infectious individual) for the wild-type pathogen.

- R_mutant:

  A `number` or vector of `numbers` specifying the R parameter (i.e.
  average secondary cases per infectious individual) for the mutant
  pathogen(s). If there is more than one value supplied to `R_mutant`,
  then the first element is the reproduction number for \\m - 1\\ mutant
  and the last element is the reproduction number for the \\m\\ mutant
  (i.e. fully evolved).

- mutation_rate:

  A `number` specifying the mutation rate (\\\mu\\), must be between
  zero and one.

- num_init_infect:

  An `integer` (or at least
  ["integerish"](https://rlang.r-lib.org/reference/is_integerish.html)
  if stored as double) specifying the number of initial infections.

- tol:

  A `number` for the tolerance of the numerical convergence. Default is
  `1e-10`.

- max_iter:

  A `number` for the maximum number of iterations for the optimisation.
  Default is `1000`.

## Value

A value with the probability of a disease emerging and causing an
outbreak.

## Details

Following Antia et al. (2003), we assume that the mutation rate for all
variants is the same.

## References

Antia, R., Regoes, R., Koella, J. & Bergstrom, C. T. (2003) The role of
evolution in the emergence of infectious diseases. Nature 426, 658–661.
[doi:10.1038/nature02104](https://doi.org/10.1038/nature02104)

## See also

[`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md),
[`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md)

## Examples

``` r
probability_emergence(
  R_wild = 0.5,
  R_mutant = 1.5,
  mutation_rate = 0.5,
  num_init_infect = 1
)
#> [1] 0.1719591
```
