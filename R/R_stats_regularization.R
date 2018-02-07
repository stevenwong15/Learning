#================================================================================= 
# [table of contents]
#   - subset selection
#   - shrinkage
#   - dimension reduction
#=================================================================================

#=================================================================================
# subset selection
# 	- information criterion methods 
# 	- best subset, with RSS or other IC methods
# 	- stepwise regression, with RSS or other IC methods
#   - cross-validation
#   - validation-test sets
#=================================================================================

#---------------------------------------------------------------------------------
# information criterion methods
#---------------------------------------------------------------------------------
#	- alternates of RSS, with penalty for large number of predictors
#	- already performed when doing lm(); just need to extract it
#	- alternatively, we can us the formula in the notes, by first computing the 
#      RSS, and plugging RSS into each IC method's formula:
k <- length(model$coef)  # number of predictors
RSS <- sum(model$resid^2)  # residual sum of squares 

# AIC:
# gives 1) the number of predictors, and 2) the AIC; 
# the default penalty factor is 2; AIC/BIC when computing the lm()
extractAIC(model) 

# BIC:
extractAIC(model, k = log(n))  # by changing the penalty factor, we get the BIC

# Mallow's Cp:
sigmahat <- summary(model)$sigma  # extract residual sd
extractAIC(fit, scale = sigmahat^2)  # returns Mallow's Cp, which is AIC scaled

#---------------------------------------------------------------------------------
# best subset, with RSS or other IC methods
#---------------------------------------------------------------------------------
#  "leaps and bounds" algorithm computes the best subset efficiently for < 30-40 p
library("leaps") 
subsets <- regsubsets(y ~ ., dataset)  # best subsets amongst all subset sizes

# i. getting all the subsets:
# the total number of models for each subset size
subsetsForEachP <- choose(p, 0:p)  
# p choose p/2 (gives the largest number of chooses for any combination of subsets)
allSubsets <- choose(p, floor(p / 2)) 
# saves all (really.big = TRUE) the subsets for each number of P (nbset = largest 
# number of subset size for any given P)
subsets <- regsubsets(y ~ ., data = train, nbest = allSubsets, really.big = TRUE)
# view only the best of each subset 
summary(subsets, all.best = FALSE) 

# i. getting just the best subsets
pSubsets <- p
# use nvmax; o/w by default, only upto a 8-variable subset size is produced
subsets <- regsubsets(y ~ ., data = train, nvmax = pSubsets)

# ii. plotting all the subsets:
# matrix of logical values that is TRUE if the variables are in the model, FALSE o/w
summary(subset)$which 

subsetSize <- c(0, rownames(summary(subsets)$which)) 
nofit <- lm(y ~ 1, dataset)  # assuming there is a beta0 (i.e. interception term)
# getting all the rss values, including that for the null 'nofit' model
rss.all <- c(sum(nofit$resid^2), summary(subsets)$rss) 
best  <- c(sum(nofit$resid^2), summary(subsets,all.best = FALSE)$rss)

#---------------------------------------------------------------------------------
# BIC:
bic <- summary(subsets)$bic
summary(subsets)$which[bic == min(bic), ] 
# or 
summary(subsets)$outmat[bic == min(bic), ]  # get model w/ the best BIC

# plotting all the BIC subsets:
all.bic <- c(extractAIC(nofit, k = log(n))[2], bic) 
best.bic <- c(extractAIC(nofit, k = log(n))[2], summary(subsets, all.best = FALSE)$bic) 
plot(bic)  # without the intercept term
plot(best.bic)  # with the intercept term
which.min(bic)  # gives the position of the min

#---------------------------------------------------------------------------------
# Mallow's Cp:
# - same as BIC, but with $cp instead of $bic
names(summary(subsets))

#---------------------------------------------------------------------------------
# adjusted r^2:
# - same as BIC, but with $adjr2 instead of $bic
names(summary(subsets))

