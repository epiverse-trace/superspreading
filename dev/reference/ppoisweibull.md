# Cumulative distribution function of the Poisson-Weibull compound distribution

Cumulative distribution function of the Poisson-Weibull compound
distribution

## Usage

``` r
ppoisweibull(q, shape, scale)
```

## Arguments

- q:

  A `number` for the quantile of the distribution.

- shape:

  A `number` for the shape parameter of the distribution.

- scale:

  A `number` for the scale parameter of the distribution.

## Value

A `numeric` vector of the distribution function.

## Details

The function is vectorised so a vector of quantiles can be input and the
output will have an equal length.

## Examples

``` r
ppoisweibull(q = 10, shape = 1, scale = 2)
#> [1] 0.988439
ppoisweibull(q = 1:10, shape = 1, scale = 2)
#>  [1] 0.5555556 0.7037037 0.8024691 0.8683128 0.9122085 0.9414723 0.9609816
#>  [8] 0.9739877 0.9826585 0.9884390
```
