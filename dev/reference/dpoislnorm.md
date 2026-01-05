# Density of the Poisson-lognormal compound distribution

Density of the Poisson-lognormal compound distribution

## Usage

``` r
dpoislnorm(x, meanlog, sdlog)
```

## Arguments

- x:

  A `number` for the quantile of the distribution.

- meanlog:

  A `number` for the mean of the distribution on the log scale.

- sdlog:

  A `number` for the standard deviation of the distribution on the log
  scale.

## Value

A `numeric` vector of the density of the Poisson-lognormal distribution.

## Details

The function is vectorised so a vector of quantiles can be input and the
output will have an equal length.

## Examples

``` r
dpoislnorm(x = 10, meanlog = 1, sdlog = 2)
#> [1] 0.01626334
dpoislnorm(x = 1:10, meanlog = 1, sdlog = 2)
#>  [1] 0.14112152 0.08990619 0.06345106 0.04780697 0.03765325 0.03061694
#>  [7] 0.02550065 0.02164138 0.01864488 0.01626334
```
