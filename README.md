
<!-- README.md is generated from README.Rmd. Please edit that file -->

# superspreading

*superspreading* provides functions for estimating individual-level
variation in transmission

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

## Installation

You can install the development version of *superspreading* from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("epiverse-trace/superspreading")
```

## Example: calculate probability of large epidemic

Case study using data from early Ebola outbreak in Guinea in 2014,
stratified by index and non-index cases, as in [Kucharski et al (EID,
2016)](https://doi.org/10.3201%2Feid2201.151410)

``` r
library(fitdistrplus)

# Load data on transmission from index and secondary cases for Ebola in 2014
# Source: Faye et al (https://doi.org/10.1016/S1473-3099(14)71075-8) & Althaus et al: https://doi.org/10.1016/S1473-3099(15)70135-0

n_all <- 152 # Total cases
index_case_transmission <- c(2,17,5,1,8,2,14)
secondary_case_transmission <- c(1,2,1,4,4,1,3,3,1,1,4,9,9,1,2,1,1,1,4,3,3,4,2,5,1,2,2,1,9,1,3,1,2,1,1,2) 

# Format data into index and non-index cases
n_non_index <- sum(c(index_case_transmission,secondary_case_transmission)) # Total non-index cases
non_index_cases <- c(secondary_case_transmission,rep(0,n_non_index-length(secondary_case_transmission))) # Transmission from all non-index cases

# Estimate R and k for index and non-index cases
param_index <- fitdistrplus::fitdist(index_cases,"nbinom") 
param_non_index <- fitdistrplus::fitdist(non_index_cases,"nbinom") 

# Compare probability of a large outbreak when k varies according to index/non-index values, 
# assuming R=2 and 3 initial spillover infections

R_input = 2
initial_infections = 3

# Probability of epidemic using k estimate from index cases
probability_epidemic(R = R_input, k = param_index$estimate[["size"]],a = initial_infections)

# Probability of epidemic using k estimate from non-index cases
probability_epidemic(R = R_input, k = param_non_index$estimate[["size"]],a = initial_infections)
```

## Development

### Lifecycle

This package is currently a *concept*. This means that essential
features and mechanisms are still being developed, and the package is
not ready for use outside of the development team.

### Contributions

Contributors to the project include:

-   Adam Kucharski (author)
-   Sebastian Funk (contributor)

### Code of Conduct

Please note that the linelist project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
