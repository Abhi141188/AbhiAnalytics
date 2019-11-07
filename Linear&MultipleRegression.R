#Regression
df <- read.csv("F:/R Tool Directory/Choudhary R/stud_reg.csv", header = T)
View(df)
df

#Single Linear Regression
result<-lm(APPLICANTS~PLACE_RATE, data=df)
summary(result)
data_fitted<-data.frame(df,fitted.values=fitted(result), residual=resid(result))
data_fitted

#Multiple Regression
result<-lm(APPLICANTS~PLACE_RATE+NO_GRAD_STUD, data=df)
summary(result)
data_fitted<-data.frame(df,fitted.values=fitted(result), residual=resid(result))
data_fitted

#Exercise
age<-c(18:29)
age
hieght<-c(76.1,77,78.1,78.2,78.8,79.7,79.9,81.1,81.2,81.8,82.8,83.5)
hieght
df<-data.frame(age,hieght)
df
plot(age~hieght)
result<-lm(age~hieght)
summary(result)

#Eq: Age= -100.84 + 1.55*Hieght
#Since R2 is close to 1, hence model is highly significant.
data_fitted<-data.frame(df , fitted.value=fitted(result),residual=resid(result))
data_fitted
library("ggplot2")
g <- ggplot(df, aes(x=hieght, y=age)) + geom_point() + geom_smooth(method="lm") 
plot(g)

#Exercise2:
names(mtcars)
View(mtcars)
plot(mpg~hp, data=mtcars)
plot(mpg~wt, data=mtcars)
result<-lm(mpg~hp+wt, data=mtcars)
summary(result)
#Accuracy
#Value of Adjusted R2 = 0.75, means that "75% of the variance in the measure of mpg can be predicted by hp and wt."

#Checking Multicollinearity:
result<-lm(mpg~hp+wt+disp+cyl+qsec+gear, data=mtcars)
summary(result)

#install.packages("usdm")
library(usdm)
vif(mtcars)
vif(mtcars[,c(-3)])
vif(mtcars[,c(-3,-2)])
result<-lm(mpg~hp+wt+qsec+gear, data=mtcars)
summary(result)

