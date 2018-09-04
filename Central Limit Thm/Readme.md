# Central Limit Theorem

This App empirically illustrates the Central Limit Theorem for some well-known probability distributions. To use it, open RStudio and run the code that you will find in the file "Central Limit Thm.R".

In the window that will pop-up, you will see a layout compounded of three parts:

<img src="https://github.com/DavidGarHeredia/teaching/blob/master/Central%20Limit%20Thm/TCL.png" alt="layout" width="600" height="400">

1. A left side panel: There you will be able to select:

	1. The distributions and their parameters.

	2. The number of Random Variables (RVs) to add (to illustrate the theorem).

	3. The sample size: The larger this number is, the better is the representation of the RVs in the computer. You can modify this value if you wish, but the default one works fine.

2. A plot-panel: Here you will see the histogram (or bar plot) resulting from what was established in the left side panel. When the number of Random Variables added is large, the Normal distribution will appear the theorem states.

3. <p>A text-panel: Above the plot it appears the theoretical mean and standard deviation of the resulting Normal approximation. Ex.: When adding <span class="math"><em>n</em></span> Poisson RVs *iid*, the resulting RV will be Normally distributed with parameters <span class="math"><em>μ</em> = <em>n</em><em>λ</em></span>, <span class="math">$\sigma = \sqrt {n\lambda}$</span>.</p>



### Packages required

To run this app, you will need to install first the following packages in RStudio:

+ Shiny.
+ Scales.
