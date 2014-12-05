

#Load the CSV
mlbdata = read.csv("mlbdata.csv", sep=",")
fix(mlbdata)


#Load leaps so we limit the # of dimensions.
library(leaps)


newMLBData = na.omit(mlbdata)
attach(newMLBData)

regfit.full = regsubsets(newMLBData$YearP1W., newMLBData)

summary(regfit.full)


