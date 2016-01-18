#================================================================================= 
# [table of contents]
#   - cross validation
#   - bootstrap
#=================================================================================

#=================================================================================
# [cross validattion]
#   - LOOCV
#   - k-fold cross-validation
#=================================================================================

#---------------------------------------------------------------------------------
# LOOCV: library(boot)

glm.fit <- glm(y ~ x, data = dataset)

# slow (on a single model)
cv.glm(data = dataset, glm.fit)$delta  # slow
# result 1 = cv.glm
# result 2 = bias-corrected cv.glm, since the number of samples is not n in cv

# fast (on a single model)
loocv <- function(fit) {
	h <- lm.influence(fit)$h
	mean((residuals(fit) / (1 - h))^2)
}
loccv(glm.ft)  # using the relationship

# cross-validation (on a range of models)
# e.g. choosing the degree of ploynominals
cv.error = rep(0, n)
for (i in 1:n){
	glm.fit <- glm(y ~ ploy(x1, i), data = dataset)
	cv.error[i] = loocv(glm.ft)
}

#---------------------------------------------------------------------------------
# k-fold cross-validation: library(boot)

# cross-validation (on a range of models)
# e.g. choosing the degree of ploynominals
# e.g. 10-fold cross-validation
cv.error <- rep(0, n)
for (i in 1:n){
	glm.fit <- glm(y ~ ploy(x1, i), data = dataset)
	cv.error[i] = cv.glm(glm.ftm, k = 10)$delta[1]
	# result 1 = cv.glm (used)
     # result 2 = bias-corrected cv.glm, since the number of samples is not n in cv
}

#=================================================================================
# [bootstrap]
#	- non-parametric
#	- parametric
#	- intervals
#	- bootstrap regression
# 	- accuracy of the bootstrap
#=================================================================================

#---------------------------------------------------------------------------------
# non-parametric
#---------------------------------------------------------------------------------
# - drawing distribution from sample data

#---------------------------------------------------------------------------------
# method 1: out of the box library(boot)

thetahat <- function(X)  # function of the original data
set.seed(number)  # bootstrap is a random sampling technique
B <- number of iterations
thetahat.star <- numeric(B)  # empty vector to hold bootstrap estimate

thetahat.star <- boot(X, thetahat, r = B)

#---------------------------------------------------------------------------------
# method 2: more control

thetahat <- function(X)  # function of the original data
n <- length(X)
set.seed(number)  # bootstrap is a random sampling technique
B <- nIterations
thetahat.star <- numeric(B)  # bootstrap estimate

for(b in 1:B) {
     x.star <- sample(X, size = n, replace = TRUE)
     thetahat.star[b] <- thetahat(x.star) # function of the new sample
}
var.boot <- var(thetahat.star)
sd.boot <- sd(thetahat.star)

#---------------------------------------------------------------------------------
# parametric
#---------------------------------------------------------------------------------
# - assuming some model, and drawing from that

thetahat <- with(data, cor(x1, x2))
n <- nrow(data)

set.seed(number)
B <- nIterations
thetahat.star <- numeric(B)

for(b in 1:B){
     X.star <- mvrnorm(n, muhat, sigmahat)  # random draw
     thetahat.star[b] <- cor(X.star)[1, 2]
}
se.boot <- sd(thetahat.star)

#---------------------------------------------------------------------------------
# intervals

# i. normal interval
normal.lb <- thetahat - qnorm(0.975)*se.boot
normal.ub <- thetahat + qnorm(0.975)*se.boot 
normal <- c("2.5%" = normal.lb, "97.5%" = normal.ub)

# ii. pivotal interval:
pivotal.lb <- 2*thetahat - quantile(thetahat.star, 0.975)
pivotal.ub <- 2*thetahat - quantile(thetahat.star, 0.025)
pivotal <- c(pivotal.lb, pivotal.ub)
names(pivotal) <- names(pivotal)[2:1]

# iii. percentile interval:
percentile <- quantile(thetahat.star, c(0.025, 0.975))

#---------------------------------------------------------------------------------
# bootstrap regression
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# method 1: out of the box library(boot)

