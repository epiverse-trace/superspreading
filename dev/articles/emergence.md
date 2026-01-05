# Pathogen evolution in the emergence of infectious disease outbreaks

Infectious diseases that cannot transmit effectively between humans
cannot cause sustained disease outbreaks. However, they can cause
stuttering chains of transmission with several cases. These short
human-to-human transmission chains provide opportunities for the
pathogen to adapt to humans and enhance transmission potential.
Therefore, even in cases where a pathogen initially introduced into a
human population might have a reproduction number below 1, that is on
average it is transmitted to less than one other person (bound to
inevitably going extinct without pathogen evolution), if a pathogen
mutates while infecting humans, its reproduction number might evolve to
exceed 1, and emerge to cause sustained outbreaks.

This vignette explores the
[`probability_emergence()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_emergence.md)
function. This is based on the framework of Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)) which uses a multi-type
branching process to calculate the probability that a subcritical
zoonotic spillover will evolve into a more transmissible pathogen with a
reproduction number greater than 1 and thus be able to cause a sustained
epidemic from human-to-human transmission.

``` r
library(superspreading)
library(ggplot2)
library(scales)
```

We use
[`probability_emergence()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_emergence.md)
to replicate Figure 2b from Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)) showing how the
probability of emergence changes for different wild-type reproduction
numbers and different mutation rates. This assumes a 2-type branching
process with a wild-type pathogen with $R_{0} < 1$ and a mutant pathogen
with $R_{0} > 1$, we test with mutant reproduction numbers of 1.2, 1.5,
1,000.

``` r
R_wild <- seq(0, 1.2, by = 0.01)
R_mutant <- c(1.2, 1.5, 1000)
mutation_rate <- c(10^-1, 10^-3)

params <- expand.grid(
  R_wild = R_wild,
  R_mutant = R_mutant,
  mutation_rate = mutation_rate
)

prob_emerge <- apply(
  params,
  MARGIN = 1,
  FUN = function(x) {
    probability_emergence(
      R_wild = x[["R_wild"]],
      R_mutant = x[["R_mutant"]],
      mutation_rate = x[["mutation_rate"]],
      num_init_infect = 1
    )
  }
)
res <- cbind(params, prob_emerge = prob_emerge)
```

``` r
ggplot(data = res) +
  geom_line(
    mapping = aes(
      x = R_wild,
      y = prob_emerge,
      colour = as.factor(mutation_rate),
      linetype = as.factor(R_mutant)
    )
  ) +
  scale_y_continuous(
    name = "Probability of emergence",
    transform = "log",
    breaks = log_breaks(n = 6),
    limits = c(10^-5, 1)
  ) +
  scale_colour_manual(
    name = "Mutation rate",
    values = c("#228B22", "black")
  ) +
  scale_linetype_manual(
    name = "Mutant pathogen R0",
    values = c("dotted", "dashed", "solid")
  ) +
  scale_x_continuous(
    name = expression(R[0] ~ of ~ introduced ~ pathogen),
    limits = c(0, 1.2),
    n.breaks = 7
  ) +
  theme_bw()
#> Warning in scale_y_continuous(name = "Probability of emergence", transform =
#> "log", : log-2.718282 transformation introduced infinite values.
```

![Line plot showing the probability of emergence of a pathogen as a
function of the basic reproduction number (R0) of the introduced
pathogen. The x-axis represents the R0 of the introduced pathogen,
ranging from 0 to 1.2. The y-axis shows the probability of emergence on
a logarithmic scale from 1e-05 to 1. Lines vary by mutation rate (green
for 0.001 and black for 0.1) and by mutant pathogen R0 (dotted for R0 =
1.2, dashed for R0 = 1.5, solid for R0 = 1000). For both mutation rates,
the probability of emergence increases with the R0 of the introduced
pathogen and with the R0 of the mutant. Higher mutation rates and higher
mutant R0s lead to higher probabilities of
emergence.](emergence_files/figure-html/plot-prob-emerge-1.png)

Next we’ll replicate Figure 3a from Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)). This uses an extension
of the 2-type (or one-step) branching process model to include multiple
intermediate mutants/variants between the introduced wild-type and the
fully-evolved pathogen with an $R > 1$. In Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)) this is called the
*jackpot model*. The introduced pathogen is subcritical ($R < 1$), and
the intermediate variants have the same reproduction number as the
wild-type. Only the final fully-evolved variant is supercritical
($R > 1$).

We use the same number of intermediate mutants between the wild-type and
the fully-evolved strain as Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)).

``` r
R_wild <- seq(0, 1.2, by = 0.01)
R_mutant <- 1.5
mutation_rate <- c(10^-1)
num_mutants <- 0:4

params <- expand.grid(
  R_wild = R_wild,
  R_mutant = R_mutant,
  mutation_rate = mutation_rate,
  num_mutants = num_mutants
)

prob_emerge <- apply(
  params,
  MARGIN = 1,
  FUN = function(x) {
    probability_emergence(
      R_wild = x[["R_wild"]],
      R_mutant = c(rep(x[["R_wild"]], x[["num_mutants"]]), x[["R_mutant"]]),
      mutation_rate = x[["mutation_rate"]],
      num_init_infect = 1
    )
  }
)
res <- cbind(params, prob_emerge = prob_emerge)
```

