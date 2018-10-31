#================================================================================= 
# [table of contents]
#   - library(caret)
#=================================================================================

#=================================================================================
# library(caret)
#=================================================================================
# Classification and Regression Training: https://topepo.github.io/caret/
# ** denotes more important functions
# pre-processing: 
# - ** creating dummy variables 
# - identifying zero- and near zero-variance predictors
# - identifying correlated predictors
# - identifying linear dependencies
# - ** centering and scaling
# data splitting
# - based on the outcome (catagorical: preserving overall class distribution)
# - based on the predictors (sample B so that it's more (dis)similar to A)
# - for time series (random sampling does not work well for time series)
# ** model training and parameter tuning
# feature selection
# variable importance

#---------------------------------------------------------------------------------
# pre-processing: creating dummy variables

# first, cast categorical variables into factors
# first, cast categorical variables into factors

# a) base R = w/ intercept, and thus useful for funcitons such as lm
model.matrix(y ~., data = dataset)  # y removed in output

# b) library(caret)
dummies <- dummyVars(y ~., data = dataset)  # w/t intercept
dummies <- dummyVars(y ~., data = dataset, fullRank = TRUE)  # w/ intercept
predict(dummies, newdata = dataset)  # y removed in output

#---------------------------------------------------------------------------------
# pre-processing: identifying zero- and near zero-variance predictors
# concerns:
# - predictors might be zero-variance predictors in sub-samples (CV, bootstrap, etc.)
# - a few samples may have an undue influence on the model
# metrics:
# frequency ratio: frequency of most prevalent value / that of the 2nd
# - near 1 for well-behaved predictors; very large for highly-unbalanced data
# percent of unqiue values: number of unique values / total number of samples
# - approaches 0 as the granularity of the data decrease

# tells you which predictors are considered as nzv, or not 
nearZeroVar(data, saveMetrics = TRUE)

# eleminates those considered as nzv, for data.table
nvz <- nearZeroVar(data, saveMetrics = TRUE)
data[, -rownames(nzv[nzv$nzv, ]), with = FALSE]

#---------------------------------------------------------------------------------
# pre-processing: identifying correlated predictors

# summary of correlation of predictors (i.e. without response variable)
data_cor <- cor(data)
summary(data_cor[upper.tri(data_cor)])

# correlation cutoff
data_cor_high <- findCorrelation(data_cor, cutoff = 0.75)
data_filtered <- data[, -data_cor_high]

# summary of post-filter correlation
data_cor_filtered <- cor(data_filtered)
summary(data_cor_filtered[upper.tri(data_cor_filtered)])

#---------------------------------------------------------------------------------
# pre-processing: identifying linear dependencies

data_combo <- findLinearCombos(data)
data_cleaned <- data[, -data_combo$remove]

#---------------------------------------------------------------------------------
# pre-processing: centering and scaling

normalized <- preProcess(data, method = c("center", "scale"))
data_normalized <- predict(normalized, data)

#---------------------------------------------------------------------------------
# data splitting: based on the outcome

# for data.table (w/t using library(caret))
data[, .SD[sample(.N, round(.N*.50))], by = c("category")]
# get the index
data[, .I[sample(.N, round(.N*.50))], by = c("category")]

#---------------------------------------------------------------------------------
# model training and parameter tuning

# define the type of resampling
# 10-fold cv, repeated 10 times
fit_control <- trainControl(
  method = "repeatedCV", 
  number = 10, 
  repeats = 10)
# method: repeatedCV, boot, cv, LOOCV, LGOCV (leave group out cv), timeslince, none, cob
# - repeatedCV: "repeats" specifies number of times to run cv
# - LGOCV: "p" specifies the training percentage
# - "classProbs" if class probabilities should be computed for held-out samples
# - "index" and "indexOut": indices of training / hold-out samples
# - "summaryFunction": function for alternative summary metrics (default: RMSE and accuracy)
#   + "data": data$obs for observation, data$pred for prediction
#   + if "classProbs" in "trainControl" is TRUE, additional columns (class levels) passed to data
#   + e.g. twoClassSummary for 2-class classification provides ROC, TPR, TNR
# - "selectionFunction": function for choosing optimal tuning parameters
#   + best() = chooses the largest/smallest value
#   + oneSE() = simplest model within one standard error of the (empirically) best model
#   + tolerance() = simplest model within some percent tolerance of the best value
#   + e.g. tolerance(x, metric, maximize)
#     - "x": data frame containing the tune parameters and their associated performance metrics
#     - "metric": a character string indicating which performance metric should be optimized
#     - "maximize":  whether larger values of the performance metric are better
# - "allowParallel": whether train should use parallel processing (if availible)
#   + the code will be executed in parallel if a parallel backend is registered

# define the type of model
# e.g. gradient boosting machine, via library(gbm)
set.seed(94305)  # for packages with randomness
gbm_fit <- train(
  y ~ ., 
  data = train, 
  method = "gbm",
  trControl = fit_control, 
  verbose = FALSE)

# customizing the tuning process
# e.g. gradient boosting machine, via library(gbm)
gbmGrid <-  expand.grid(
  interaction.depth = c(1, 5, 9),
  n.trees = (1:30)*50,
  shrinkage = 0.1,
  n.minobsinnode = 20)

# all together
set.seed(94305)
gbm_fit <- train(
  y ~ ., 
  data = train, 
  method = 'gbm',
  trControl = fitControl,
	truneGrid = gbmGrid)

# plot: ?xyplot.train for other plots
ggplot(gbm_fit)

# output
fit$results  # all results
fit$finalModel  # final model based on optimization criteria

# predict() and automatically handles details of hyperparameters
predict.train() 
# "type" = "class" or "prob"
