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
            h1("Report"),
            p("This is our report")
        ),

        tabPanel(

            title = "Interactive",
            h1("Interactive"),

            sidebarPanel(

                fileInput("file", "File input:"),
                textInput("txt", "Text input:", "general"),
                sliderInput("slider", "Slider input:", 1, 100, 30),
                h5("Deafult actionButton:"),
                actionButton("action", "Search"),
                h5("actionButton with CSS class:"),
                actionButton("action2", "Action button", class = "btn-primary")
            ),

            mainPanel(tabsetPanel(
                tabPanel(
                    "Tab 1",
                    h4("Table"),
                    tableOutput("table"),
                    h4("Verbatim text output"),
                    verbatimTextOutput("txtout"),
                    plotlyOutput("plot")
                ),

                tabPanel("Tab 2"),
                tabPanel("Tab 3")
            ))
        )


    )
)
