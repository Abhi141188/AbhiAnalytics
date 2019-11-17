#Clustering
#We  have data on the total spend of customers and their ages. 
#To improve advertising, marketing team wants to send more targeted emails to their customers.

#Plot the total spend and the age of the customers.

library(ggplot2)
df <- data.frame(age = c(18, 21, 22, 24, 26, 26, 27, 30, 31, 35, 39, 40, 41, 42, 44, 46, 47, 48, 49, 54),
                 spend = c(10, 11, 22, 15, 12, 13, 14, 33, 39, 37, 44, 27, 29, 20, 28, 21, 30, 31, 23, 24)
)
ggplot(df, aes(x = age, y = spend)) +
  geom_point()

#K-means clustering on Dataset "Computers".
library(dplyr)
df<-read.csv("F:/rWork/rProjects/AbhiAnalytics/computers.csv",header = T)
View(df)
#removing unwanted columns
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
#install.packages("animation")	
#add .ani after kmeans and R will plot all the steps. For illustration purpose, 
#we only run the algorithm with the rescaled variables hd and ram with three clusters.
par(mfcol = c(2, 3))
set.seed(2345)
library(animation)
kmeans.ani(rescale_df[2:3], 3)

#
pc_cluster <-kmeans(rescale_df, 5)
pc_cluster
#pc_cluster contains few interesting elements:

# Indicates the cluster of each observation
pc_cluster$cluster

#The total sum of squares
pc_cluster$totss

#Within sum of square. 
#The number of components return is equal to `k`
pc_cluster$withinss

#Number of observation within each cluster
pc_cluster$size

#We use the sum of the within sum of square (i.e. tot.withinss) to compute the optimal number of clusters k.

#Optimal K
#One technique to choose the best k is called the elbow method. 
#This method uses within-group homogeneity or within-group heterogeneity to evaluate the variability.

#Construct a function to compute the total within clusters sum of squares----
kmean_withinss <- function(k) {
  cluster <- kmeans(rescale_df, k)
  return (cluster$tot.withinss)
}
## Try with 2 cluster
kmean_withinss(2)

#Run the algorithm n times----

# Set maximum cluster 
max_k <-20 
# Run algorithm over a range of k 
wss <- sapply(2:max_k, kmean_withinss)

#Create a data frame with the results of the algorithm----
#We run the k-mean algorithm over a range from 2 to 20, store the tot.withinss values.

# Create a data frame to plot the graph
elbow <-data.frame(2:max_k, wss)

#Plot the graph with gglop
ggplot(elbow, aes(x = X2.max_k, y = wss)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = seq(1, 20, by = 1))

#Once we have our optimal k, we re-run the algorithm with k equals to 7 and 
#evaluate the clusters.

#Examining the cluster
pc_cluster_2 <-kmeans(rescale_df, 7)

#Other Info:
pc_cluster_2$cluster
pc_cluster_2$centers
pc_cluster_2$size

#Create a heat map with ggplot to highlight the difference between categories.----
#Build a data frame
library(tidyr)
#create dataset with the cluster number
center <-pc_cluster_2$centers
center
cluster <- c(1: 7)
center_df <- data.frame(cluster, center)

#Reshape the data
center_reshape <- gather(center_df, features, values, price_scal: trend_scal)
head(center_reshape)

library(RColorBrewer)
# Create the palette
hm.palette <-colorRampPalette(rev(brewer.pal(10, 'RdYlGn')),space='Lab')
# Plot the heat map
ggplot(data = center_reshape, aes(x = features, y = cluster, fill = values)) +
  scale_y_continuous(breaks = seq(1, 7, by = 1)) +
  geom_tile() +
  coord_equal() +
  scale_fill_gradientn(colours = hm.palette(90)) +
  theme_classic()






