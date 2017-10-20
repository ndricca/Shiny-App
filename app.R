library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# Define UI ----
ui <- fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    
  sidebarPanel(
    fluidRow(
      helpText("Create demographic maps with information from the 2010 US Census.")
    ),
    fluidRow(
      selectInput("var", h3("Select a variable to display"),
                  choices = list("Percent White",
                                 "Percent Black",
                                 "Percent Hispanic",
                                 "Percent Asian"),
                  selected = "Percent White"
                  )
    ),
    fluidRow(
      sliderInput("range", "Range of Interest:",
                  min = 0, max = 100, value = c(25, 75))
    )
  ),
  
  mainPanel(
    mainPanel(plotOutput("map",width = "100%"))
  )
  )
)

# Define server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)