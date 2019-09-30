#----Data Frame----
#We can create a dataframe by combining variables of same length.
# Create a, b, c, d variables
a <- c(10,20,30,40)
b <- c('book', 'pen', 'textbook', 'pencil_case')
c <- c(TRUE,FALSE,TRUE,FALSE)
d <- c(2.5, 8, 10, 7)
# Join the variables to create a data frame
df <- data.frame(a,b,c,d)
df

#We can see the column headers have the same name as the variables. 
#We can change the column name with the function names()
names(df) <- c('ID', 'items', 'store', 'price')
df

# Print the structure
str(df)
# Note: By default, data frame returns string variables as a factor.

#Slice Data Frame: 
#We select rows and columns to return into bracket preceded by the name of the data frame

## Select row 1 in column 2
df[1,2]

## Select Rows 1 to 2
df[1:2,]

## Select Columns 1
df[,1]

## Select Rows 1 to 3 and columns 3 to 4
df[1:3, 3:4]

#It is also possible to select the columns with their names.
## Slice with columns name
df[, c('ID', 'store')]

#Append a Column to Data Frame (use the symbol $ to append a new variable.)
# Create a new vector
quantity <- c(10, 35, 40, 5)
# Add `quantity` to the `df` data frame
df$quantity <- quantity
df

#Note:The number of elements in the vector has to be equal to the no of elements in data frame. 
#Hence, executing the below statement will give error
quantity <- c(10, 35, 40)
# Add `quantity` to the `df` data frame
df$quantity <- quantity

#Selecting a Column of a Data Frame.
# Select the column ID
df$ID

#Subsetting a Data Frame based on some condition.(we will use subset() fxn for this)
# Select price above 5
subset(df, subset = price > 5)

# Another example of dataframe:

#create Vectors to be combined into DF
(rollno = 1:30)
(sname = paste('student',1:30,sep=''))
(gender = sample(c('M','F'), size=30, replace=T, prob=c(.7,.3)))
(marks = floor(rnorm(30, mean=50,sd=10)))
plot(density(marks)); 
abline(v=50)
(marks2 = ceiling(rnorm(30,40,5)))
plot(density(marks2)); 
abline(v=c(40,50))
(course = sample(c('BBA','MBA'), size=30, replace=T, prob=c(.5,.5)))

#create DF
df1= data.frame(rollno, sname, gender, marks, marks2, course)
str(df1) #structure of DF
head(df1) #top 6 rows
head(df1,n=3) #top 3 rows
tail(df1) #last 6 rows
class(df1) # DF
summary(df1) #summary

df1  #full data
df1[,c('course')]
df1$course
df1$gender  # one column
df1[ , c(2,4)] #multiple columns
df1[1:10 ,] #select rows, all columns
#as per conditionis
names(df1)
df1[ marks > 50 & gender=='F', c('rollno', 'sname','marks')]
df1[ marks < 50 & gender=='F', c(1,2,3,4)]
df1[ marks > 50 & gender=='F', ]

names(df1)  # names of columns
dim(df1)  #Dimensions

aggregate(df1$marks, by=list(df1$gender), FUN=min)

(df2 = aggregate(cbind(marks,marks2) ~ gender + course, data=df1, FUN=max))

