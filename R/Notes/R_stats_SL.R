#================================================================================= 
# [table of contents]
#   - general stats
#   - general model commands
#   - library(caret)
#   - library(xgboost) - boosting
#   - OLS
#   - classification
#   - count
#   - nonlinear
#   - nonlinear: tree-based
#   - SVM
#   - kernel smoothing
#   - changepoint models
#=================================================================================
# sortable model list: http://topepo.github.io/caret/modelList.html

#=================================================================================
# general stats
# - bacis
# - distributions
# - simulations
# - sampling
# - ROCR
#=================================================================================

#---------------------------------------------------------------------------------
# basic

summary(data)  # a summary of the data
cor(data)  # pairwise correlation

# condition number: 
# - to check for multi-colinearility
eigenvalues <- eigen(cor(X))$values  # getting the eigenvalues
conditionNumber <- sqrt( max(eigenvalues) / min(eigenvalues) )

#---------------------------------------------------------------------------------
# distributions

(q, p, d, r) * 
  (beta, binom, cauchy, chisq, exp, f, gamma, geom, hyper, lnorm, logis, multinom,
  nbinom, norm, pois, signrank, t, unif, weibull, wilcox, birthday, tukey)
# d = pdf
# p = cdf
# q = inverse cdf 
# r = random
# _norm(x, mean = , sd = , lower.tail = TRUE)
# _t(x, df = )

ecdf(x) # empirical CDF

apropos('\\.test$')  # various tests 

quantile(data)  # compute the {0, 25, 50, 75, 100}% quantiles by default
quantile(x, prob = c(...))  # values at the specified percentiles
IQR(data) # interquartile range is range of the middle 50%

boxplot(data, horizontal = TRUE)
boxplot.stats(data)
quantile(data,0.25) - 1.5*IQR(data) # lower whisker
quantile(data,0.75) + 1.5*IQR(data) # upper whisker

# extreme value distribution
library('evd')
fit.maxs = fgev(maxs) # fgev fits a generalized extreme value (GEV) distribution

dgev() # computes the GEV density function
dgumbel() # computes the Gumbel density function

#---------------------------------------------------------------------------------
# simulation

set.seed(number)  # track the random values
rnorm(number, mean, sigma)  # normal
runif(number)  # uniform 
rexp(number, rate)  # exponential 
rbinom(number, number of trial, probability of success)  # binomial 
mvrnorm(number, mean vector, sigma matrix)

#---------------------------------------------------------------------------------
# sampling

set.seed(number)  
sample(data, size = s) # sample with replacement of size s from data
# need to have 'replace = TRUE' to sample a set less than the size of the data
coins <- sample(c('H','T'), size = 20, replace = TRUE, prob = c(0.8, 0.2)) 
table(coins)  # to see the allocations in the dataset

#---------------------------------------------------------------------------------
# ROCR plot

rocplot <- function(pred, truth, ...) {
	predob <- prediction(pred, truth)
	perf <- performance(predob, 'tpr', 'fpr')
	plot(perf, ...)
}

# ex: SVM
fitted <- attributes(predict(svm.model, dataset[train, ] decision, values = T))$decision.values
par(mfrow = c(1, 2))
rocplot(fitted, dataset[train, 'y'], main = 'Training Data')

#=================================================================================
# general model commands
#=================================================================================

names(model)  # shows a list describing each property
model$value  # get access to the particular value
model  # give a short summary
summary(model)  # a summary of the model
names(summary(model))  # values available
coef(summary(model))  # coeficients
fitted(model)  # extract fitted values of the model
confint(model)  # CI from t-statistic, w/ n - p dof 
confint.default(model)  # CI from normal dist (which t approaches as n -> inf)

# plots
plot(model)  # various diagnostic plots (4 plots, thus use par(mfrow = c(2,2)))

# multiple linear regression plots
library("scatterplot3d")  # 3d plot of the multi-linear regression
plot3d <- scatterplot3d(x1, x2, y)
plane <- lm(y ~ x1 + x2, dataset) 
plot3d$plane3d(plane)  # plots the multi-linear regression

# lines: 
abline(line) # draws a linear line with parameters
points(x, fitted(model))  # extract fitted values of the model

# dummy variable
contrast(data$value1)  # shows how qualitative predictors are treated

# confusion matrix
table(predictedResponse, actualResponse)

