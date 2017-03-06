## File for modeling algorithms
#

# Source files
source('data-prep.r')

# Needed libraries
library(dplyr)
library(readr)

# Load data
training.data <- read_csv('data/training.csv') %>%
    data.prep()

verif.data <- read_csv('data/verification.csv') %>%
    data.prep()


################
### Modeling ###
################

