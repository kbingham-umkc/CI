

#Load the CSV
mlbdata = read.csv("mlbdata_r.csv", header=TRUE, sep=",", nrows=5000)
#fix(mlbdata)


#Load leaps so we limit the # of dimensions.
library(leaps)


newMLBData = na.omit(mlbdata)
attach(newMLBData)

#Now let's do a training set  Gives us a training set of 2/3rds
set.seed(1)
onetwothree = sample(c(1, 2, 3), nrow(newMLBData), rep=TRUE)
train = onetwothree != 1
test=(!train)


regfit.full = regsubsets(YearP1W~., newMLBData[train,], nvmax=25)
regfit.fwd = regsubsets(YearP1W~., newMLBData[train,], nvmax=30, method="forward")
regfit.bwd = regsubsets(YearP1W~., newMLBData[train,], nvmax=30, method="backward")

regfit.summary = summary(regfit.full)

plot(regfit.summary$adjr2, xlab="Number of Variables", ylab="Adjusted RSq", type="l")
plot(regfit.summary$cp, xlab="Number of Variables", ylab="Adjusted cp", type="l")
plot(regfit.summary$bic, xlab="Number of Variables", ylab="Adjusted bic", type="l")

which.max(regfit.summary$adjr2)
which.min(regfit.summary$cp)
which.min(regfit.summary$bic)
#fix(newMLBData)

#Get a best fit
#regfit.best = regsubsets(YearP1W~., data=newMLBData[train,], nvmax=30, really.big=T)
regfit.best = regfit.full

regfit.test = model.matrix(YearP1W~., data=newMLBData[test,])

#Get the MSE Errors
val.errors = rep(NA, 30)
for (i in 1:30){
  coefi = coef(regfit.best,id=i)
  pred=regfit.test[,names(coefi)]%*%coefi
  val.errors[i]=mean((newMLBData$YearP1W[test]-pred)^2)
}
print(which.min(val.errors))

coef(regfit.full, id=which.max(regfit.summary$adjr2))
coef(regfit.full, id=which.min(regfit.summary$cp))
coef(regfit.full, id=which.min(regfit.summary$bic))
coef(regfit.full, id=which.min(val.errors))
