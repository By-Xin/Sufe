library(readxl)
library(tidyverse)
# ex 6.5
rm(list=ls())
setwd("D:/Sufe/Multivariate-Stat-Analysis/Hw&Proj/hw3")

  ## Clustering for e.g.6.3.3
  dat1 <- read_xlsx("examp6.3.3.xlsx") %>% select(-region) #load data
  
  dist <- dist(dat1, method="euclidean", diag = TRUE) #compute distance
  dist_std <- dist(scale(dat1), method = "euclidean", diag=TRUE) #compute std distance
  
  ### WARD.Distance
  hc_ward <-  hclust(dist, "ward.D")  #ward clustering
  hc_ward_std <- hclust(dist_std,"ward.D") #ward clustering on std distance
  
  
  par(mfrow=c(2,1)) #show cluster fig
  plot(hc_ward, hang =-1) #plot cluster
  rect.hclust(hc_ward, k=3)#plot frame to show cluster
  plot(hc_ward_std, hang =-1)#plot cluster std
  rect.hclust(hc_ward_std, k=3)  #plot frame to show cluster std

  cutree(hc_ward,k=3) #show cluster result
  cutree(hc_ward_std,k=3)#show cluster result std
  
  ### Longest Distance
  long_dist <-  hclust(dist, "complete")  #longest dist clustering
  long_dist_std <- hclust(dist_std,"complete") #longest dist clustering on std distance
  
  
  par(mfrow=c(2,1)) #show cluster fig
  plot(long_dist, hang =-1) #plot cluster
  rect.hclust(long_dist, k=3)#plot frame to show cluster
  plot(long_dist_std, hang =-1)#plot cluster std
  rect.hclust(long_dist_std, k=3)  #plot frame to show cluster std
  
  cutree(long_dist,k=3) #show cluster result
  cutree(long_dist_std,k=3)
  
  ### Centroid
  center_dist <-  hclust(dist, "centroid")  #centroid dist clustering
  center_dist_std <- hclust(dist_std,"centroid") #centroid dist clustering on std distance
  
  
  par(mfrow=c(2,1)) #show cluster fig
  plot(center_dist, hang =-1) #plot cluster
  rect.hclust(center_dist, k=3)#plot frame to show cluster
  plot(center_dist_std, hang =-1) #plot cluster std
  rect.hclust(center_dist_std, k=3)  #plot frame to show cluster std
  
  cutree(center_dist,k=3) #show cluster result
  cutree(center_dist_std,k=3) #show cluster result std
  
  ## Clustering for e.g.6.4.2
  kmean <- kmeans(dat1,5) #kmeans for original data
  sort(kmean$cluster)    #show result in order
  kmean_std <- kmeans(scale(dat1),5)  #kmeans for std data
  sort(kmean_std$cluster)  #show result in order 
  
# ex.6.6
dat2 <- scale(read_excel("exec6.6.xlsx")%>%select(-nation)) # load data
dist <- dist(dat2, diag=TRUE) # compute distance

  # Average Linkage Method
  hc_avg <- hclust(dist, method = "average")#clustering
  par(mfrow=c(1,1))
  plot(hc_avg, hang=-1) #plot cluster result
  rect.hclust(hc_avg, k=4) #frame out clusters
  cutree(hc_avg, k=4) #show results 
  
  # Ward Method
  hc_wrd <- hclust(dist, method = "ward.D")#clustering
  plot(hc_wrd, hang=-1) #plot cluster result
  rect.hclust(hc_wrd, k=4) #frame out clusters
  cutree(hc_wrd, k=4) #show results 
  
  # kmeans
  kmeans <- kmeans(dat2,4)
  kmeans$cluster 
      
  
# ex.7.5
dat3 <- as.matrix(read_excel("examp6.3.7.xlsx")%>%select(-1)) #load data
eign <- eigen(dat3) #calculate eign value and eign vector
eign.value <- eign$values 
eign.vector <- eign$vectors

contribution <- eign.value/sum(eign.value) #calculate contribution rate
accumulative.contribution <- cumsum(contribution)#cal accu.contribution rate
par(mfrow=c(2,1)) #plot contribution of each PC
plot(contribution,type='o', main='Contribution of each PC', 
     xlab = "Principal Components",ylab="Percentage")
plot(accumulative.contribution, type='o', 
     main="Accumulative Contribution of PC", 
     xlab = "Principal Components",
     ylab="Percentage")
par(mfrow=c(1,1))
print(round(eign.vector,3))
print(round(eign.value,3))

# ex.7.6
dat4 <- as.matrix(read_excel("exec7.6.xlsx")%>%select(-state)) #load data
dat4
PCA = prcomp(dat4, center = TRUE, scale. = TRUE) #get std. data PCA
summary(PCA) #summary pca
screeplot(PCA,type="lines")

# ex.7.7
dat5 <- as.matrix(read_excel("exec7.7.xlsx")%>%select(-week)) #load data
dat5
PCA = prcomp(dat5, center = TRUE, scale. = TRUE) #get std. data PCA
summary(PCA) #summary pca
screeplot(PCA,type="lines")
round(PCA$rotation,3)
