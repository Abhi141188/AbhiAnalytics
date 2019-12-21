#Time Series
#Forecasting the Stock Price with Avg Monthly Stock Prices:
mydata <- read.csv("F:/rWork/rProjects/AbhiAnalytics/StockPriceMonthly.csv", header = T)
attach(mydata)
View(mydata)

#Load Libraries
library(MASS)
library(tseries)
library(forecast)

#Plot & Convert to ln format

lnstock=log(price[1:30])
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
difflnstock <- diff(lnstock)
difflnstock

adf.test(difflnstock)
#the time series has not become stationary even now, hence, we differenciate it second time.

diff2lnstock <- diff(diff(lnstock))
diff2lnstock
adf.test(diff2lnstock)
#this test shows that this time series is stationary now.


#Time Series & auto.arima
pricearima <- ts(lnstock,start = c(2015,1),end = c(2017,6),frequency = 12)
class(pricearima)

fitlnstock <- auto.arima(pricearima)
fitlnstock
plot(pricearima)
title ('Stock Price')
exp(lnstock)

#Forecasted values from ARIMA
forecastedvalues_ln = forecast(fitlnstock,h=6)
forecastedvalues_ln
plot(forecastedvalues_ln)

forecastedvaluesextracted = as.numeric(forecastedvalues_ln$mean)
final_forecastedvalues = exp(forecastedvaluesextracted)
final_forecastedvalues

#Percentage Error:
df <-data.frame(price[31:36],final_forecastedvalues)
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

-------------------------------------
#Fetching Company's financial data from online source & analyzing it using quantmode package----
install.packages("quantmod")
library(quantmod)
start <- as.Date("2019-10-01") ;end <- as.Date("2019-12-20")
getSymbols("SBIN.NS", src = "yahoo", from = start, to = end)
SBIN.NS
head(SBIN.NS)
plot(SBIN.NS[, "SBIN.NS.Close"], main = "SBIN.NS")
candleChart(SBIN.NS, up.col = "black", dn.col = "red", theme = "white")
#multiple stocks - prices from 
getSymbols(c("ICICIBANK.NS", "TATAMOTORS.NS"), src = "yahoo", from = start, to = end)

stocks = as.xts(data.frame(SBIN = SBIN.NS[, "SBIN.NS.Close"], ICICI = ICICIBANK.NS[, "ICICIBANK.NS.Close"], TATAMOTORS = TATAMOTORS.NS[, "TATAMOTORS.NS.Close"]))
head(stocks)
plot(as.zoo(stocks), screens = 1, lty = 1:3, xlab = "Date", ylab = "Price")
legend("right", c("SBIN", "ICICI", "TATATMOTORS"), lty = 1:3, cex = 0.5)

