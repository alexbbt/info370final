## File for verification of algorithms
#

source('data-prep.r')
source('modeling.R')


# Verification Data
verification <- read.csv('./data/verification.csv')

# Factorize dataframe
verification.data <- data.prep(verification)


# Normalize factors
verification.data$grade <- with(verification.data, factor(grade, levels = grade_levels))
verification.data$condition <- with(verification.data, factor(condition, levels = condition_levels))
verification.data$floors <- with(verification.data, factor(floors, levels = floors_levels))
verification.data$view <- with(verification.data, factor(view, levels = view_levels))
verification.data$yr_renovated <- with(verification.data, factor(yr_renovated, levels = yr_renovated_levels))
verification.data$yr_built <- with(verification.data, factor(yr_built, levels = yr_built_levels))
verification.data$zipcode <- with(verification.data, factor(zipcode, levels = zipcode_levels))


# Cleaned data for prediction
verification.data.cleaned <- verification.data %>% select(-price, -season, -date, -waterfront)


# response variable
input.response <- verification.data.cleaned$price.thousands


# Run through Models
prediction.response.all <- predict(fit.all, verification.data.cleaned, type = 'response')
RMSE.all <- sqrt(mean((input.response - prediction.response.all)^2))
verification.data$prediction.all <- prediction.response.all

prediction.response.rsquare <- predict(fit.rsquared, verification.data.cleaned, type = 'response')
RMSE.rsquared <- sqrt(mean((input.response - prediction.response.rsquare)^2))
verification.data$prediction.rsquare <- prediction.response.rsquare

prediction.response.upper <- predict(fit.upper, verification.data.cleaned, type = 'response')
RMSE.upper <- sqrt(mean((input.response - prediction.response.upper)^2))
verification.data$prediction.upper <- prediction.response.upper

prediction.response.lower <- predict(fit.lower, verification.data.cleaned, type = 'response')
RMSE.lower <- sqrt(mean((input.response - prediction.response.lower)^2))
verification.data$prediction.lower <- prediction.response.lower


# Plots
plot(verification.data$price.thousands, verification.data$prediction.all)
plot(verification.data$price.thousands, verification.data$prediction.rsquare)
plot(verification.data$price.thousands, verification.data$prediction.upper)
plot(verification.data$price.thousands, verification.data$prediction.lower)