#---------------------------------------------------------------------------------
# AIC:
# - a little more work because regsubsets() doesn't do AIC automatically, unlike lm()
all.subsets <- summary(subsets)$which
all.fits <- list()  
for(i in 1:nrow(all.subsets)){
     index <- colnames(all.subsets)[all.subsets[i, ]][-1]
     all.fits[[i]] <- lm(lpsa ~ ., data = train[, c(index, "lpsa")])
}
aic.fn <- function(fit){ extractAIC(fit)[2] }  # function to extract AIC
aic <- lapply(all.fits, aic.fn) # lapply() applies a function to every member of a list
aic <- unlist(aic) # removes the list structure from a list object
summary(subsets)$which[aic == min(aic), ] 
# or 
summary(subsets)$outmat[aic == min(aic), ]  # to see which model has the best AIC

# plotting all the AIC subsets:
all.aic <- c(extractAIC(nofit)[2], aic) 
# tapply() apply a specified function with each group of values, 
where grouping is defined by the 2nd argument
best.aic <- tapply(all.aic,size, min) 

#---------------------------------------------------------------------------------
# all three:
# - given a fixed k, all three information criteria will choose the same subset of 
#   predictors (i.e. the penalty factor is constant, and thus becomes zero in a 
#   minimization problem)
# - thus, we only need to compare the best subset of the three criteria (i.e. 3 
#   models), and choose among them
BIC <- summary(subsets, all.best = FALSE)$bic
summary(subsets, all.best = FALSE)$outmat[BIC == min(BIC), ]
CP <- summary(subsets, all.best = FALSE)$cp
summary(subsets,all.best = FALSE)$outmat[CP == min(CP), ]
best.subsets <- summary(subsets, all.best = FALSE)$which
best.fits = list() # first create an empty list for storage
for(i in 1:nrow(best.subsets)){
     index <- colnames(best.subsets)[best.subsets[i,]][-1]
     best.fits[[i]] <- lm(lpsa ~ .,data = train[, c(index, "lpsa")])
}
AIC <- unlist(lapply(best.fits,aic.fn))
summary(subsets, all.best = FALSE)$outmat[AIC == min(AIC), ]

#---------------------------------------------------------------------------------
# another way to plot:
# - to see graphically: the darker the shade (i.e. lower the value), the better 
#   the error by the specified criteria
# - it's likely the the model with too many, or too few variables will remain at
#   where bic / aic are very high (and thus no good)
best.subsets <- regsubsets(lpsa ~ .,data = train) 
plot(best.subsets, scale = "bic") 
plot(best.subsets, scale = "Cp")  
plot(best.subsets, scale = "r2") # r^2 is a scaled version of RSS 

#---------------------------------------------------------------------------------
# coefficients
ceof(subset, n = k)

#---------------------------------------------------------------------------------
# stepwise regression, with RSS or other IC methods
#---------------------------------------------------------------------------------
# i. best for each k subset of p:
forward <- regsubsets(lpsa ~ ., data = train, method = "forward") 
backward <- regsubsets(lpsa ~ ., data = train, method = "backward") 
summary(forward)$rss
summary(forward)$bic
summary(forward)$cp

# ii. best overall, showing steps:
# - choose the best lm(), given each information criteria, and subset search alogorithm
null.fit <- lm(lpsa ~ 1, data = train)
full.fit <- lm(lpsa ~ ., data = train)

# AIC
step(null.fit, 
     scope = list(lower = null.fit, upper = full.fit), 
     direction = "forward") 
# BIC
step(null.fit, 
     scope = list(lower = null.fit, upper = full.fit), 
     direction = "forward",k=log(n)) 
# Mallow's Cp 
step(null.fit, 
     scope = list(lower = null.fit, upper = full.fit), 
     direction = "forward", 
     scale = sigmahat^2)

# iii. ANOVA and the F-Test:
# - F-Test is an comparison of variance (and thus ANOVA: analysis of variance)
anova(model.lessP, model.moreP) 

# incorporating the F-Test into the step function:
step(null.fit,
     scope = list(lower = null.fit, upper = full.fit), 
     direction = "forward", test = "F")
step(full.fit, scope = list(lower = null.fit, upper = full.fit), 
     direction = "backward", test = "F")

