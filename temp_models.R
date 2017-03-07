## Temporary models for shiny app
#

# Needed libraries
library(plotly)
library(dplyr)
library(tibble)

# make data
set.seed(666)

x <- runif(100, 0, 100)
y <- if_else(runif(100) < .5,
             x + runif(100, 0, 15),
             x - runif(100, 0, 15))

data <- tibble(x, y)


# make plot
g <- ggplot(data = data,
            aes(x = x,
                y = y)) +
    geom_point()

ggplotly(g)

