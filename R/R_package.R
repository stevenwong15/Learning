#================================================================================= 
# [table of contents]
#   - structure
#   - /R
#   - DESCRIPTION
#=================================================================================
# http://r-pkgs.had.co.nz/
# https://cran.r-project.org/doc/manuals/R-exts.html#Creating-R-packages

#=================================================================================
# structure
#=================================================================================
# /R
# - .R files (cannot have subdirectories)
# /data
# - any processed data, .RData form
# /inst/extdata
# - any raw data
# DESCRIPTION
# - what your package needs to work, what it does, etc.
# NAMESPACE
# - what functions it requires from other packages, and vice versa
# /vignettes
# - great for analysis and reporting, in addition to documenting packages

#---------------------------------------------------------------------------------
# bascis

# library
# - directory containing installed packages
.libPaths()  # shows 2 path: 1) R-installed, 2) user-installed
lapply(.libPaths(), dir)

# source -> bundle -> binary -> install -> in memory
library(ggplot2)  # goes through last 2 steps (base as an example)
devtools::load_all()  # goes through all the steps - helps development
# roughly simulates what happens when a package is installed and loaded with library

# example:
library(devtools)
create("eda")  # creates package in the current directory

#=================================================================================
# /R
#=================================================================================
# .R script vs. package
# source(temp.R): code is run when it's loaded
# library(package): code is run when it's built, not when it's loaded
# in a package:
# - never use library() or require(): modify the search path
# - never use source(): modifies current environment

# reset old options, upon leaving
old <- options(stringsAsFactors = FALSE)
on.exit(options(old), add = TRUE)

# reset old directories, upon leaving
old <- setwd(tempdir())
on.exit(setwd(old), add = TRUE)

# separate functions that prepare data, and create output (plots, etc.)

#=================================================================================
# DESCRIPTION
#=================================================================================

library(roxygen2)

# 


# install.packages(c("devtools", "roxygen2", "testthat", "knitr"))