#=================================================================================
# library(caret)
#=================================================================================
# much more at: http://topepo.github.io/caret/
# pre-processing: 
# - creating dummy variables 
# - identifying zero- and near zero-variance predictors
# - identifying correlated predictors
# - identifying linear dependencies
# variable importance
# model training and tuning

#---------------------------------------------------------------------------------
# pre-processing: creating dummy variables

# base R = w/ intercept, and thus useful for funcitons such as lm
model.matrix(y ~., data = dataset)

# library(caret) = w/t intercept
dummies <- dummaryVars(y ~., data = dataset)
predict(dummies, newdata = dataset)

#---------------------------------------------------------------------------------
# pre-processing: identifying zero- and near zero-variance predictors
# concerns:
# - predictors might be zero-variance predictors in sub-samples (CV, bootstrap, etc.)
# - a few samples may have an undue influence on the model
# metrics:
# frequency ratio: frequency of most prevalent value / that of the 2nd
# - near 1 for well-behaved predictors; very large for highly-unbalanced data
# percent of unqiue values: number of unique values / total number of samples
# - approaches 0 as the granularity of the data increases

# tells you which predictors are considered as nzv, or not 
nearZeroVar(data, saveMetrics = TRUE)

# eleminates those considered as nzv
nearZeroVar(data)

#---------------------------------------------------------------------------------
# pre-processing: identifying correlated predictors

data_cor <- cor(data)
summary(data_cor[upper.tri(data_cor)])

data_cor_high <- findCorrelation(data_cor, cutoff = 0.75)  # correlation cutoff
data_filtered <- data[, -data_cor_high]

data_cor_filtered <- cor(data_filtered)
summary(data_cor_filtered[upper.tri(data_cor_filtered)])

#---------------------------------------------------------------------------------
# pre-processing: identifying linear dependencies

data_combo <- findLinearCombos(data)
data_cleaned <- data[, -data_combo$remove]

#---------------------------------------------------------------------------------
# variable importance: http://topepo.github.io/caret/varimp.html
# - metrics that use the model information (more closely tied to model performance)
# - metrics that do not
# - classification (most): each predictor have separate variable importance for each class

varImp(fitted_model_object, scale = FALSE)

# area under the ROC curve
filterVarImp(x = train[, -ncol(train)], y = train$class)

#---------------------------------------------------------------------------------
# model training and tuning (basic)

# define the type of resampling
# e.g. repeated CV (others: boot, cv, LOOCV, LGOCV, timeslince, none, cob)
fit_control <- trainControl(method = 'repeatedCV', number = 10, repeats = 10)

# define the type of model
# e.g. gradient boosting machine, via library(gbm)
set.seed(94305)
fit <- train(y ~ ., data = train, method = 'gbm',
	         trControl = fit_control, verbose = FALSE)

# customizing the tuning process
# 1) pre-processing
# - passes preProcess() arguements in train() and/or trainControl()
# - methods for imputation (i.e. using k-nearest neighbors, bagged trees, median)
# 2) alternate tuning grids
# - takes a data.frame with columns for each tuning parameter
# e.g. gradient boosting machine, via library(gbm)
gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9),
                        n.trees = (1:30)*50,
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

set.seed(94305)
fit <- train(y ~ ., data = train, method = 'gbm',
	         trControl = fitControl,
	         truneGrid = gbmGrid)

# plot; ?xyplot.train for other plots
ggplot(fit)

#---------------------------------------------------------------------------------
# feature selection

#=================================================================================
# library(xgboost) - boosting
#=================================================================================
# https://xgboost.readthedocs.org/en/latest/
# inputs: 
# - matrix
# - Matrix::dgCMatrix (sparse; 0 not stored so smaller in size)
# - xgb.DMatrix (recommended)
# only takes numerical inputs; need to convert catagorical to numerical

# structure data (features and responses) to the xgb.DMatrix format
data_train <- xgb.DMatrix(data = train$data, label = train$label)
data_test <- xgb.DMatrix(data = test$data, label = test$label)

#---------------------------------------------------------------------------------
# basic: xgboost

# traning (example: binary classification model)
# - verbose {0, 1, 2} for different levels
bst <- xgboost(data = data_train, verbose = 2, objective = 'binary:logistic',
	           max.depth = 2, eta = 1, nthread = 2, nround = 2)