#---------------------------------------------------------------------------------
# cross-validation
#---------------------------------------------------------------------------------

# writing our own predict function, that can be called with just 'predict'
predict.regsubsets <- function(object, newdata, id, ...) {
    form <- as.formula(object$call[[2]])  # gets the 'Y ~ .' form
    mat <- model.matrix(form, newdata)  # building the 'X' matrix from data
    coefi <- coef(object, id = id)  # get the coefficients
    mat[, names(coefi)] %*% coefi  # matrix multiplication of the selected cols
}


# nFold cross-validation
set.seed(1)
nFold <- 10
folds <- sample(rep(1:nFold, length = nrow(dataset)))
cv.errors <- matrix(NA, nFold, p)
for (k in 1:nFold) {
  best.fit <- regsubsets(Y ~ ., data = dataset[folds != k, ], nvmax = 19, 
                         method = 'forward')  # 'backwards' or without
  for (i in 1:p) {
      # calls the 'predict.regsubsets' function
      pred <- predict(best.fit, dataset[folds == k, ], id = i)
      cv.errors[k, i] <- mean((dataset$Y[folds == k] - pred)^2)
  }
}
rmse.cv = sqrt(apply(cv.errors, 2, mean))
plot(rmse.cv, pch = 19, type = "b")

#=================================================================================
# shrinkage
# - ridge regression
# - the lasso
# - cross-validation
# - validation
#=================================================================================

#---------------------------------------------------------------------------------
# ridge regression
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# method 1: library(glmnet)
# - glment standardizes y to have unit variance before computing
# - then, it unstandardizes the resulting coefficients
# - to compare with other software, best to supply a standardized y first

x <- model.matrix(Y ~ . - 1, data = dataset)  # '-1' to rid of interecept term
y <- dataset$y
fit.ridge <- glmnet(x, y, alpha = 0)
# alpha = 1 for lasso (default), 0 for ridge
# - in between: a mixture of lasso and ridge (say alpha = 0.5)
# - if predictors are correlated in groups, tends to select groups in/out together
# weights = 1 (default) for each observation
# nlambda = 100 (default) for number of lambdas to compute (recommends 100/more)
# - stopping criteria: % dev explained reaches 0.999 or marginal increase <0.00005
# standardize = TRUE (default) for x covariate standardization
# - coefficients are always returned on the original scale
# lower, upper = lower (must be ≤0) and upper (must be ≥0) bound of coefficients
# - e.g. if want coefficients to be positive
# penalty.factor = 1 (default); if set to zero, no penalty for the coefficient
# - e.g. if some variables may be so important that one wants to keep them all the time
# intercept = TRUE (default); can be set to FALSE to force zero intercept

# returns 1) # of nonzero coefficients, 2) % deviance explained, 3) lambda
print(fit.ridge)
plot(fit.ridge, xvar = "lambda", label = TRUE)
plot(fit.ridge, xvar = "dev", label = TRUE)  # fraction of variance explained

# adds variable name to plot
vnat <- coef(fit)
vnat <- vnat[-1, ncol(vnat)]  # removes intercept; get last set of coefficients
plot(fit.ridge, xvar = "lambda", label = TRUE)
axis(4, at = vnat, line = -0.5, label = names(vnat), las = 1, tick = FALSE, cex.axis = 0.5)

# get coefficient where lambda = 0.1 or 0.05
# - exact = FALSE for linear interpolation for values of s not in lambdas
# - exact = TRUE reruns with specified lambdas
coef(fit, s = c(0.1, 0.05), exact = FALSE)
coef(fit, s = c(0.1, 0.05), exact = TRUE, x = x, y = y)

# predict (same as for the lasso)
# type = "link" (log-odds), "response" (probability); for regression, both same
# e.g. predict where lambda = 0.1 or 0.05
predict(fit.ridge, newx = x_new, s = c(0.1, 0.05))

#---------------------------------------------------------------------------------
# method 2: regular ridge regression

