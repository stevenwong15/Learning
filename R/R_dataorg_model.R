#================================================================================= 
# [table of contents]
#   - library(caret)
#=================================================================================
# sortable model list: http://topepo.github.io/caret/modelList.html

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
dummies <- dummyVars(y ~., data = dataset)
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
