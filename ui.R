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
            includeHTML('report.html')
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
                                         "All" = "all",
                                         "Lower" = "lower",
                                         "Upper" = "upper",
                                         "R-squared" = "rsquare"
                                     ))
                   ),
                   wellPanel(
                       h4(strong("Model Info:")),
                       textOutput(outputId = "model_info")
                   )),
                column(9,
                    h2(textOutput(outputId = "plot_title")),
                    plotlyOutput("plot")
                )
            )
        )
    )
)