# i. scaling the data:
# - normalize each column of the matrix / data.frame, with output always being a matrix; 
# - center = TRUE: each input subtracted by its column's mean; 
# - scale = TRUE: each input substrated by its column's standard deviation
xScaled = scale(X, center = TRUE, scale = TRUE) 
attr(xScaled, 'scaled:center')  # extract the scaled mean
attr(xScaled, 'scaled:scale')  # extract the scaled standard deviation

# ii. regressing:
# - scaling is automatical (not the case for lasso); scale manually for best practices
# - df and lambda are input arguments; b/c df is more restrictive (0 < df < p), 
#   it's often easier to use df (default value for lambda is 1)
fit.ridge <- simple.ridge(xScaled, dataset$Y, df = seq(1, p, by = increment)) 
fit.ridge$beta[, which(fit.ridge$df == value)]  # the betas for the ridge regression 

# iii. plotting all the dfs with their betas:
all.betas <- cbind(0, fit.ridge$beta)
all.dfs <- c(0, fit.ridge$df)
matplot(all.dfs, t(all.betas), type = 'o', col = 'blue', pch = 16, cex = 0.3, lty = 1,
        xlab = expression(df(lambda)), ylab = 'Coefficients', xlim = c(0,8.5), 
        xaxt = 'n')  # also removed the x-axis labels
# placing text starting at x value, and at the end of each line for the y value
text(x, betas[, ncol(betas)], rownames(betas), cex = 0.6, adj = 0) 

#---------------------------------------------------------------------------------
# lasso
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# method 1: library(glmnet)

x <- model.matrix(Y ~ . - 1, data = dataset)  # '-1' to rid of interecept term
y <- dataset$y
fit.ridge <- glmnet(x, y, alpha = 1) 
plot(fit.ridge, xvar = "lambda", label = TRUE)
plot(fit.ridge, xvar = "dev", label = TRUE)  # fraction of variance explained

#---------------------------------------------------------------------------------
# method 2: library(lasso2)

# i. data preparation:
# - scale all values to have zero mean and standard deviation of 1, except for the 
#   response, and attach the response column back in
data.S = data.frame(scale(data[, - responseColumn]), 'y' = data$y) 

# ii. the Lasso:
# - bound is the shrinkage factor, but if 'absolute.t = TRUE', the bound uses t instead 
#   (similar to the lambda vs. df for ridge regression); 
# - sometimes the lower bound needs to be 0.1 instead of 0 to not produce error
# - other optional arguments include (showing their default value): 
#   1) 'trace = FALSE' to not output the computation, 
#   2) 'sweep.out = ~1' to not penalize the intercept term, and 
#   3) 'standardize = FALSE' to not standardize the inputs
fit.lasso = l1ce(y ~ ., data.S, bound = seq(0, 1, by = 0.1)) 
# gives the Lasso fit for the ith value in the list
# we note that each value in the bound is a nested list, as the l1ce() output is a list
fit.lasso[[i]]  

# iii. plotting the Lasso:
# extract the coefficients
coef.fn <- function(x){x$coef}
lasso.coefs <- sapply(fit.lasso, coef.fn)
# extract the shrinkage factors used
shrinkage.factor <- sapply(fit.lasso, function(x){x$relative.bound}) 
colnames(lasso.coefs) <- shrinkage.factor  # input column names 

# getting rid of values that are zeros
for(i in 1:nrow(lasso.coefs)){
     for(j in 1:(ncol(lasso.coefs)-1)){
          if(lasso.coefs[i,j+1] == 0){
               lasso.coefs[i,j] = NA
          }
     }
}
matplot(s, t(lasso.coefs[-1, ]), type = 'o', 
        xlab = expression(paste('shrinkage factor ',s)),
        ylab = 'Coefficients', xlim = c(0,1.06), 
        col = 'blue', pch = 19, cex = 0.3, lty = 1, xaxt = 'n') 

#---------------------------------------------------------------------------------
# cross validation
#---------------------------------------------------------------------------------
# - first getting the number of samples in each fold:
# - if n / k = q * k + r, then we make:
#   - (r observations q + 1)
#   - (k - r observations q)

