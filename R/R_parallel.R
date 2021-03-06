#================================================================================= 
# [table of contents]
# 	- library(parallel)
# 	- library(multidplyr)
#=================================================================================

#=================================================================================
# library(parallel)
#=================================================================================
# https://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf
# parallel builds on the work in multicore and snow

# snow clusters (works everywhere where socket communication works)
# to find out how many cores are in the processor
detectCores()

#---------------------------------------------------------------------------------
# snow workflow:

# 1: fire up clusters
# 'PSOCK' = uses Rscript to launch further copies of R
# 'FORK' = forks the workers on the current host (i.e. current host R already has stuff)
cl <- makeCluster(8, 'PSOCK')  # using all 8 cores

# 2
# use one or more par[La, Sa, A]pply: parallel versions of [la, sa, a]pply
unlist(parLapply(cl, 1:10, sqrt))  # e.g.

# 3: free up clusters
stopCluster(cl) 

#---------------------------------------------------------------------------------
# multicore wokflow: 
# relies on forking 

unlist(mclapply(1:10, sqrt, mc.cores=4))  # using 4 cores

#=================================================================================
# library(multidplyr)
#=================================================================================
# https://github.com/hadley/multidplyr/blob/master/vignettes/multidplyr.md

# check run time with
systemtime({...})

# wrapper around parallel::makePSOCKcluster()
cluster <- create_cluster(8)
# if desired, set the cluster by default for partition
set_default_cluster(cluster)

# split datasets into clusters
by_grouping <- 
  dataset %>% 
  partition(grouping, cluster = cluster)
# load necessary library to each node:
cluster_library(by_grouping, 'library_name')

#---------------------------------------------------------------------------------
# current limitations
# - for optimal partitioning, each node needs to do a similar amount of work, so
#   it might be necessary to specifically create grouping variables 
# - necessary to load all the data in one instance, and then split; to split into
#   clusters from the get-go, do it by 'hand':

cluster <- create_cluster(4)
cluster_assign_each(cluster, "filename",
  list("a.csv", "b.csv", "c.csv", "d.csv")
)
cluster_assign_expr(cluster, "my_data", readr::read_csv(filename))

my_data <- src_cluster(cluster) %>% tbl("my_data")