# prediction
pred <- predict(bst, test$data)
# library(xgboost) does & returns regression response (need to convert to classes)
prediction <- as.numeric(pred > 0.5)

#---------------------------------------------------------------------------------
# advanced: xgb.train
# capacity to follow the progress of the learning after each round (for boosting,
# these is a time when having too many rounds lead to an overfitting)

# watchlist is a list of xgb.DMatrix, each with a tagged name
watchlist <- list(train = data_train, test = data_test)

# algorithm 1: boosting trees (i.e. decision trees, which is better at catching non-linearity)
# nroound = 2 means doing it 2X
# different eval.metric used
bst <- xgb.train(data = data_train, watchlist = watchlist, objective = "binary:logistic",
	             eval.metric = "error", eval.metric = "logloss",
	             max.depth = 2, eta = 1, nthread  =  2, nround = 2)

# algorithm 2: linear boosting
bst <- xgb.train(data = data_train, watchlist = watchlist, objective = "binary:logistic",
	             booster = 'gblinear',
	             eval.metric = "error", eval.metric = "logloss",
	             max.depth = 2, nthread  =  2, nround = 2)

# view feature importance
importance_matrix <- xgb.importance(model = bst)

# view tree
xgb.dump(bst, with.stats = T)

# save / load model (i.e. when dataset is too large)
xgb.save(bst, 'xgboost.model')
bst_load <- xgb.load('xgboost.model')

#=================================================================================
# OLS
#=================================================================================

# linear model (ols)
line <- lm(y ~ x, data = dataset)  # linear model of y onto x
line <- glm(y ~ x, data = dataset)  # same as lm with more available specifications 
beta0 <- coef(line)[1]  # accessing intercept
beta1 <- coef(line)[2]  # accessing slope

l.model <- lm(y ~ x1 + x2, dataset)  # multi-linear model with 2 predictors
l.model <- lm(y ~ ., dataset)  # multi-linear model with all predictors in dataset
l.model <- update(model, ~ . –x1 –x2)  # removing 2 predictors, keep same response

#---------------------------------------------------------------------------------
# extensions
l.model <- lm(y ~ x1*x2, dataset)  # include the interaction variable, b/w x1 and x2
l.model <- lm(y ~ I(x1^2), dataset)  # include the quadratic term, w/ I() to inhibit lm() 
# from understanding the quadratic term for other meanings (e.g. I(x1*x2) will multiple 
# the two values, rather than including it as an interaction term)
l.model <- lm(y ~ ploy(x1, n), dataset) # include a nth degree polynomial to fit,k

# predict (input's name is the predictor's name) at listed values, using the model
new_data <- data.frame(input = c(value1, value2, ...))
predict(model, new_data)
# confidence interval (i.e. of the mean)
predict(model, new_data, interval = "confidence", level = 0.95)  # w/ CI
# prediction interval (i.e. of all the values)
predict(model, new_data, interval = "prediction", level = 0.95)

#---------------------------------------------------------------------------------
# simulate sample response
simulate(l.model)

#=================================================================================
# classification
#=================================================================================

#---------------------------------------------------------------------------------
# logistic regression
# input arguments is the same as that of linear regression
# outputs reads like that of linear regression, using summary()
LR.model <- glm(y ~ x1 + x2, data = dataset, family = binomial)  # logistics
# subset s is a vector of T/F indicating T as the subset
LR.model <- glm(y ~ x1 + x2, data = dataset, family = binomial, subset = s)
pred <- predict(model, data, type = 'response')
# to alter the threshold as other than 0.5, filter the posterior probabilities
sum(pred >= T)
sum(pred < T)

#---------------------------------------------------------------------------------
# LDA
# input arguments is the same as that of linear regression
# outputs reads differently from linear regression, by entering the model, not summary()
# gives prior probabilities, group means, coefficient of linear discrimants
LDA.model <-lda(y ~ x1 + x2, data = dataset)  # LDA
# outputs: 
# class = predicted class
# posterior = posterior probabilities
# x = discrimanants
pred <- predict(model, data, type = 'response')
# to alter the threshold as other than 0.5, filter the posterior probabilities
sum(pred$posterior[, 1] >= T)
sum(pred$posterior[, 1] < T)

#---------------------------------------------------------------------------------
# QDA
# same as LDA, except excludes coefficients of linear discrimants (b/c quadratic)
QDA.model <- qda(y ~ x1 + x2, data = dataset)  # QDA

