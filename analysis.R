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
test.data <- read_csv('data/testing.csv') %>%
    data.prep()


################
### Analysis ###
################


