## File to set up datam Shiny app needs
#

# Needed libraries
library(readr)
library(ggplot2)
library(dplyr)

# Read in data
pred.data <- read_csv('data/pred_data.csv') %>%
    select(price,
           prediction.all,
           prediction.lower,
           prediction.upper,
           prediction.rsquare) %>%
    mutate(price = price / 1000)

model.rmse <- read_csv('data/models_rmse.csv')


########################
### Plot predictions ###
########################

plot_pred <- function(model) {

    col.name <- paste0('prediction.', model)

    g <- ggplot(data = pred.data,
                aes(x = price),
                aes_string(y = col.name)) +
        geom_point(aes_string(y = col.name),
                   color = '#0066cc',
                   alpha = .5,
                   size = 2) +
        geom_smooth(aes_string(y = col.name),
                    method = 'lm',
                    se = FALSE,
                    color = '#d8b365',
                    size = 1.5) +
        geom_abline(intercept = 0,
                    slope = 1,
                    size = 1.5,
                    color = '#990033') +
        scale_x_continuous(limits = c(0, max(pred.data$price))) +
        scale_y_continuous(limits = c(0, max(pred.data$price))) +
        labs(x = 'Actual price (thousands of dollars)',
             y = 'Predicted Price (thousands of dollars)')

    return(g)
}


#################
### RMSE list ###
#################

rmse <- setNames(as.list(model.rmse$rmse), model.rmse$model.name)

