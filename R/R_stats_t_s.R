#================================================================================= 
# [table of contents]
#   - generalized least squares
#   - temporal correlation
#   - spatial correlation 
#=================================================================================

#=================================================================================
# generalized least squares
# - Cholesky decomposition
# - fit
#=================================================================================

#---------------------------------------------------------------------------------
# Cholesky decomposition

C <- t(chol(Sigma))
C.inv <- solve(C)
Z <- C.inv %*% Y
M <- C.inv %*% cbind(1,X)
gamma <- C.inv %*% e

#---------------------------------------------------------------------------------
# fit

# since the transformation includes the intercept term, we supress it here
gls.model <- lm(Z ~ M - 1)

lm(Z ~ M - 1)$coef
# or
solve(t(M) %*% M) %*% t(M) %*% Z

#---------------------------------------------------------------------------------
# fit: time series

# ols
ols.model <- lm(y ~ time(y), data = dataset)
# to see if the residuals is stationary
ols.resid <- ts(ols.model$resid, start = date)
acf(ols.resid)
pacf(ols.resid)
# a more automatic way to find out p, q, and d
auto.arima(ols.resid)

# gls: library(nlme)
# specify the correlation structure of the residuals
gls(y ~ time(y), data = dataset, correlation = corARMA(p = P, q = Q))

#=================================================================================
# temporal correlation
# - time object
# - autocorrelation + partial autocorrelation
# - moving average
# - differencing
# - ARIMA
#=================================================================================

#---------------------------------------------------------------------------------
# time object

data <- ts(data, start = year, end = year)
time(data)  # outputs the years
frequency(data)  # times per unit time

# white noise
white.noise <- ts(rnorm(n))
plot(white.noise)

#---------------------------------------------------------------------------------
# autocorrelation + partial autocorrelation

# autocorrelation
acf(e)  # error
acf(e, plot = F)  # error, printed form
acf(na.omit(e))  # acf() in R cannot tolerate missing values
acf(gamma)  # error, after the transformation (with Cholesky decomposition)

# partial autocorrelation
pacf(data)

# manually computing the ACF
# slightly different from acf(), though differences should not affect inference

n <- length(data)
lags <- L  # number of lags to be computed, exclusing 0
autocor.data <- numeric(lags + 1)  # storage space
autocro.data[1] <- cor(data, data)  # compute lag 0 (which is 1)
for (i in 1:lags) {
	autocor.co2[i + 1] <- cor(data[-((n-i+1):n)], data[-(1:i)])
}

#---------------------------------------------------------------------------------
# moving average
# not that there's a conflict between the dplyr::filter, and stats:filter

ma.model <- filter(dataset, filter = rep(1/n, n))  # n time points to average over

# exponentially weighted moving averages (EWMAs)
# EWMA is a special case of the Holt-Winters exponential smoother, where
# beta = FALSE, and gamma = FALSE
ewma.model <- HoltWinters(dataset, alpha = a, beta = F, gamma = F)
plot(ewma.model)  # original and smoothed together

#---------------------------------------------------------------------------------
# differencing

d1.arima <- diff(arima)  # takes the first difference
d2.arima <- diff(diff(arima)) # takes the first + second difference

#---------------------------------------------------------------------------------
# ARIMA(p, d, q)
# p = AR (autoregressive) of p lag
# d = differencing of d lag (i.e. integration order in arima.sim)
# q = MA (moving average) of q lag

# simulation
# AR(1) with phi = -0.8
ar1 <- arima.sim(model = list(ar = -0.8), n = 200)
# ARIMA(2, 1, 1) with phi1 = 0.8, phi2 = -0.3, and theta = 0.2
arima211 <- arima.sim(model = list(order = c(2, 1, 1), ar = c(0.8, -0.3), ma = 0.2), 
	                  n = 200)
# AR(1) with phi = -0.8, and e ~ iid N(0, 5); e ~ iid N(0, 1) by default
ar1 <- arima.sim(model = list(ar = -0.8), n = 200, innov = rnorm(200, 0, 5))

# fit
arima.model <- arima(data, order = (p, d, q))

# automatic fit: library(forecast)
auto.arima(dataset)
auto.arima(dataset, ic = 'aic')
auto.arima(dataset, ic = 'bic')
# the default seeting uses a forwards stepwise search up to order of p = 5 and q = 5
auto.arima(dataset, setpwise = FALSE)  # exhaustive search
auto.arima(dataset, max.p = 10,max.q = 10)  # expand search range

# diagnostics: library(astsa)
sarima(dataset, p, d, q)

# Ljung-Box-Pierce test statistics
# fitdf = the number df lost when fitting hte ARMA/ARIMA model: fitdf = p + q
# lag > fitdf
Box.test(arima.model$resid, lag = l, fitdf = df)

# prediction
# adding xreg because of small bug
n <- length(dataset)
arima.model <- arima(dataset, order = c(3, 1, 0), xreg = 1:n)
# predict 'N' steps ahead, from n + 1 to n + N
pred <- predict(arima.model, n.ahead = N, newxreg = (n + 1):(n + N))

# plots both the original and the prediction
ts.plot(data, pred$pred, col = 1:2)
lb <- pred$pred - pred$se
ub <- pred$pred + pred$se
colors <- c("black", "red", "blue", "blue")
ts.plot(data, pred$pred, lb, ub, col = colors, lty = c(1, 2, 3, 3))

#=================================================================================
# spatial correlation
# - 
#=================================================================================

#---------------------------------------------------------------------------------
# 
