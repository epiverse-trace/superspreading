# Calculate the reproduction number (\\R\\) for a (heterogeneous) network

The calculation of the reproduction number adjusting for heterogeneity
in number of contacts.

## Usage

``` r
calc_network_R(
  mean_num_contact,
  sd_num_contact,
  infect_duration,
  prob_transmission,
  age_range
)
```

## Arguments

- mean_num_contact:

  A `numeric`, mean (average) number of new contacts per unit time.

- sd_num_contact:

  A `numeric`, standard deviation of the number of new contacts per unit
  time.

- infect_duration:

  A `numeric`, the duration of infectiousness.

- prob_transmission:

  A `numeric` probability of transmission per contact, also known as
  \\\beta\\.

- age_range:

  A `numeric` vector with two elements, the lower and upper age limits
  of individuals in the network.

## Value

A named `numeric` vector of length 2, the unadjusted (`R`) and network
adjusted (`R_net`) estimates of \\R\\.

## Examples

``` r
# example using NATSAL data
calc_network_R(
  mean_num_contact = 14.1,
  sd_num_contact = 69.6,
  infect_duration = 1,
  prob_transmission = 1,
  age_range = c(16, 74)
)
#>         R     R_net 
#> 0.2431034 6.1665077 
```
