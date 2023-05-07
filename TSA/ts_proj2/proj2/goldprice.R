library(readxl)
library(TSA)
library(ggplot2)
library(forecast)
library(tseries)
library(FinTS)
library(rugarch)
library(fGarch)

rm(list = ls())

########################################
#           Comments Rules:            #
#                                      #
# # -------- #. SECTION NAME --------  #
#                                      #
# ## ------ #.a Unit Name ------       #
#                                      #
# #: Function Description              #
#                                      #
# #" Natural Language Explanation"     #
#                                      #
########################################

# -------- 0. Load Data ----------------

setwd("/Users/xinby/Desktop/Sufe/TSA/ts_proj2/proj2")
dat <- as.matrix(read_excel("tdat.xlsx",col_names = F,sheet = "gold"))
vec <- c(dat)
vec
gold <- ts(vec, start=c(2002,10), freq=12)
gold.frame <- data.frame(gold)
ld.gold.frame <- data.frame(diff(log(gold)))

dat.t <- as.matrix(read_excel("tdat.xlsx",col_names = F,sheet = "test"))
vec.t <- c(dat)
vec.t
gold.t <- ts(vec, start=c(2002,10), freq=12)

# -------- 1. Descriptive Stat --------

## ------ 1.a For original data -------

plot(gold,xlab = 'Year', ylab = "Price", main="Gold Price (AU9999)") #:TS plot

qqnorm(gold);qqline(gold) #:Q-Q plot

ggplot(data=gold.frame,aes(x=gold.frame$gold,y=..density..))+ 
  geom_histogram(bins=30,color="black",fill="gray")+
  geom_density(size=1)+
  theme_bw()+
  xlab('Gold Price')+
  ylab("Density")+
  scale_y_continuous(labels = scales::percent_format())+
  ggtitle("Histogram & Density of Gold Price") #:Histogram & Density plot

## ------ 1.b For Diff Data ------
plot(diff(gold) , xlab = 'Year', ylab = "Price Difference", #:TS plot
     main="Gold Price Difference (AU9999)" )

## ------ 1.c For Log Diff Data ------
plot(diff(log(gold)*100),xlab = 'Year', ylab = "Log Difference (%)",  #:TS plot
     main="Gold Price Log Return (AU9999) ")
qqnorm(diff(log(gold)));qqline(diff(log(gold))) #:Q-Q plot

ggplot(data=ld.gold.frame,aes(x=ld.gold.frame$diff.log.gold..,y=..density..))+ 
  geom_histogram(bins=30,color="black",fill="gray")+
  geom_density(size=1)+
  theme_bw()+
  xlab('Gold Price')+
  ylab("Density")+
  ggtitle("Histogram & Density of Gold Price Log Return") #:Histogram & Density plot

# -------- 2. Model Recoginition ----------------

## ------ 2.a Stationarity Test ------

par(mfrow = c(1, 2))
forecast::Acf(diff(log(gold)),main="ACF - Log Return of Gold Price") #:ACF
  #"From ACF, apart from lag=21, others all stay inbetween -> WN "#
  #"cannot fit an MA"#
forecast::Pacf(diff(log(gold)),main="PACF - Log Return of Gold Price") #:PACF
  #"From PACF, basically all stay inbetween"#
  #"cannot fit an AR"#
  #"ARMA model not appliable"#
par(mfrow=c(1,1))

Box.test(diff(log(gold)),lag=6,type = "Ljung")
Box.test(diff(log(gold)),lag=12,type = "Ljung")
Box.test(diff(log(gold)),lag=18,type = "Ljung")
Box.test(diff(log(gold)),lag=24,type = "Ljung") #:Ljung-Box
  #"From Ljung-Box with different lags, affirm there's no relationships"#

t.test(as.vector(diff(log(gold)))) #:t.test
  #"t test, H0: mean=0 -> rejected, mean (approx.)= 0.006"

## ------ 2.b ARCH Effect Test ------

par(mfrow = c(1, 2))
forecast::Acf(abs(diff(log(gold))),main="abs. Log Return")
forecast::Acf((diff(log(gold)))^2,main ="sq. Log Return") #:ACF
par(mfrow=c(1,1))

Box.test(diff(log(gold))^2,lag=6,type = "Ljung")
Box.test(diff(log(gold))^2,lag=12,type = "Ljung")
Box.test(diff(log(gold))^2,lag=18,type = "Ljung")
Box.test(diff(log(gold))^2,lag=24,type = "Ljung") #:Mcleod Test

## ------ 2.c Model ARCH ------

forecast::Pacf((diff(log(gold)))^2,main="") #:PACF
  ##"consider arch(1),arch(13)"
auto.arima(diff(log(gold))^2,seasonal = F,stationary = T,max.q=0) #aic
  ##"consider arch(2)
garchFit(~ 1 + garch(1,0), data=c(diff(log(gold))), trace=FALSE)
garchFit(~ 1 + garch(13,0), data=c(diff(log(gold))), trace=FALSE)
garchFit(~ 1 + garch(2,0), data=c(diff(log(gold))), trace=FALSE)

fit.arch2=ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(2, 0)), 
                     mean.model = list(armaOrder = c(0, 0),include.mean = T),                 
                     distribution.model = "norm")

gold.arch2<-ugarchfit(spec = fit.arch2, data = diff(log(gold.t)), out.sample = 3, solver = 'hybrid', fit.control = list(stationarity = 1))
gold.arch2
plot(gold.arch2,which='all')

### ---- 2.c.b Predict ----

forecast.norm.arch2=ugarchforecast(gold.arch2, data = gold.t, n.ahead = 3, n.roll = 0, out.sample = 3) 
forecast.norm.arch2

## ------ 3 GARCH -------
garchFit(~1+garch(1,1),data=c(diff(log(gold))),trace=F)
fit.garch11=ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)), 
                     mean.model = list(armaOrder = c(0, 0),include.mean = T),                 
                     distribution.model = "norm")
gold.garch11<-ugarchfit(spec = fit.garch11, data = diff(log(gold.t)), out.sample = 3, solver = 'hybrid', fit.control = list(stationarity = 1))
gold.garch11
plot(gold.garch11,which='all')
forecast.norm.garch11=ugarchforecast(gold.garch11, data = gold.t, n.ahead = 3, n.roll = 0, out.sample = 3) 
forecast.norm.garch11

sqrt(var(diff(log(gold.t[0:-3]))))
