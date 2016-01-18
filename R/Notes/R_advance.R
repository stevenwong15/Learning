#================================================================================= 
# [table of contents]
# 	- resources
#---------------------------------------------------------------------------------
# 	- data structures
# 	- subsetting
# 	- functions
# 	- OO field guide
# 	- environments
# 	- exceptions and debugging
#---------------------------------------------------------------------------------
# 	- functional programming
# 	- functionals
# 	- function operators
#---------------------------------------------------------------------------------
# 	- non-standard evaluation
# 	- expressions
# 	- domain specific languages
#---------------------------------------------------------------------------------
# 	- performance
# 	- profiling
# 	- memory
# 	- rcpp
# 	- R's C interface
#=================================================================================

#=================================================================================
# resources
#=================================================================================
# note that this .R file is meant to contain more theories and examples; for a
# list of functions, see other R_ files
# - Structure and Interpretation of Computer Programs: 
# http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-4.html#%_toc_start
# - Concepts, Techniques, and Models of Computer Programming
# - The Pragmatic Programmer: From Journeyman to Master
# - advanced r: http://adv-r.had.co.nz/
# - packages: http://r-pkgs.had.co.nz/

#=================================================================================
# data structures
#=================================================================================
# - homogeneous: atomic vector (1d), matrix (2d), array (nd)
# - heterogeneous: list (1d), data frame (2d)
str()  # the strutcure of the data & more
mode()  # the strutcure of the data (how R is storing it)
class()  # the object type of the data

#---------------------------------------------------------------------------------
# vectors
typeof()  # what it is
length()  # how many elements it contains
attributes()  # additional arbitrary metadata
is.atomic(x) || is.list(x)  # to test if an object is actually a vector
# specifically: is.character(), is.double(), is.integer(), is.logical()
# note that is.numeric() tests specifically for "numberliness": double or integer
is.vector()  # returns TRUE if vector has no attributes apart from names

# atomic vectors (in order from least to most flexible types)
# logical, integer, double (numeric), and character
c()  # creates atomic vector (short for "combine")
typeof()  # determine the type atomic vectors
# coercion often happens automatically (from least to most), but can be explicitly:
# with: as.character(), as.double, as.integer(), as.logical()
# e.g. c(list(1,2),c(3,4)) coerce the vectors into list before combining them
# missing values
NA  # will always be coerced into the types in c(); for specific types, use:
# NA_real_, NA_integer_ and NA_character

# list
list()  # create a list
# sometimes called recursive vectors, because they can contain other lists:
# e.g. x = list(list(list(list())))
# is.recursive(x) returns TRUE
is.list()  # tests if list
as.list()  # coerces into list
unlist()  # turn a list into an atomic vector (coerce list c() as needed)

#---------------------------------------------------------------------------------
# attributes (stores metadata about the object; a named list with unique names)
# attributes are lost modifying a vector, except: names, dimensions, and class
attr(x, "attribute_name")  # access attributes individually
attributes(x)  # access attributes all at once
structure(x, attribute="new_entry")  # returns a new object with changed attributes
# access the 3 important attributes with: names(x), class(x), and dim(x)

# names
# can be created in three ways:
x <- c(a=1, b=2, c=3)  # 1
x <- 1:3; names(x) = c("a", "b", "c")  # 2
x <- setNames(1:3, c("a", "b", "c"))  # 3
# remove names (note that not all elements need to have names, nor uuique names)
unname(x)  # 1
names(x) = NULL  # 2

# factors (a vector that can only contain predefined values; stores catagorical data)
# - the class() "factor" makes them behave differently from integer vectors
# - levels() defines the set of allowed values: NA generated if attempted
# NOTE: most data loading functions in R automatically convert character vectors 
# to factors; as such, you can either:
x <- read.csv(data, na.strings=".")  # specify what should be read as NA (eg. ".")
# or, coerce to character, and then to double
as.double(as.character(x))
# or, suppress the auto-convertion, and then manually convert the character vectors 
# to factors using knowledge of the dataset
x <- read.csv(data, stringsAsFactors = FALSE)
# NOTE: while factors may seem like strings, they are not, as such it's best to
# convert fators to strings before using string operations on them

#---------------------------------------------------------------------------------
# matrices (special case of arrays) and arrays
# - arrays in R are column-major order (i.e. go down a column, like a matrix)
matrix(values, ncol = x, nrow = y)  # is.matrix() to test; as.matrix() to change
# NOTE: data.matrix() is a combination of as.numeric() and as.matrix()
array(values, c(dim1, dim2,...))  # is.array() to test; as.array() to change
# while atomic vectors, matrices and arrays should behave similarly, they are 
# different (and this is noticed particularly in: tapply(), among others)

# modify dimensions (generalized from length() and names())
dim(x) <- c(dim1, dim2, ...)
length(x)  # returns the number of values
nrow(x); ncol(x); rownames(x); colnames(x)  # for matrices
dim(x); dimnames(x)  # for arrays
t()  # transpose for matrices
aperm(array, c(2, 3, 1))  # transpose for arrays: reorder the dimensions

# append (generalized from cucbind(); rbind()  # for matrices
abind()  # for arrays, in library(abind)