``` r
ggplot(data = res) +
  geom_line(
    mapping = aes(
      x = R_wild,
      y = prob_emerge,
      colour = as.factor(num_mutants)
    )
  ) +
  scale_y_continuous(
    name = "Probability of emergence",
    transform = "log",
    breaks = log_breaks(n = 6),
    limits = c(10^-5, 1)
  ) +
  scale_colour_brewer(
    name = "Number of \nintermediate mutants",
    palette = "Set1"
  ) +
  scale_x_continuous(
    name = expression(R[0] ~ of ~ introduced ~ pathogen),
    limits = c(0, 1.2),
    n.breaks = 7
  ) +
  theme_bw()
#> Warning in scale_y_continuous(name = "Probability of emergence", transform =
#> "log", : log-2.718282 transformation introduced infinite values.
```

![Line plot showing the probability of emergence of a pathogen as a
function of the basic reproduction number (R0) of the introduced
pathogen, with varying numbers of intermediate mutants before reaching
the fully-evolved mutant. The x-axis represents the R0 of the introduced
pathogen (ranging from 0 to 1.2), and the y-axis shows the probability
of emergence on a logarithmic scale from 1e-05 to 1. Lines represent
different numbers of intermediate mutants: red for 0, blue for 1, green
for 2, purple for 3, and orange for 4. As the number of required
intermediate mutants increases, the probability of emergence decreases
across all R0 values. All curves rise with increasing R0, and converge
at higher R0 values near
1.2.](emergence_files/figure-html/plot-prob-emerge-multi-type-1.png)

Thus far we’ve only introduced a single infection, however, just as with
[`probability_epidemic()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_epidemic.md)
and
[`probability_extinct()`](https://epiverse-trace.github.io/superspreading/dev/reference/probability_extinct.md),
we extend the method of Antia et al.
([2003](#ref-antiaRoleEvolutionEmergence2003)) and introduce multiple
initial human infections using the `num_init_infect` argument.

``` r
R_wild <- seq(0, 1.2, by = 0.01)
R_mutant <- 1.5
mutation_rate <- 10^-1
num_mutants <- 1
num_init_infect <- seq(1, 9, by = 2)

params <- expand.grid(
  R_wild = R_wild,
  R_mutant = R_mutant,
  mutation_rate = mutation_rate,
  num_mutants = num_mutants,
  num_init_infect = num_init_infect
)

prob_emerge <- apply(
  params,
  MARGIN = 1,
  FUN = function(x) {
    probability_emergence(
      R_wild = x[["R_wild"]],
      R_mutant = c(rep(x[["R_wild"]], x[["num_mutants"]]), x[["R_mutant"]]),
      mutation_rate = x[["mutation_rate"]],
      num_init_infect = x[["num_init_infect"]]
    )
  }
)
res <- cbind(params, prob_emerge = prob_emerge)
```

``` r
ggplot(data = res) +
  geom_line(
    mapping = aes(
      x = R_wild,
      y = prob_emerge,
      colour = as.factor(num_init_infect)
    )
  ) +
  scale_y_continuous(
    name = "Probability of emergence",
    transform = "log",
    breaks = log_breaks(n = 6),
    limits = c(10^-5, 1)
  ) +
  scale_colour_brewer(
    name = "Number of introductions",
    palette = "Set1"
  ) +
  scale_x_continuous(
    name = expression(R[0] ~ of ~ introduced ~ pathogen),
    limits = c(0, 1.2),
    n.breaks = 7
  ) +
  theme_bw()
#> Warning in scale_y_continuous(name = "Probability of emergence", transform =
#> "log", : log-2.718282 transformation introduced infinite values.
```

![Line graph showing the relationship between the basic reproduction
number (R0) of an introduced pathogen and the probability of emergence,
under varying numbers of introductions. The x-axis represents R0 values
from 0 to 1.2, and the y-axis (logarithmic scale) represents the
probability of emergence, from 1e-05 to 1. Five curves are shown for
different numbers of introductions: 1 (red), 3 (blue), 5 (green), 7
(purple), and 9 (orange). All curves show increasing probability of
emergence with higher R0, and higher numbers of introductions
consistently increase emergence probability. Increasing the number of
initial infections has diminishing increases on the probability of
emergence with greater number of
introductions.](emergence_files/figure-html/plot-prob-emerge-multi-init-infect-1.png)

Antia, Rustom, Roland R. Regoes, Jacob C. Koella, and Carl T. Bergstrom.
2003. “The Role of Evolution in the Emergence of Infectious Diseases.”
*Nature* 426 (6967): 658–61. <https://doi.org/10.1038/nature02104>.
