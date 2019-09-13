Tests-for-correct-specification-of-conditional-densities
========================================================

`R` implementation of [Rossi and Sekhposyan
(2019)](https://doi.org/10.1016/j.jeconom.2018.07.008) by Lluc Puig
Codina.

Two tests, a Kolmogorov-Smirnov test and an Cràmer-von Mises test, are
implemented to assess the correct specification of rolling window
conditional distribution forecasts out of sample, one and multiple steps
ahead.

Aplications to Financial Risk Management
----
Expected shortfall is the risk measure at the forefront of Basel III. The accuracy of expected shortfall depends on the accuracy of the predicted distributions, their left tail in fact. Therefore we might want to backtest that the left tail of the predictive distributions is well specified. Unlike Diebold (1998) the test is joint, not pointwise, and is robust to serial correlation of the probability integral transforms (multi-step-ahead forecasts).

Test
----

An aplication of one of the tests, the Kolmogorov-Smirnov test, can be
found in [Adrian, Boyarchenko and Giannone
(2019)](https://www.aeaweb.org/articles?id=10.1257/aer.20161923). Here I
reproduce those results and also show the Càmer-von Mises test results.
The null hypothesis of the conditional distribution being correctly
specified can be rejected if the statistic is larger than the critical
value.

    rm(list=ls())

    set.seed(1234)

    library(readr)
    library(kableExtra)

    source("RStest.R", echo = FALSE)

    pits_quarter <- read_csv("data_quarter.csv", col_types = cols(X1 = col_skip()))
    pits_year <- read_csv("data_year.csv", col_types = cols(X1 = col_skip()))

    test_quarterly_GDP_and_NFCI <- RStest(pits_quarter$GDP_and_NFCI, alpha = 0.05, nSim = 1000, rmin = 0, rmax = 1, step = "one")
      
    test_quarterly_only_GDP <- RStest(pits_quarter$only_GDP, alpha = 0.05, nSim = 1000, rmin = 0, rmax = 1, step = "one")
      
    test_year_GDP_and_NFCI <- RStest(pits_year$GDP_and_NFCI, alpha = 0.05, nSim = 1000, rmin = 0, rmax = 1, step = "multiple", l = 12)
      
    test_year_only_GDP <- RStest(pits_year$only_GDP, alpha = 0.05, nSim = 1000, rmin = 0, rmax = 1, step = "multiple", l = 12)

    RStestresults <- data.frame(c(test_quarterly_GDP_and_NFCI$KS_P, test_quarterly_only_GDP$KS_P,
                                  test_year_GDP_and_NFCI$KS_P, test_year_only_GDP$KS_P),
                                c(test_quarterly_GDP_and_NFCI$KS_alpha, test_quarterly_only_GDP$KS_alpha,
                                  test_year_GDP_and_NFCI$KS_alpha, test_year_only_GDP$KS_alpha),
                                c(test_quarterly_GDP_and_NFCI$CvM_P, test_quarterly_only_GDP$CvM_P,
                                  test_year_GDP_and_NFCI$CvM_P, test_year_only_GDP$CvM_P),
                                c(test_quarterly_GDP_and_NFCI$CvM_alpha, test_quarterly_only_GDP$CvM_alpha,
                                  test_year_GDP_and_NFCI$CvM_alpha, test_year_only_GDP$CvM_alpha))

    rownames(RStestresults) <-c("One-Quarter-Ahead GDP and NFCI", "One-Quarter-Ahead only GDP",
                                "One-Year-Ahead GDP and NFCI", "One-Year-Ahead only GDP")

    colnames(RStestresults) <-c("Statistic", "Critical Value at 95%", 
                                "Statistic", "Critical Value at 95%")

    kable(RStestresults, longtable = T, booktabs = T, caption = "Correct Specification of the Conditional Distribution") %>%
      add_header_above(c(" ", "Kolmogorov-Smirnov Test" = 2, "Cràmer-von Mises Test" = 2)) %>%
      kable_styling(latex_options = c("repeat_header"))

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Correct Specification Tests of the Conditional Distribution
</caption>
<thead>
<tr>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="2">
Kolmogorov-Smirnov Test

</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="2">
Cràmer-von Mises Test

</th>
</tr>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Statistic
</th>
<th style="text-align:right;">
Critical Value at 95%
</th>
<th style="text-align:right;">
Statistic
</th>
<th style="text-align:right;">
Critical Value at 95%
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
One-Quarter-Ahead GDP and NFCI
</td>
<td style="text-align:right;">
1.901234
</td>
<td style="text-align:right;">
1.373776
</td>
<td style="text-align:right;">
1.6606653
</td>
<td style="text-align:right;">
0.4845432
</td>
</tr>
<tr>
<td style="text-align:left;">
One-Quarter-Ahead only GDP
</td>
<td style="text-align:right;">
1.582624
</td>
<td style="text-align:right;">
1.281321
</td>
<td style="text-align:right;">
0.8015819
</td>
<td style="text-align:right;">
0.4201134
</td>
</tr>
<tr>
<td style="text-align:left;">
One-Year-Ahead GDP and NFCI
</td>
<td style="text-align:right;">
2.719001
</td>
<td style="text-align:right;">
2.173060
</td>
<td style="text-align:right;">
3.1087441
</td>
<td style="text-align:right;">
1.7921749
</td>
</tr>
<tr>
<td style="text-align:left;">
One-Year-Ahead only GDP
</td>
<td style="text-align:right;">
1.606533
</td>
<td style="text-align:right;">
2.253907
</td>
<td style="text-align:right;">
0.7424817
</td>
<td style="text-align:right;">
1.6629933
</td>
</tr>
</tbody>
</table>
