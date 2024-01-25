# superspreading 0.2.0

Second minor release of _superspreading_. This release enhances functions added in v0.1.0 and adds two new exported functions, and two new vignettes.

## New features

* A new function (`calc_network_R()`) to estimate the reproduction number for heterogeneous networks and a vignette outlining use cases for the function from existing epidemiological literature is added (#71).
* `probability_epidemic()` and `probability_extinct()` now have individual-level and population-level control in a joint framework (#70).
* `proportion_*()` functions can now return proportion columns of the output `<data.frame>` as `numeric` when the new argument `format_prop` is set to `FALSE` (#72).
* A new design principles vignette to document package development is added (#68).
* Added a helper function (`ic_tbl()`) to improve model comparison tables (#65).
* `probability_*()` functions now accept [dynamic dots](https://rlang.r-lib.org/reference/dyn-dots.html) ([{rlang}](https://CRAN.R-project.org/package=rlang) is added as a dependency) (#82).

## Breaking changes

* `ind_control` and `pop_control` arguments replace `control` and `control_type` arguments in `probability_contain()`; and the argument default for `num_init_infect` is removed (#70).
* Changed `epidist` argument to `offspring_dist` to follow Epiverse style (affects several functions) (#64).
* Argument in `proportion_transmission()` has been renamed from `sim` to `simulate` (#81).

## Minor changes

* New package hex logo (#73).
* Updated continuous integration and package infrastructure (#67).
* Improved function documentation (#63).
* Optimisation now uses `optim()` by default (#82).
* Testing suite now uses snapshot testing for regression tests (#84).

## Bug fixes

* None to {superspreading} functions.
* Update {epiparameter} use in vignette and tests (#62).

## Deprecated and defunct

* None

# superspreading 0.1.0

Initial release of _superspreading_, an R package to estimate individual-level variation in disease transmission and provide summary metrics for superspreading events.

## New features

* Offspring distributions, not available in base R, to fit to transmission data.
* Functions to calculate the probability an infectious disease will cause an epidemic, go extinct or be contained.
* Summary metric functions to calculate proportion of cases that cause a certain proportion of secondary transmission, as well as which proportion of cases are within clusters of a certain size.
* Three vignettes, including: an introduction to the package, estimating individual-level transmission from data, and the effect of superspreading on epidemic risk.
* Unit tests and documentation files.
* Continuous integration workflows for R package checks, rendering the README.md, calculating test coverage, and deploying the pkgdown website.

## Breaking changes

* None

## Bug fixes

* None

## Deprecated and defunct

* None
