## shiny server file

# Needed libraries
library(shiny)


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

})
