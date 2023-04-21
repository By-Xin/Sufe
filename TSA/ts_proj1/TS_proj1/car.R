library(TSA)
library(fUnitRoots)
library(forecast)
library(modelr)

set.seed(123)

###################################################################

# 1. Load Data
rm(list=ls())
setwd("/Users/xinby/Desktop/Sufe/TSA/ts_proj1/TS_proj1")
dat <- readxl::read_excel("car.xlsx")

CarSale <- ts(dat, start = 1976, end = 2019)
CarSale.train <- ts(CarSale[1:41],start=1976)
CarSale.test <- ts(CarSale[42:44],start=2017)

###################################################################
# 2. Description

plot(CarSale,type='o',ylab="Car Sales (in thousand units)",
     main="Annual Light Car Sales \n in the United States from 1977 to 2019")
qqnorm(CarSale, main="Q-Q plot to Annual Sales"); qqline(CarSale)


###################################################################

# 3. Stationary Test

## diff(car)

diff.CarSale <- diff(CarSale) # get diff data

plot(diff.CarSale,type = 'o',main="Car Sales Annual Growth",
     ylab = "Annual Growth (in thousand units)") # plot

adfTest(diff.CarSale,lags=3,type='nc') # adf test

par(mfrow=c(1,2))
acf(diff.CarSale,xaxp=c(0,20,10),lag.max=20,main="ACF",ci.type='ma') # acf: suggest MA(1)
pacf(diff.CarSale,xaxp=c(0,20,10),lag.max=20,main="PACF") # pacf: suggest AR(3)

eacf(diff.CarSale) # eacf: poor performance


## diff(log(car))

diff.log.CarSale <- diff(log(CarSale)) # get log diff data

par(mfrow=c(1,1))
plot(diff.log.CarSale,type = 'o',
     main="Annual Car Sales Logrithm Growth",
     ylab = "Annual Logrithm Growth (in thousand units)") # plot

adfTest(diff.log.CarSale,lags = 0,type='nc') #adf test


###################################################################

# 4. Parameter Estimation

## ARI(3,1)

ari31.ml <- TSA::arima(x = (CarSale.train), order = c(3,1,0), method = "ML") 
ari31.css <- TSA::arima(x = (CarSale.train), order = c(3,1,0), method = "CSS") 

ari31.ml
ari31.css

BIC(ari31.ml)

## IMA(1,1)
ima11.ml <- TSA::arima(x = (CarSale.train), order = c(0,1,1), method = "ML")
ima11.css <- TSA::arima(x = (CarSale.train), order = c(0,1,1), method = "CSS")

ima11.ml
ima11.css

###################################################################

# 5. Model Diagnosis

## IMA(1,1)
par(mfrow=c(1,1))
plot(rstandard(ima11.ml),ylab='Standardized residuals',type='o', main = "IMA(1,1) Residual") # residual plot

par(mfrow=c(1,2))
hist(residuals(ima11.ml), xlab='Residuals', main='Histogram') # residual histogram
qqnorm(residuals(ima11.ml), main='Q-Q plot'); qqline(residuals(ima11.ml)) #residual qqplot

par(mfrow=c(1,1))
shapiro.test(rstandard(ima11.ml)) # shapiro Normality test
acf(as.numeric(rstandard(ima11.ml)), xaxp = c(0,24,12), main = "")
Box.test(rstandard(ima11.ml), lag = 6, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ima11.ml), lag = 12, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ima11.ml), lag = 18, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ima11.ml), lag = 24, type = "Ljung-Box", fitdf = 1)
tsdiag(ima11.ml,gof=15,omit.initial=F)

## ARI(3,1)
plot(rstandard(ari31.ml),ylab='Standardized residuals',type='o', main = "ARI(3,1) Residual")

par(mfrow=c(1,2))
hist(residuals(ari31.ml), xlab='Residuals', main='Histogram') # residual histogram
qqnorm(residuals(ari31.ml), main='Q-Q plot'); qqline(residuals(ari31.ml)) #residual qqplot
par(mfrow=c(1,1))

shapiro.test(rstandard(ari31.ml))

acf(as.numeric(rstandard(ari31.ml)), xaxp = c(0,24,12), main = "")
Box.test(rstandard(ari31.ml), lag = 6, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ari31.ml), lag = 12, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ari31.ml), lag = 18, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ari31.ml), lag = 24, type = "Ljung-Box", fitdf = 1)
tsdiag(ari31.ml,gof=15,omit.initial=F)


###################################################################

# 6. Model Comparison & Prediction

## Comparison
  ## IMA(1,1)
  ima11.ml
  ima <- forecast(CarSale.train, h=3, model =ima11.ml)
  summary(ima)
  ## ARI(1,3) 
  ari31.ml
  ari <- forecast(CarSale.train, h=3, model =ari31.ml)
  summary(ari)

## ARI prediction

sale_pred <- forecast::forecast(CarSale.train,h=3, model=ari31.ml,
                                xlab='Year',ylab='Car Sale (in thousand units)')
sale_pred
predict(ari31.ml,n.ahead=3)
CarSale.test
plot(sale_pred)

accuracy(sale_pred,CarSale.test)

###################################################################

# 目前存在的问题：

# 1. 残差不符合正态性怎么办？如果进行了对数变换那么数据的ACF结果就显示是一个WN
# 2. 如果进行其他Box-Cox变换，该如何进行预测？
# 3. 如果给数据划分了test和train set的话，是不是模型拟合的时候就应该只使用train的数据？
# 4. 如果进行滚动预测，如果希望更新模型的话，那么是不是每次更新完模型都要进行残差检验？
#   （还是说因为每次的变动不大，所以只要第一次开始时的残差通过检验即可）
# 5. 对于差分数据该如何计算其MSE等？
#    可以对真实数据进行差分然后比较预测（差分）数据与真实（差分）数据吗？
# 6. 差分变换的区间预测怎么还原？

# 关于报告的一些想法：
# 1. 最后的预测可以画一个真实值与预测值共存的图
