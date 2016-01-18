#================================================================================= 
# [table of contents]
# 	- setup
#=================================================================================

#=================================================================================
# setup
#=================================================================================

#---------------------------------------------------------------------------------
# The following two commands remove any previously installed H2O packages for R
if ("package:h2o" %in% search()) { detach("package:h2o", unload = TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download, install and initialize the H2O package for R.
install.packages("h2o", 
	             repos = (c("http://s3.amazonaws.com/h2o-release/h2o/master/1497/R", 
	             getOption("repos"))))
library(h2o)

#---------------------------------------------------------------------------------
# starting and ending an instance

# starts
localH2O <- h2o.init(ip = 'localhost', max_mem_size = '8g')
h2o.clusterInfo(localH2O)

pathToFolder <- '/users/swong/Documents/...'
data.hex <- h2o.importFile(localH2O, path = pathToFolder, key = 'data.hex')

DB.hex %>%
summary()

# shuts down
h2o.shutdown(localH2O)