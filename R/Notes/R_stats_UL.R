#================================================================================= 
# [table of contents]
#   - principal components analysis 
#   - clustering
#=================================================================================

#=================================================================================
# principal components analysis 
#=================================================================================

pca.out <- prcomp(data, scale = T)

pca.out$center  # means, prior to scaling
pca.out$scale  # stdev, prior to scaling
pca.out$rotation  # loadings
pr.var <- pca.out$sdev^2  # variance explained
PVE <- pr.var / sum(pr.var)
biplot(pca.out, scale = 0)

#=================================================================================
# clustering
# - k-means clustering
# - hierarchical clustering
#=================================================================================

#---------------------------------------------------------------------------------
# k-means clustering:

km.out <- kmeans(x, 4, nstart = 50)
km.out$withinss  # within-cluster sum of squares

#---------------------------------------------------------------------------------
# hierarchical clustering:

hc.complete <- hclust(dist(x), method = 'complete')
hc.average <- hclust(dist(x), method = 'average')
hc.single <- hclust(dist(x), method = 'single')

cutree(hc, n)  # number of cluster to get

# correlation as distance: only makes sense with >= 3 features b/c absolute corr
# b/w two features and two observations is always 1
dd <- as.dist(1 - cor(t(x)))  
hc.complete <- hclust(dd, method = 'complete')