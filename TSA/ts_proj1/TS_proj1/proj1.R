library(TSA)
library(fUnitRoots)

set.seed(123)

path <- "/Users/xinby/Desktop/Sufe/TSA/ts_proj1/TS_proj1/industry data.xlsx"
dat <- readxl::read_excel(path)
IP <- ts(dat$`Industrial Production`, start = 1947, end = 1993)



plot(IP,type='o')
qqnorm(IP, main="Q-Q plot"); qqline(IP)

dIP <- diff(IP)
plot(dIP,type = 'o',main="Industrial Production Growth",ylab = "diff(IP)")

adfTest(IP,lags=0,type='c')
adfTest(dIP,lags = 0,type='c')

pacf(dIP,xaxp=c(0,20,10),lag.max=20,main="PACF") #suggest AR(2)
acf(dIP,xaxp=c(0,20,10),lag.max=20,main="ACF",ci.type='ma') # suggest MA(2)


