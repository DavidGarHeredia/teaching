# Hypothesis Testing

This App shows, through different plots, how hypothesis tests work for Normal samples (when knowing or not the variance). To use the App, open RStudio and run the code that you will find in the file "Hypothesis testing.R".

The layout of the App is compounded of three parts:

<img src="https://github.com/DavidGarHeredia/teaching/blob/master/Hypothesis%20Testing/HT1.png" alt="layout" width="600" height="450">

1. A left side panel: There you will be able to select:

	1. <p> The <span class="math"><em>σ</em></span> parameter of the Normal distribution. When performing the test for unknown variance this will be ignore.<p>

	2. <p>The parameters of the test. Modifying the values, the App will automatically show the effect on the test. The sample standard deviation (<span class="math"><em>s̄</em></span>) will be ignore when performing the test for a known variance.</p>

	3. If you want to plot the p-value in the charts that show the test.

2. Three tabs on the top of the App. The first tab shows the test when the variance is known, the second one when it is not and the third shows a comparison between the two tests so the effect of knowing or not the variance can be appreciated.

3. A plot panel: The following three situations are represented:

	1. <p><span class="math"><em>H</em><sub>1</sub> ≠ <em>μ</em><sub>0</sub></span>.</p>

	2. <p><span class="math"><em>H</em><sub>1</sub> &gt; <em>μ</em><sub>0</sub></span>.</p>

	3. <p><span class="math"><em>H</em><sub>1</sub> &lt; <em>μ</em><sub>0</sub></span>.</p>

For the three cases: The dotted vertical line indicates the value of the statistic, the pink area is the Rejection Region and the conclusion of the test appears next to the plots.  

Notice that in the plots:

1. The title shows the distribution employed for the test.

2. Below the title appears the test that is being performed.

3. <p> For the test of the unknown variance, the degrees of freedom for the <span class="math"><em>t</em> − </span>distribution are shown. </p>

### Packages required

To run this app, you will need to install first the following packages in RStudio:

+ Shiny.
+ Scales.
