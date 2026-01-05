# Density of the Poisson-Weibull compound distribution

Density of the Poisson-Weibull compound distribution

## Usage

``` r
dpoisweibull(x, shape, scale)
```

## Arguments

- x:

  A `number` for the quantile of the distribution.

- shape:

  A `number` for the shape parameter of the distribution.

- scale:

  A `number` for the scale parameter of the distribution.

## Value

A `numeric` vector of the density of the Poisson-Weibull distribution.

## Details

The function is vectorised so a vector of quantiles can be input and the
output will have an equal length.

## Examples

``` r
dpoisweibull(x = 10, shape = 1, scale = 2)
#> [1] 0.00578051
dpoisweibull(x = 1:10, shape = 1, scale = 2)
#>  [1] 0.222222222 0.148148148 0.098765432 0.065843621 0.043895748 0.029263832
#>  [7] 0.019509221 0.013006147 0.008670765 0.005780510
```