#---------------------------------------------------------------------------------
# KNN
# fits model, and produces response in 1 step
set.seed(1)  # knn breaks a tie randomly, given multiple nearest neighbors
# note, standardize (scale()) the data to give predictors equal weights 
KNN.response <- knn(trainset, testset, trueClassOfTrainset, k = K)  # KNN

# confusion matrix
table(predictedResponse, actualResponse)  

#=================================================================================
# count
#=================================================================================

#---------------------------------------------------------------------------------
# poisson regression
glm(y ~ x1 + x2, family = poisson, offset = log(baseline))
# overdispersed model
glm(y ~ x1 + x2, family = quasipoisson, offset = log(baseline))

#---------------------------------------------------------------------------------
# logistic-binomial
# in general, a link function is some F(.) s.t. F(Y) = XB + e
# in logit, it's F(Y) = log(Y)
glm(y ~ x1 + x2, family = binomial(link = 'logit'))
# overdispersed model
glma(y ~ x2 + x2, family = quasibinomial(link = 'logit'))

#---------------------------------------------------------------------------------
# probit
glm(y ~ x1 + x2, family = binomial(link = 'probit'))

#---------------------------------------------------------------------------------
# orderd logit and probit
polr(factor(y) ~ x)

#=================================================================================
# nonlinear
# - polynomial regression
# - step function
# - splines
# - smoothing splines
# - local regression
# - GAM
#=================================================================================

#---------------------------------------------------------------------------------
# polynomial regression

# ploy() builds columns that are a basis of orthogonal polynomials, meaning that
# each column is a linear combination of the variables x^1, x^2, ..., x^d, and that
# you can test the significance of each term separately, since they are linearlly
# independent (i.e. orthogonal)
# more generally, anova() is needed to perform F-tests on nested models
ploy.model <- lm(y ~ ploy(x, d), data = dataset)
# summary() allows us to separately test for each coefficient, taking advantage of
# the orthogonal property; works only with  a single predictor linear regression
# the t-stat is the same as the f-stat in anova()
# if using glm() instead of lm(), the orthogonality is lost; then, use anova()
summary(ploy.model)

# alternative ways, without orthgonal polynominals columns
# the responses remain the same, while the coefficients would vary 
ploy.model <- lm(y ~ ploy(x, d, raw = T), data = dataset)
ploy.model <- lm(y ~ I(x^1) + I(x^2) + ... + I(x^d), data = dataset)  # same
ploy.model <- lm(y ~ cbind(x^1, x^2, ... , x^d), data = dataset)  # same

# prediction
pred <- predict(ploy.model, newdata = dataset, se = TRUE)  # includes SE's
se.band <- cbind(pred$fit + 2*pred$se.fit, pred$fit - 2*pred$se.fit)

# anova() = analysis of variance, for general tests of nested model 
fit1 <- lm(y ~ x1, data = dataset)
fit2 <- lm(y ~ x1 + ploy(x1, 1), data = dataset)
fit3 <- lm(y ~ x1 + ploy(x1, 2), data = dataset)
fit4 <- lm(y ~ x1 + ploy(x1, 3), data = dataset)
anova(fit1, fit2, fit3, fit4)  # all nested models of fit4
# alternatively, to using anova(), we can use cross-validation
 
# ploynomial logistic regression
ploy.model <- glm(I(y > threshold) ~ ploy(x, d), data = dataset, family = binomial)

# prediction
# note the we did not use 'type = 'response'' in the predict() function, since the
# corresponding se is likely to give probabilities outside the [0, 1] range
pred <- predict(ploy.model, newdata = dataset, se = TRUE)
se.bands <- pred$fit + cbind(fit = 0, lower = - 2 * pred$se, upper = 2 * pred$se)
prob.bands <- exp(se.bands) / (1 + exp(se.bands))

# to get the rug plot on the x-axis
points(jitter(x), I(y > threshold)/10, pch = "|", cex = 0.5)

#---------------------------------------------------------------------------------
# step function

# cut() returns an ordered catagorical variable
# in the model, the lowest term is left out, treated as the intercept
step.model <- lm(y ~ cut(x, d), data = dataset)
coef(summary(fit))

#---------------------------------------------------------------------------------
# splines

# default degree ploynomial is 3
spline.model <- lm(y ~ bs(x, knots = c(k1, k2, ..., K)), data = dataset)

