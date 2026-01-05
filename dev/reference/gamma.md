# Defines the gamma functions in terms of the mean reproductive number (R) and the dispersion parameter (k)

- `dgammaRk()` for the gamma density function

- `pgammaRk()` for the gamma distribution function

- `fvx()` fore the gamma probability density function (pdf) describing
  the individual reproductive number \\\nu\\ given R0 and k

## Usage

``` r
dgammaRk(x, R, k)

pgammaRk(x, R, k)

fvx(x, R, k)
```

## Arguments

- R:

  A `number` specifying the \\R\\ parameter (i.e. average secondary
  cases per infectious individual).

- k:

  A `number` specifying the \\k\\ parameter (i.e. dispersion in
  offspring distribution from fitted negative binomial).
