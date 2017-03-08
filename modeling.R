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


# Factorize Data frame
training.data <- data.prep(training)


# Ensure that all factorise have the same levels
grade_levels <- as.character(c(3:13))
training.data$grade <- with(training.data, factor(grade, levels = grade_levels))

condition_levels <- as.character(c(1:5))
training.data$condition <- with(training.data, factor(condition, levels = condition_levels))

floors_levels <- as.character(c(2:7)/2)
training.data$floors <- with(training.data, factor(floors, levels = floors_levels))

view_levels <- as.character(c(0:4))
training.data$view <- with(training.data, factor(view, levels = view_levels))

yr_renovated_levels <- as.character(c(c(0), c(1934:2015)))
training.data$yr_renovated <- with(training.data, factor(yr_renovated, levels = yr_renovated_levels))

yr_built_levels <- as.character(c(1900:2015))
training.data$yr_built <- with(training.data, factor(yr_built, levels = yr_built_levels))

zipcode_levels <- as.character(c(98001:98119))
training.data$zipcode <- with(training.data, factor(zipcode, levels = zipcode_levels))


# Find R Squared of all features
rsquared <- function(coefficient, feature) {
  model <- lm(price.thousands ~ coefficient, data = training.data)
  r.squared <- summary(model)$r.squared
  return(r.squared)
}

features <- lapply(1:25, function(x) names(training.data)[x])
r.values <- lapply(1:25, function(x) rsquared(training.data[,x]))
rsquared.df <- do.call(rbind, Map(data.frame, 'Feaure' = features, 'R_Squared' = r.values)) %>%
  arrange(-R_Squared)


# Prep data for trees by removing character types and factors with less than
# two levels
training.data.cleaned <- training.data %>% select(-price, -season, -date, -waterfront)


# Run the trees
fit.all <- ctree(price.thousands ~ ., data = training.data.cleaned)
fit.rsquared <- ctree(price.thousands ~ grade + sqft_living + zipcode +
                            sqft_above + sqft_living15 + bathrooms + sqft_basement + view +
                            sqft_living_diff + yr_renovated + lat + bedrooms, data = training.data.cleaned)
fit.upper <- ctree(price.thousands ~ grade + sqft_living + zipcode +
                     sqft_above + sqft_living15 + bathrooms, data = training.data.cleaned)
fit.lower <- ctree(price.thousands ~ sqft_basement + view + sqft_living_diff +
                     yr_renovated + lat + bedrooms, data = training.data.cleaned)