#---------------------------------------------------------------------------------
# data.frames (a list of equal-length columns: shares properties of matrix and list)
# - names() is the same as colnames()
# - length() is the same as ncol()
# NOTE: data.frame() turns strings into factors; we can suppress this behavior
data.frame(data, stringsAsFactors = FALSE)  # is.data.frame(); as.data.frame()

# append
cbind()  # the number of rows must match
rbind()  # the number AND the names of columns must match
# NOTE: cbind() creates a matrix, unless one part is already a data.frame
# so instead, use data.frame() directly to combine

#=================================================================================
# subsetting
#=================================================================================
# see R_dataorg.R for info on more up-to-date packages
# S3 objects
# S4 objects

#---------------------------------------------------------------------------------
# data types

# atomic vectors
x[c(index1, index2, ...)]  # positive (can repeat indexes)
x[c("name1", "name2", ...)]  # if vector is named, we can also call by name
x[-c(index1, index2, ...)]  # negative (excludes) (can't mix + and -)
x[c(T,F,...)]  # logical (recycles if shorter than vector)
x[]  # returns original vectors, matrices, data.frames, and arrays

# matrices and arrays
# can use a 2-col matrix to subset a matrix; 3-col, to subset a 3D array; etc.
select <- 
  matrix(ncol = 2, byrow = T,
         c(rownum1, colnum1,
           rownum2, colnum2,
           rownum3, colnum3,...))
matrix[select]  # to get the output

# data.frame
# matrix subsetting
data[c(rownum1, rownum2,...), ]  # select rows
data[, c(colnum1, colnum2,...)]  # select cols
data[, c(colname1, colname2,...)]  # select cols, returning matrix
data[c(colname1, colname2,...)]  # select cols, returning list

#---------------------------------------------------------------------------------
# subsetting operators
# [ gives the list
# [[ gives the contents of the list, but because it can return only a single value,
# it is used with either a single positive integer or a string; supplying a vector
# means indexing recursively:
l <- list(a = list(b = list(c = list(d = 1))))
l[[c("a","b","c","d")]]  # access recursively, same as: l[["a"]][["b"]][["c"]][["d"]]
# $ is a shorthand operator for [[, but it does partial matching

# simplifying = extracting the results
# vector:		x[[1]]
# list:			x[[1]]
# factor:		x[1:4, drop =T]
# array:		x[1,] or x[,1]
# data.frame:	x[,1] or x[[1]]
# perserving = keeping the results in the original form
# vector:		x[1]
# list:			x[1]
# factor:		x[1:4]
# array:		x[1, , drop=F] or x[,1, drop=F]
# data.frame:	x[,1, drop=F] or x[1]

# missing / out of bound (OOB) indices
# behavior varies: atomic vs. list, [ vs. [[

#---------------------------------------------------------------------------------
# subsetting and assigment
# subsetitng with nothing preserves the original object class and structure
data[] <- lapply(data, as.integer)  # returns the original data.frame
data <- lapply(data, as.integer)  # returns lists

#---------------------------------------------------------------------------------
# examples: (note that many of these have concise functions in other packages)

# lookup (character subsetting)
x <- c("m", "f", "u", "f", ...)  # a list of items to lookup
lookup <- c(m = "Male", f = "Female", u = NA)  # the data to lookup
unname(lookup[x])  # returns what's desired

# matching and merging by hand (integer subsetting)
# using match() (alternative is using rownames())
id <- match(searchValues, data$searchCol)
data[id,]

# random samples / bootstrap (integer subsetting)
data[sample(nrow(data)), ]  # order rows randomly
data[sample(nrow(data), n), ]  # select n random rows
data[sample(nrow(data), n, rep = T)]  # select n bootstrap replicates

# ordering (integer subsetting)
data[order(nrow(data$field)), ]  # order rows by field
data[, order(names(data))]  # order columns










#=================================================================================
# functions
#=================================================================================
# funcitons are objects in their own right; work with them the same way as objects
# library(pryr) allows user to pry into how R works; all R functions contain:
body()  # the code inside the function
formals()  # the list of arguments controlling how a function is called
environment()  # the "map" of the location of the function's variables
# NOTE: primitive functions do not contain the above components, but are generally
# more efficient, since they do not need to make copies

#---------------------------------------------------------------------------------
# function components

# '...' allows the users to add other components not explicitly specified
f <- function(x1, x2, ...) {
  # do something
  plot(x1, x2, ...)
}


#---------------------------------------------------------------------------------
# lexical scoping


#---------------------------------------------------------------------------------
# every operation is a function call


#---------------------------------------------------------------------------------
# function arguments


#---------------------------------------------------------------------------------
# special calls

#---------------------------------------------------------------------------------
# return values




source("filename")  # to load pre-existing functions

functionName <- function(input1, input2, … ) {
  # body of the function
  # note that "…" is an argument, to be filled when calling the function, 
  # and "…" is passed on to a function embedded within the function body
  if(missing(input1)) {
    # do something
    message("string")  # generate a diagnostic message
    warning("string")  # generate a warning message
  }
  return(something)  # (as a style) only use return for early returns
  invisible(something)  # useful when the function assigns (thus no need to print)
  on.exit("expression")  # expression given when function exits, or errs
}

#=================================================================================
# OO field guide
#=================================================================================

#=================================================================================
# environments
#=================================================================================

#=================================================================================
# exceptions and debugging
#=================================================================================


object_size(x)
