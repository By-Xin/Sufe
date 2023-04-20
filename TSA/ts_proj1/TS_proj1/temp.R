library(TSA)
library(fUnitRoots)
library(forecast)

set.seed(123)

######################################################################################

# 1. Load Data
rm(list=ls())
setwd("/Users/xinby/Desktop/Sufe/TSA/ts_proj1/TS_proj1")
dat <- readxl::read_excel("CO2.xlsx")

CO2 <- ts(dat, start = 1960, end = 2019)
CO2.train <- CO2[1:37]
CO2.test <- CO2[38:40]

######################################################################################

# 2. Description

plot(CO2,type='o',ylab="CO2 emissions (in billion metric tons)",
     main="Global Carbon Dioxide Emissions \n from 1970 to 2019 in Power Industry")
qqnorm(CO2, main="Q-Q plot to CO2 Emissions"); qqline(CO2)


######################################################################################

# 3. Stationary Test

## diff(IP)

diff.CO2 <- diff(CO2) # get diff data

plot(diff.CO2,type = 'o',main="CO2 Annual Growth",
     ylab = "CO2 emission (in billion metric tons)") # plot

adfTest(diff.CO2,lags=0,type='c') # adf test

pacf(diff.CO2,xaxp=c(0,20,10),lag.max=20,main="PACF") # pacf: suggest AR(3)
acf(diff.CO2,xaxp=c(0,20,10),lag.max=20,main="ACF",ci.type='ma') # acf: suggest MA(3)

#--------Conclusion: suggest AR(2) or MA(2) --------#

## diff(log(IP))

difflog.CO2 <- diff(log(CO2)) # get log diff data

plot(difflog.CO2,type = 'o',
     main="Annual Car Sales Logrithm Growth",
     ylab = "Annual Logrithm Growth (in million units)") # plot

adfTest(difflog.CO2,lags = 0,type='c') #adf test

pacf(difflog.CO2,xaxp=c(0,20,10),lag.max=20,main="PACF") # pacf: suggest AR(0)
acf(difflog.CO2,xaxp=c(0,20,10),lag.max=20,main="ACF",ci.type='ma') # acf: suggest MA(0)

#--------Conclusion: White Noise. log diff not applicable. --------#

######################################################################################

# 4. Parameter Estimation

## AR(2)

ar2.ml <- TSA::arima(x = (CO2), order = c(1,1,0), method = "ML") 
#---According to MLE, AR(2): Y_t = 0.0603 Y_t-1 - 0.3674 Y_t-2 + 21.9938 + a_t ---#
ar2.css <- TSA::arima(x = (CO2), order = c(1,1,0), method = "CSS")
#---According to CSS, AR(2): Y_t = 0.0555 Y_t-1 - 0.3730 Y_t-2 + 22.5603 + a_t ---#

## MA(2)
ma2.ml <- TSA::arima(x = (CO2), order = c(0,1,1), method = "ML")
#---According to MLE, MA(2): Y_t = -0.0659 a_t-1 - 0.4823 a_t-2 + 22.0447 + a_t ---#
ma2.css <- TSA::arima(x = (CO2), order = c(0,1,1), method = "CSS")
#---According to CSS, MA(2): Y_t = -0.0433 a_t-1 - 0.4775 a_t-2 + 21.8382 + a_t ---#


######################################################################################

# 5. Model Diagnosis

## MA(2)
plot(rstandard(ma2.ml),ylab='Standardized residuals',type='o', main = "MA(2) Residual") # residual plot
hist(residuals(ma2.ml), xlab='Residuals', main='Histogram') # residual histogram
qqnorm(residuals(ma2.ml), main='Q-Q plot'); qqline(residuals(ma2.ml)) #residual qqplot
shapiro.test(rstandard(ma2.ml)) # shapiro Normality test
acf(as.numeric(rstandard(ma2.ml)), xaxp = c(0,24,12), main = "")
Box.test(rstandard(ma2.ml), lag = 6, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ma2.ml), lag = 12, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ma2.ml), lag = 18, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ma2.ml), lag = 24, type = "Ljung-Box", fitdf = 1)
tsdiag(ma2.ml,gof=15,omit.initial=F)

## AR(2)
plot(rstandard(ar2.ml),ylab='Standardized residuals',type='o', main = "AR(2) Residual")
hist(residuals(ar2.ml), xlab='Residuals', main='Histogram') # residual histogram
qqnorm(residuals(ar2.ml), main='Q-Q plot'); qqline(residuals(ar2.ml)) #residual qqplot
shapiro.test(rstandard(ar2.ml))
acf(as.numeric(rstandard(ar2.ml)), xaxp = c(0,24,12), main = "")
Box.test(rstandard(ar2.ml), lag = 6, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ar2.ml), lag = 12, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ar2.ml), lag = 18, type = "Ljung-Box", fitdf = 1)
Box.test(rstandard(ar2.ml), lag = 24, type = "Ljung-Box", fitdf = 1)
tsdiag(ar2.ml,gof=15,omit.initial=F)


######################################################################################

# 6. Model Prediction

## MA(2)
tprd_ma2.ml <- predict(ma2.ml, n.ahead = 3)$pred


tprd_ma2.css <- predict(ma2.css, n.ahead = 3)


plot(forecast::forecast(CO2,h=3, model=ma2.ml),xlab='Time',ylab='diff(IP)')


## AR(2)
prd_ar2.ml <- predict(ar2.ml, n.ahead = 3)
plot(forecast::forecast(CO2,h=3, model=ar2.ml),xlab='Time',ylab='diff(IP)')
prd_ma2.css <- predict(ar2.css, n.ahead = 3)



######################################################################################

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
