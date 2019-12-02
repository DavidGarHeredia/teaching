library(ggplot2)
library(viridisLite) 

set.seed(1410) 
dsmall <- diamonds[sample(nrow(diamonds), 1000), ] 


ggplot(dsmall, aes(x = carat, y = price, color = color)) + 
  facet_wrap(~ cut, ncol = 3) + 
  geom_point(alpha = 0.5) + 
  theme(legend.position = "bottom") 
  

#----------------------------------

plot1 <- ggplot(dsmall, aes(x = cut, y = price)) 
plot1 <- plot1 + geom_boxplot() 
print(plot1)


plot2 <- ggplot(dsmall, aes(x = cut, y = price)) 
plot2 <- plot2 + geom_boxplot(aes(color = cut)) 
plot2 <- plot2 + scale_color_viridis_d(option = "magma") 
print(plot2)


plot3 <- ggplot(dsmall, aes(x = cut, y = price)) 
plot3 <- plot3 + geom_boxplot(aes(fill = cut)) 
plot3 <- plot3 + scale_fill_viridis_d(alpha = 0.6) 
print(plot3)


plot4 <- ggplot(dsmall, aes(x = cut, y = price)) 
plot4 <- plot4 + geom_boxplot(aes(fill = cut, color = cut)) 
plot4 <- plot4 + scale_color_viridis_d(option = "cividis")
plot4 <- plot4 + scale_fill_viridis_d(alpha = 0.5, option = "cividis") 
plot4 <- plot4 + theme_light() # https://ggplot2.tidyverse.org/reference/ggtheme.html
print(plot4)


#----------------------------------

# Title and name of the axes
plot3 <- plot3 + labs(title = "Spread of price for each type of cut",
                      y = "Price ($)", x = "Type of cut") 
# Labels of x-axis
labelsX <- c("F", "G", "VG", "P", "I") 
plot3 <- plot3 + scale_x_discrete(labels = labelsX)
print(plot3)


plot3 <- plot3 + theme(plot.title = element_text(size   = 15,
                                                 face   = "bold",
                                                 family = "serif",
                                                 color  = "tomato",
                                                 hjust  = 0.5),  
                       axis.text.x = element_text(angle = 30,
                                                  vjust = .5)
                      )  
print(plot3)


# Legend
plot3 <- plot3 + scale_fill_viridis_d(alpha  = 0.6, 
                                      name   = "Cut quality",
                                      labels = labelsX)
print(plot3)


plot3 <- plot3 + theme(legend.title = element_text(colour = "blue",
                                                   size   = 10, 
                                                   face   = "bold"), 
                       legend.background = element_rect(fill = "gray90", 
                                                        size = .5, 
                                                        linetype = "dotted"),
                       legend.position = "top")
print(plot3)


#----------------------------------

plot3 <- plot3 + geom_boxplot(aes(fill = cut), 
                              outlier.fill = "turquoise1",
                              outlier.alpha = 0.4, 
                              outlier.shape = 23)

plot3 <- plot3 + geom_point(alpha = 0.1) 
print(plot3)


#----------------------------------

plotHist1 <- ggplot(dsmall)
plotHist1 <- plotHist1 + geom_histogram(aes(price, y = ..density..),
                                        color = "black", fill  = "lightblue",
                                        bins  = 10)
plotHist1 <- plotHist1 + labs(title = "Histogram")
print(plotHist1)


plotHist2 <- ggplot(dsmall)
plotHist2 <- plotHist2 + geom_histogram(aes(price, fill = cut),
                                      color = "black", bins = 10)
plotHist2 <- plotHist2 + scale_fill_viridis_d(option = "magma", alpha = 0.8)
plotHist2 <- plotHist2 + labs(title = "Stacked histogram")
print(plotHist2)


plotBar <- ggplot(dsmall)
plotBar <- plotBar + geom_bar(aes(cut, fill = color), 
                              width = 0.5) # width of the bars
plotBar <- plotBar + scale_fill_viridis_d()
plotBar <- plotBar + labs(title = "Stacked bar plot")

# Let's also rotate the x-labels
plotBar <- plotBar + theme(axis.text.x = element_text(angle = 65, vjust = 0.6))
print(plotBar)


#----------------------------------

