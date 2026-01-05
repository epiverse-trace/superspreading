# Estimate what proportion of new cases originated within a transmission event of a given size

Calculates the proportion of new cases that originated with a
transmission event of a given size. It can be useful to inform backwards
contact tracing efforts, i.e. how many cases are associated with large
clusters. Here we define a cluster to as a transmission of a primary
case to at least one secondary case.

## Usage

``` r
proportion_cluster_size(
  R,
  k,
  cluster_size,
  ...,
  offspring_dist,
  format_prop = TRUE
)
```

## Arguments

- R:

  A `number` specifying the \\R\\ parameter (i.e. average secondary
  cases per infectious individual).

- k:

  A `number` specifying the \\k\\ parameter (i.e. dispersion in
  offspring distribution from fitted negative binomial).

- cluster_size:

  A `number` for the cluster size threshold.

- ...:

  [dots](https://rdrr.io/r/base/dots.html) not used, extra arguments
  supplied will cause a warning.

- offspring_dist:

  An `<epiparameter>` object. An S3 class for working with
  epidemiological parameters/distributions, see
  [`epiparameter::epiparameter()`](https://epiverse-trace.github.io/epiparameter/reference/epiparameter.html).

- format_prop:

  A `logical` determining whether the proportion column of the
  `<data.frame>` returned by the function is formatted as a string with
  a percentage sign (`%`), (`TRUE`, default), or as a `numeric`
  (`FALSE`).

## Value

A `<data.frame>` with the value for the proportion of new cases that are
part of a transmission event above a threshold for a given value of R
and k.

## Details

This function calculates the proportion of secondary cases that are
caused by transmission events of a certain size. It does not calculate
the proportion of transmission events that cause a cluster of secondary
cases of a certain size. In other words it is the number of cases above
a threshold divided by the total number of cases, not the number of
transmission events above a certain threshold divided by the number of
transmission events.

## Examples

``` r
R <- 2
k <- 0.1
cluster_size <- 10
proportion_cluster_size(R = R, k = k, cluster_size = cluster_size)
#>   R   k prop_10
#> 1 2 0.1   69.2%

# example with a vector of k
k <- c(0.1, 0.2, 0.3, 0.4, 0.5)
proportion_cluster_size(R = R, k = k, cluster_size = cluster_size)
#>   R   k prop_10
#> 1 2 0.1   69.6%
#> 2 2 0.2   51.4%
#> 3 2 0.3   39.2%
#> 4 2 0.4   30.8%
#> 5 2 0.5   25.3%

# example with a vector of cluster sizes
cluster_size <- c(5, 10, 25)
proportion_cluster_size(R = R, k = k, cluster_size = cluster_size)
#>   R   k prop_5 prop_10 prop_25
#> 1 2 0.1  85.5%     69%   34.8%
#> 2 2 0.2  76.2%   51.1%   14.2%
#> 3 2 0.3  69.2%   39.4%   6.05%
#> 4 2 0.4  64.1%   31.1%    2.6%
#> 5 2 0.5  59.8%   24.6%   1.47%
```
