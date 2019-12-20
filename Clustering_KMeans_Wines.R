#K-means clustering with Wines dataset
# Install following packages:
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("corrplot")
#install.packages("gridExtra")
#install.packages("GGally")
#install.packages("cluster")
#install.packages("fpc")
#install.packages("factoextra")
#install.packages("NbClust")

library(tidyr) # data manipulation
library(corrplot)
library(gridExtra)
library(GGally)
library(cluster) # clustering algorithms 
library(factoextra) # clustering algorithms & visualization
library(dplyr)
library(NbClust)

#Load the dataset in R:
wines_0 <- read.csv("F:/rWork/rProjects/AbhiAnalytics/wine.csv",header = T)
View(wines_0)

#k-means is an unsupervised machine learning algorithm and works with unlabeled data. 
#So, We don't need the Class column.Hence, removing it from the dataset.
wines <- wines_0[,-14]
head(wines)
View(wines)
#Data Analysis
#As a first step we will have an overview of the individual data sets 
#using the summary and str function.
summary(wines)

str(wines)
#We can see that the all the variables are either numeric or integers, 
#therefore, we can use these variables here.

#Visualize: 
#Let's visualize variables available in dataset by making histograms for each.
wines %>%
  gather(attributes, value, 1:13) %>%
  ggplot(aes(x = value)) +
  geom_histogram(fill = 'lightblue2', color = 'black') +
  facet_wrap(~attributes, scales = 'free_x') +
  labs(x="Values", y="Frequency") +
  theme_bw()

#Correlation Matrix:
#Making a correlation matrix to understand the relation between each attributes
corrplot(cor(wines), type = 'upper', method = 'circle', tl.cex = 0.9)

#Data Preparation:
#From the data summary, we see that few variables are on different scales
#Hence, we need to scale the data.
winesNorm <- as.data.frame(scale(wines))
head(winesNorm)

#k-means clustering in R
#We can compute k-means in R with the kmeans function.
set.seed(123)
wines_K2 <- kmeans(winesNorm, centers = 2, nstart = 25)
print(wines_K2)
View(winesNorm)

#Plot
#install.packages("animation")
par(mfcol = c(2, 3))
set.seed(2345)
library(animation)
kmeans.ani(winesNorm, 2)

#let's visualize the cluster we have created.
library(cluster)
library(fpc)
plotcluster(winesNorm,wines_K2$cluster)

##Optimal k----
#Method to choose optimal no. of clusters(k) is called the elbow method.
#Construct a function to compute the total within clusters sum of squares
kmean_withinss <- function(k) {
  cluster <- kmeans(winesNorm, k)
  return (cluster$tot.withinss)
}
#Try with 2 cluster
kmean_withinss(2)

#Run the algorithm n times
#Use sapply() function to run the algorithm over a range of k. 
#This technique is faster than creating a loop and store the value.

# Set maximum cluster 
max_k <-20 
#Run algorithm over a range of k 
wss <- sapply(2:max_k, kmean_withinss)

#Create a data frame with the results of the algorithm
#Post creation and testing function, we can run the k-mean algorithm over a range
#from 2 to 20, store the tot.withinss values.

# Create a data frame to plot the graph
elbow <-data.frame(2:max_k, wss)

#Plot the results
# We plot to visualize where is the elbow point

#Plot the graph with gglop
ggplot(elbow, aes(x = X2.max_k, y = wss)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = seq(1, 20, by = 1))

#From the graph, we see the optimal k is three, where the curve is starting to have 
#a diminishing return. Once we have optimal k, we re-run the algorithm with k=3 
#and evaluate the clusters.

##Now,we compute k-means in R with k=3.
set.seed(123)
wines_K3 <- kmeans(winesNorm, centers = 3)
print(wines_K3)
View(winesNorm)

#let's visualize the cluster we have created.
library(cluster)
library(fpc)
plotcluster(winesNorm,wines_K3$cluster)

#Checking the relation between Alcohol & color intensity in Wines, segmented in clusters.
set.seed(1)
ggplot(wines, aes(x =Alcohol, y = Color.intensity)) + 
  geom_point(stat = "identity", aes(color = as.factor(wines_K3$cluster))) +
  scale_color_discrete(name=" ",
                       breaks=c("1", "2", "3"),
                       labels=c("Cluster 1", "Cluster 2", "Cluster 3")) +
  ggtitle("Segments of Wines based on Alcohol & Color", subtitle = "Using K-means Clustering")

#Accuracy:
#table cmd:
winesNorm$CL<-wines_K3$cluster
View(winesNorm)
table(wines_0$Class,winesNorm$CL)

