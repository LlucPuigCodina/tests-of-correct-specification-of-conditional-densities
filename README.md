Tests-for-correct-specification-of-conditional-densities
========================================================

`R` implementation of [Rossi and Sekhposyan
(2019)](https://doi.org/10.1016/j.jeconom.2018.07.008) by Lluc Puig
Codina.

Two tests, a Kolmogorov-Smirnov test and an Cràmer-von Mises test, are
implemented to assess the correct specification of rolling window
conditional distribution out-of-sample forecasts, one and multiple steps
ahead.

Aplications to Financial Risk Management
----------------------------------------

Expected shortfall is the risk measure at the forefront of Basel III.
The accuracy of expected shortfall depends on the accuracy of the
predicted distributions, their left tail in fact. Therefore we might
want to backtest that the left tail of the predictive distributions is
well specified. Unlike Diebold (1998) the test is joint, not pointwise,
and is robust to serial correlation of the probability integral
transforms (multi-step-ahead forecasts).

Test
----

### Input

The test is implemented in the function `RStest` which has several
arguments:

-   `pits`: A vector containing the probability integral transforms
    (predicted CDF evaluated at it’s realization), thus it’s elements
    are numeric and in \[0, 1\]. Elements are oredered from *t* = *R* to
    *T*, the out-of-sample set.

-   `alpha`: significance level, the probability of rejecting the null
    hypothesis when it is true.

-   `nSim`: number of simulations in the calculation of the critical
    values.

-   `rmin`: lower quantile to be tested. Must be in \[0,1\] and &gt;
    than `rmax`.

-   `rmax`: upper quantile to be tested. Must be in \[0,1\] and &lt;
    than `rmin`.

-   `step`: must be a string, either or . The first option implements
    the second boostrap procedure described in Theorem 2 of Rossi and
    Sekhposyan (2019) to compute critical values, while the second
    option implements the procedure described in Theorem 4 of Rossi and
    Sekhposyan (2019), which is robust to autocorrelation of the
    probability integral transforms (recomended for multi-step-ahead
    forecasts).

-   `l`: Bootstrap block length. Default is set to
    \[*P*<sup>1/3</sup>\], where \[ ⋅ \] denotes the floor operator, as
    in all Pannels, except G, of Table 3 in Rossi and Sekhposyan (2019).
    Although there is no guidance on how to choose `l`, results seem to
    be robust to alternative lengths. Boostrap block length must be
    numeric and larger than 1. Specifying the boostrap block length is
    unecessary for one-step-ahead forecasts.

### Output

The test outputs a list with several objects:

-   `KS_P`: Kolmogorov-Smirnov statistic.

-   `KS_alpha`: Kolmogorov-Smirnov critical value.

-   `CvM_P`: Cràmer-von Mises statistic.

-   `CvM_alpha`: Cràmer-von Mises critical value.

The null hypothesis of the correct specification of the conditional
distribution can be rejected if the statistic is larger than the
critical value.

Note
----

The test is set up such that one can test the null for
*r* ∈ \[rmin, rmax\] but not for say the left and the right tail,
*r* ∈ {\[0, 0.25\] ∩ \[0.75, 1\]}. The code is written such that it can
be easily modified. The point where modifications should be introduced
for this type of test are where `v` is subsettetd, line 76 for the
one-step-ahead forecasts and line 108 for multiple-step-ahead forecasts.
