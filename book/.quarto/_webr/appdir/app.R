library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Law of Large Numbers: Dice Rolls"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("n_rolls", 
                  "Number of rolls:",
                  min = 10,
                  max = 5000,
                  value = 100,
                  step = 10),
      actionButton("roll", "Roll the dice!", 
                   class = "btn-primary"),
      hr(),
      helpText("The red dashed line shows the theoretical 
               expected value of 3.5"),
      hr(),
      verbatimTextOutput("summary_stats")
    ),
    
    mainPanel(
      plotOutput("convergence_plot", height = "400px"),
      plotOutput("histogram", height = "200px")
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive values to store rolls
  rolls <- reactiveVal(NULL)
  
  # Generate new rolls when button is clicked
  observeEvent(input$roll, {
    new_rolls <- sample(1:6, input$n_rolls, replace = TRUE)
    rolls(new_rolls)
  })
  
  # Initialize with some rolls
  observe({
    if (is.null(rolls())) {
      rolls(sample(1:6, 100, replace = TRUE))
    }
  })
  
  # Convergence plot
  output$convergence_plot <- renderPlot({
    req(rolls())
    
    roll_data <- rolls()
    n <- length(roll_data)
    
    # Calculate running mean
    running_mean <- cumsum(roll_data) / seq_along(roll_data)
    
    df <- data.frame(
      roll_number = 1:n,
      running_mean = running_mean
    )
    
    ggplot(df, aes(x = roll_number, y = running_mean)) +
      geom_line(color = "steelblue", linewidth = 0.8) +
      geom_hline(yintercept = 3.5, color = "red", 
                 linetype = "dashed", linewidth = 1) +
      scale_y_continuous(limits = c(1, 6)) +
      labs(
        title = "Convergence of Sample Mean to Expected Value",
        x = "Number of Rolls",
        y = "Running Average"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank()
      )
  })
  
  # Histogram of rolls
  output$histogram <- renderPlot({
    req(rolls())
    
    df <- data.frame(value = factor(rolls(), levels = 1:6))
    
    ggplot(df, aes(x = value)) +
      geom_bar(fill = "steelblue", alpha = 0.7) +
      geom_hline(yintercept = length(rolls()) / 6, 
                 color = "red", linetype = "dashed") +
      labs(
        title = "Distribution of Rolls",
        x = "Die Face",
        y = "Count"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold")
      )
  })
  
  # Summary statistics
  output$summary_stats <- renderText({
    req(rolls())
    
    roll_data <- rolls()
    paste0(
      "Number of rolls: ", length(roll_data), "\n",
      "Sample mean: ", round(mean(roll_data), 4), "\n",
      "Expected value: 3.5\n",
      "Difference: ", round(abs(mean(roll_data) - 3.5), 4)
    )
  })
}

shinyApp(ui = ui, server = server)
