# Time Series Analysis-Basics
#Basics:----

#Loading the Data Set----
data(AirPassengers)
View(AirPassengers)
class(AirPassengers)
#This tells you that the data series is in a time series format

start(AirPassengers)
#This is the start of the time series

end(AirPassengers)
#This is the end of the time series

frequency(AirPassengers)
#The intervals of this time series is 12months in a year

summary(AirPassengers)
#The number of passengers are distributed across the spectrum

#Detailed Metrics----
plot(AirPassengers)
#This will plot the time series

#Seasonal decomposition
#A time series with additive trend, seasonal, 
#and irregular components can be decomposed using the stl() function. 
fit <- stl(AirPassengers, s.window="period")
plot(fit)
#Above graph shows components of Time Series.

plot(AirPassengers)
#This will plot the time series
abline(reg=lm(AirPassengers~time(AirPassengers)))
# This will fit in a line

#Few Operations of the Time Series dataset:----
cycle(AirPassengers)
#This will print the cycle across years.

plot(aggregate(AirPassengers,FUN=mean))
#This will aggregate the cycles and display a year on year trend.
#Year on year trend clearly shows that the #passengers have been increasing without fail.

boxplot(AirPassengers~cycle(AirPassengers))
#Box plot across months will give us a sense on seasonal effect

# Again plottng time series plot:
#install.packages("forecast")
library(forecast)
series <- AirPassengers
# plot the series 
plot(series, col="darkblue", ylab="Passegners on airplanes")
plot(AirPassengers)

# We observe:
#1. There is a trend component which shows growth in passengers year by year.
#2. There looks to be a seasonal component which has a cycle less than 12 months.
#3. The variance in the data keeps on increasing with time.

#We know that we need to address two issues before we test stationary series. 
#1. we need to remove unequal variances. We do this using log of the series. 
plot(log(AirPassengers))

#2.To address the trend component, we need to make the mean across series equal.
#We do this by taking differential of the series. 
plot(diff(log(AirPassengers)))

#Now, let's test the resultant series.
#install.packages("tseries")
library(tseries)

#ADF Test
adf.test(diff(log(AirPassengers)))
#We see that the series is stationary enough to do any kind of time series modelling

#ARIMA Model----
#Next step is to find the right parameters to be used in the ARIMA model. 
#We already know that 'd' component is 1 as we need 1 differential to make the series stationary. 
#We do this using the Correlation plots. 
#Following are the ACF plots for the series :

#AR I MA
# p d q

# ACF(Auto Correlation factor) Plots:
acf(log(AirPassengers))
#the decay of ACF chart above is very slow, which means that the population 
#is not stationary.
#Hence, we will regress on the difference of logs rather than log directly. 

#ACF(Auto Correlation factor) and PACF(Partial Auto Correlation factor) curve 
#come out after regressing on the difference.
acf(diff(log(AirPassengers))) # Determines the value of q

pacf(diff(log(AirPassengers))) # Determines the value of p

#Clearly, ACF plot cuts off after the first lag. 
#Hence, we understood that value of p should be 0 as the ACF is the curve getting a cut off.
#While value of q should be 1. Also, since series has been differenciated once to make it stationary,
#hence, the value of d will be 1. So, parameters of ARIMA (p,d,q) have value (0,1,1).


#Predictions:
#Let's fit an ARIMA model and predict the future 10 years. 
#Also, we will try fitting in a seasonal component in the ARIMA formulation. 
#Then, we will visualize the prediction along with the training data.
fit <- arima(log(AirPassengers), c(0, 1, 1),seasonal = list(order = c(0, 1, 1), period = 12))
fit
pred <- predict(fit, n.ahead = 10*12)
ts.plot(AirPassengers,2.718^pred$pred, log = "y", lty = c(1,3))

#Accuracy of ARIMA Model forecasting:----
#Determining Prediction accuracy on test dataset using MAPE
#Testing our Model:
datawide <- ts(AirPassengers, frequency = 12, start = c(1949,1),end = c(1959,12))
fit <- arima(log(datawide),c(0,1,1),seasonal = list(order = c(0,1,1),period=12))
pred <- predict(fit, n.ahead = 10*12)
pred1 <- 2.718^pred$pred
data1<-head(pred1,12)
predicted_1960 <- round(data1,digits = 0)
predicted_1960
original_1960 <- tail(AirPassengers,12)
original_1960

#MAPE(MeanAbsolutePercentageError): 
#Lower its value better is the accuracy of the model.

#MAPE Calculation:
mape <- mean(abs((predicted_1960 - original_1960))/original_1960)*100
mape

# Mape using mape function
#install.packages("Metrics")
library(Metrics)
mape(predicted_1960,original_1960)