plotDensity <- plotHist1 + labs(title = "Histogram and density line")

# Exponential distribution
plotDensity <- plotDensity + stat_function(fun   = dexp, 
                                           args  = list(rate = 1/mean(dsmall$price)), 
                                           color = "darkred", size = 0.7)

plotDensity <- plotDensity + annotate("text", x = 5000, y = 0.00020, 
                                      parse = TRUE, size  = 4, 
                                      label = "y == lambda*e^{-lambda*x}", 
                                      color = "darkred")

# Normal distribution
plotDensity <- plotDensity + stat_function(fun  = dnorm, 
                                           args = list(mean = mean(dsmall$price), 
                                                       sd   = sd(dsmall$price)), 
                                           color = "darkgreen", size = 0.7)

plotDensity <- plotDensity + annotate("text", x = 10000, y = 0.00010, 
                                      parse = TRUE, size = 4, 
                                      label = "y==frac(1, sqrt(2*pi))*e^{-x^2/2}", 
                                      color = "darkgreen")

print(plotDensity)


#----------------------------------

plotReg1 <- ggplot(dsmall)
plotReg1 <- plotReg1 + facet_wrap(~ cut, ncol = 3)
plotReg1 <- plotReg1 + geom_point(aes(x = carat, y = price, 
                                      shape = price > 15000, # condition for the shape
                                      color = price > 15000), 
                                  alpha = 0.5)
plotReg1 <- plotReg1 + scale_shape_manual(values = c(16,8)) # choose the shape
plotReg1 <- plotReg1 + scale_color_manual(values = c("black", "red")) # choose the color
plotReg1 <- plotReg1 + geom_smooth(aes(x = carat, y = price), method = lm, se = FALSE)
plotReg1 <- plotReg1 + theme(legend.position = "none")
print(plotReg1)


dsmall2  <- dsmall[dsmall$cut %in% c("Fair", "Good", "Very Good"), ]
plotReg2 <- ggplot(dsmall2) + labs(title = "Multiple lines")
plotReg2 <- plotReg2 + geom_point(aes(x = carat, y = price, color = cut, shape = cut), 
                                  alpha = 0.5)
plotReg2 <- plotReg2 + geom_smooth(aes(x = carat, y = price, color = cut), 
                                   method = lm, se = FALSE)
plotReg2 <- plotReg2 + scale_color_viridis_d(option = "inferno", 
                                             end = 0.75) # to not use the yellow color
print(plotReg2)


#----------------------------------

library(cowplot)

plotHist2 <- plotHist2 + theme(plot.title  = element_text(size = 10),
                               axis.text.x = element_text(size = 6),
                               axis.text.y = element_text(size = 6),
                               text = element_text(size = 7)
                              )

plotDensity <- plotDensity + theme(plot.title   = element_text(size = 10),
                                   legend.title = element_text(size = 7),
                                   axis.text.x  = element_text(size = 6),
                                   axis.text.y  = element_text(size = 6),
                                   text = element_text(size = 7)
                                  )

plotReg2 <- plotReg2 + theme(plot.title   = element_text(size = 10),
                             legend.title = element_text(size = 7),
                             axis.text.x  = element_text(size = 6),
                             axis.text.y  = element_text(size = 6),
                             text = element_text(size = 7)
                            )

multiplePlots <- plot_grid(plotHist2, plotDensity, plotReg2, 
                           labels = "AUTO",  # use "auto" for lowercase letters
                           label_size = 8,
                           ncol = 2, nrow = 2)

title <- ggdraw() + draw_label("General Title", fontface = 'bold')

plot_grid(title, multiplePlots, ncol = 1, 
          rel_heights = c(0.1, 1)) # rel_heights values control title margins


#----------------------------------

multiplePlots2 <- plot_grid(plotHist2, 
                            plot_grid(plotDensity, plotReg2, 
                                      ncol = 2, nrow = 1, 
                                      labels = c("(B)", "(C)"), label_size = 8), 
                            labels = c("(A)"), label_size = 8,
                            ncol = 1, nrow = 2)

plot_grid(title, multiplePlots2, ncol = 1, rel_heights = c(0.1, 1)) 

# https://drive.google.com/drive/folders/1JquAL_WJprY_nkkXyFKD-nb_0-IDZpij?usp=sharing
