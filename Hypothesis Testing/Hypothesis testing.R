##################
# Libraries
##################
library('shiny')
library('scales')


##################
# Functions that we will need
##################
make_plot <- function(x, hx, stitle){
  plot(x, hx, type = "l", lwd = 2, col = alpha("#0288d1", 0.7),
       xlab = "", ylab = "",  axes = FALSE,
       main = stitle)
  axis(1, pos=0)
}


plot_area <- function(lb, ub, x, hx){
  polygon(c(lb, x, ub), c(0, hx, 0), col= alpha("#f44336", 0.3))
}


plot_pvalue <- function(lb, x, ub, hx){
  polygon(c(lb, x, ub), c(0, hx, 0), col= alpha("#90a4ae", 0.5))
}


get_quantiles <- function(B_tdist, input){
  x  <- seq(-4, 4, length = 1000)
  hx <- dnorm(x)
  if (B_tdist){
    hx <- dt(x, input$n - 1)
  }
  return (hx)
}


get_statistic <- function(B_tdist, input){
  value = (input$x_mean - input$mu0)/sqrt(input$sigma/input$n)
  if (B_tdist){
    value = (input$x_mean - input$mu0)*sqrt(input$n)/input$x_sd
  }
  return(value)
}


plot_dist <- function(B_tdist, input){
  x  <- seq(-4, 4, length = 1000)
  hx <- get_quantiles(B_tdist, input)

  if (B_tdist){
    make_plot(x, hx, paste("t distribution, ", input$n - 1, " df"))
  }else{
    make_plot(x, hx, "Normal distribution")
  }
}

get_alpha <- function(B_twoside, input){
  q_alpha <- 0
  if(B_twoside){
    q_alpha <- input$alpha/2
  }else{
    q_alpha <- input$alpha
  }
  return(q_alpha)
}

getQ <- function(B_tdist, input, q_alpha, B_left){
  if(B_left){
    ql <- qnorm(q_alpha)
    if (B_tdist){
      ql <- qt(q_alpha, input$n - 1)
    }
    return(ql)
  }else{
    qr <- qnorm(1 - q_alpha)
    if (B_tdist){
      qr <- qt(1 - q_alpha, input$n - 1)
    }
    return(qr)
  }
}


plot_quantiles <- function(B_tdist, input, B_twoside, B_right){

  # Compute the quantile and the value of the statistic
  q_alpha <- get_alpha(B_twoside, input)

  zl <- getQ(B_tdist, input, q_alpha, TRUE)   # left quantile
  zr <- getQ(B_tdist, input, q_alpha, FALSE)  # right quantile

  valueStatistic <- get_statistic(B_tdist, input)
  s_conclusion   <- expression("Not Reject H"[0]) # We change afterwards if needed

  # Make the plot
  x  <- seq(-4, 4, length = 1000)
  hx <- get_quantiles(B_tdist, input)


  if(B_twoside){
    # abline(v = c(zl, zr), col = alpha("#9b0000", 1)) # quantiles
    mtext(substitute(paste("H"[1], ": ", mu != a), list(a = input$mu0)), 3)
    i <- x <= zl
    plot_area(-4, zl, x[i], hx[i])
    i <- x >= zr
    plot_area(zr, 4, x[i], hx[i])

    if(abs(valueStatistic) > zr){s_conclusion = expression("Reject H"[0])}

  }else if(B_right){
    mtext(substitute(paste("H"[1], ": ", mu > a), list(a = input$mu0)), 3)
    i <- x >= zr
    plot_area(zr, 4, x[i], hx[i])

    if(valueStatistic > zr){s_conclusion = expression("Reject H"[0])}

  }else{
    mtext(substitute(paste("H"[1], ": ", mu < a), list(a = input$mu0)), 3)
    i <- x <= zl
    plot_area(-4, zl, x[i], hx[i])

    if(valueStatistic < zl){s_conclusion = expression("Reject H"[0])}
  }

  text(3.5, 0.3, s_conclusion, cex = 1.3)
}