fold <- k  # number of folds (= k)
n <- nrow(dataset)  # number of observations to split
quot <- floor(n / fold)  # quotient
rem <- n %% fold  # remainder
counts <- rep(1:fold, rep(c(quot + 1, quot), c(rem, fold - rem)))  # repeat
table(counts)  # number of observations are in each subset
set.seed(99)  # making the grouping of the count random

# premute the values in counts without replacement, to randomly distribute 
# each training / test set
cv.index <- sample(counts) 

# to compare with linear model, use lm(), instead of glmnet, and setting lambda
# to zero, because lm() has more useful outputs

#---------------------------------------------------------------------------------
# the lasso

# method 1: library('glmnet')
cv.lasso <- cv.glmnet(x, y)
# nfolds = number of folds
# foldid = user-supplied folds
# type.measure = "deviance", "mse" or "mae" (mean aboslute error)
# - can also use "auc" (under ROC) for classification
plot(cv.lasso)  # also shows the lowest + the least p w/in one stdev
coef(cv.lasso)

# lambda of min MSE
cv.lasso$lambda.min
cv.lasso$lambda.1se  # most regularized model where error is w/in 1 SE of the min
coef(cv.lasso, s = "lambda.min")   # corresponding fit

# to select the lambda with validation (instead of cross-validation)
lasso.tr <- glment(x[train, ], y[train, ])
pred <- predict(lasso.tr, x[-train, ])
rmse <- sqrt(apply((y[-train] - pred)^2, 2, mean))  # y[-train] auto fills up
plot(log(lass.tr$lambda), rmse, type = 'b', xlab = 'Log(lambda)')

lam.best <- lasso.tr$lambda[order(rmse)[1]]
ceof(lasso.tr, s = lam.best)

# parallel
library(doMC)
registerDoMC(cores = 2)
# registerDoSEQ() = unregister
# test
X = matrix(rnorm(1e4 * 200), 1e4, 200)
Y = rnorm(1e4)
system.time(cv.glmnet(X, Y))
system.time(cv.glmnet(X, Y, parallel = TRUE))

# method 2: more control
bounds <- seq(0.05, 1, by = 0.05) 
cv.error <- matrix(nrow = length(bounds), ncol = fold) 

for(i in 1:fold) {
     valid.index <- cv.index == i
     train.cv <- train.S[!valid.index,] # get the training set
     fit <- l1ce(lpsa ~ .,data=train.cv,bound=bounds) 

     betas <- sapply(fit,coef.fn) # coef.fn is a function previously defined
     
     x.validation <- train.S[valid.index, -9] # get the validation set
     y.validation <- train.S[valid.index, 'lpsa'] # get the validation set

     y.pred <- cbind(1, as.matrix(x.validation)) %*% betas
     cv.error[, i] <- apply((y.validation - y.pred)^2, 2, mean)
}

means <- apply(cv.error, 1, mean)
stdevs <- apply(cv.error, 1, sd)

plot(means ~ bounds, ylim = range(means - sds, means + sds), 
     pch = 21, bg = 'blue', cex = 0.8, 
     xlab = 's', ylab = 'CV Error', type = 'o', xaxt = 'n')
axis(1, at = seq(0.1, 1, by = 0.1), labels = seq(0.1, 1, by = 0.1))
segments(bounds, means - sds, bounds, means + sds)  # adds error bar segments

min.cv <- which(means == min(means))
bounds[min.cv]
abline(h = means[min.cv] + sds[min.cv], lty = 2)  

#---------------------------------------------------------------------------------
# ridge regression

# method 1: library('glmnet')
cv.ridge = cv.glmnet(x, y, alpha =0)
plot(cv.ridge)  # also shows the lowest + the least p w/in one stdev
coef(cv.ridge)

# to select the lambda with validation (instead of cross-validation)
# - same as for the lasso

# method 2: more control
dfs <- seq(1,8, by = 0.5)  # df values to search over
cv.error <- matrix(nrow = length(dfs), ncol = fold)

