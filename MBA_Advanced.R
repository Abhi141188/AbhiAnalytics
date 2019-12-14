#Market Basket Analysis:
#Data Preparation

#Convert raw and demographic data to transaction class
df <- data.frame(
  age   = as.factor(c(6, 6, 8, 8, NA, 9, 16)),
  grade = as.factor(c("A", "C", "C", "C", "F", NA, "C")),
  pass  = c(TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE)) 
View(df)
## convert to transaction
#install.packages("arules")
library("arules")
trans3 <- as(df, "transactions")
inspect(trans3)

#Project/Case Study:
# Read CSV data file
mydata = read.csv("F:/rWork/rProjects/AbhiAnalytics/MBA.csv")
# See first 10 observations
head(mydata, n=10)
View(mydata)

# Split data
dt <- split(mydata$Products, mydata$ID)
View(dt)
# Loading arules package
library("arules")

# Convert data to transaction level
dt2 = as(dt,"transactions")
summary(dt2)
inspect(dt2)

# Most Frequent Items
itemFrequency(dt2, type = "relative")
itemFrequencyPlot(dt2,topN = 5)

# aggregated data
rules = apriori(dt2, parameter=list(support=0.05, confidence=0.8))
rules = apriori(dt2, parameter=list(support=0.005, confidence=0.8, minlen = 3))
rules = apriori(dt2, parameter=list(support=0.005, confidence=0.8, maxlen = 4))

#Convert rules into data frame
rules3 = as(rules, "data.frame")
View(rules3)
write(rules, "F:/rWork/rProjects/AbhiAnalytics/rules2.csv", sep=",")

# Show only particular product rules ( let say Product H)
inspect( subset( rules, subset = rhs %pin% "Product H" ))

# Show the top 10 rules
options(digits=2)
#Option(digit=2): this cmd controls the number of significant digits to print when 
#printing numeric values. 
inspect(rules[1:10])

# Get Summary Information
summary(rules)

# Sort by Lift
rules<-sort(rules, by="lift", decreasing=TRUE)

# Remove Unnecessary Rules
#identify duplicate rules and remove them
rules
redundant_rules <- is.redundant(rules)
redundant_rules
summary(redundant_rules)
#Since we got TRUE for 674 rules,Hence, there are 674 rules which are redundant.
#We will have to remove these duplicate rules.
rules<-rules[!redundant_rules]
rules
# We have removed the duplicate rules from above cmds.

inspect(rules[1:5])

#Visualization of Rules
#install.packages("arulesViz")
library("arulesViz")
plot(rules,method = "graph")
plot(rules[1:50],method = "graph")

#Interactive plot
plot(rules,method = "graph", interactive = T)
plot(rules[1:25],method = "graph", interactive = T)

#What are customers likely to buy before they purchase "Product A"
rules<-apriori(data=dt, parameter=list(supp=0.001,conf = 0.8), 
               appearance = list(default="lhs",rhs="Product A"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])

#What are customers likely to buy if they purchased "Product A"l
rules<-apriori(data=dt, parameter=list(supp=0.001,conf = 0.8), 
               appearance = list(default="rhs",lhs="Product A"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules)

