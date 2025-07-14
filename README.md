
<!-- README.md is generated from README.Rmd. Please edit that file -->

# *superspreading*: Estimate individual-level variation in transmission <img src="man/figures/logo.svg" align="right" width="120"/>

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit)
[![R-CMD-check](https://github.com/epiverse-trace/superspreading/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/superspreading/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/superspreading/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/superspreading?branch=main)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14756676.svg)](https://doi.org/10.5281/zenodo.14756676)
[![CRAN
status](https://www.r-pkg.org/badges/version/superspreading)](https://CRAN.R-project.org/package=superspreading)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/superspreading)](https://cran.r-project.org/package=superspreading)
<!-- badges: end -->

`{superspreading}` is an R package that provides a set of functions to
estimate and understand individual-level variation in transmission of
infectious diseases from data on secondary cases.

`{superspreading}` implements methods outlined in Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)), Lloyd-Smith et al.
([2005](#ref-lloyd-smithSuperspreadingEffectIndividual2005)), Adam J.
Kucharski et al. ([2020](#ref-kucharskiEarlyDynamicsTransmission2020)),
and Kremer et al.
([2021](#ref-kremerQuantifyingSuperspreadingCOVID192021)), as well as
additional functions.

`{superspreading}` is developed at the [Centre for the Mathematical
Modelling of Infectious
Diseases](https://www.lshtm.ac.uk/research/centres/centre-mathematical-modelling-infectious-diseases)
at the [London School of Hygiene and Tropical
Medicine](https://www.lshtm.ac.uk/) as part of
[Epiverse-TRACE](https://data.org/initiatives/epiverse/).

## Installation

The package can be installed from CRAN using

``` r
install.packages("superspreading")
```

The easiest way to install the development version of `{superspreading}`
from [GitHub](https://github.com/) is to use the `{pak}` package:

``` r
# check whether {pak} is installed
if(!require("pak")) install.packages("pak")
pak::pak("epiverse-trace/superspreading")
```

Alternatively, install pre-compiled binaries from [the Epiverse TRACE
R-universe](https://epiverse-trace.r-universe.dev/superspreading)

``` r
install.packages("superspreading", repos = c("https://epiverse-trace.r-universe.dev", "https://cloud.r-project.org"))
```

## Quick start

``` r
library(superspreading)
```

### Calculate the heterogeneity of transmission

Case study using data from early Ebola outbreak in Guinea in 2014,
stratified by index and non-index cases, as in Adam J. Kucharski et al.
([2016](#ref-kucharskiEffectivenessRingVaccination2016)). Data on
transmission from index and secondary cases for Ebola in 2014.

***Source***: Faye et al.
([2015](#ref-fayeChainsTransmissionControl2015)) & Althaus
([2015](#ref-althausEbolaSuperspreading2015)).

[`{fitdistrplus}`](https://CRAN.R-project.org/package=fitdistrplus) is a
well-developed and stable R package that provides a variety of methods
for fitting distribution models to data ([Delignette-Muller and Dutang
2015](#ref-delignette-mullerFitdistrplusPackageFitting2015)). Therefore,
it is used throughout the documentation of `{superspreading}` and is a
recommended package for those wanting to fit distribution models, for
example those supplied in `{superspreading}` (Poisson-lognormal and
Poisson-Weibull). We recommend reading the `{fitdistrplus}`
documentation (specifically `?fitdist`) to explore the full range of
functionality.

In this example we fit the negative binomial distribution to estimate
the reproduction number ($R$, which is the mean of the distribution) and
the dispersion ($k$, which a measure of the variance of the
distribution). The parameters are estimated via maximum likelihood (the
default method for `fitdist()`).

``` r
# we use {fitdistrplus} to fit the models
library(fitdistrplus)
#> Loading required package: MASS
#> Loading required package: survival

# transmission events from index cases
index_case_transmission <- c(2, 17, 5, 1, 8, 2, 14)

# transmission events from secondary cases
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
# rename size and mu to k and R
names(param_index$estimate) <- c("k", "R")
param_index$estimate
#>        k        R 
#> 1.596646 7.000771
param_non_index <- fitdist(data = non_index_cases, distr = "nbinom")
# rename size and mu to k and R
names(param_non_index$estimate) <- c("k", "R")
param_non_index$estimate
#>         k         R 
#> 0.1937490 0.6619608
```

The reproduction number ($R$) is higher for index cases than for
non-index cases, but the heterogeneity in transmission is higher for
non-index cases (i.e. $k$ is lower).

### Calculate the probability of a large epidemic

Given the reproduction number ($R$) and the dispersion ($k$), the
probability that a infectious disease will cause an epidemic, in other
words the probability it does not go extinct, can be calculated using
`probability_epidemic()`. Here we use `probability_epidemic()` for the
parameters estimated in the above section for Ebola, assuming there are
three initial infections seeding the potential outbreak.

``` r
# Compare probability of a large outbreak when k varies according to
# index/non-index values, assuming 3 initial spillover infections

initial_infections <- 3

# Probability of an epidemic using k estimated from index cases
probability_epidemic(
  R = param_index$estimate[["R"]],
  k = param_index$estimate[["k"]],
  num_init_infect = initial_infections
)
#> [1] 0.9995741

# Probability of an epidemic using k estimated from non-index cases
probability_epidemic(
  R = param_non_index$estimate[["R"]],
  k = param_non_index$estimate[["k"]],
  num_init_infect = initial_infections
)
#> [1] 0
```

The probability of causing a sustained outbreak is high for the index
cases, but is zero for non-index cases (i.e. disease transmission will
inevitably cease assuming transmission dynamics do not change).

## Package vignettes

More details on how to use `{superspreading}` can be found in the
[online documentation as package
vignettes](https://epiverse-trace.github.io/superspreading/), under
“Articles”.

### Visualisation and plotting functionality

`{superspreading}` does not provide plotting functions, instead we
provide example code chunks in the package’s vignettes that can be used
as a templates upon which data visualisations can be modified. We
recommend users copy and edit the examples for their own purposes. (This
is permitted under the package’s MIT license). By default code chunks
for plotting are folded, in order to unfold them and see the code simply
click the code button at the top left of the plot.

## Help

To report a bug please open an
[issue](https://github.com/epiverse-trace/superspreading/issues/new/choose)

## Contribute

Contributions to `{superspreading}` are welcomed. Please follow the
[package contributing
guide](https://github.com/epiverse-trace/.github/blob/main/CONTRIBUTING.md).

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
#>   Lambert J, Kucharski A, Adam D (2025). _superspreading: Understand
#>   Individual-Level Variation in Infectious Disease Transmission_. R
#>   package version 0.3.0.9000,
#>   <https://github.com/epiverse-trace/superspreading>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {superspreading: Understand Individual-Level Variation in Infectious Disease
#> Transmission},
#>     author = {Joshua W. Lambert and Adam Kucharski and Dillon C. Adam},
#>     year = {2025},
#>     note = {R package version 0.3.0.9000},
#>     url = {https://github.com/epiverse-trace/superspreading},
#>   }
```

## Related projects

This project has some overlap with other R packages:

- [`{epichains}`](https://github.com/epiverse-trace/epichains) is
  another Epiverse-TRACE R package that analyses transmission chain data
  to infer the likelihood for either the size or length of an outbreak
  cluster, or simulate transmission chains. It is based on the, now
  retired, [`{bpmodels}`](https://github.com/epiforecasts/bpmodels)
  package.

  Two main differences between `{superspreading}` and `{epichains}`
  are: 1) `{superspreading}` has functions to compute metrics that
  characterise outbreaks and superspreading events
  (e.g. `probability_epidemic()`, `probability_extinct()`,
  `proportion_cluster_size()` & `proportion_transmission()`); whereas
  `{epichains}` has functions to calculate the likelihood of a
  transmission chain size and length. 2) `{epichains}` exports functions
  to simulate a single-type branching process (`simulate_chains()` &
  `simulate_chain_stats()`).

- [`{modelSSE}`](https://CRAN.R-project.org/package=modelSSE) has a
  similar scope to `{superspreading}`, it contains functions to infer
  offspring distribution parameters. It exports several infectious
  disease outbreak datasets (see `data(package = "modelSSE")`). Both
  `{superspreading}` and `{modelSSE}` export functions to calculate the
  proportion of transmission using different methods. It also imports
  the [`{Delaporte}`](https://CRAN.R-project.org/package=Delaporte)
  package to model the offspring distribution as a Delaporte
  distribution.

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-althausEbolaSuperspreading2015" class="csl-entry">

Althaus, Christian L. 2015. “Ebola Superspreading.” *The Lancet
Infectious Diseases* 15 (5): 507–8.
<https://doi.org/10.1016/S1473-3099(15)70135-0>.

</div>

<div id="ref-antiaRoleEvolutionEmergence2003" class="csl-entry">

Antia, Rustom, Roland R. Regoes, Jacob C. Koella, and Carl T. Bergstrom.
2003. “The Role of Evolution in the Emergence of Infectious Diseases.”
*Nature* 426 (6967): 658–61. <https://doi.org/10.1038/nature02104>.

</div>

<div id="ref-delignette-mullerFitdistrplusPackageFitting2015"
class="csl-entry">

Delignette-Muller, Marie Laure, and Christophe Dutang. 2015.
“Fitdistrplus: An R Package for Fitting Distributions.” *Journal of
Statistical Software* 64 (4). <https://doi.org/10.18637/jss.v064.i04>.

</div>

<div id="ref-fayeChainsTransmissionControl2015" class="csl-entry">

Faye, Ousmane, Pierre-Yves Boëlle, Emmanuel Heleze, Oumar Faye, Cheikh
Loucoubar, N’Faly Magassouba, Barré Soropogui, et al. 2015. “Chains of
Transmission and Control of Ebola Virus Disease in Conakry, Guinea, in
2014: An Observational Study.” *The Lancet Infectious Diseases* 15 (3):
320–26. <https://doi.org/10.1016/S1473-3099(14)71075-8>.

</div>

<div id="ref-kremerQuantifyingSuperspreadingCOVID192021"
class="csl-entry">

Kremer, Cécile, Andrea Torneri, Sien Boesmans, Hanne Meuwissen, Selina
Verdonschot, Koen Vanden Driessche, Christian L. Althaus, Christel Faes,
and Niel Hens. 2021. “Quantifying Superspreading for COVID-19 Using
Poisson Mixture Distributions.” *Scientific Reports* 11 (1): 14107.
<https://doi.org/10.1038/s41598-021-93578-x>.

</div>

<div id="ref-kucharskiEffectivenessRingVaccination2016"
class="csl-entry">

Kucharski, Adam J., Rosalind M. Eggo, Conall H. Watson, Anton Camacho,
Sebastian Funk, and W. John Edmunds. 2016. “Effectiveness of Ring
Vaccination as Control Strategy for Ebola Virus Disease.” *Emerging
Infectious Diseases* 22 (1): 105–8.
<https://doi.org/10.3201/eid2201.151410>.

</div>

<div id="ref-kucharskiEarlyDynamicsTransmission2020" class="csl-entry">

Kucharski, Adam J, Timothy W Russell, Charlie Diamond, Yang Liu, John
Edmunds, Sebastian Funk, Rosalind M Eggo, et al. 2020. “Early Dynamics
of Transmission and Control of COVID-19: A Mathematical Modelling
Study.” *The Lancet Infectious Diseases* 20 (5): 553–58.
<https://doi.org/10.1016/S1473-3099(20)30144-4>.

</div>

<div id="ref-lloyd-smithSuperspreadingEffectIndividual2005"
class="csl-entry">

Lloyd-Smith, J. O., S. J. Schreiber, P. E. Kopp, and W. M. Getz. 2005.
“Superspreading and the Effect of Individual Variation on Disease
Emergence.” *Nature* 438 (7066): 355–59.
<https://doi.org/10.1038/nature04153>.

</div>

</div>
