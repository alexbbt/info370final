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

# Factorise
# levels(v.df$grade) <- c(levels(v.df$grade), setdiff(levels(t.df$grade), levels(v.df$grade)))
# levels(v.df$floors) <- c(levels(v.df$floors), setdiff(levels(t.df$floors), levels(v.df$floors)))
# levels(v.df$waterfront) <- c(levels(v.df$waterfront), setdiff(levels(t.df$waterfront), levels(v.df$waterfront)))
# levels(v.df$view) <- c(levels(v.df$view), setdiff(levels(t.df$view), levels(v.df$view)))
# levels(v.df$condition) <- c(levels(v.df$condition), setdiff(levels(t.df$condition), levels(v.df$condition)))
# levels(v.df$yr_built) <- c(levels(v.df$yr_built), setdiff(levels(t.df$yr_built), levels(v.df$yr_built)))
# levels(v.df$yr_renovated) <- c(levels(v.df$yr_renovated), setdiff(levels(t.df$yr_renovated), levels(v.df$yr_renovated)))
# levels(v.df$zipcode) <- c(levels(v.df$zipcode), setdiff(levels(t.df$zipcode), levels(v.df$zipcode)))
# set.factors <- function(index, df) {
#   if (is.factor(df[,index])) {
#     levels(df[,index]) <- c(levels(df[,index]), setdiff(levels(t.df[,index]), levels(df[,index])))
#   }
# }
# lapply(1:25, function(x) set.factors(x, v.df))

grade_levels <- union(levels(t.df$grade), levels(v.df$grade))
v.df$grade <- with(v.df, factor(grade, levels = grade_levels))
t.df$grade <- with(t.df, factor(grade, levels = grade_levels))

condition_levels <- union(levels(t.df$condition), levels(v.df$condition))
v.df$condition <- with(v.df, factor(condition, levels = condition_levels))
t.df$condition <- with(t.df, factor(condition, levels = condition_levels))

floors_levels <- union(levels(t.df$floors), levels(v.df$floors))
v.df$floors <- with(v.df, factor(floors, levels = floors_levels))
t.df$floors <- with(t.df, factor(floors, levels = floors_levels))

waterfront_levels <- union(levels(t.df$waterfront), levels(v.df$waterfront))
v.df$waterfront <- with(v.df, factor(waterfront, levels = waterfront_levels))
t.df$waterfront <- with(t.df, factor(waterfront, levels = waterfront_levels))

view_levels <- union(levels(t.df$view), levels(v.df$view))
v.df$view <- with(v.df, factor(view, levels = view_levels))
t.df$view <- with(t.df, factor(view, levels = view_levels))

yr_renovated_levels <- union(levels(t.df$yr_renovated), levels(v.df$yr_renovated))
v.df$yr_renovated <- with(v.df, factor(yr_renovated, levels = yr_renovated_levels))
t.df$yr_renovated <- with(t.df, factor(yr_renovated, levels = yr_renovated_levels))

yr_built_levels <- union(levels(t.df$yr_built), levels(v.df$yr_built))
v.df$yr_built <- with(v.df, factor(yr_built, levels = yr_built_levels))
t.df$yr_built <- with(t.df, factor(yr_built, levels = yr_built_levels))




lapply(1:25, function(x) set.factors(x, v.df))


# Log vars. Brings larger values together and spreads out smaller values
l.lot <- log(t.df$sqft_lot)
l.living <- log(t.df$sqft_living)
l.lot_15 <- log(t.df$sqft_lot15)
l.above <- log(t.df$sqft_above)
l.basement <- log(t.df$sqft_basement)


# Find R Squared of all features
rsquared <- function(coefficient, feature) {
  model <- lm(price.thousands ~ coefficient, data = t.df)
  r.squared <- summary(model)$r.squared
  return(r.squared)
}

features <- lapply(1:25, function(x) names(t.df)[x])
r.values <- lapply(1:25, function(x) rsquared(t.df[,x]))
linear.df <- do.call(rbind, Map(data.frame, 'Feaure' = features, 'R_Squared' = r.values)) %>%
  arrange(-R_Squared)



p.values <- lapply(1:25, function(x) pvalue(t.df[,x], names(t.df)[x]))

# Multi-linear regression models
m.grade <- lm(price.thousands ~ grade, data = t.df)
m.features <- lm(price.thousands ~ grade + l.lot + zipcode + l.above + l.lot_15 + bathrooms + l.basement + 
                 view + yr_renovated + lat + bedrooms, data = t.df)


# model.1 <- lm(price.thousands ~ grade + condition, data = t.df)
# model.2 <- lm(price ~ id, data = t.df)
# summary(model.2)
# summary(model.2)$coefficients
# coef(model.2)
# summary(model.2)$r.squared


# Create tree models
model_tree <- ctree(price ~ sqft_living + bedrooms + season, t.df)
new_t.df <- t.df %>% 
    select(-price, -season, -date)

rtree <- ctree(price.thousands ~ ., data = new_t.df)


t.df$price.predicted <- predict(rtree, newdata = new_t.df, type = 'response')

plot(t.df$price.thousands, t.df$price.predicted)

new_v.df <- v.df %>% 
  select(-price, -season, -date)

typeof(new_t.df)
typeof(new_v.df)

lapply(new_t.df, typeof)
lapply(new_v.df, typeof)

summary(new_t.df)
summary(new_v.df)


v.df$price.predicted <- predict(rtree, newdata = new_v.df, type = 'response')
class.check <- lapply(1:25, function(x) class(t.df[,x]) == class(v.df[,x]))



plot(v.df$price.thousands, v.df$price.predicted)

head(y)
head(t.df$price.thousands)
# Plotting fit against residuals
plot(fitted(model.2), residuals(model.2))



# Predict Models on verification data set




# Show R squared


# Fucking around with graphs
# abline adds a straight line to plot
# confint finds the the confidence intervals
summary(model.1)
confint(model.1)

abline(model.1)

summary(model.test)
hist(lsize)

abline(model.test)
a <- predict(model.test, t.df)
summary(a)