for(i in 1:fold){
     train.cv <- train.S[cv.index != i,]
     X <- train.cv[, -9]
     y <- train.cv[, 'lpsa']
     fit <- simple.ridge(X, y, data = train.cv, df = dfs)
    
     X.valid <- train.S[cv.index == i, -9]
     y.valid <- train.S[cv.index == i, 'lpsa']
     y.pred <- as.matrix(X.valid) %*% fit$beta + fit$beta0
     cv.error[, i] <- apply((y.valid - y.pred)^2, 2, mean)
}

means <- apply(cv.error,1,mean)
sds <- apply(cv.error,1,sd)

plot(means ~ dfs,ylim = range(means - sds, means + sds),
     pch = 21, bg = 'blue', cex = 0.8, 
     xlab = expression(df(lambda)), ylab = 'CV Error', type = 'o')
segments(dfs, means - sds, dfs, means + sds)

min.cv <- which(means == min(means))
dfs[min.cv]  # which df minimizes CV error
abline(h = means[min.cv] + sds[min.cv], lty = 2)

#=================================================================================
# dimension reduction
# - principle component regression
# - partial least square
# - cross-validation
#=================================================================================

#---------------------------------------------------------------------------------
# principle component regression
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# method 1: library('pls')
set.seed(1)
pcr.fit <- pcr(Y ~ ., data = dataset, scale = TRUE, validation = 'CV')
# pcr() reports the RMSE, to get MSE, we need to square
validationplot(prc.fit, val.type = 'MSEP')

# valiation and cross-valiation the same way as in linear model
# after choosing the number of components, we use predict
pcr.fit <- prc(Y ~., data = dataset, scale = TRUE, validation = 'CV',
               subset = train)
pcr.pred <- predict(pcr.fit, x[test, ], ncomp = 7)
mean((pcr.pred - y.test)^2)

#---------------------------------------------------------------------------------
# method 2:

# i. plotting the data:
# setting aspect ratios to one, so the the arrows below appear orthogonal
plot(X, pch = 21, bg = 'blue', cex = 0.5, asp = 1, 
     xlab = 'X1', ylab = 'X2') 
arrows(0, 0, V[1, 1], V[2, 1], length = 0.1, col = 'red')
arrows(0, 0, V[1, 2], V[2, 2], length = 0.1) 

# ii. getting the principal components:
V <- eigen(cov(X))$vectors  # gets the eigenvectors of the X matrix
prcomp(X)$rotation  # same as V
Z <- X %*% V  # principal components

# iii. plotting in the new principal components:
plot(Z, pch = 21, bg = 'blue', cex = 0.5, asp = 1, xlab = 'PC1', ylab = 'PC2')
arrows(0 , 0, 1, 0, length = 0.1, col = 'red')
arrows(0 , 0, 0, 1, length = 0.1)

# iv. proportion of variance explained
eigen <- eigen(cov(X))
eigenvalues <- eigen$vectors
# proportion of variance explained / retained by the first m predictors
proportionExplained <- sum(eigenvalues[1:m]) / sum(eigenvalues) 

# iv. principal component regression:
eigenvalues <- eigen$values
sum(eigenvalues[1:m])/sum(eigenvalues)  # proportion of variance retained
V <- eigen$vectors
Z <- X $*$ V  # principal components
fit.pcr <- lm(Y ~ Z)  # fitting with Z as inputs
# coefficients for all the predictor values, less the intercept term
alpha.pcr <- fit.pcr$coef[-1] 
alpha <- lm(Y~X)$ceof
beta.ols <- V %*% alpha
beta.ols <- V[, 1:m] %*% alpha[1:m]  # ols estimate using the first m predictors

# v. plotting:
allBetas.pcr = matrix(0, ncol = 9, nrow = 8)
for (j = in 1:p) {
     allBetas.pcr[, j + 1] <- V[, 1:j] %*% alpha[1:j]
}
colnames(allBetas.pcr) <- 0:p
rownames(allBetas.pcr) <- colnames(X)

#---------------------------------------------------------------------------------
# partial least square
#---------------------------------------------------------------------------------

