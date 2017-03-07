## shiny server file

# Needed libraries
library(shiny)

# Source files
source('temp_models.R')


#############################
### Shiny server function ###
#############################

shinyServer(function(input, output) {

    output$txtout <- renderText({
        paste(input$txt, input$slider, format(input$date), sep = ", ")
    })
    output$table <- renderTable({
        head(cars, 4)
    })
    output$plot <- renderPlotly({
        ggplotly(g)
    })

})
