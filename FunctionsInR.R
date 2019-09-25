#----Various Functions in R----

# str() Compactly display the internal structure of an R object. 
# names() Names of elements within an object
# class() Retrieves the internal class of an object
# mode() Get or set the type or storage mode of an object.
# length() Retrieve or set the dimension of an object.
# dim() Retrieve or set the dimension of an object.

#Examples:
x <- 1:10
class(x)
mode(x)
str(x)

# Creating data set by combining 4 variables of same length.
# Create a, b, c, d variables
a <- c(10,20,30,40)
b <- c('book', 'pen', 'textbook', 'pencil_case')
c <- c(TRUE,FALSE,TRUE,FALSE)
d <- c(2.5, 8, 10, 7)
# Join the variables to create a data frame
df <- data.frame(a,b,c,d)
df
names(df)
length(df) 
dim(df)

#----Functions to navigate inside the dataset.----
#select() fxn: We can select variables in different ways with select()
#filter() fxn: It helps to keep the observations following a criteria.

# select()
#install.packages("dplyr")
library(dplyr)
step_1_df <- select(df, a,b,c)
dim(df)
dim(step_1_df)
step_1_df

# filter()
# Select observations
select_f1 <- filter(df, b == "book")
dim(select_f1)

select_f2 <- filter(df, c == "TRUE")
dim(select_f2)

#Sorting:
#You can sort your data according to certain variable in dataset using order() fxn.
# Sort by column 'd' in dataset df in ascending order.
df1 <-df[order(df$d),]
head(df1)
# Sort by column 'd' in dataset df in descending order.
df2 <-df[order(-df$d),]
head(df2)

