#================================================================================= 
# - list of packages in R
#=================================================================================

packages <- c(

#---------------------------------------------------------------------------------
# standard packages
"MASS",  # standard statistical package
"ElemStatLearn",  # functions and examples from "ESL"
"ISLR",  # functions and examples from "ISL"
"gcookbook",  # functions and examples from "R Graphics Cookbook"
"pryr",  # tools to pry in to R, used with "Advanced R Programming"

#---------------------------------------------------------------------------------
# data processing
"foreign",  # .dbf (read.dbf, read.spss)
"readr",  # alternative ways to load data
"xlsx",  # .xlsx (read.xlsx)
"gdata",  # .xls (read.xls)
"scales",  # allows for $, %, etc.
"lubridate",  # to allow easier parsing of dates
"xts",  #  uniform handling of different time-based data classes by extending zoo

#---------------------------------------------------------------------------------
# data manipulation
"magrittr",  # provides "pipe"-like operator
"plyr",  # splitting, applying and combining data
"data.table",
"dplyr",  # splitting, applying and combining data, replacing plyr
"reshape2",  # alternative to reshape(); convert data between wide & long
"tidyr",  # alternative to reshape2()
"broom",  # installation: "devtools); install_github("dgrtwo/broom")
"abind",  # combines arrays

#---------------------------------------------------------------------------------
# statistical methods

# helper
"caret",

# math
"expm",  # matrix exponential
"Matrix",  # matrix

# plot
"corrplot",  # correlation plot
"ROCR",  # # ROCR plot

# methods
"lasso2",  # the lasso
"leaps",  # function to find the regression subset
"class",  # classification
"boot",  # cross-validation and bootstrap
"pls",  # PRC
"glmnet",  # the lasso or elastic-net regularization path
# "spline",  # splines
"gam",  # generalized additive models
"tree",  # trees
"randomForest",  # bagging + random forest
"gbm",  # boosting
"e1071",  # SVM
"np",  # kernel smoothing / non-parametric regression
"PSCBS",  # circular binary segmentation, install the following before
# source("http://bioconductor.org/biocLite.R")
# biocLite("DNAcopy")
"nlme",  # generalized least square"
"bcp",  # bayesian changepoint model
"xgboost",  # optimized package for boosted (tree) algorithms

# distributions
"evd",  # extreme value distribution
"mnormt",  # multivariate t-distribution
"truncnorm",  # truncated normal distribution
"VGAM",  # Rayleigh distribution

# time series
"astsa",  # applied statistical time series analysis
"forecast",  # forecasting functions for time series & linear models

# bayesian
"bayesm",  # by Peter Rossi, from "Bayesian Statistics and Marketing"
"MCMCpack",  # a variant

# h2o
"h2o",  # h2o instance

#---------------------------------------------------------------------------------
# graphics

# framework
"ggplot2",  # ggplot2.org/book
"ggsubplot",  # facilitate embedded plots through ggplot2
"ggvis",  # web-interactive graphics, used with shiny: ggvis.rstudio.com
"shiny",  # web-application framework for R: shiny.rstudio.com
"shinythemes",  # themes for shiny
"shinydashboard",  # dashboards for shiny
"gridExtra",  # plot multiple ggplot2 plots in a grid
"dygraphs",  # htmlwidget for time series
"RColorBrewer",  # sensible colour schemes

# specific plots
"gplots",  # a variant
"igraph",  # network
"rgl",  # 3D graphics
"vcd",  # mosaic

# fonts
"extrafont",
# load fonts: loadfonts()
# import all fonts: font_import()
# list all the fonts: fonts()

#---------------------------------------------------------------------------------
# string manipulation
"stringr", 

#---------------------------------------------------------------------------------
# GIS
"maptools",  # reading and handling spatial objects

#---------------------------------------------------------------------------------
# markdown
# "pandoc
"knitr", 
"rmarkdown",  # rmarkdown.rstudio.com
"flexdashboard",  # http://rmarkdown.rstudio.com/flexdashboard/

#---------------------------------------------------------------------------------
# SQL
"DBI",
"RMySQL",
"RPostgreSQL",

#---------------------------------------------------------------------------------
# parallel
"parallel",
"multidplyr",

#---------------------------------------------------------------------------------
# package control
"packrat",

#---------------------------------------------------------------------------------
# package development
"devtools",
"roxygen2"

)

#================================================================================= 
# - installs all of above in R
#=================================================================================
# ipak function: check to see if packages are installed; Install them if they are 
# not, then load them into the R session

ipak <- function(pkg) {
	new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
	if (length(new.pkg)) 
		install.packages(new.pkg, dependencies = TRUE)
	sapply(pkg, require, character.only = TRUE)
}

ipak(packages)
