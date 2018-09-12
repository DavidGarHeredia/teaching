# Author: David García Heredia
# Date: September 2018
# https://github.com/DavidGarHeredia/teaching

##################
# Libraries
##################
library('shiny')
library('scales')


##################
# Functions that we will need
##################
make_barplot <- function(dataVector){
  barplot(table(dataVector)/length(dataVector), col = alpha("#0288d1", 0.4),
          main = "Bar plot", xlab = "Quantiles", ylab = "Probability")
}


make_histogram <- function(dataVector){
  hist(dataVector, col = alpha("#0288d1", 0.4), probability = TRUE,
       main = "Histogram", xlab = "Quantiles", ylab = "Density")
}


compute_parameters <- function(input){
  if (input$dist == "bin"){
    mu 	  <- input$Nsample1 * input$p1 * input$numRV1
    sigma <- sqrt(mu * (1 - input$p1))
  } else if (input$dist == "norm"){
    mu    <- input$mu * input$numRV2
    sigma <- input$sd * sqrt(input$numRV2)
  } else if (input$dist == "pois"){
    mu    <- input$lambdaP * input$numRV3
    sigma <- sqrt(mu)
  } else if (input$dist == "exp"){
    mu    <- 1/input$lambdaE * input$numRV4
    sigma <- 1/input$lambdaE * sqrt(input$numRV4)
  } else {
    mu    <- (input$ub + input$lb)/2  * input$numRV5
    sigma <- sqrt((input$ub - input$lb)^2/12 * input$numRV5)
  }
  return (list(mu = round(mu, 3), sd = round(sigma, 3)))
}


generate_data <- function(input){
  if (input$dist == "bin"){
    x <- rbinom(input$Size1, input$Nsample1, input$p1)
    if(input$numRV1 > 1){
      for (i in 1:(input$numRV1 - 1)){
        x <- x + rbinom(input$Size1, input$Nsample1, input$p1)
      }
    }
  } else if (input$dist == "norm"){
    x <- rnorm(input$Size2, input$mu, input$sd)
    if(input$numRV2 > 1){
      for (i in 1:(input$numRV2 - 1)){
        x <- x + rnorm(input$Size2, input$mu, input$sd)
      }
    }
  } else if (input$dist == "pois"){
    x <- rpois(input$Size3, input$lambdaP)
    if(input$numRV3 > 1){
      for (i in 1:(input$numRV3 - 1)){
        x <- x + rpois(input$Size3, input$lambdaP)
      }
    }
  } else if (input$dist == "exp"){
    x <- rexp(input$Size4, input$lambdaE)
    if(input$numRV4 > 1){
      for (i in 1:(input$numRV4 - 1)){
        x <- x + rexp(input$Size4, input$lambdaE)
      }
    }
  } else {
    x <- runif(input$Size5, input$lb, input$ub)
    if(input$numRV5 > 1){
      for (i in 1:(input$numRV5 - 1)){
        x <- x + runif(input$Size5, input$lb, input$ub)
      }
    }
  }
  return (x)
}





##################
# The App
##################

ui <- fluidPage(
  headerPanel("Central Limit Theorem"),
  sidebarLayout(
    sidebarPanel(
      selectInput('dist', 'Distribution', c("Binomial" = "bin", "Normal" = "norm",
                  "Poisson" = "pois", "Exponential" = "exp", "Uniform" = "uni"),
                   selected = "bin"),

      conditionalPanel(
        condition = "input.dist == 'bin'",
        numericInput(inputId = 'numRV1', "Number of Random Variables", min = 1, value = 1),
        numericInput(inputId = 'Nsample1', "Number of trials (N)", min = 1, value = 10),
        numericInput(inputId = 'p1', "Probability of success (p)", min = 0,
                     max = 1, value = 0.5),
        numericInput(inputId = 'Size1', "Sample size", min = 1, value = 10000)
      ),

      conditionalPanel(
        condition = "input.dist == 'norm'",
        numericInput(inputId = 'numRV2', "Number of Random Variables", min = 1, value = 1),
        numericInput(inputId = 'mu', HTML("&mu;"), value = 0),
        numericInput(inputId = 'sd', HTML("&sigma;"), min = 0, value = 1),
        numericInput(inputId = 'Size2', "Sample Size", min = 1, value = 10000)
      ),

      conditionalPanel(
        condition = "input.dist == 'pois'",
        numericInput(inputId = 'numRV3', "Number of Random Variables", min = 1, value = 1),
        numericInput(inputId = 'lambdaP', HTML("&lambda;"), min = 0, value = 1),
        numericInput(inputId = 'Size3', "Sample Size", min = 1, value = 10000)
      ),

      conditionalPanel(
        condition = "input.dist == 'exp'",
        numericInput(inputId = 'numRV4', "Number of Random Variables", min = 1, value = 1),
        numericInput(inputId = 'lambdaE', HTML("&lambda;"), min = 0, value = 1),
        numericInput(inputId = 'Size4', "Sample Size", min = 1, value = 10000)
      ),

      conditionalPanel(
        condition = "input.dist == 'uni'",
        numericInput(inputId = 'numRV5', "Number of Random Variables", min = 1, value = 1),
        numericInput(inputId = 'lb', "Lower bound", value = 0),
        numericInput(inputId = 'ub', "Upper bound", value = 1),
        numericInput(inputId = 'Size5', "Sample Size", min = 1, value = 10000)
      )

    ),

    mainPanel(
      verbatimTextOutput(outputId = 'InfoCLT'),
      plotOutput(outputId = 'PlotCLT')
    )
  )
)

server <- function(input, output){

  data <- reactive({generate_data(input)})

  output$InfoCLT <- renderPrint({
    values <- compute_parameters(input)
    paste("Parameters of the Normal approximation: mu = ",
          values[1], ", sd = ", values[2])
  })

  output$PlotCLT <- renderPlot({
    if(input$dist == "bin" || input$dist == "pois"){
      make_barplot(data())
    } else {
      make_histogram(data())
    }
  })
}

shinyApp(ui = ui, server = server)


# In case you want to use ggplot2

# library('ggplot2')

# make_barplot <- function(dataVector){
#   qplot(dataVector, geom = "blank") +
#   geom_bar(aes(y = ..count../sum(..count..)), fill = I("lightsteelblue2"),
#            col = "#37474f", alpha = 0.7) +
#   labs(title = "Distribution bar plot", x ="Quantiles", y = "Probability")
# }
#
# make_histogram <- function(dataVector){
#   bw <- ceiling(diff(range(dataVector))/(2 * IQR(dataVector) * length(dataVector)^(-1/3)))
#   qplot(dataVector, geom="blank") +
#   geom_histogram(aes(y = ..density..), fill = I("lightsteelblue2"),
#                  col = "#37474f", alpha = 0.7, bins = bw) +
#   labs(title = "Distribution histogram", x ="Quantiles", y = "Density")
# }
