# Hypothesis Testing

This App shows, through different plots, how hypothesis tests work for Normal populations (when knowing or not the variance). To use the App, open RStudio and run the code that you will find in the file ``Hypothesis testing.R''.

The layout of the App is compounded of three parts:

<img src="https://github.com/DavidGarHeredia/teaching/blob/master/Hypothesis%20Testing/HT.png" alt="layout" width="600" height="450">

1. A left side panel: There you will be able to select:

	1. The $\sigma$ parameter of the Normal distribution. When performing the test for unknown variance this will be ignore.

	2. The parameters of the test. Modifying the values, the App will automatically show the effect on the test. The sample standard deviation ($\bar{s}$) will be ignore when performing the test for a known variance.

	3. If you want to plot the p-value in the charts that show the test.

2. Three tabs on the top of the App. The first tab shows the test when the variance is known, the second one when it is not and the third shows a comparison between the two tests so the effect of knowing or not the variance can be appreciated.

3. A plot panel: The following three situations are represented:

	1. $H_1 \neq \mu_0$.

	2. $H_1 > \mu_0$.

	3. $H_1 < \mu_0$.

For the three cases: The dotted vertical line indicates the value of the statistic, the pink area is the Rejection Region and the conclusion of the test appears next to the plots.  

Notice that in the plots:

1. The title shows the distribution employed for the test.

2. Below the title appears the test that is being performed.

3. For the test of the unknown variance, the degrees of freedom for the $t-$distribution are shown.

### Packages required

To run this app, you will need to install first the following packages in RStudio:

+ Shiny.
+ Scales.
