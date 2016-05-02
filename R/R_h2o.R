#================================================================================= 
# [table of contents]
# 	- setup
#=================================================================================
# http://www.h2o.ai/product/integration/

#=================================================================================
# setup
#=================================================================================

#---------------------------------------------------------------------------------
# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
    if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-tukey/4/R")))
library(h2o)

#---------------------------------------------------------------------------------
# starting and ending an instance

# workflow
# starts
localH2O <- h2o.init(nthreads = -1)
# cluster information
h2o.clusterInfo()

# 1) from file to h2o object
pathToFolder <- '/users/swong/Documents/...'
data.hex <- h2o.importFile(localH2O, path = pathToFolder, key = 'data.hex')

DB.hex %>%
summary()

# 1) from R object to h2o object

# shuts down
h2o.shutdown()