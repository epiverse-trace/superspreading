# Optimise a function using either numerical optimisation or grid search

Optimise a function using either numerical optimisation or grid search

## Usage

``` r
.fit(func, fit_method = c("optim", "grid"), ...)
```

## Arguments

- func:

  A `function`.

- fit_method:

  A `character` string, either `"optim"` or `"grid"`.

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Named elements to replace default optimisation settings for either
  [`optim()`](https://rdrr.io/r/stats/optim.html) or grid search. See
  details.

## Value

A single `numeric`.

## Details

Arguments passed through [dots](https://rdrr.io/r/base/dots.html) depend
on whether `fit_method` is set to `"optim"` or `"grid"`. For `"optim"`,
arguments are passed to [`optim()`](https://rdrr.io/r/stats/optim.html),
for `"grid"`, the variable arguments are `lower`, `upper` (lower and
upper bounds on the grid search for the parameter being optimised,
defaults are `lower = 0.001` and `upper = 0.999`), and `"res"` (the
resolution of grid, default is `res = 0.001`).