plot_statistic <- function(input, B_tdist, B_twoside, B_right){

  valueStatistic <- get_statistic(B_tdist, input)

  if(input$radio == 1){
    x  <- seq(-4, 4, length = 1000)
    hx <- get_quantiles(B_tdist, input)

    if(B_twoside){
      i <- x <= -abs(valueStatistic)
      plot_pvalue(-4, x[i], -abs(valueStatistic), hx[i])
      i <- x >= abs(valueStatistic)
      plot_pvalue(abs(valueStatistic), x[i], 4, hx[i])

    }else if(B_right){
      i <- x >= valueStatistic
      plot_pvalue(valueStatistic, x[i], 4, hx[i])

    }else{
      i <- x <= valueStatistic
      plot_pvalue(-4, x[i], valueStatistic, hx[i])
    }
  }

  abline(v = valueStatistic, col = alpha("#212121", 1), lty = 2, lwd = 2)
}





##################
# The App
##################

ui <- fluidPage(
  headerPanel("Hypothesis Testing"),
  sidebarLayout(
    sidebarPanel(
      p(strong("Parameters of the Normal distribution")),
      # numericInput(inputId = 'mean', HTML("&mu;"), value = 0),
      numericInput(inputId = 'sigma', HTML("&sigma;"), min = 0, value = 1),

      p(strong("Data for the test")),
      numericInput(inputId = 'alpha', HTML("&alpha;"), min = 0, max = 1, value = 0.05),
      numericInput(inputId = 'mu0', HTML("&mu;<sub>0</sub>"), value = 0),

      numericInput(inputId = 'n', "n", min = 1, value = 20),
      numericInput(inputId = 'x_mean', HTML("x&#772"), value = 0.2),
      numericInput(inputId = 'x_sd', HTML("s&#772"), min = 0,, value = 1),

      radioButtons("radio", "Plot p-value?",
                   choices = list("No" = 0, "Yes" = 1), selected = 0)
    ),

    mainPanel(
      tabsetPanel(
        tabPanel(HTML("HT &sigma; known"),
                 plotOutput(outputId = 'Pcase1', height = "600px")),

        tabPanel(HTML("HT &sigma; unknown"),
                 plotOutput(outputId = 'Pcase2', height = "600px")),

        tabPanel(HTML("Comparing tests"),
                 plotOutput(outputId = 'Pcase3', height = "600px"))
      )
    )
  )
)


server <- function(input, output){

  # CASE 1: When the variance is known (Normal distribution)
  output$Pcase1 <- renderPlot({
    par(mfrow = c(3, 1))
    # two-sided
    plot_dist(FALSE, input)
    plot_quantiles(FALSE, input, TRUE, FALSE)
    plot_statistic(input, FALSE, TRUE, FALSE)
    # right-sided
    plot_dist(FALSE, input)
    plot_quantiles(FALSE, input, FALSE, TRUE)
    plot_statistic(input, FALSE, FALSE, TRUE)
    # left-sided
    plot_dist(FALSE, input)
    plot_quantiles(FALSE, input, FALSE, FALSE)
    plot_statistic(input, FALSE, FALSE, FALSE)
  })


  # CASE 2: When the variance is unknown (t distribution)
  output$Pcase2 <- renderPlot({
    par(mfrow = c(3, 1))
    # two-sided
    plot_dist(TRUE, input)
    plot_quantiles(TRUE, input, TRUE, FALSE)
    plot_statistic(input, TRUE, TRUE, FALSE)
    # right-sided
    plot_dist(TRUE, input)
    plot_quantiles(TRUE, input, FALSE, TRUE)
    plot_statistic(input, TRUE, FALSE, TRUE)
    # left-sided
    plot_dist(TRUE, input)
    plot_quantiles(TRUE, input, FALSE, FALSE)
    plot_statistic(input, TRUE, FALSE, FALSE)
  })


  # CASE 3: Comparing when using a t distribution or a Normal one.
  output$Pcase3 <- renderPlot({
    par(mfrow = c(2, 1))
    # Normal distribution
    plot_dist(FALSE, input)
    plot_quantiles(FALSE, input, TRUE, FALSE)
    plot_statistic(input, FALSE, TRUE, FALSE)
    # t distribution
    plot_dist(TRUE, input)
    plot_quantiles(TRUE, input, TRUE, FALSE)
    plot_statistic(input, TRUE, TRUE, FALSE)
  })

}

shinyApp(ui = ui, server = server)
