# Changelog

## superspreading (development version)

## superspreading 0.4.0

CRAN release: 2025-07-15

The fourth minor release of the *superspreading* package contains new
functionality, a new vignette and various minor improvements to
documentation.

With this release the development status of the package has been updated
from *experimental* to *stable*.

### New features

- The
  [`probability_emergence()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_emergence.md)
  function has been added to calculate the probability that a pathogen
  introduced to humans can evolve and emerge to cause a sustained
  human-to-human outbreak, implementing and extending the framework of
  [Antia et al. (2003)](https://doi.org/10.1038/nature02104)
  ([\#124](https://github.com/epiverse-trace/superspreading/issues/124),
  [\#133](https://github.com/epiverse-trace/superspreading/issues/133)).

- A new vignette, `emergence.Rmd`, has been added that covers the
  functionality of
  [`probability_emergence()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_emergence.md)
  and reproduces the two figures from [Antia et
  al. (2003)](https://doi.org/10.1038/nature02104) as well as a figure
  using the multiple introductions extension
  ([\#124](https://github.com/epiverse-trace/superspreading/issues/124),
  [\#133](https://github.com/epiverse-trace/superspreading/issues/133)).

- Alt-text has been added to all plots across all vignettes
  ([\#129](https://github.com/epiverse-trace/superspreading/issues/129)).

### Breaking changes

- The `percent_transmission` argument in
  [`proportion_transmission()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_transmission.md)
  has been renamed to `prop_transmission`
  ([\#130](https://github.com/epiverse-trace/superspreading/issues/130)).

### Minor changes

- An `.aspell/` folder is added to the package including `defaults.R`
  and `superspreading.rds` to supply a wordlist to the CRAN spell
  checking to avoid quoting names in the `DESCRIPTION`
  ([\#127](https://github.com/epiverse-trace/superspreading/issues/127)).

- Package and function documentation has been updated. Vignette changes
  include minor reworking of text, updating any information or links
  that were outdated; function documentation is styled more consistently
  and follows the [Tidyverse style
  guide](https://style.tidyverse.org/documentation.html)
  ([\#131](https://github.com/epiverse-trace/superspreading/issues/131),
  [\#134](https://github.com/epiverse-trace/superspreading/issues/134)).

- Internal code style has been updated to adhere to current best
  practice
  ([\#125](https://github.com/epiverse-trace/superspreading/issues/125)).

- The package lifecycle badge has been updated from *experimental* to
  *stable*. CRAN status, CRAN downloads, repo status and Zenodo DOI
  badges have been added to the `README`
  ([\#119](https://github.com/epiverse-trace/superspreading/issues/119),
  [\#132](https://github.com/epiverse-trace/superspreading/issues/132)).

- The {pkgdown} `development: mode` has been set to `auto` now the
  package is hosted on CRAN
  ([\#118](https://github.com/epiverse-trace/superspreading/issues/118)).

### Bug fixes

- None

### Deprecated and defunct

- None

## superspreading 0.3.0

CRAN release: 2025-01-27

The third minor release of the *superspreading* package contains
enhancements to several functions and a new vignette.

We are also pleased to welcome Dillon Adam
([@dcadam](https://github.com/dcadam)) as a new package author for his
contributions towards this version.

### New features

- The
  [`proportion_transmission()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_transmission.md)
  function has been expanded to incorporate a new method. The new method
  calculates the proportion of transmission from X% the most infectious
  individuals, corresponding to the [Lloyd-Smith et
  al. (2005)](https://doi.org/10.1038%2Fnature04153) calculation. The
  [`proportion_transmission()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_transmission.md)
  has a new `method` argument to toggle between the two calculations
  ([@dcadam](https://github.com/dcadam),
  [\#99](https://github.com/epiverse-trace/superspreading/issues/99)).
- A new vignette explaining the methods in the
  [`proportion_transmission()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_transmission.md)
  function
  ([\#101](https://github.com/epiverse-trace/superspreading/issues/101)).
- {bpmodels} is removed as a package dependency and a branching process
  simulation function, modified from `bpmodels::chain_sim()`, is added
  to the {superspreading} package
  ([\#103](https://github.com/epiverse-trace/superspreading/issues/103)).
  [@sbfnk](https://github.com/sbfnk) is added as copyright holder and
  [@jamesmbaazam](https://github.com/jamesmbaazam) as a contributor.
- [`probability_contain()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_contain.md)
  is enhanced to enable to probability of containment within a certain
  amount of time since the outbreak started. This adds `outbreak_time`
  and `generation_time` arguments to
  [`probability_contain()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_contain.md).
  This addition is backwards compatible as by default the time is
  unlimited, `outbreak_time = Inf`, and no generation time is required.

### Breaking changes

- The `stochastic` argument in
  [`probability_contain()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_contain.md)
  has been renamed `simulate` to be consistent with other functions
  ([\#103](https://github.com/epiverse-trace/superspreading/issues/103)).

### Minor changes

- The proportions output of `proportion_*()` functions are now formatted
  to significant figures rather than rounding to prevent small values
  being rounded to zero
  ([\#102](https://github.com/epiverse-trace/superspreading/issues/102)).
- Improve input checking, error messages and edge case handling for
  functions
  ([\#102](https://github.com/epiverse-trace/superspreading/issues/102)).
- Vignettes now use
  [`rmarkdown::html_vignette`](https://pkgs.rstudio.com/rmarkdown/reference/html_vignette.html)
  instead of `bookdown::html_vignette2` and `as_is: true` has been
  removed due to changes to {pkgdown} in v2.1.0. {bookdown} has been
  removed as a suggested package and code folding is removed from
  vignettes. KaTeX headers have been added to `_pkgdown.yml` for correct
  math rendering
  ([\#104](https://github.com/epiverse-trace/superspreading/issues/104)
  &
  [\#109](https://github.com/epiverse-trace/superspreading/issues/109)).
- The `get_epidist_params()` internal function has been renamed
  `get_epiparameter_params()` since {epiparameter} renamed the
  `<epidist>` class to `<epiparameter>`
  ([\#100](https://github.com/epiverse-trace/superspreading/issues/100)).
- Internal constants have been added to the package and used by
  functions
  ([\#111](https://github.com/epiverse-trace/superspreading/issues/111)).
- Checking if the user specifies individual parameters (`R` and `k`) or
  provides an `<epiparameter>` object is now in `.check_input_params()`
  ([\#111](https://github.com/epiverse-trace/superspreading/issues/111)).

### Bug fixes

- None to {superspreading} functions.
- Update {epiparameter} use in vignette and tests
  ([\#106](https://github.com/epiverse-trace/superspreading/issues/106)).

### Deprecated and defunct

- None

## superspreading 0.2.0

Second minor release of *superspreading*. This release enhances
functions added in v0.1.0 and adds two new exported functions, and two
new vignettes.

### New features

- A new function
  ([`calc_network_R()`](https://epiverse-trace.github.io/superspreading/dev/reference/calc_network_R.md))
  to estimate the reproduction number for heterogeneous networks and a
  vignette outlining use cases for the function from existing
  epidemiological literature is added
  ([\#71](https://github.com/epiverse-trace/superspreading/issues/71)).
- [`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)
  and
  [`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md)
  now have individual-level and population-level control in a joint
  framework
  ([\#70](https://github.com/epiverse-trace/superspreading/issues/70)).
- `proportion_*()` functions can now return proportion columns of the
  output `<data.frame>` as `numeric` when the new argument `format_prop`
  is set to `FALSE`
  ([\#72](https://github.com/epiverse-trace/superspreading/issues/72)).
- A new design principles vignette to document package development is
  added
  ([\#68](https://github.com/epiverse-trace/superspreading/issues/68)).
- Added a helper function
  ([`ic_tbl()`](https://epiverse-trace.github.io/superspreading/dev/reference/ic_tbl.md))
  to improve model comparison tables
  ([\#65](https://github.com/epiverse-trace/superspreading/issues/65)).
- `probability_*()` functions now accept [dynamic
  dots](https://rlang.r-lib.org/reference/dyn-dots.html)
  ([{rlang}](https://CRAN.R-project.org/package=rlang) is added as a
  dependency)
  ([\#82](https://github.com/epiverse-trace/superspreading/issues/82)).

### Breaking changes

- `ind_control` and `pop_control` arguments replace `control` and
  `control_type` arguments in
  [`probability_contain()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_contain.md);
  and the argument default for `num_init_infect` is removed
  ([\#70](https://github.com/epiverse-trace/superspreading/issues/70)).
- Changed `epidist` argument to `offspring_dist` to follow Epiverse
  style (affects several functions)
  ([\#64](https://github.com/epiverse-trace/superspreading/issues/64)).
- Argument in
  [`proportion_transmission()`](https://epiverse-trace.github.io/superspreading/dev/reference/proportion_transmission.md)
  has been renamed from `sim` to `simulate`
  ([\#81](https://github.com/epiverse-trace/superspreading/issues/81)).

### Minor changes

- New package hex logo
  ([\#73](https://github.com/epiverse-trace/superspreading/issues/73)).
- Updated continuous integration and package infrastructure
  ([\#67](https://github.com/epiverse-trace/superspreading/issues/67)).
- Improved function documentation
  ([\#63](https://github.com/epiverse-trace/superspreading/issues/63)).
- Optimisation now uses [`optim()`](https://rdrr.io/r/stats/optim.html)
  by default
  ([\#82](https://github.com/epiverse-trace/superspreading/issues/82)).
- Testing suite now uses snapshot testing for regression tests
  ([\#84](https://github.com/epiverse-trace/superspreading/issues/84)).

### Bug fixes

- None to {superspreading} functions.
- Update {epiparameter} use in vignette and tests
  ([\#62](https://github.com/epiverse-trace/superspreading/issues/62)).

### Deprecated and defunct

- None

## superspreading 0.1.0

Initial release of *superspreading*, an R package to estimate
individual-level variation in disease transmission and provide summary
metrics for superspreading events.

### New features

- Offspring distributions, not available in base R, to fit to
  transmission data.
- Functions to calculate the probability an infectious disease will
  cause an epidemic, go extinct or be contained.
- Summary metric functions to calculate proportion of cases that cause a
  certain proportion of secondary transmission, as well as which
  proportion of cases are within clusters of a certain size.
- Three vignettes, including: an introduction to the package, estimating
  individual-level transmission from data, and the effect of
  superspreading on epidemic risk.
- Unit tests and documentation files.
- Continuous integration workflows for R package checks, rendering the
  README.md, calculating test coverage, and deploying the pkgdown
  website.

### Breaking changes

- None

### Bug fixes

- None

### Deprecated and defunct

- None
