

#Load the CSV
mlbdata = read.csv("mlbdata2.csv", header=TRUE, sep=",")
fix(mlbdata)


#Load leaps so we limit the # of dimensions.
library(leaps)


newMLBData = na.omit(mlbdata)
attach(newMLBData)

regfit.full = regsubsets(newMLBData, newMLBData$YearP1W)

summary(regfit.full)


fix(newMLBData)
