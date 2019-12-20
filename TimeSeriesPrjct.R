#Time Series Modelling & Forecasting:
#Create a model to forecast the umemployment rate for next year.
#Installing packages:
#install.packages("readr")
#install.packages("ggplot2")
#install.packages(forecast)
#install.packages(TTR)
#Loading libraries:
library(readr)
library(ggplot2)
library(forecast)
library(TTR)
library(dplyr)
#Reading dataset----
dat <- read.csv("F:/rWork/rProjects/AbhiAnalytics/UNRATE.csv",header = T)
dim(dat)
View(dat)
str(dat)

#Data Partitioning----
dat_train = subset(dat, CLASS == 'Train')
dat_test = subset(dat, CLASS == 'Test')

nrow(dat_train); nrow(dat_test)

#Preparing the Time Series Object
dat_ts <- ts(dat_train[, 2], start = c(1948, 1), end = c(2017, 12), frequency = 12)
#To run the forecasting models in 'R', we need to convert the data into a time series object 
#The 'start' and 'end' argument specifies the time of the first and the last observation, respectively. 
#The argument 'frequency' specifies the number of observations per unit of time.
class(dat_ts)

#Creating MAPE function to calculate the Accuracy of Prediction using various models:----
#Mape
mape <- function(actual,pred){
  mape <- mean(abs((actual - pred)/actual))*100
  return (mape)
}

#Checking whether time series is stationary or not using----
#Augmented Dickey-Fuller test or ADF Test:
library(tseries)
adf.test(dat_ts)
#We see that the series is stationary enough to do any kind of time series modelling.

#Forecasting Methods for Time Series Forecasting:----

#Naive Forecasting Method----
naive_mod <- naive(dat_ts, h = 24)
summary(naive_mod)

dat_test$naive = 4.1
mape(dat_test$UNRATE, dat_test$naive) 
View(dat_test)

#Simple Exponential Smoothing----
se_model <- ses(dat_ts, h = 24)
summary(se_model)
dat_test$simplexp = 4.1
#df_fc = as.data.frame(se_model)
#dat_test$simplexp = se_model$`Point Forecast`
mape(dat_test$UNRATE, dat_test$simplexp) 

#Holt's Trend Method-----
holt_model <- holt(dat_ts, h = 24)
summary(holt_model)

df_holt = as.data.frame(holt_model)

dat_test$holt = df_holt$`Point Forecast`
mape(dat_test$UNRATE, dat_test$holt)

View(dat_test)

#ARIMA (auto arima model)----
arima_model <- auto.arima(dat_ts)
summary(arima_model)

fore_arima = forecast(arima_model, h=24)

df_arima = as.data.frame(fore_arima)
dat_test$arima = df_arima$`Point Forecast`
mape(dat_test$UNRATE, dat_test$arima)
View(dat_test)

#Plotting the forecasts:----
par(mfrow=c(2,2))
ts.plot(dat_test$naive,main="Naive Forecast")
ts.plot(dat_test$simplexp,main="Simple Exponential Smoothening Forecast")
ts.plot(dat_test$holt,main="Holt Winters Forecast")
ts.plot(dat_test$arima,main="Auto Arima Forecast")