boot.fn <- function(dataset, index) {
     coefficients(lm(y ~ X1 + X2, data = dataset, subset = index))
}

B <- 1000
thetahat.star <- matrix(nrow = B, ncol = ncol(data)) 
for(b in 1:B) {
  thetahat.star <- boot.fn(data, sample(nrow(data), nrow(data), replace = T))
}
apply(thetahat.star, sd)  # for standard error

# or
boot(Xy, boot.fn, 1000)

#---------------------------------------------------------------------------------
# method 2: more control

LAozone.S <- with(LAozone, data.frame(ozone, scale(LAozone[, -1])))
X.S <- as.matrix(LAozone.S[, -1])  # extract the scaled predictors
y <- LAozone.S[, 1]  # extract the response vector 

fit.lasso <- l1ce(ozone ~ .,data = LAozone.S, bound = 0.4)
betahat <- fit.lasso$coef 
B <- nIterations

betahat.star <- matrix(ncol = B,nrow = ncol(LAozone.S))
rownames(betahat.star) <- c("(Intercept)", colnames(X.S))
n <- nrow(LAozone.S) 

# i. bootstrapping residual:
resids = y - (cbind(1, X.S) %*% betahat)
for(b in 1:B){
     e.star <- sample(resids, size = n, replace = TRUE)
     # if using parametric bootstrap on the residual, and making it follow a ~N(0, sd^2)
     # e.star <- rnorm(n, mean = 0, sd = sd(resids))  
     y.star <- cbind(1, X.S) %*% betahat + e.star
     fit <- l1ce(y.star ~ X.S, bound = 0.4)
     betahat.star[, b] <- fit$coef
}
se.boot <- apply(betahat.star, 1, sd) # applying to the rows

# ii. bootstrapping observations:
for(b in 1:B){
     index <- sample(1:n, size = n, replace = TRUE)
     LAozone.boot <- LAozone.S[index, ]
     fit <- l1ce(ozone ~ ., data = LAozone.boot, bound = 0.4)
     betahat.star[, b] <- fit$coef
}
se.boot <- apply(betahat.star, 1, sd)

#---------------------------------------------------------------------------------
# accuracy of the bootstrap
#---------------------------------------------------------------------------------
# - e.g.: let bootstrap determine the variance of sample correlation, when samples 
#   drawn from a bivariate normal distribution with known correlation
# - here, correlation = theta (parameter of concern)
# - additionally (not shown here), should try varying theta and n, to learn more 
#   about the sensitivity to the context (i.e. performing the entire process below 
#   with each theta-n combination)
# - lastly coverage probabilities can be computed, but is quite computationally 
#   intensive (i.e. generating a number of bootstrap variances to populate the 
#   coverage domain, in order to subsequently look at the percentage of the domain 
#   that falls within specified significance)

theta <- 0.6
n <- 30  # sample size
mu <- c(0,0)
sigma <- matrix(c(1, theta, theta, 1), ncol = 2, nrow = 2)

# i. simulation values:
N <- 1000  # simulate 1000 correlation values
true.cors <- numeric(N)

set.seed(260)
for(i in 1:N) {
     X <- mvrnorm(n, mu, sigma)
     true.cors[i] = cor(X)[1,2]
}
var(true.cors)  # true variance (very good approximation) = 0.01438627

# ii. bootstrap values
B <- 200
asymp.vars <- numeric(B)
boot.vars <- asymp.vars

set.seed(260)
for(i in 1:N) { 

     # asymptotic formule for the variance
     X <- mvrnorm(n, mu, sigma)  # gets a random set of X's
     asymp.vars[i] <- (1 - (cor(X)[1, 2])^2)^2 / (n - 3)

     # bootstrapped value for the variance 
     thetahat.star <- numeric(B)
     for(b  in 1:B) {
          X.star = X[sample(1:n, size = n, replace = TRUE), ] # 
          thetahat.star[b] = cor(X.star)[1, 2]
     }
     boot.vars[i] <- var(thetahat.star)
}
# the bootstrap variance is lower; bootstrap is closer to the truth in this example
mean(boot.vars) # 0.01484583 
mean(asymp.vars) # 0.01566916

