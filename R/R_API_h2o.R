#================================================================================= 
# [table of contents]
# 	- setup
#=================================================================================
# http://h2o-release.s3.amazonaws.com/h2o/rel-wheeler/2/docs-website/h2o-docs/booklets/RBooklet.pdf

#=================================================================================
# setup
#=================================================================================

# The following two commands remove any previously installed H2O packages for R
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Now we download, install and initialize the H2O package for R.
install.packages("h2o")

# Finally, let's load H2O and start up an H2O cluster
library(h2o)

#---------------------------------------------------------------------------------
# starting and ending an instance

# start
h2o.init(nthreads = -1, max_mem_size = "4g")
h2o.clusterInfo()  # cluster information

# 1) from file to h2o object
pathToFolder <- '/users/swong/Documents/...'
data.hex <- h2o.importFile(localH2O, path = pathToFolder, key = 'data.hex')

DB.hex %>%
summary()

# 1) from R object to h2o object

# shuts down
h2o.shutdown()

