## shiny server file

# Needed libraries
library(shiny)
library(stringr)

# Source files
source('shiny_setup.R')


#############################
### Shiny server function ###
#############################

shinyServer(function(input, output) {

    output$plot <- renderPlotly({
        ggplotly(plot_pred(input$model))
    })

    output$plot_title <- renderText({
        paste("Predicted vs Actual Price for:",
              str_to_title(input$model),
              "Model")
    })

    output$model_info <- renderText({
        paste("hello", 2 + 2)
    })

})