# df = 6 means 6 basis functions, and so w/ the intercept term, this tranlate to 
# 7 degrees of freedom; since the default polynomial is 3, we have 4 degrees of
# freedom left, and these are for the intercept, and 3 knots
# the knots are place at uniform quantiles
spline.model <- lm(y ~ bs(x, df = 6)), data = dataset)
# to change the degree ploynomial
spline.model <- lm(y ~ bs(x, degree = d)), data = dataset)

# natural spline
nspline.model <- lm(y ~ ns(x, df = 4), data = dataset)

#---------------------------------------------------------------------------------
# smoothing splines

# note the the arguements are different from that of lm()
sspline.model <- smooth.spline(y, x, df = d)
# using cv to get effective df instead
sspline.model <- smooth.spline(y, x, cv = T)
sspline.mode$df  # effective degrees of freedom

#---------------------------------------------------------------------------------
# local regression

# span as a percent of observations
lr.model <- loess(y ~ x, span = percent, data = dataset)
# alternatively, we can use library(locfit)

#---------------------------------------------------------------------------------
# GAM

# natural splines
# x3 is piece-wise constant in this case
l.model <- lm(y ~ ns(x1, d1) + ns(x2, d2) + x3, data = dataset)

# smoothing spline
gam.model <- gam(y ~ s(x1, d1) + s(x2, d2) + x3, data = dataset)
plot(gam.model, se = T)  # plot() recognizes gam.model, with se
plot.gam(l.model, se = T)  # can also use for lm(), with se

# local regression
gam.model <- gam(y ~ s(x1, d1) + lo(x2, span = s) + x3, data = dataset)
# with interactions
gam.model <- gam(y ~ lo(x1, x2, span = s) + x3, data = dataset)

# anova()
gam.model1 <- gam(y ~ x1 + s(x2, d1), data = dataset)
gam.model2 <- gam(y ~ x1 + s(x2, d1) + s(x3, d1), data = dataset)
anova(gam.model1, gam.model2, test = 'F')

# anova() for logistic regression
gam.model1 <- gam(I(y > threshold) ~ x1 + s(x2, d1), data = dataset, family = binomial)
gam.model2 <- gam(I(y > threshold) ~ x1 + s(x2, d1) + s(x3, d1), data = dataset, family = binomial)
anova(gam.model1, gam.model2, test = 'Chisq')

#=================================================================================
# nonlinear: tree-based
# - classification tree
# - regression tree
# - bagging + random forest
# - boosting
#=================================================================================

#---------------------------------------------------------------------------------
# classification tree: library(tree)

tree.model <- tree(y ~ ., data = dataset)
tree.model  # shows the entire tree in text
summary(tree.model)
# the deviance reported by summary() is -2*sum(sum( n(m, k)*log(p(m, k), k), m))
plot(tree.model)
text(tree.model, pretty = 0)

pred <- predict(tree.model, newdata = dataset, type = 'class')
table(pred, dataset$y)

# complexity pruning: instead of using deviance, we use classification error rate, 
# called by FUN = prun.misclass
tree.model <- tree(y ~., data = dataset, FUN = prune.misclass)
tree.model  # dev is the CV error rate, k is the alpha
plot(tree.model)  # size (number of nodes) vs. misclass
plot(tree.model$size, tree.model$dev, type = 'b')  # ibid

tree.model.prune <- prune.misclass(tree.model, best = size)
plot(tree.model.prune)
text(tree.model.prune, pretty = 0)

#---------------------------------------------------------------------------------
# regression tree: library(tree)
# same as classification; in the context of regreesion, dev is sum of squared error

#---------------------------------------------------------------------------------
# bagging + random forest: library(randomForest)

# bagging
# mtry = number of predictors (fullset = bagging)
# importance = shows the predictors' importance 
rf.model <- randomForest(y ~ ., data = dataset, mtry = p, importance = TRUE)
# mean sqaured residuals, and $ var explained are based on OOB estimates
rf.model
# importance of each variable
# - mean decrease of accuracy in predictions on the OOB samples
# - total decrease in impurity that results in splits over that variable, averaged
#   over all trees; in regression, node impurity is measured by train RSS; in 
#   classification, deviance
important(rf.model)
varImpPlot(rf.model)

# random forest
# default uses m = p/3 for regression; m = sqrt(p) for classification
# ntree = number of trees to grow
rf.model <- randomForest(y ~ ., data = dataset, mtry = m, importance = TRUE, ntree = n)

