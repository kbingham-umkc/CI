

#Load the CSV
mlbdata = read.csv("mlbdata3.csv", header=TRUE, sep=",")
fix(mlbdata)


#Load leaps so we limit the # of dimensions.
library(leaps)


newMLBData = na.omit(mlbdata)
attach(newMLBData)

regfit.full = regsubsets(newMLBData$YearP1W~., newMLBData, nvmax=20)

summary(regfit.full)


#fix(newMLBData)


#predwl = as.numeric(newMLBData$YearP1W)
#lg = as.factor(as.character(newMLBData$Lg))
#g = as.numeric(newMLBData$G)
#w = as.numeric(newMLBData$W)
#l = as.numeric(newMLBData$L)

#df = data.frame(predwl, lg, g, l)
#rdf =  regsubsets(df[,c(2:4)], predwl)
