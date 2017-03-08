## File to set up data Shiny app needs
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
           prediction.rsquare)

model.rmse <- read_csv('data/models_rmse.csv')

