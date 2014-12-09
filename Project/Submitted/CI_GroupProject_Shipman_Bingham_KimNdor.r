#Load leaps so we limit the # of dimensions.
library(leaps)


#Load the CSV
mlbdata = read.csv("mlbdata_r.csv", header=TRUE, sep=",", nrows=5000)

#Get rid of all the Empty data  ( empty columns )
newMLBData = na.omit(mlbdata)
attach(newMLBData)

#Now let's do a training set  Gives us a training set of 2/3rds
set.seed(1)
#Create Training set.  First create a vector of 1, 2, and 3.  So that we can get 2/3 of the data as train 1/3 as test.
onetwothree = sample(c(1, 2, 3), nrow(newMLBData), rep=TRUE)
train = onetwothree != 1
test=(!train)

#Create best subset selection for exhaustive, forward, backward and sequential replacment.
#May take while.
regfit.full = regsubsets(YearP1W~., newMLBData[train,], nvmax=25)
regfit.fwd = regsubsets(YearP1W~., newMLBData[train,], nvmax=30, method="forward")
regfit.bwd = regsubsets(YearP1W~., newMLBData[train,], nvmax=30, method="backward")
regfit.seqrep = regsubsets(YearP1W~., newMLBData[train,], nvmax=30, method="seqrep")


regfit.summary = summary(regfit.full)

#Plot the data from the adjr, cp and bic for the exhaustive.
plot(regfit.summary$adjr2, xlab="Number of Variables", ylab="Adjusted RSq", type="l")
plot(regfit.summary$cp, xlab="Number of Variables", ylab="Adjusted cp", type="l")
plot(regfit.summary$bic, xlab="Number of Variables", ylab="Adjusted bic", type="l")

#find the # of variables for each that work the best.
which.max(regfit.summary$adjr2)
which.min(regfit.summary$cp)
which.min(regfit.summary$bic)

#Get a best fit  Since our exhuastive was it, we just set it to the best fit.
regfit.best = regfit.full

#Create the test set matrix.
regfit.test = model.matrix(YearP1W~., data=newMLBData[test,])

#Get the MSE Errors for best fit
val.errors = rep(NA, 25)
for (i in 1:25){
  coefi = coef(regfit.best,id=i)
  pred=regfit.test[,names(coefi)]%*%coefi
  val.errors[i]=mean((newMLBData$YearP1W[test]-pred)^2)
}
print("minimum error index.")
print(which.min(val.errors))
print("MSE")
print(min(val.errors))

print("Coefficents for adjr, cp, bic")
coef(regfit.full, id=which.max(regfit.summary$adjr2))
coef(regfit.full, id=which.min(regfit.summary$cp))
coef(regfit.full, id=which.min(regfit.summary$bic))
coef(regfit.full, id=which.min(val.errors))

########### FWD SUBSET #################
#Get the MSE Errors for best fwd
val.errors = rep(NA, 25)
for (i in 1:25){
  coefi = coef(regfit.fwd,id=i)
  pred=regfit.test[,names(coefi)]%*%coefi
  val.errors[i]=mean((newMLBData$YearP1W[test]-pred)^2)
}
print("Forward low MSE index and MSE")
print(which.min(val.errors))
print(min(val.errors))

print("Coefficents for forward MSE")
coef(regfit.fwd, id=which.min(val.errors))

########### Backward SUBSET #################
#Get the MSE Errors for best BWD
val.errors = rep(NA, 25)
for (i in 1:25){
  coefi = coef(regfit.bwd,id=i)
  pred=regfit.test[,names(coefi)]%*%coefi
  val.errors[i]=mean((newMLBData$YearP1W[test]-pred)^2)
}
print("Backward low MSE index and MSE")
print(which.min(val.errors))
print(min(val.errors))

print("Coefficients for backward low MSE")
coef(regfit.bwd, id=which.min(val.errors))


########### Sequential Replacement SUBSET #################
#Get the MSE Errors for best Sequential replacement
val.errors = rep(NA, 25)
for (i in 1:25){
  coefi = coef(regfit.seqrep,id=i)
  pred=regfit.test[,names(coefi)]%*%coefi
  val.errors[i]=mean((newMLBData$YearP1W[test]-pred)^2)
}
print("sequential replacement low MSE index and MSE")
print(which.min(val.errors))
print(min(val.errors))
print("Coefficients for sequential replacement")
coef(regfit.seqrep, id=which.min(val.errors))


############ LASSO ############ 
library(glmnet)
k = 10
set.seed(1)
folds = sample(1:k,nrow(newMLBData),replace=TRUE)

avgVector = c()
MLB.X = as.matrix(newMLBData[,-42])
MLB.Y = newMLBData$YearP1W

for(j in 1:k){
	MLB.lasso.cv = cv.glmnet(MLB.X[folds!=j,],MLB.Y[folds!=j],alpha=1)
	minLambda = MLB.lasso.cv$lambda.min

	lasso.mod = glmnet(MLB.X[folds!=j,],MLB.Y[folds!=j],alpha=1,lambda=minLambda)
	MLB.lasso.pred = predict(lasso.mod,MLB.X[folds==j,],s=minLambda)
	mse = mean((MLB.Y[folds==j] - MLB.lasso.pred)^2)
	avgVector = c(avgVector, mse)
}

print(mean(avgVector))

#Get the last lasso and get the coefficients.
MLB.lasso.coef = predict(MLB.lasso.cv, type="coefficients", MLB.lasso.cv$lambda.min)
print("lasso coefficients")
print(MLB.lasso.coef)


#Do a linear fit with batting age up to 3 polynnomioal.
#MLB.throwfit = lm(YearP1W~poly(BatAge, 3)+X.P+YPN6+hr+BPF+PPF, data=newMLBData, subset=train)
#MLB.throwfit = lm(YearP1W~poly(BatAge, 2)+X.P+YPN6+hr+BPF+PPF, data=newMLBData, subset=train)
MLB.throwfit = lm(YearP1W~I(BatAge ^ 2)+X.P+YPN6+hr+BPF+PPF, data=newMLBData, subset=train)
summary(MLB.throwfit)  # Signifigance seems to be overstated here.
MLB.throwfitpred = predict(MLB.throwfit, newMLBData[test,])
#Extra doing a batage ^ 2 gives a really good mean with teh coefficients from backwards.
print(mean(MLB.throwfitpred-newMLBData$YearP1W[test])^2)  #WOW look at that mean.

