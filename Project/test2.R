#Load the CSV
mlbdata = read.csv("mlbdata3.csv", header=TRUE, sep=",", nrows=5000)
fix(mlbdata)


#Load leaps so we limit the # of dimensions.
library(leaps)
library(glmnet)

newMLBData = na.omit(mlbdata)
attach(newMLBData)


#Get a Validation and a Test set randomly.
set.seed(1)
train = sample(c(TRUE, FALSE), dim(newMLBData)[1], rep=TRUE)
test = !train

MLB.trainX = model.matrix(YearP1W~., newMLBData[train,])[,]
MLB.trainY = newMLBData[train,]$YearP1W
MLB.testX = model.matrix(YearP1W~., newMLBData[train,])[,]
MLB.testY = newMLBData[train,]$YearP1W


mlbmatrix = model.matrix(newMLBData$YearP1W~., newMLBData)

#Let's do a fit with least squares
MLB.lm = lm(YearP1W~., data=newMLBData, subset=train)
MLB.lmPredictY = predict(MLB.lm, newMLBData[test,])


#Ridge
MLB.mod = glmnet(MLB.trainX, MLB.trainY, alpha=0)

MLB.ridge = cv.glmnet(MLB.trainX, MLB.trainY, alpha=0)
MLB.ridge.pred = predict(MLB.mod, s=MLB.ridge$lambda.min, MLB.testX)
MLB.ridge.mean = mean(( MLB.ridge.pred - MLB.testY)^2)


#Lasso
MLB.lassomod = glmnet(MLB.trainX, MLB.trainY, alpha=1)
MLB.lasso.cv = cv.glmnet(MLB.trainX, MLB.trainY, alpha=1)
MLB.lasso.pred = predict(MLB.lassomod, s=MLB.lasso.cv$lambda.min, newx=MLB.testX)
MLB.lasso.mean = mean(( MLB.lasso.pred - MLB.testY)^2)

#PLS
library(pls)
MLB.pcr.fit = pcr(YearP1W~., data=newMLBData, subset=train, scale=TRUE, validation="CV")
MLB.pcr.pred = predict(MLB.pcr.fit, MLB.testX[,-2],ncomp=17)
MLB.pcr.mean = mean((MLB.pcr.pred - MLB.testY)^2)


#PLS
MLB.pls.fit = plsr(YearP1W~., data=newMLBData, subset=train, scale=TRUE, validation="CV")
MLB.pls.predict = predict(MLB.pls.fit, MLB.testX[,-2], ncomp=13)
MLB.pls.mean = mean((MLB.pls.pred - MLB.testY)^2)
