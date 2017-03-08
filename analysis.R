## Analysis file for predicting housing prices
#

# Source files
source('data-prep.r')
source('modeling.R')

# Needed libraries
library(readr)
library(reshape2)
library(tidyr)
library(ggplot2)
library(dplyr)

# Load data
test <- read_csv('./data/testing.csv')

# Factorize dataframe
test.data <- data.prep(test)

# Normalize factors
test.data$grade <- with(test.data, factor(grade, levels = grade_levels))
test.data$condition <- with(test.data, factor(condition, levels = condition_levels))
test.data$floors <- with(test.data, factor(floors, levels = floors_levels))
test.data$view <- with(test.data, factor(view, levels = view_levels))
test.data$yr_renovated <- with(test.data, factor(yr_renovated, levels = yr_renovated_levels))
test.data$yr_built <- with(test.data, factor(yr_built, levels = yr_built_levels))
test.data$zipcode <- with(test.data, factor(zipcode, levels = zipcode_levels))


# Cleaned data for prediction
test.data.cleaned <- test.data %>% select(-price, -season, -date, -waterfront)


# response variable
input.response <- test.data.cleaned$price.thousands


# Run through Models
prediction.response.all <- predict(fit.all, test.data.cleaned, type = 'response')
RMSE.all <- sqrt(mean((input.response - prediction.response.all)^2))
test.data$prediction.all <- prediction.response.all

prediction.response.rsquare <- predict(fit.rsquared, test.data.cleaned, type = 'response')
RMSE.rsquared <- sqrt(mean((input.response - prediction.response.rsquare)^2))
test.data$prediction.rsquare <- prediction.response.rsquare

prediction.response.upper <- predict(fit.upper, test.data.cleaned, type = 'response')
RMSE.upper <- sqrt(mean((input.response - prediction.response.upper)^2))
test.data$prediction.upper <- prediction.response.upper

prediction.response.lower <- predict(fit.lower, test.data.cleaned, type = 'response')
RMSE.lower <- sqrt(mean((input.response - prediction.response.lower)^2))
test.data$prediction.lower <- prediction.response.lower


################
### Analysis ###
################

# Plots
plot(test.data$price.thousands, test.data$prediction.all)
plot(test.data$price.thousands, test.data$prediction.rsquare)
plot(test.data$price.thousands, test.data$prediction.upper)
plot(test.data$price.thousands, test.data$prediction.lower)


# Pretty Plots
ggplot(test.data, aes(x = test.data$price.thousands, y = test.data$prediction.all))  +
  scale_x_continuous(limits=c(min(test.data$price.thousands),max(test.data$price.thousands))) +
  scale_y_continuous(limits=c(min(test.data$prediction.all),max(test.data$prediction.all))) +
  geom_point(shape = 1, colour = '#6baed6') +
  geom_rug(col= '#3182bd') +
  geom_smooth(method = "lm", se = FALSE) +
  geom_abline(intercept = 0, slope = 1, color = 'black') +
  labs (title = "Price vs Predicted Price",
        x = 'Predicted Price from All Tree',
        y = 'Price')


######################
### Write new data ###
######################

rmse.data <-
  data_frame(
    model.name = c('all', 'lower', 'upper', 'rsquare'),
    rmse = c(RMSE.all, RMSE.lower, RMSE.upper, RMSE.rsquared)
  )

write_csv(test.data, 'data/pred_data.csv')
write_csv(rmse.data, 'data/models_rmse.csv')
