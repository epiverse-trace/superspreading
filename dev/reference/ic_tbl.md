# Helper function to create a model comparison table

This is a helper function for creating a model comparison `<data.frame>`
primarily for use in the superspreading vignettes. It is designed
specifically for handling
[`fitdistrplus::fitdist()`](https://lbbe-software.github.io/fitdistrplus/reference/fitdist.html)
output and not a generalised function. See `bbmle::ICtab()` for a more
general use function to create information criteria tables.

## Usage

``` r
ic_tbl(..., sort_by = c("AIC", "BIC", "none"))
```

## Arguments

- ...:

  [dots](https://rdrr.io/r/base/dots.html) One or more model fit results
  from
  [`fitdistrplus::fitdist()`](https://lbbe-software.github.io/fitdistrplus/reference/fitdist.html).

- sort_by:

  A `character` string specifying which information criterion to order
  the table by, either `"AIC"` (default), `"BIC"`, or `"none"` (i.e. no
  ordering).

## Value

A `<data.frame>`.

## Examples

``` r
if (requireNamespace("fitdistrplus", quietly = TRUE)) {
  cases <- rnbinom(n = 100, mu = 5, size = 0.7)
  pois_fit <- fitdistrplus::fitdist(data = cases, distr = "pois")
  geom_fit <- fitdistrplus::fitdist(data = cases, distr = "geom")
  nbinom_fit <- fitdistrplus::fitdist(data = cases, distr = "nbinom")
  ic_tbl(pois_fit, geom_fit, nbinom_fit)
}
#>   distribution      AIC   DeltaAIC         wAIC      BIC    DeltaBIC
#> 1       nbinom 544.9231   0.000000 8.282326e-01 550.1335   0.0000000
#> 2         geom 548.0694   3.146305 1.717674e-01 550.6746   0.5411352
#> 3         pois 925.9316 381.008504 1.524779e-83 928.5368 378.4033341
#>           wBIC
#> 1 5.672322e-01
#> 2 4.327678e-01
#> 3 3.841678e-83
```