# cross-validation on the number of variables
oob.err = double(p)
test.err = double(p)
for (mtry in 1:p) {
  fit <- randomForest(y ~ ., data = dataset, subset = train, mtry = mtry, ntree = 400)
  oob.err[mtry] <- fit$mse[400]
  pred <- predict(fit, dataset[-train, ])
  test.err[mtry] <- with(dataset[-train, ], mean((medv - pred)^2))
  cat(mtry, " ")
}

#---------------------------------------------------------------------------------
# boosting: library(gbm)

# regression
boost.model <- gbm(y ~ ., data = dataset, distribution = 'gaussian', 
	               n.trees = 10000, shrinkage = 0.01, interaction.depth = 4)
# variable importance plot
summary(boost.model)
# partial depedence plots: marginal effect of selected variables on the response
# (after integrating out the other variables)
plot(boost.model, i = 'x1')

predict(boost.model, newdata = dataset, n.trees = 5000)

# classification
boost.model <- gbm(y ~ ., data = dataset, distribution = 'bernoulli', 
	               n.trees = 10000, shrinkage = 0.01, interaction.depth = 4)

#=================================================================================
# SVM
# - support vector classifer 
# - support vector machine
# - good looking SVM plots
#=================================================================================

#---------------------------------------------------------------------------------
# support vector classifer: library(e1071)
# another option is library(LiblineaR), which is useful for large linear problems

# encode y as factor to use svm for classification, as oppose to for regression
dataset <- data.frame(x = x, y = as.factor(y))
svm.model <- svm(y ~ ., data = dataset, kernel = 'linear', cost = C, scale = F)
# unfortunately, width of margin and coefficients of the linear decision boundary
# are not explicitly outputted in library(e1071)
summary(svm.model) 
svm.model$index  # support vectors

# cross-validation
svm.cv <- tune(svm, y ~., data = dataset, kernel = 'linear', 
	           ranges = list(cost = c(...)))
summary(svm.cv)
summary(svm.cv$best.model)

# predict
dataset.test <- data.frame(x = x, y = as.factor(y))
svm.pred <- predict(svm.model, dataset.test)
table(predict = svm.pred, truth = dataset.test$y)

#---------------------------------------------------------------------------------
# support vector machine: library(e1071)

# polynomial kernel
svm.model <- svm(y ~ ., data = dataset, kernel = 'polynomial', degree = D, cost = C)

# radial kernel
svm.model <- svm(y ~ ., data = dataset, kernel = 'radial', gamma = G, cost = C)

#---------------------------------------------------------------------------------
# good looking SVM plots

make.grid <- function(x, n = 75) {
    grange <- apply(x, 2, range)
    x1 <- seq(from = grange[1, 1], to = grange[2, 1], length = n)
    x2 <- seq(from = grange[1, 2], to = grange[2, 2], length = n)
    expand.grid(X1 = x1, X2 = x2)
}

xgrid <- make.grid(x)
ygrid <- predict(svm.model, xgrid)

plot(xgrid, col = c("red", "blue")[as.numeric(ygrid)], pch = 20, cex = 0.2)
points(x, col = y + 3, pch = 19)
points(x[svm.model$index, ], pch = 5, cex = 2)

beta <- drop(t(svm.model$coefs) %*% x[svm.model$index, ])
beta0 <- svm.model$rho
plot(xgrid, col = c("red", "blue")[as.numeric(ygrid)], pch = 20, cex = 0.2)
points(x, col = y + 3, pch = 19)
points(x[svm.model$index, ], pch = 5, cex = 2)
abline(beta0 / beta[2], -beta[1] / beta[2])
abline((beta0 - 1) / beta[2], -beta[1] / beta[2], lty = 2)
abline((beta0 + 1) / beta[2], -beta[1] / beta[2], lty = 2)

# nonlinear countors
func <- predict(fit, xgrid, decision.values = T)
func <- attributes(func)$decision
# decision boundary
contour(px1, px2, matrix(func, 69, 99), level = 0, add = T)

#=================================================================================
# kernel smoothing: library(np)
# - gaussian, epanechnikom, uniform, triangular
# - plotting
#=================================================================================

#---------------------------------------------------------------------------------
# gaussian, epanechnikom, uniform, triangular
# npreg() stands for 'non-parametric regression', and the default bandwidth is
# computed using least squares cross-validation (lscv)

