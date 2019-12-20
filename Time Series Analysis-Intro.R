#Date Manipulations:
#Date:----
#Used if you have only dates, but no times, in your data.
#create a date:
dt1 <- as.Date("2012-07-22")
dt1
str(dt1)

#non-standard formats must be specified:
dt2 <- as.Date("04/20/2011", format = "%m/%d/%Y")
dt2
str(dt2)

dt3 <- as.Date("October 6, 2010", format = "%B %d, %Y")
dt3
str(dt3)

#see list of format symbols:
`?`(strptime)

#calculations with dates:

#find the difference between dates:
dt1 - dt2

difftime(dt1, dt2, units = "weeks")

#Add or subtract days:
dt2 + 10

#POSIXct----
#If you have times in your data, this is  the best class to use.
#create some POSIXct objects:
tm1 <- as.POSIXct("2013-07-24 23:55:26")
tm1

tm2 <- as.POSIXct("25072013 08:32:07", format = "%d%m%Y %H:%M:%S")
tm2

#specify the time zone:
tm3 <- as.POSIXct("2010-12-01 11:42:03", tz = "GMT")
tm3

#some calculations with times
#compare times:
tm2 > tm1

#Add or subtract seconds:
tm1 + 30

#find the difference between times:
tm2 - tm1

#Get the current time (in POSIXct by default):
Sys.time()

#see the internal integer representation:
unclass(tm1)

#POSIXlt----
#This class enables easy extraction of specific components of time. 
#("ct" stand for calender time and "lt" stands for local time. 
#"lt" also helps one remember that POSIXlt objects are lists.)

#create a time:
tm1.lt <- as.POSIXlt("2013-07-24 23:55:26")
tm1.lt

#extract componants of a time object:
tm1.lt$sec
tm1.lt$wday

#truncate or round off the time:
trunc(tm1.lt, "days")
trunc(tm1.lt, "mins")

#Cleaning and manipulating dates with R lubridate and dplyr----
#install.packages("lubridate")
#install.packages("hflights", lib="/Library/Frameworks/R.framework/Versions/3.3/Resources/library")
#install.packages("dplyr")
library(lubridate)
library(hflights)
library(dplyr)

#Using data sets available in hflights package and lakers (from the lubridate package)
View(hflights)
str(hflights)
#Quick look at data set shows that hflights has no singular dedicated date column,
#instead year, month & day of the month are contained in three separate columns.
View(lakers)
str(lakers$date)
#The lakers dataset has a string containing the digits for year month and day 
#without clear separation.

##Using dplyr package for date manipulation----
#Adding Day, Month and Year from different columns together using mutate fxn
Dated_hflights <- mutate(hflights,Date = paste(Year, Month, DayofMonth,
                                               sep = "-"))
View(Dated_hflights)
str(Dated_hflights$Date)
#The Dates_hflights will now have a new column called "Date" which has the
#date formatted into the Year-Month-Day string format.

##Using lubridate package for date manipulation----
#We can choose the function required by the way the function's name orders 
#the elements: year ('y'), month ('m'), day ('d') with optional hour ('h'), 
#minute ('m') and second ('s').

#Lubridate's selected function will parse the date string into R as
#POSIXct date-time objects.For example the string could be parsed as: 
#dmy (30-12-2017), myd (12-30-2017), ymd (2017-12-30), ydm (2017-30-12), 
#dym (30-2017-12), mdy (12-30-2017), or ymd_hms (2017-12-30 12:30:29)
ymd(lakers$date[1:10])

ymd(Dated_hflights$Date[1:10])

#create a time:
tm1.lub <- ymd_hms("2013-07-24 23:55:26")
tm1.lub

#some manipulations: extract or reassign componants:
year(tm1.lub)

week(tm1.lub)

wday(tm1.lub, label = TRUE)

hour(tm1.lub)

tz(tm1.lub)

#Time series object is created by using the ts() function.
# Get the data points in form of a R vector.
rainfall <- c(799,1174.8,865.1,1334.6,635.4,918.5,685.5,998.6,784.2,985,882.8,1071)
class(rainfall)

# Convert it to a time series object.
rainfall.timeseries <- ts(rainfall,start = c(2012,1),frequency = 12)
class(rainfall.timeseries)

# Print the timeseries data.
print(rainfall.timeseries)

#The value of the frequency parameter in the ts() function decides the time intervals at which
#the data points are measured.
#A value of 12 indicates that the time series is for 12 months,i.e., every month of the year.
#A value of 4 indicates that the time series is for every quarter of the year.
#A value of 6 indicates that the time series is for every 10 minutes of an hour.
#A value of 24*6 indicates that the time series is for every 10 minutes of a day.

#Multiple Time Series
#We can create multiple time series into one by combining both the series into a matrix.
#Get the data points in form of a R vector.
rainfall1 <- c(799,1174.8,865.1,1334.6,635.4,918.5,685.5,998.6,784.2,985,882.8,1071)
rainfall2 <- c(655,1306.9,1323.4,1172.2,562.2,824,822.4,1265.5,799.6,1105.6,1106.7,1337.8)

# Convert them to a matrix.
combined.rainfall <-  matrix(c(rainfall1,rainfall2),nrow = 12)

# Convert it to a time series object.
rainfall.timeseries <- ts(combined.rainfall,start = c(2012,1),frequency = 12)

# Print the timeseries data.
print(rainfall.timeseries)
