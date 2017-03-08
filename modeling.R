## File for modeling algorithms
#

# Source files
source('data-prep.r')

# Needed libraries
library(dplyr)
library(readr)
library(ggplot2)
library(party)
library(tree)

# Read CSVs
training <- read.csv('./data/training.csv')
verification <- read.csv('./data/verification.csv')

# Create Custom dfs
t.df <- data.prep(training)
v.df <- data.prep(verification)

# Ensure that all factorise have the same levels
grade_levels <- union(levels(t.df$grade), levels(v.df$grade))
v.df$grade <- with(v.df, factor(grade, levels = grade_levels))
t.df$grade <- with(t.df, factor(grade, levels = grade_levels))

condition_levels <- union(levels(t.df$condition), levels(v.df$condition))
v.df$condition <- with(v.df, factor(condition, levels = condition_levels))
t.df$condition <- with(t.df, factor(condition, levels = condition_levels))

floors_levels <- union(levels(t.df$floors), levels(v.df$floors))
v.df$floors <- with(v.df, factor(floors, levels = floors_levels))
t.df$floors <- with(t.df, factor(floors, levels = floors_levels))

view_levels <- union(levels(t.df$view), levels(v.df$view))
v.df$view <- with(v.df, factor(view, levels = view_levels))
t.df$view <- with(t.df, factor(view, levels = view_levels))

yr_renovated_levels <- union(levels(t.df$yr_renovated), levels(v.df$yr_renovated))
v.df$yr_renovated <- with(v.df, factor(yr_renovated, levels = yr_renovated_levels))
t.df$yr_renovated <- with(t.df, factor(yr_renovated, levels = yr_renovated_levels))

yr_built_levels <- union(levels(t.df$yr_built), levels(v.df$yr_built))
v.df$yr_built <- with(v.df, factor(yr_built, levels = yr_built_levels))
t.df$yr_built <- with(t.df, factor(yr_built, levels = yr_built_levels))

zipcode_levels <- union(levels(t.df$zipcode), levels(v.df$zipcode))
v.df$zipcode <- with(v.df, factor(zipcode, levels = zipcode_levels))
t.df$zipcode <- with(t.df, factor(zipcode, levels = zipcode_levels))

# Find R Squared of all features
rsquared <- function(coefficient, feature) {
  model <- lm(price.thousands ~ coefficient, data = t.df)
  r.squared <- summary(model)$r.squared
  return(r.squared)
}

features <- lapply(1:25, function(x) names(t.df)[x])
r.values <- lapply(1:25, function(x) rsquared(t.df[,x]))
rsquared.df <- do.call(rbind, Map(data.frame, 'Feaure' = features, 'R_Squared' = r.values)) %>%
  arrange(-R_Squared)

# Prep data for trees by removing character types and factors with less than
# two levels
new_t.df <- t.df %>% 
    select(-price, -season, -date, -waterfront)
new_v.df <- v.df %>% 
  select(-price, -season, -date, -waterfront)

input.response <- new_v.df$price.thousands

# Run the trees
fit.all <- ctree(price.thousands ~ ., data = new_t.df)
pred.response.all <- predict(fit.all, new_v.df, type = 'response')
RMSE.all <- sqrt(mean((input.response - pred.response.all)^2))

fit.rsquared <- ctree(price.thousands ~ grade + sqft_living + zipcode +
                            sqft_above + sqft_living15 + bathrooms + sqft_basement + view + 
                            sqft_living_diff + yr_renovated + lat + bedrooms, data = new_t.df)
pred.response.rsquare <- predict(fit.rsquared, new_v.df, type = 'response')
RMSE.rsquared <- sqrt(mean((input.response - pred.response.rsquare)^2))

fit.upper <- ctree(price.thousands ~ grade + sqft_living + zipcode + 
                     sqft_above + sqft_living15 + bathrooms, data = new_t.df)
pred.response.upper <- predict(fit.upper, new_v.df, type = 'response')
RMSE.upper <- sqrt(mean((input.response - pred.response.upper)^2))

fit.lower <- ctree(price.thousands ~ sqft_basement + view + sqft_living_diff + 
                     yr_renovated + lat + bedrooms, data = new_t.df)
pred.response.lower <- predict(fit.rsquared.all, new_v.df, type = 'response')
RMSE.lower <- sqrt(mean((input.response - pred.response.lower)^2))


# Plotting fit against residuals
plot(fitted(model.2), residuals(model.2))




