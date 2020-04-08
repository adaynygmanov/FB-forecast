### 1) Load the data and do initial look:
## Load libraries
library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)
library(ggplot2)

## Pull data from Yahoo Finance
getSymbols('FB',from='2015-04-01',to='2020-04-01')
class(FB) #Class is xts/zoo

## We want the days close price for each trading day (4th column)
FB_Close_Prices=FB[,4]

## Plot the data
par(mfrow=c(1,1))
plot(FB_Close_Prices)
class(FB_Close_Prices)

## Plot the data and get initial auto.arima pdq values
par(mfrow=c(1,2))
Acf(FB_Close_Prices,main='ACF for Differenced Series')
Pacf(FB_Close_Prices,main='PACF for Differenced Series')
auto.arima(FB_Close_Prices,seasonal=FALSE)

### 2) Log residuals to remove non-stationary properties
##C Compute the log returns for the stock - makes data more stable
logs = diff(log(FB_Close_Prices),lag=1)
logs = logs[!is.na(logs)] #get rid off any missing data

## ADF test for p-value
print(adf.test(logs)) #p-value < 0.01
auto.arima(logs, seasonal = FALSE) 
str(logs) #xts object

# Split the dataset in two parts - 80/20 training and testing
sample_size=floor(0.80 * nrow(logs))
set.seed(109) #random seed number that when reused makes this reproductible
train_indices<-sample(seq_len(nrow(logs)),size = sample_size)

train<-logs[train_indices, ] #80%
test<-logs[-train_indices, ] #other 20%

par(mfrow=c(1,2))
Acf(train, main='ACF for Differenced Series')
Pacf(train, main='PACF for Differenced Series')
auto.arima(train,seasonal = FALSE)

### 3) Plot models, get accuracy and draw conclusions
## Look at residuals for the auto.arima and custom arima models based on the above determined pdq values
fit1<-auto.arima(train,seasonal=FALSE)
tsdisplay(residuals(fit1), lag.max = 40, main='(0,0,1) Model Residuals') 

fit2<-arima(train,order = c(9,0,11))
tsdisplay(residuals(fit2), lag.max = 40, main='(9,0,11) Model Residuals')

## Original data without logs of returns (lag at 31)
fit3<-auto.arima(FB_Close_Prices, seasonal=FALSE)
tsdisplay(residuals(fit3), lag.max = 40, main='Original, Non-log returns Model Residuals')

## Custom Arima from fit2 above applied to original dataset
fit4<-arima(FB_Close_Prices, order=c(9,0,11))
tsdisplay(residuals(fit4), lag.max = 40, main='(9,0,11) Model Residuals on original dataset')

## Plots of all arima models
par(mfrow=c(2,2))

##auto arima 
Period<-100
fcast1<-forecast(fit1, h=Period)
plot(fcast1)

## custom arima 
fcast2<-forecast(fit2, h=Period)
plot(fcast2)

## original, non-log returns data
fcast3<-forecast(fit3, h=Period)
plot(fcast3)

## custom arima applied to original, non-log returns, dataset
fcast4<-forecast(fit4,h=Period)
plot(fcast4)

## Look closely at auto arima on original dataset
par(mfrow=c(1,2))
plot(fcast3)
plot(fcast4)

## Check for accuracy
accuracy(fcast1)
accuracy(fcast2)
accuracy(fcast3) #98.7% accuracy by MAPE (Mean Average Percent Error)
accuracy(fcast4) #99.4% accuracy by MAPE (Mean Average Percent Error)

## Look at actual forecasted values on original dataset (fcast3)
#1 – auto arima
fcast3

#2 - custom arima with pdq values
fcast4