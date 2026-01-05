# Design Principles for {superspreading}

This vignette outlines the design decisions that have been taken during
the development of the {superspreading} R package, and provides some of
the reasoning, and possible pros and cons of each decision.

This document is primarily intended to be read by those interested in
understanding the code within the package and for potential package
contributors.

## Scope

The {superspreading} package aims to provide a range of summary metrics
to characterise individual-level variation in disease transmission and
its impact on the growth or decline of an epidemic. These include
calculating the probability an outbreak becomes an epidemic
([`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)),
or conversely goes extinct
([`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md)),
the probability an outbreak can be contained
([`probability_contain()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_contain.md)),
the probability of a pathogen evolving and emerging, the proportion of
cases in cluster of a given size
([`proportion_cluster_size()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_cluster_size.md)),
and the proportion of cases that cause a proportion of transmission
([`proportion_transmission()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_transmission.md)).

The other aspect of the package is to provide probability density
functions and cumulative distribution functions to compute the
likelihood for distribution models to estimate heterogeneity in
individual-level disease transmission that are not available in R
(i.e. base R). At present we include two models: Poisson-lognormal
([`dpoislnorm()`](https://epiverse-trace.github.io/superspreading/dev/reference/dpoislnorm.md)
&
[`ppoislnorm()`](https://epiverse-trace.github.io/superspreading/dev/reference/ppoislnorm.md))
and Poisson-Weibull
([`dpoisweibull()`](https://epiverse-trace.github.io/superspreading/dev/reference/dpoisweibull.md)
&
[`ppoisweibull()`](https://epiverse-trace.github.io/superspreading/dev/reference/ppoisweibull.md))
distributions.

The package implements a branching process simulation based on
[`bpmodels::chain_sim()`](https://github.com/epiforecasts/bpmodels/blob/3d892baa64b6bc239d6e4cf4430d7c5f1b4d0591/R/simulate.r)
to enable the numerical calculation of the probability of containment
within a outbreak time and outbreak duration threshold. In the future
this function could be removed in favour of using a package implementing
branching process models as a dependency. The package is mostly focused
on analytical functions that are derived from branching process models.
The package provides functions to calculate variation in
individual-level transmission but does not provide functions for
inference, and currently relies on {fitdistrplus} for fitting models.

## Output

Functions with the name `probability_*()` return a single `numeric`.
Functions with the name `proportion_*()` return a `<data.frame>` with as
many rows as combinations of input values (see
[`expand.grid()`](https://rdrr.io/r/base/expand.grid.html)). The
consistency of simple well-known data structure makes it easy for users
to apply these functions in different scenarios.

The distribution functions return a vector of `numeric`s of equal length
to the input vector. This is the same behaviour as the base R
distribution functions.

## Design decisions

- `proportion_*()` functions return a `<data.frame>` with the proportion
  column(s) containing `character` strings, formatted with a percentage
  sign (`%`) by default. It was reasoned that {superspreading} is most
  likely used either as a stand-alone package, or at the terminus of a
  epidemiological analysis pipeline, and thus the outputs of
  {superspreading} functions would not be passed into other functions.
  For instances where these proportions need to be passed to another
  calculation or for plotting purposes the `format_prop` argument can be
  switched to `FALSE` and a `numeric` column of proportions will be
  returned.

- The distribution functions are vectorised (i.e. wrapped in
  [`Vectorize()`](https://rdrr.io/r/base/Vectorize.html)). This enables
  them to be used identically to base R distribution functions.

- Native interoperability with `<epiparameter>` objects, from the
  {epiparameter} package is enabled for `probability_*()` and
  `proportion_*()` via the `offspring_dist` argument. This allows user
  to pass in a single object and the parameters required by the
  {superspreading} function will be extracted, if these are not
  available within the `<epiparameter>` object the function returns an
  informative error. The `offspring_dist` argument is after `...` to
  ensure users specify the argument in full and not accidentally provide
  data to this argument. The exception is
  [`probability_emergence()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_emergence.md)
  which does not have an `offspring_dist` argument and thus no
  interoperability with {epiparameter} due to the function using two
  reproduction numbers so handling multiple `<epiparameter>` objects was
  judged to add too much complexity for the benefit.

- Internal functions have a dot (`.`) prefix, exported functions do not.

- Several functions use constants that are internally defined
  (e.g. `NSIM` and `FINITE_INF`). These are used in several functions to
  prevent the use of apparently arbitrary [magic
  numbers](https://en.wikipedia.org/wiki/Magic_number_(programming)).
  Constants are all uppercase to make clear they are *internal*
  constants (following
  [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const#basic_const_usage)
  and [PEP8](https://peps.python.org/pep-0008/#constants) styles. These
  constants should not be exported (i.e. should not appear in the
  `NAMESPACE`) as they should only be used by functions and not package
  users.

## Dependencies

The aim is to restrict the number of dependencies to a minimal required
set for ease of maintenance. The current hard dependencies are:

- {stats}
- [{checkmate}](https://CRAN.R-project.org/package=checkmate)
- [{rlang}](https://CRAN.R-project.org/package=rlang)

{stats} is distributed with the R language so is viewed as a lightweight
dependency, that should already be installed on a user’s machine if they
have R. {checkmate} is an input checking package widely used across
Epiverse-TRACE packages. {rlang} is used to accept [dynamic
dots](https://rlang.r-lib.org/reference/dyn-dots.html) in various
{superspreading} functions.

Suggested dependencies are used for package documentation, including
building vignettes ([{knitr}](https://CRAN.R-project.org/package=knitr),
[{rmarkdown}](https://CRAN.R-project.org/package=rmarkdown)), data
wrangling ([{dplyr}](https://CRAN.R-project.org/package=dplyr),
[{purrr}](https://CRAN.R-project.org/package=purrr)), plotting
([{ggplot2}](https://CRAN.R-project.org/package=ggplot2),
[{scales}](https://CRAN.R-project.org/package=scales),
[{ggtext}](https://CRAN.R-project.org/package=ggtext)), loading
epidemiological parameters from
[{epiparameter}](https://CRAN.R-project.org/package=epiparameter), and
model fitting with
[{fitdistrplus}](https://CRAN.R-project.org/package=fitdistrplus). There
are also suggested dependencies for testing and spell checking
([{testthat}](https://CRAN.R-project.org/package=testthat),
[{spelling}](https://CRAN.R-project.org/package=spelling)).

## Contribute

There are no special requirements to contributing to {superspreading},
please follow the [package contributing
guide](https://github.com/epiverse-trace/.github/blob/main/CONTRIBUTING.md).
