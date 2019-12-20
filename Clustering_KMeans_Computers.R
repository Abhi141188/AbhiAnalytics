#K-means clustering on Dataset "Computers".----
df<-read.csv("F:/rWork/rProjects/AbhiAnalytics/computers_price.csv",header = T)
View(df)

#In clustering categorical variables are not handled, hence, we have to remove them first
#removing unwanted columns
library(dplyr)
df <- read.csv("computers.csv") %>%
  select(-c(X, cd, multi, premium))
glimpse(df)
View(df)
#Summary Statisitcs:----
summary(df)
#We can see the data has large values. 
#A good practice with k mean and distance calculation is to rescale the data so that 
#the mean is equal to one and the standard deviation is equal to zero.
#We rescale the variables with the scale() function of the dplyr library.
#Rescale----
rescale_df <- df %>%
  mutate(price_scal = scale(price),
         hd_scal = scale(hd),
         ram_scal = scale(ram),
         screen_scal = scale(screen),
         ads_scal = scale(ads),
         trend_scal = scale(trend)) %>%
  select(-c(price, speed, hd, ram, screen, ads, trend))

View(rescale_df)

#Train the model----
#add .ani after kmeans and R will plot all the steps. For illustration purpose, 
#we only run the algorithm with the rescaled variables hd and ram with three clusters.

#install.packages("animation")
par(mfcol = c(2, 3))
set.seed(2345)
library(animation)
kmeans.ani(rescale_df[2:3], 3)

#The algorithm converged after seven iterations. 

#Now, lets run the k-mean algorithm in dataset with five clusters.
pc_cluster <-kmeans(rescale_df, 5)
#To know the cluster of each observation
pc_cluster$cluster
#To know the mean value of each variable column in each cluster
pc_cluster$centers
#To know the no. of observation within each cluster
pc_cluster$size
#To know the total sum of squares:
pc_cluster$totss
#Within sum of squares in each cluster:
pc_cluster$withinss
#To know the Total within sum of squares
pc_cluster$tot.withinss
#To know the sum of squares in between clusters, 
#sum of squares in between clusters = (Total sum of square - Within sum of square)
pc_cluster$betweenss

#Optimal k----
#Method to choose optimal no. of clusters(k) is called the elbow method.
#Construct a function to compute the total within clusters sum of squares
kmean_withinss <- function(k) {
  cluster <- kmeans(rescale_df, k)
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

#From the graph, we see the optimal k is seven, where the curve is starting to have 
#a diminishing return. Once we have optimal k, we re-run the algorithm with k equals to 7 
#and evaluate the clusters.

#Examining the cluster----
pc_cluster_2 <-kmeans(rescale_df, 7)
str(pc_cluster_2)

#access the remaining interesting information in the list returned by kmean().
pc_cluster_2$cluster
#Indicates the cluster of each observation

pc_cluster_2$centers
#Tells cluster centres or average value of each variable in each cluster.

pc_cluster_2$size	
#Number of observation within each cluster

#Adding cluster column in dataset, to clearly show which data point belongs to which cluster.
rescale_df$CL<-pc_cluster_2$cluster
View(rescale_df)

#Write dataset with cluster in a csv
write.csv(rescale_df,"C:/Users/abhinavc.TEEMWURK/Desktop/Analytics Opportunities/Training Material/Training_RCode/computers_clusters.csv")

#To Unscale a scaled variable, we use the attributes:
# d$s.x * attr(d$s.x, 'scaled:scale') + attr(d$s.x, 'scaled:center')
rescale_df$Price <- rescale_df$price_scal * attr(rescale_df$price_scal, 'scaled:scale') + attr(rescale_df$price_scal, 'scaled:center')
View(rescale_df)
