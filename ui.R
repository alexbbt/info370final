## shiny ui file

# Needed libraries
library(shiny)
library(shinythemes)
library(plotly)


#########################
### Shiny UI function ###
#########################

shinyUI(

    navbarPage(

        theme = shinytheme("sandstone"),
        title = "Predicting Home Prices",

        tabPanel(
            title = "Introduction",
            h1("Introduction"),
            p("Welcome to our project")
        ),

        tabPanel(
            title = "Report",
            includeHTML('temp_report.html')
        ),

        tabPanel(

            title = "Interactive",
            h1("Interactive"),

            fluidRow(
                column(3,
                    wellPanel(
                        h4(strong("Choose Model:")),
                        radioButtons(inputId = "model",
                                     label = "",
                                     choices = c(
                                         "Full" = "full",
                                         "Top 5" = "top5",
                                         "Second 5" = "second5"
                                     ))
                   ),
                   wellPanel(
                       h4(strong("Model Info:")),
                       textOutput(outputId = "info")
                   )),
                column(9,
                    h2("Model"),
                    plotlyOutput("plot")
                )
            )
        )
    )
)