ks.model <- npreg(y ~ x.time, data = dataset)  # gaussian
ks.model <- npreg(y ~ x.time, data = dataset, ckertype = 'epanechnikom')
ks.model <- npreg(y ~ x.time, data = dataset, ckertype = 'uniform')
# triangle
tri <- function(v,h){
	(1 - abs(v)) * (abs(v) <= h)
}
tri.smooth <- function(vec, time.vec = 1:length(vec), h = 1){
	smooth <- numeric(length(vec))
	for(i in 1:length(vec)){
		smooth[i] <- 
		  sum((tri(time.vec - time.vec[i], h) / sum(tri(time.vec - time.vec[i], h)))*vec)
	}
	smooth
}
plot(tri.smooth(x, h = H), type = "l")

# custom bandwdith
ks.model <- npreg(y ~ x.time, data = dataset, bws= B)  # gaussian
# because the scale of the bandwidth is dependent on the scale of the independent
# variable(s) (e.g. time scale when smoothing over time), it is helpful to have
# an automatic / data-driven reference point (such as LSCV bandwith)
lscv.bw.gauss <- npreg(y ~ x.time, data = dataset)$bw
ks.model <- npreg(y ~ x.time, data = dataset, bws= 0.25*lscv.bw.gauss)

#---------------------------------------------------------------------------------
# plotting

# simple
plot(ks.model)

# more control
plot(y ~ x.time)
lines(ks.model$mean ~ x.time)
# multiple segments
segments(c(x0_1, x0_2, x0_3, ...), 
	     c(y0_1, y0_2, y0_3, ...),
	     c(x1_1, x1_2, x1_3, ...),
	     c(y1_1, y1_2, y1_3, ...), lwd = 2, col = "red")

#=================================================================================
# changepoint models
# - circular binary segmentation: library(PSCBS)
# - bayesian changepoint model: library(bcp)
#=================================================================================

#---------------------------------------------------------------------------------
# circular binary segmentation: library(PSCBS)
# to use the package, install this first:
# source("http://bioconductor.org/biocLite.R")
# biocLite("DNAcopy")
# note that the package's output uses terminalogy from genomics:
# each row refers to a segment found by ciruclar binary segmentation; the default
# alpha = 0.01, and I currently don't know how to change it

# the implementation approximates some estimates through random sampling, but seed
# needs to be specified within the function
cbs.x <- segmentByCBS(y = x, seed = 1234)
start.x <- cbs.x$segRows$startRow
end.x <- c(cbs.x$segRows$startRow[2],cbs.x$segRows$endRow[2])
means <- cbs.x$output$mean
segments(start.x, means, end.x, means, lwd = 2, col = "purple")
segments(end.x[1], means[1], end.x[1], means[2], lwd = 2, col = "purple")

#---------------------------------------------------------------------------------
# bayesian changepoint model: library(bcp)

# the hyperparameters are w0 and p0
set.seed(260)
bcp.model <- bcp(data, w0 = 0.2, p0 = 0.01)

# plots
plot(data ~ time(data), type = "p", pch = 21, cex = 0.5, bg = "grey", las = 1, 
	                    xlab = "Time", ylab = "so2")
points(bcp.model$posterior.mean ~ time(data), type = "l", lwd = 2, col = "blue")
# posterior probabilities
plot(bcp.model$posterior.prob ~ time(data), type = "l", las = 1)

# the package also has default plots, with posterior probabilities
plot(bcp(data, p0 = 0.2, w0 = 0.01))

# mcmc extraction:
# By default, bcp() will generate 500 samples from the posterior distribution of 
# the mean parameters and compute the posterior mean as the estimate of the mean 
# function (after a default burn-in period of 50 iterations).

# by fixing the observations number (i.e. time here), we can plot the posterior 
# distribution of the mean at that time point
hist(bcp.model$mcmc.means[timepoint, -(1:50)])
# adding the confidence interval of the posterior distribution to the plot
bounds <- apply(bcp.model$mcmc.means[, -(1:50)], 1, quantile, c(0.025, 0.975))
points(bounds[1, ] ~ time(data), , type = "l", lty = 2, lwd = 2, col = "blue")
points(bounds[2, ] ~ time(data), , type = "l", lty = 2, lwd = 2, col = "blue")
