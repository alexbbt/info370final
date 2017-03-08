## shiny server file

# Needed libraries
library(shiny)

# Source files
source('temp_models.R')


#############################
### Shiny server function ###
#############################

shinyServer(function(input, output) {

    output$plot <- renderPlotly({
        ggplotly(g)
    })

    output$model_info <- renderText({
        paste("hello", 2 + 2)
    })

})