# method 1: library('pls')
# same as pcr
set.seed(1)
pcr.fit <- plsr(Y ~ ., data = dataset, scale = TRUE, validation = 'CV')

#---------------------------------------------------------------------------------
# cross validation
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# principle component regression

m <- 0:(ncol(train.S)-1) # number of principal components
cv.error <- matrix(nrow = length(m), ncol = fold)

for(i in 1:fold){
     train.cv <-  train.S[cv.index != i, ]
     X.train <- train.cv[, -9]
     y.train <- train.cv[, 'lpsa']
     V <- eigen(cov(X.train))$vectors
     Z <- as.matrix(X.train) %*% V
     fit <- lm(y.train ~ Z)
     alphahat <- fit$coef[-1]
     betahats <- matrix(0, ncol = 9, nrow = 8)

     for(j in 1:8){
          betahats[, j + 1] <- V[, 1:j] %*% as.matrix(alphahat[1:j])
     }

     colnames(betahats) <- m
     X.valid <- train.S[cv.index == i,-9]
     y.valid <- train.S[cv.index == i,'lpsa']
     y.pred <- as.matrix(X.valid) %*% betahats + fit$coef[1]
     cv.error[, i] <- apply((y.valid - y.pred)^2, 2, mean)
}

means <- apply(cv.error, 1, mean)
sds <- apply(cv.error, 1, sd)

plot(means ~ m, ylim = range(means - sds, means + sds),
     pch = 21, bg = 'blue', cex = 0.8, xlab = 'm', ylab = 'CV Error', type = 'o', xaxt = 'n')
axis(1, at = m, labels = m)
segments(m, means - sds, m, means + sds)

min.cv <- which(means == min(means))
m[min.cv]  # which m minimizes CV error
abline(h = means[min.cv] + sds[min.cv], lty=2)

#=================================================================================
# validation-test sets
#=================================================================================
test <- prostate[prostate$train == FALSE, -10] 
test.S <- data.frame(scale(test[, -9]), 'lpsa' = test$lpsa)
y.test <- test.S$lpsa

#---------------------------------------------------------------------------------
# prediction with ols:
fit.ols <- lm(y ~., train.S)
yhat.ols <- predict(fit.ols, test.S)
 
#---------------------------------------------------------------------------------
# prediction with best subset using BIC:
subsets <- regsubsets(lpsa ~ ., data = train.S)
bic <- summary(subsets)$bic  # extract BIC from the 8 models
which(bic == min(bic))  # which model minimizes BIC
summary(subsets)$outmat

fit.best <- lm(lpsa ~ lcavol + lweight, data = train.S)  # best subset
yhat.best <- predict(fit.best, newdata = test.S)  # predicted values

#---------------------------------------------------------------------------------
# prediction with ridge regression:
# output of simple.ridge() not compatible with predict()
fit.ridge <- simple.ridge(x = train.S[, -9], y = train.S[, 9], df = 2) 
X.test <- test.S[, -9]
yhat.ridge <- as.matrix(X.test)%*%fit.ridge$beta + fit.ridge$beta0  

#---------------------------------------------------------------------------------
# prediction with lasso:
fit.lasso <- l1ce(lpsa ~ ., data = train.S, bound = 0.35)
yhat.lasso <- predict(fit.lasso,newdata=test.S)  

#---------------------------------------------------------------------------------
# prediction with PCA regression:
X <- train.S[, -9]
Y <- train.S[, 'lpsa']
V <- eigen(cov(X))$vectors
Z <- as.matrix(X) %*% V  # principal components

fit.pcr <- lm(Y ~ Z)
alphahat <- fit.pcr$coef[-1]
# using only 1 principal component
betahat.pcr <- V[, 1] %*% as.matrix(alphahat[1])  
yhat.pcr <- as.matrix(X.test) %*% betahat.pcr + fit.pcr$coef[1]

#---------------------------------------------------------------------------------
# prediction error:
mean((y.test - yhat)^2) 
# std error, where m is the number of predictors used
sqrt((1 / (testSize - m - 1)) * mean((y.test - yhat)^2))  

