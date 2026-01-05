# Getting started with {superspreading}

The {superspreading} R package provides a set of functions for
understanding individual-level transmission dynamics, and thus whether
there is evidence of superspreading or superspreading events (SSE).
Individual-level transmission is important for understanding the growth
or decline in cases of an infectious disease accounting for transmission
heterogeneity, this heterogeneity is not accounted for by the
population-level reproduction number ($R$).

## Definition

Superspreading describes individual heterogeneity in disease
transmission, such that some individuals transmit to many infectees
while other infectors infect few or zero individuals ([Lloyd-Smith et
al. 2005](#ref-lloyd-smithSuperspreadingEffectIndividual2005)).

``` r
library(superspreading)
library(epiparameter)
```

The [{epiparameter}](https://github.com/epiverse-trace/epiparameter) R
package is loaded to provide a library of epidemiological parameters.
These parameters can be used by the {superspreading} functions. See the
[Empirical superspreading](#empirical-superspreading) section of this
vignette for its usage.

As an example, offspring distributions are stored in the {epiparameter}
library which contain estimated parameters, such as the reproduction
number ($R$), and in the case of a negative binomial model, the
dispersion parameter ($k$).

The offspring distribution is the distribution of the number of
infectees (secondary case or offspring) that each infector (primary
case) produces.

## Probability of epidemic

The probability that a novel disease will cause a epidemic
(i.e. sustained transmission in the population) is determined by the
nature of that diseases’ transmission heterogeneity. This variability
may be an intrinsic property of the disease, or a product of human
behaviour and social mixing patterns.

For a given value of $R$, if the variability is high, the probability
that the outbreak will cause epidemic is lower as the superspreading
events are rare. Whereas for lower variability the probability is higher
as more individuals are closer to the mean ($R$).

Here we use $R$ to represent the reproduction number (number of
secondary cases caused by a typical case). Depending on the situation,
this may be equivalent to the basic reproduction number ($R_{0}$,
representing transmission in a fully susceptible population) or the
effective reproduction number at a given point in time ($R_{t}$,
representing the extent of transmission at time $t$). Either can be
input into the functions provided by {superspreading}.

The
[`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)
function in {superspreading} can calculate the probability of sustained
transmission. $k$ is the dispersion parameter of a negative binomial
distribution and controls the variability of individual-level
transmission.

``` r
probability_epidemic(R = 1.5, k = 1, num_init_infect = 1)
#> [1] 0.3333333
probability_epidemic(R = 1.5, k = 0.5, num_init_infect = 1)
#> [1] 0.2324081
probability_epidemic(R = 1.5, k = 0.1, num_init_infect = 1)
#> [1] 0.06765766
```

In the above code, $k$ values above one represent low heterogeneity (in
the case $\left. k\rightarrow\infty \right.$ it is a Poisson
distribution), and as $k$ decreases, heterogeneity increases. When $k$
equals 1, the distribution is geometric. Values of $k$ less than one
indicate overdispersion of disease transmission, a signature of
superspreading.

When the value of $R$ increases, this causes the probability of an
epidemic to increase, if $k$ remains the same.

``` r
probability_epidemic(R = 0.5, k = 1, num_init_infect = 1)
#> [1] 0
probability_epidemic(R = 1.0, k = 1, num_init_infect = 1)
#> [1] 0
probability_epidemic(R = 1.5, k = 1, num_init_infect = 1)
#> [1] 0.3333333
probability_epidemic(R = 5, k = 1, num_init_infect = 1)
#> [1] 0.8
```

Any value of $R$ less than or equal to one will have zero probability of
causing a sustained epidemic.

Finally, the probability that a new infection will cause a large
epidemic is influenced by the number of initial infections
(`num_init_infect`) seeding the outbreak.

``` r
probability_epidemic(R = 1.5, k = 1, num_init_infect = 1)
#> [1] 0.3333333
probability_epidemic(R = 1.5, k = 1, num_init_infect = 10)
#> [1] 0.9826585
probability_epidemic(R = 1.5, k = 1, num_init_infect = 100)
#> [1] 1
```

## Empirical superspreading

Using
[`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)
it is possible to determine the probability of an epidemic for diseases
for which parameters of an offspring distribution have been estimated.
An offspring distribution is simply the distribution of the number of
secondary infections caused by a primary infection. It is the
distribution of $R$, with the mean of the distribution given as $R$.

Here we can use
[{epiparameter}](https://github.com/epiverse-trace/epiparameter) to load
in offspring distributions for multiple diseases and evaluate how likely
they are to cause epidemics.

``` r
sars <- epiparameter_db(
  disease = "SARS",
  epi_name = "offspring distribution",
  single_epiparameter = TRUE
)
#> Using Lloyd-Smith J, Schreiber S, Kopp P, Getz W (2005). "Superspreading and
#> the effect of individual variation on disease emergence." _Nature_.
#> doi:10.1038/nature04153 <https://doi.org/10.1038/nature04153>.. 
#> To retrieve the citation use the 'get_citation' function
evd <- epiparameter_db(
  disease = "Ebola Virus Disease",
  epi_name = "offspring distribution",
  single_epiparameter = TRUE
)
#> Using Lloyd-Smith J, Schreiber S, Kopp P, Getz W (2005). "Superspreading and
#> the effect of individual variation on disease emergence." _Nature_.
#> doi:10.1038/nature04153 <https://doi.org/10.1038/nature04153>.. 
#> To retrieve the citation use the 'get_citation' function
```

The parameters of each distribution can be extracted:

``` r
sars_params <- get_parameters(sars)
sars_params
#>       mean dispersion 
#>       1.63       0.16
evd_params <- get_parameters(evd)
evd_params
#>       mean dispersion 
#>        1.5        5.1
```

``` r
family(sars)
#> [1] "nbinom"
probability_epidemic(
  R = sars_params[["mean"]],
  k = sars_params[["dispersion"]],
  num_init_infect = 1
)
#> [1] 0.1198705
family(evd)
#> [1] "nbinom"
probability_epidemic(
  R = evd_params[["mean"]],
  k = evd_params[["dispersion"]],
  num_init_infect = 1
)
#> [1] 0.5092324
```

In the above example we assume the initial pool of infectors is one
(`num_init_infect = 1`) but this can easily be adjusted in the case
there is evidence for a larger initial seeding of infections, whether
from animal-to-human spillover or imported cases from outside the area
of interest.

We can see that the probability of an epidemic given the estimates of
Lloyd-Smith et al.
([2005](#ref-lloyd-smithSuperspreadingEffectIndividual2005)) is greater
for Ebola than SARS. This is due to the offspring distribution of Ebola
having a larger dispersion (dispersion $k$ = 5.1), compared to SARS,
which has a relatively small dispersion ($k$ = 0.16), with relatively
similar values of $R$ (Ebola $R =$ 1.5, SARS $R =$ 1.63).

## References

Lloyd-Smith, J. O., S. J. Schreiber, P. E. Kopp, and W. M. Getz. 2005.
“Superspreading and the Effect of Individual Variation on Disease
Emergence.” *Nature* 438 (7066): 355–59.
<https://doi.org/10.1038/nature04153>.
