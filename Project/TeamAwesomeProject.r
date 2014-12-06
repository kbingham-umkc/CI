

#Load the CSV
mlbdata = read.csv("mlbdata5.csv", header=TRUE, sep=",", nrows=5000)
fix(mlbdata)


#Load leaps so we limit the # of dimensions.
library(leaps)


newMLBData = na.omit(mlbdata)
attach(newMLBData)

regfit.full = regsubsets(newMLBData$YearP1W~., newMLBData, nvmax=30, really.big=T)

regfit.summary = summary(regfit.full)

plot(regfit.summary$adjr2, xlab="Number of Variables", ylab="Adjusted RSq", type="l")
plot(regfit.summary$cp, xlab="Number of Variables", ylab="Adjusted cp", type="l")
plot(regfit.summary$bic, xlab="Number of Variables", ylab="Adjusted bic", type="l")

which.max(regfit.summary$adjr2)
which.min(regfit.summary$cp)
which.min(regfit.summary$bic)
#fix(newMLBData)


#predwl = as.numeric(newMLBData$YearP1W)
#lg = as.factor(as.character(newMLBData$Lg))
#g = as.numeric(newMLBData$G)
#w = as.numeric(newMLBData$W)
#l = as.numeric(newMLBData$L)

#df = data.frame(predwl, lg, g, l)
#rdf =  regsubsets(df[,c(2:4)], predwl)
