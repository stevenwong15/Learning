#================================================================================= 
# [table of contents]
# 	- preloads essential libraries to the current directory
#      - standard packages
#      - data processing
#      - data manipulation
#      - statistical methods
#      - graphics
#      - string manipulation
#      - GIS
#      - markdown
#      - pack development
# 	- preloads essential functions to the current directory
#=================================================================================

#=================================================================================
# preloads essential libraries to the current directory
#=================================================================================

#---------------------------------------------------------------------------------
# terminal

# install: devtools::install_github("jalvesaq/colorout")
library(colorout)  # color for terminal

#---------------------------------------------------------------------------------
# standard packages
library(MASS)  # standard statistical package
library(ElemStatLearn)  # functions and examples from "ESL"
library(ISLR)  # functions and examples from "ISL"
library(gcookbook)  # functions and examples from "R Graphics Cookbook"
library(pryr)  # tools to pry in to R, used with "Advanced R Programming"

#---------------------------------------------------------------------------------
# data processing
library(foreign)  # .dbf (read.dbf, read.spss)
library(readr)  # alternative ways to load data
library(xlsx)  # .xlsx (read.xlsx)
library(gdata)  # .xls (read.xls)
library(scales)  # allows for $, %, etc.
library(lubridate)  # to allow easier parsing of dates
library(xts)  #  uniform handling of different time-based data classes by extending zoo

#---------------------------------------------------------------------------------
# data manipulation
library(magrittr)  # provides "pipe"-like operator
library(data.table)
# library(reshape2)  # alternative to reshape(); convert data between wide & long
library(tidyr)  # alternative to reshape2()
library(broom)  # installation: library(devtools); install_github("dgrtwo/broom")
library(abind)  # combines arrays
library(plyr)  # splitting, applying and combining data
library(dplyr)  # splitting, applying and combining data, replacing plyr

#---------------------------------------------------------------------------------
# statistical methods

# helper
library(caret)

# math
library(expm)  # matrix exponential
library(Matrix)  # matrix

# plot
library(corrplot)  # correlation plot
library(ROCR)  # # ROCR plot

# methods
library(lasso2)  # the lasso
library(leaps)  # function to find the regression subset
library(class)  # classification
library(boot)  # cross-validation and bootstrap
library(pls)  # PCR
library(glmnet)  # the lasso or elastic-net regularization path
# library(spline)  # splines
library(gam)  # generalized additive models
library(tree)  # trees
library(randomForest)  # bagging + random forest
library(gbm)  # boosting
library(e1071)  # SVM
library(np)  # kernel smoothing / non-parametric regression
library(PSCBS)  # circular binary segmentation, install the following before
# source("http://bioconductor.org/biocLite.R")
# biocLite("DNAcopy")
library(nlme)  # generalized least square
library(bcp)  # bayesian changepoint model
library(xgboost)  # optimized package for boosted (tree) algorithms

# distributions
library(evd)  # extreme value distribution
library(mnormt)  # multivariate t-distribution
library(truncnorm)  # truncated normal distribution
library(VGAM)  # Rayleigh distribution

# time series
library(astsa)  # applied statistical time series analysis
library(forecast)  # forecasting functions for time series & linear models

# bayesian
library(bayesm)  # by Peter Rossi, from "Bayesian Statistics and Marketing"
# library(MCMCpack)  # a variant

# h2o
library(h2o)  # h2o instance

#---------------------------------------------------------------------------------
# graphics

# framework
library(ggplot2)  # ggplot2.org/book
library(ggsubplot)  # facilitate embedded plots through ggplot2
library(ggvis)  # web-interactive graphics, used with shiny: ggvis.rstudio.com
library(shiny)  # web-application framework for R: shiny.rstudio.com
library(shinythemes)  # themes for shiny
library(shinydashboard)  # dashboards for shiny
library(gridExtra)  # plot multiple ggplot2 plots in a grid
library(dygraphs)  # htmlwidget for time series
library(RColorBrewer)  # sensible colour schemes

# specific plots
library(gplots)  # a variant
library(igraph)  # network
library(rgl)  # 3D graphics
library(vcd)  # mosaic

# fonts
library(extrafont)
# load fonts: loadfonts()
# import all fonts: font_import()
# list all the fonts: fonts()

#---------------------------------------------------------------------------------
# string manipulation
library(stringr)

#---------------------------------------------------------------------------------
# GIS
library(maptools)  # reading and handling spatial objects

#---------------------------------------------------------------------------------
# markdown
# library(pandoc)
library(knitr)
library(rmarkdown)  # rmarkdown.rstudio.com

#---------------------------------------------------------------------------------
# SQL
library('DBI')
library('RMySQL')

#---------------------------------------------------------------------------------
# parallel
library(parallel)
library(multidplyr)

#---------------------------------------------------------------------------------
# package control
library('packrat')

#---------------------------------------------------------------------------------
# package development
# library(devtools)
# library(roxygen2)

#=================================================================================
# preloads essential functions to the current directory
#=================================================================================
# setwd("~/Documents/Steven/Code/STATS/R")
setwd("~/Desktop/Data/R")
source("save_as.r")
source("ggplot2_theme.r")