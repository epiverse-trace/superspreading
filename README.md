
<!-- README.md is generated from README.Rmd. Please edit that file -->

# *superspreading*: Estimate individual-level variation in transmission <img src="man/figures/logo.png" align="right" width="130"/>

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/superspreading/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/superspreading/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/superspreading/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/superspreading?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`{superspreading}` is an R package that provides a set of functions to
estimate and understand individual-level variation in transmission from
secondary cases.

`{superspreading}` is developed at the [Centre for the Mathematical
Modelling of Infectious
Diseases](https://www.lshtm.ac.uk/research/centres/centre-mathematical-modelling-infectious-diseases)
at the [London School of Hygiene and Tropical
Medicine](https://www.lshtm.ac.uk/) as part of
[Epiverse-TRACE](https://data.org/initiatives/epiverse/).

## Installation

The easiest way to install the development version of `{superspreading}`
from [GitHub](https://github.com/) is to use the `{pak}` package:

``` r
# check whether {pak} is installed
if(!require("pak")) install.packages("pak")
pak::pak("epiverse-trace/superspreading")
```

## Quick start

``` r
library(superspreading)
```

### Calculate the heterogeneity of transmission

Case study using data from early Ebola outbreak in Guinea in 2014,
stratified by index and non-index cases, as in Kucharski et al.
([2016](#ref-kucharskiEffectivenessRingVaccination2016)). Data on
transmission from index and secondary cases for Ebola in 2014.

***Source***: Faye et al.
([2015](#ref-fayeChainsTransmissionControl2015)) & Althaus
([2015](#ref-althausEbolaSuperspreading2015)).

``` r
# we use {fitdistrplus} to fit the models
library(fitdistrplus)
#> Loading required package: MASS
#> Loading required package: survival

index_case_transmission <- c(2, 17, 5, 1, 8, 2, 14)
secondary_case_transmission <- c(
  1, 2, 1, 4, 4, 1, 3, 3, 1, 1, 4, 9, 9, 1, 2, 1, 1, 1, 4, 3, 3, 4, 2, 5, 
  1, 2, 2, 1, 9, 1, 3, 1, 2, 1, 1, 2
) 

# Format data into index and non-index cases
# total non-index cases
n_non_index <- sum(c(index_case_transmission, secondary_case_transmission)) 
# transmission from all non-index cases
non_index_cases <- c(
  secondary_case_transmission, 
  rep(0, n_non_index - length(secondary_case_transmission))
)

# Estimate R and k for index and non-index cases
param_index <- fitdist(data = index_case_transmission, distr = "nbinom") 
param_index
#> Fitting of the distribution ' nbinom ' by maximum likelihood 
#> Parameters:
#>      estimate Std. Error
#> size 1.596646   1.025029
#> mu   7.000771   2.320850
param_non_index <- fitdist(data = non_index_cases, distr = "nbinom") 
param_non_index
#> Fitting of the distribution ' nbinom ' by maximum likelihood 
#> Parameters:
#>       estimate Std. Error
#> size 0.1937490 0.05005421
#> mu   0.6619608 0.14197451
```

### Calculate the probability of large epidemic

``` r
# Compare probability of a large outbreak when k varies according to 
# index/non-index values, assuming R = 2 and 3 initial spillover infections

R <- 2
initial_infections <- 3

# Probability of epidemic using k estimate from index cases
probability_epidemic(
  R = R, 
  k = param_index$estimate[["size"]], 
  a = initial_infections
)
#> [1] 0.9280087

# Probability of epidemic using k estimate from non-index cases
probability_epidemic(
  R = R, 
  k = param_non_index$estimate[["size"]], 
  a = initial_infections
)
#> [1] 0.4665883
```

## Package vignettes

More details on how to use `{superspreading}` can be found in the
[online documentation as package
vignettes](https://epiverse-trace.github.io/superspreading/), under
“Articles”.

## Help

To report a bug please open an
[issue](https://github.com/epiverse-trace/superspreading/issues/new/choose)

## Contribute

Contributions to `{superspreading}` are welcomed. Please follow the
[package contributing
guide](https://github.com/epiverse-trace/superspreading/blob/main/.github/CONTRIBUTING.md).

## Code of Conduct

Please note that the {superspreading} project is released with a
[Contributor Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

## Citing this package

``` r
citation("superspreading")
#> To cite package 'superspreading' in publications use:
#> 
#>   Lambert J, Kucharski A (2023). _superspreading: Estimate individual
#>   level variation in transmission_. R package version 0.0.0.9000.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {superspreading: Estimate individual level variation in transmission},
#>     author = {Joshua W. Lambert and Adam Kucharski},
#>     year = {2023},
#>     note = {R package version 0.0.0.9000},
#>   }
```

## Related projects

This project has some overlap with other R packages:

- [`{bpmodels}`](https://github.com/epiverse-trace/bpmodels) is another
  Epiverse-TRACE R package that analyses transmission chain data to
  infer the transmission process for either the size or length of
  transmission chains. Two main differences between the packages are: 1)
  `{superspreading}` has more functions to compute metrics that
  characterise outbreaks and superspreading events
  (e.g. `probability_epidemic()` & `probability_extinct()`); 2)
  `{bpmodels}` can simulate a branching process (`chain_sim()`) with a
  specified process (e.g. negative binomial).

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-althausEbolaSuperspreading2015" class="csl-entry">

Althaus, Christian L. 2015. “Ebola Superspreading.” *The Lancet
Infectious Diseases* 15 (5): 507–8.
<https://doi.org/10.1016/S1473-3099(15)70135-0>.

</div>

<div id="ref-fayeChainsTransmissionControl2015" class="csl-entry">

Faye, Ousmane, Pierre-Yves Boëlle, Emmanuel Heleze, Oumar Faye, Cheikh
Loucoubar, N’Faly Magassouba, Barré Soropogui, et al. 2015. “Chains of
Transmission and Control of Ebola Virus Disease in Conakry, Guinea, in
2014: An Observational Study.” *The Lancet Infectious Diseases* 15 (3):
320–26. <https://doi.org/10.1016/S1473-3099(14)71075-8>.

</div>

<div id="ref-kucharskiEffectivenessRingVaccination2016"
class="csl-entry">

Kucharski, Adam J., Rosalind M. Eggo, Conall H. Watson, Anton Camacho,
Sebastian Funk, and W. John Edmunds. 2016. “Effectiveness of Ring
Vaccination as Control Strategy for Ebola Virus Disease.” *Emerging
Infectious Diseases* 22 (1): 105–8.
<https://doi.org/10.3201/eid2201.151410>.

</div>

</div>