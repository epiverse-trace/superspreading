# Cumulative distribution function of the Poisson-lognormal compound distribution

Cumulative distribution function of the Poisson-lognormal compound
distribution

## Usage

``` r
ppoislnorm(q, meanlog, sdlog)
```

## Arguments

- q:

  A `number` for the quantile of the distribution.

- meanlog:

  A `number` for the mean of the distribution on the log scale.

- sdlog:

  A `number` for the standard deviation of the distribution on the log
  scale.

## Value

A `numeric` vector of the distribution function.

## Details

The function is vectorised so a vector of quantiles can be input and the
output will have an equal length.

## Examples

``` r
ppoislnorm(q = 10, meanlog = 1, sdlog = 2)
#> [1] 0.74796
ppoislnorm(q = 1:10, meanlog = 1, sdlog = 2)
#>  [1] 0.3964753 0.4863815 0.5498326 0.5976395 0.6352928 0.6659097 0.6914104
#>  [8] 0.7130517 0.7316966 0.7479600
```
