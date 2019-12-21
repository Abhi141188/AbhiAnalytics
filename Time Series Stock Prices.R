#Time Series
#Forecasting the Stock Price:
mydata <- read.csv("F:/rWork/rProjects/AbhiAnalytics/StockPrice.csv", header = T)
attach(mydata)
View(mydata)
#Load Libraries
library(MASS)
library(tseries)
library(forecast)

#Plot & Convert to ln format
lnstock=log(price[1:741])
lnstock
#the reason we are taking log of stock prices is because:stock prices are based on returns 
#and returns are based on percentages, so we are going to cover the price in log format 
#to make sure that we are picking up that attribute in our time series.


#Dickey-Fuller Test
adf.test(lnstock)
#this test shows that this time series is not stationary.

#ACF, PACF
acf(lnstock, lag.max = 20)
pacf(lnstock, lag.max = 20)
difflnstock <- diff(lnstock,1)
difflnstock

adf.test(difflnstock)
#the time series has become stationary now.

#Time Series & auto.arima
pricearima <- ts(lnstock,start = c(2015,1),end = c(2017,12),frequency = 252)
#Above we have taken frequency = 260, bcz our dataset has daily stock price and
#the stock markets open five days a week, hence, total days stock prices change in a year
#becomes: 52 weeks * 5 days = 260.
#We could also take frequency = 252 bcz on an average about 252 trading days occure in a year. 

class(pricearima)

fitlnstock <- auto.arima(pricearima)
fitlnstock
plot(pricearima)
title ('Stock Price')
exp(lnstock)

#Forecasted values from ARIMA
forecastedvalues_ln = forecast(fitlnstock,h=138)
forecastedvalues_ln
plot(forecastedvalues_ln)

forecastedvaluesextracted = as.numeric(forecastedvalues_ln$mean)
final_forecastedvalues = exp(forecastedvaluesextracted)
final_forecastedvalues

#Percentage Error:
df <-data.frame(price[741:878],final_forecastedvalues)
col_headings <-c("Actual Price","Forecasted Price")
names(df) <- col_headings
View(df)
attach(df)
percentage_error = ((df$'Actual Price'- df$'Forecasted Price')/(df$'Actual Price'))
percentage_error
mean(percentage_error)

#Ljung-Box test:
# To see if our residuals are random or not,
# bcz if there are correlations between our residuals then its going to create problems in our time series model bcz its not good to have correlations between the residuals.
#and it could skew the accuracy of the estimates/firecasts we are getting.
Box.test(fitlnstock$resid, lag = 5,type = "Ljung-Box")
Box.test(fitlnstock$resid, lag = 10,type = "Ljung-Box")
#Now, since the p value is in-significant, hence, we cant reject the Null hypothesis 
#that the residuals are random.



