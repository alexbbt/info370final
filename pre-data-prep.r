library(dplyr)

data <- read.csv('./data/ORIGINAL_DATA_DO_NOT_USE.csv')

set.seed(1234)

working.data <- sample_frac(data, 0.8, replace = FALSE)
working.data.rows <- order(as.numeric(rownames(working.data)))
working.data <- working.data[working.data.rows,] #Sort
test.data <- data[-working.data.rows,]

training.data <- sample_frac(working.data, 0.875, replace = FALSE)
training.data.rows <- order(as.numeric(rownames(training.data)))
training.data <- training.data[training.data.rows,] #Sort
verif.data <- working.data[-training.data.rows,]

verif.data.rows <- order(as.numeric(rownames(verif.data)))
testing.data.rows <- order(as.numeric(rownames(test.data)))

should.be.empty <- data[-training.data.rows,][-verif.data.rows,][-testing.data.rows,]
# This is to verify no over lap.

# summary(order(as.numeric(rownames(data[-order(c(training.data.rows, verif.data.rows)),]))) == testing.data.rows)
# 
# summary(order(as.numeric(rownames(data[-order(c(training.data.rows, testing.data.rows)),]))) == verif.data.rows)
# 
# summary(order(as.numeric(rownames(data[-order(c(verif.data.rows, testing.data.rows)),]))) == training.data.rows)

# summary(testing.data.rows %in% working.data.rows)

write.csv(training.data, file = "./data/training.csv",row.names=FALSE)
write.csv(verif.data, file = "./data/verification.csv",row.names=FALSE)
write.csv(test.data, file = "./data/testing.csv",row.names=FALSE)
