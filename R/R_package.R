#================================================================================= 
# [table of contents]
#   - structure
#   - /R
#   - DESCRIPTION
#=================================================================================
# http://r-pkgs.had.co.nz/
# https://cran.r-project.org/doc/manuals/R-exts.html#Creating-R-packages
install.packages(c("devtools", "roxygen2", "testthat", "knitr"))

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
# package structure

# naming: can only consist of letters, numbers and periods (i.e. no "-" or "_")
# needs, at a minimum: R/, DESCRIPTION, NAMESPACE

# create:
devtools::create("path/to/package/pkgname")
# .Rproj: text file on project options; double-click to open new RStudio session

# bundled package (.tar.gz): reduced to a single file (.tar) and compressed (.gz)
devtools::build()  # to bundle; should not need to do this
# includes (decompress a bundle):
# - vignettes build as HTML and PDF (instead of Markdown or LaTeX)
# - exclude temp files (such as those in src/)
# - exclude any files in .Rbuildignore
devtools::use_build_ignore("file")  # to add to .Rbuildignore (in regular expression)

# binary package: to distribute package to R user who doesn't have package dev tools
devtools:build(binary = TRUE)

# package installation
R CMD INSTALL  # install a source, bundle or binary package, from the command line
devtools::install()  # wrapper for R CMD INSTALL
devtools::build()  # wrapper for R CMD BUILD, turning packages into bundles
devtools::install_github()  # download from GitHub, build vignettes and installs
devtools::install_bitbucket()  # same, from bitbucket
install.packages()  # same, from CRAN

# library: directory containing installed packages
.libPaths()  # usuallly shows 2 path: 1) R-installed, 2) user-installed
lapply(.libPaths(), dir)

# loading a package from the library
# lifecycle: source -> bundle -> binary -> install -> in memory
library()  # goes through last steps (base as an example), from .libPaths()
devtools::load_all()  # goes through all the steps - do it to help test development
# roughly simulates what happens when a package is installed and loaded with library

# loading vs. attaching
library(devtools)  # loads
install()  # attaches

#=================================================================================
# /R
#=================================================================================

# .R script vs. package
# source(temp.R): code is executed and the results made immediately available
# library(package): when the package is built (e.g. by CRAN) all the code in R/
# is executed and the results saved; library() takes the cached results
# 
# therefore, in a package, never use:
# - library() or require(): modifies the search path, and thus what's available
# - source(): modifies current environment; instead, use devtools::load_all() to
# source all files in R/
# 
# therefore, also:
# - separate functions that prepare data, and create output (plots, etc.)
# - avoid relying on user's landscape (e.g. stringsAsFactors)

# reset old options, upon leaving
old <- options(stringsAsFactors = FALSE)
on.exit(options(old), add = TRUE)

# reset old directories, upon leaving
old <- setwd(tempdir())
on.exit(setwd(old), add = TRUE)

# to show message when packages loads
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to my package")
}

# to show message when package is attached
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to my package")
}

# to be called when package is loaded, for instance:
.onLoad <- function(libname, pkgname) {
  op <- options()
  op.devtools <- list(
    devtools.path = "~/R-dev",
    devtools.install.args = "",
    devtools.name = "Your name goes here",
    devtools.desc.author = '"First Last <first.last@example.com> [aut, cre]"',
    devtools.desc.license = "What license is it under?",
    devtools.desc.suggests = NULL,
    devtools.desc = list()
  )
  toset <- !(names(op.devtools) %in% names(op))
  if(any(toset)) options(op.devtools[toset])

  invisible()
}

#=================================================================================
# DESCRIPTION
#=================================================================================

library(roxygen2)

# 


# 