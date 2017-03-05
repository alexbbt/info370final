library(reshape2)
library(zoo)

#################
### Data Prep ###
#################

data.prep <- function(data) {
  if (is.data.frame(data)) {
    # Factorize numeric data points
    data$floors <- factor(data$floors)
    data$waterfront <- as.logical(data$waterfront) # could just be a factor
    data$view <- factor(data$view)
    data$condition <- factor(data$condition)
    data$grade <- factor(data$grade)
    data$yr_built <- factor(data$yr_built)
    data$yr_renovated <- factor(data$yr_renovated)
    data$zipcode <- factor(data$zipcode)
    
    ### Create Custom Metrics ##
    data$price.thousands <- data$price / 1000
    data$sqft_basement[data$sqft_basement == 0] <- NA
    data$yr_renovated[data$yr_renovated == 0] <- NA
    data$sqft_living_diff <- data$sqft_living - data$sqft_living15
    data$sqft_lot_diff <- data$sqft_lot - data$sqft_lot15
    
    # Find the season the home was sold
    month <- substr(data$date, 5, 6)
    year <- substr(data$date, 1, 4)
    day <- substr(data$date, 7, 8)
    data$date <- paste0(month,'/', day, '/', year)
    
    year.quarter <- as.yearqtr(as.yearmon(data$date, "%m/%d/%Y") + 1/12)
    data$season <- factor(format(year.quarter, "%q"), levels = 1:4,
                          labels = c("Winter", "Spring", "Summer", "Fall"))
    
    return(data)
  } else {
    return(NULL)
  }
}

# Optional variables.
#
# price.lower.3.quartiles.by.thousands <- data[data$price < 645000,]$price.thousands
#
# sqft_living.lower.3.quartiles <- data[data$sqft_living < 2550,]$sqft_living
#
# flat.data <- melt(data[,-c(2:5)], id.vars = "id")
#
# data.for.price.sqft.plot <- data[data$price < 645000,][data$sqft_living < 2550,]
#
# with.waterfront <- data[data$waterfront == 1,]
# without.waterfront <- data[data$waterfront == 0,]



