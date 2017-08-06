#================================================================================= 
# [table of contents]
#   - prinicples
#---------------------------------------------------------------------------------
# 	- data structures
#   - subsetting
# 	- functions
# 	- OO field guide
# 	- environments
# 	- exceptions and debugging
#---------------------------------------------------------------------------------
# 	- functions, expanded (functional programming in Advanced R)
# 	- functionals
# 	- function operators
#---------------------------------------------------------------------------------
# 	- non-standard evaluation (NSE)
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
# principles
#=================================================================================

#---------------------------------------------------------------------------------
# everything that exits is an object

str(c(1, 2, 3))  # an array is an object
class(c(1, 2, 3))
str(rnorm)  # as is a function – function definition object
class(rnorm)

# a function definition object has 3 parts:
formals(rnorm)
body(rnorm)
environment(rnorm)

# 1st way to change existing function
myFun <- rnorm  # assign a new object an existing function
# change the desired arguments 
args <- formals(myFun)
args[[i]] <- i_new  
formals(myFun) <- args

# 2nd way to change existing function
flist <- as.list(rnorm)  # assign a list vector an existing function 
flist[[i]] <- i_new  # change the desired elements
myFun <- as.function(flist, environment(rnorm)  # convert the list back to the function 
# the original function has an environment, which needs to be carried over

#---------------------------------------------------------------------------------
# everything that happens is a function call, which is also an object

fc <- quote(a <- c(1, 2, 3))  # fc is a function call, shown here as an object
class(fc)  # '<-' is a function
typeof(fc)  # a 'language' means a function call internally
`<-`(a, c(1, 2, 3))  # a function call, evaluated

# other examples
sapply(1:5, '+', 3)
sapply(list(1:3, 4:9, 10:12), '[', 2)
sapply(1:5, 'sum', 3)  # sapply also takes function's name, instead of the function

# changing the function call
fc[[1]]  # '<-'
fc[[2]]  # 'a'
fc[[3]]  # 'c(1, 2, 3)'
fc[[3]][[1]]  # the c() function
fc[[3]][[1]] <- quote(sum)  # change 1 to 5 (ca)
fc  # a <- sum(1, 2, 3)

#=================================================================================
# data structures
#=================================================================================
# - homogeneous: atomic vector (1d), matrix (2d), array (nd)
# - heterogeneous: list (1d), data frame (2d)
# - no 0d (scalar) types

str()  # the strutcure of the data & more
mode()  # the strutcure of the data (how R is storing it)
class()  # the object type of the data

#---------------------------------------------------------------------------------
# vectors

# 3 properties
typeof()  # what it is internally
length()  # how many elements it contains
length(x) <- n  # change the length of x to n
attributes()  # arbitrary metadata of x (even indicates class implementation)

is.atomic(x) || is.list(x)  # to test if an object is a vector (not as.vector())
# specific tests: is.character(), is.double(), is.integer(), is.logical()
# note is.numeric() tests for double OR integer

# atomic vectors (in order from least to most flexible types)
# logical, integer, double (numeric), and character; (rarer: complex, and raw)
c()  # creates atomic vector (short for "combine")
# coercion often happens automatically (from least to most flexible):
# e.g. c(list(1,2),c(3,4)) coerce the vectors into list before combining them
# can be explicit with: as.character(), as.double, as.integer(), as.logical()

# missing values
NA  # coerced into the various types in c(); fault type logical (least flexible)
# for specific types, use: NA_real_, NA_integer_ and NA_character_

# list
list()  # create a list
# sometimes called recursive vectors, because they can contain other lists:
# e.g. x = list(list(list(list()))); is.recursive(x) returns TRUE
is.list()  # tests if list
as.list()  # coerces into list
unlist()  # turn a list into an atomic vector, coercing list w/ c() if needed

#---------------------------------------------------------------------------------
# attributes: stores metadata about the object; a named list with unique names

attributes(x)  # access all attributes
attr(x, "attr_name")  # access attributes individually
structure(x, attr_name="new_entry")  # returns a new object w/ changed attributes

# attributes lost when modifying a vector, except: names, dimensions, and class
# access these attributes with: names(x), class(x), and dim(x); not attr(x, 'attr_name')

# names
# can be created in three ways:
x <- c(a=1, b=2, c=3)  # 1
x <- 1:3; names(x) = c("a", "b", "c")  # 2
x <- setNames(1:3, c("a", "b", "c"))  # 3
# remove names (note that not all elements need to have names, nor uique names):
x <- unname(x)  # 1
names(x) = NULL  # 2

# factors: a vector that can only contain predefined values (stores catagorical data)
# - the class() "factor" makes them behave differently from integer vectors
# - levels() defines the set of allowed values: NA generated if not in the levels
# - useful in subsetting, when a set do not have entries for a particular catagory

# NOTE: most data loading functions in R convert character vectors to factors
# 3 ways to bypass this:
as.double(as.character(x))  # read.csv, and coerce to character, then to double
x <- read.csv(data, na.strings=".")  # specify what should be read as NA (eg. ".")
x <- read.csv(data, stringsAsFactors = FALSE)  # or, suppress the auto-convertion

# NOTE: factors are not strings; factors are actually integers
# thus, best to convert to strings b/f using string operations

#---------------------------------------------------------------------------------
# matrices (2d arrays) and arrays (nd)
# - arrays in R are column-major order: indices go down by column
# - atomic vectors, 1d matrices and 1d arrays should behave similarly, but are 
# sometimes different – noticed particularly in: tapply()

matrix(values, ncol = x, nrow = y)  # is.matrix() to test; as.matrix() to change
# data.matrix() is a combination of as.numeric() and as.matrix()
array(values, c(dim1, dim2,...))  # is.array() to test; as.array() to change

# modify dimensions
length(x)  # returns the number of values
dim(x) <- c(dim1, dim2, ...)  # generalized from length() for arrays
nrow(x); ncol(x)  # generalized from length() for matrices

# change dimensions
t()  # transpose for matrices
aperm(matrix(1:10, c(2, 5)), c(2, 1))  # reorder the dimensions for arrays

# append
cbind(); rbind()  # generalized from c() for matrices
abind()  # generalized from c() for arrays, in library(abind)

# modify names
rownames(x); colnames(x)  # generalized from names() for matrices
dimnames(x)  # generalized from names() for arrays

#---------------------------------------------------------------------------------
# data.frames: a list of equal-length columns (shares properties of matrix and list)
# - names() is the same as colnames()
# - length() is the same as ncol()
# - list of lists, but most operations will assume it's list of vectors

# data.frame() turns strings into factors, but this behavior can be suppressed 
data.frame(data, stringsAsFactors = FALSE)  # is.data.frame(); as.data.frame()

# append
cbind()  # number of rows must match; creates matrix, unless one part is already a df
data.frame() # to directly combine 
rbind()  # number AND the names of columns must match

#=================================================================================
# subsetting
#=================================================================================
# see R_dataorg.R for subsetting with more up-to-date packages

#---------------------------------------------------------------------------------
# data types

# atomic vectors
x[c(index1, index2, ...)]  # positive (can repeat indexes)
x[c("name1", "name2", ...)]  # if vector is named, we can also call by name
x[-c(index1, index2, ...)]  # negative (excludes) (can't mix + and -)
x[c(TRUE, FALSE,...)]  # logical (recycles if shorter than vector)
x[]  # returns original vectors, matrices, data.frames, and arrays

# matrices and arrays
# can use a 2-col matrix to subset a matrix; 3-col, to subset a 3D array; etc.
select <- 
  matrix(ncol = 2, byrow = TRUE,
         c(rownum1, colnum1,
           rownum2, colnum2,
           rownum3, colnum3,...))
matrix[select]  # to get the output

# data.frame
# matrix subsetting
df[c(rownum1, rownum2,...), ]  # select rows
df[c(rownum1, rownum2,...)]  # select cols
df[, c(colnum1, colnum2,...)]  # select cols
df[, c(colname1, colname2,...)]  # select cols, returning matrix
df[c(colname1, colname2,...)]  # select cols, returning list

#---------------------------------------------------------------------------------
# subsetting operators

# [ returns the list
# [[ returns the list's content, via a single value (a positive integer or a string)
# supplying a vector means indexing recursively:
l <- list(a = list(b = list(c = list(d = 1))))
l[[c("a","b","c","d")]]  # access recursively, same as: l[["a"]][["b"]][["c"]][["d"]]

# x$y is a shorthand operator, and does partial matching: x[['y', exact=FALSE]]
var <- 'colname'
df$var  # does not work
df[[var]]  # works

# simplifying = extracting the results
# vector:		x[[1]]
# list:			x[[1]]
# factor:		x[1:4, drop=TRUE]
# array:		x[1,] or x[,1]
# data.frame:	x[,1] or x[[1]]

# perserving = keeping the results in the original form
# vector:		x[1]
# list:			x[1]
# factor:		x[1:4]
# array:		x[1, , drop=FALSE] or x[, 1, drop=FALSE]
# data.frame:	x[, 1, drop=FALSE] or x[1]

# missing / out of bound (OOB) indices
# behavior varies: atomic vs. list, [ vs. [[

#---------------------------------------------------------------------------------
# subsetting and assigment

# subsetitng with nothing preserves the original object class and structure
df[] <- lapply(df, as.integer)  # returns the original data.frame
df[1:i] <- lapply(df[1:i], as.integer)  # on a subset
df <- lapply(df, as.integer)  # returns lists

# with lists, can use NULL to remove/add components
x <- list(a = 1, b = 1)
x[['b']] <- NULL  # b dropped
x['b'] <- list(NULL)  # list of NULL added back

#---------------------------------------------------------------------------------
# examples: (many of these have more concise functions in other packages)
# - character subsetting
# - integer subsetting
# - logical subsetting

# lookup (character subsetting)
x <- c('m', 'f', 'u', 'f', ...)  # a list of items to lookup
lookup <- c(m = 'Male', f = 'Female', u = NA)  # the data to lookup
lookup[x]  # values
unname(lookup[x])  # values, w/t names

# removing columns from data frames (character subsetting)
df <- data.frame(x = c(2, 4, 1), y = c(9, 11, 6), n = c(3, 5, 1))
df$n <- NULL  # 1
df[setdiff(names(df), 'n')]  # 2

# matching and merging by hand (integer subsetting)
# using match(); alternative is using rownames()
index <- match(searchValues, df$searchCol)
df[index, ]
# to match multiple columns, first collapse them to a single column

# random samples / bootstrap (integer subsetting)
data[sample(nrow(data)), ]  # order rows randomly
data[sample(nrow(data), n), ]  # select n random rows
data[sample(nrow(data), n, rep=TRUE)]  # select n bootstrap replicates

# ordering (integer subsetting)
order(x, na.last = FALSE)  # NA at the front
order(x, na.last = NA)  # removing NAs
df[order(df$field), ]  # order rows by field
df[, order(names(df))]  # order columns by name

# expanding aggregated counts (integer subsetting)
df <- data.frame(x = c(2, 4, 1), y = c(9, 11, 6), n = c(3, 5, 1))
df[rep(1:nrow(df), df$n), ]  # repeat rows by the n value of that row

# selecting rows based on a condition (logical subsetting)
df[df$col == value, ]

# boolean algebra (logical subsetting) vs. sets (integer subsetting)
(x <- 1:10<4)  # () assigns and outputs
which(x)  # indexes: c(1:10)[which(x)] is redundant; use c(1:10)[1:10<4] instead
which.max(x)  # indexes of max: c(1:10)[which.max(x)] gets the largest TRUE
which.min(x)  # indexes of min: c(1:10)[which.min(x)] gets the smallest TRUE

#=================================================================================
# functions
#=================================================================================
# like everything in all, funcitons are also objects
# library(pryr) allows user to pry into how R works

# calling a function given a list of arguements: makes code dynamic (output to input) 
args <- list(1:10, na.rm=TRUE)
do.call(mean, args)
do.call('mean', args)  # same

# default arguements
f <- function(a=1, b=2) c(a, b)
f <- function(a=1, b=2*a) c(a, b)  # can be a function of another arguement
# can even be a function of a result: DO NOT DO this b/c hard to read
f <- function(a=1, b=d) {
  d <- 2*a
  c(a, b)  
}

# default arguements are evaluated inside the function
f <- function(x = ls()) {
  a <- 1
  x
}
f()  # local enviroment: a, x
f(ls())  # global enviroment

# missing arguements
f <- function(a, b) c(missing(a), missing(b))  # but hard to know which is required
# here, requirement is evident: a is required, but b is not
f <- function(a = NULL, b) {
  ifelse(is.na(a), 'need arguement', 'we are good')
}
f(a = 1)

# for not explicitly arguements, use '...' (but always better to be explicit)
# reading source code: find the parent code to understand what can go into '...' 
f <- function(x1, x2, ...) {
  # do something
  plot(x1, x2, ...)
}

# lazy evaluation: this should be an error, but not evaluated
x <- NULL
if (!is.null(x) && x > 0) {

}
# to force evaluation (same as function(x) x, but easier to read)
force(x)
# important in creating closures with lappy() or loop, but not longer needed in R3.2.0

# user-created inflix functions: comes between its arguments, and uses %
`%||%` <- function(a, b) if (!is.null(a)) a else b
NULL %||% 5  # 5
# built-in inflix operators w/t %
'+'(1, 5)  # same as 1 + 5

# replacement functions: `xxxx<-` changes value in place (actually makes a copy)
# this is why you can change names: names(x)[1] <- 'another_name'
`modify<-` <- function(x, position, value) {
  x[position] <- value
  x
}
x <- 1:10
modify(x, 1) <- 10  # 10  2  3  4  5  6  7  8  9 10
# behind the scence: x <- `modify<-`(x, 1, 10)
# so this is invalid: modify(get('x'), 1) <- 10

# return: function can only return 1 object; create a list if multiple
# use return() if returning early
f <- function(x, y) {
  if (!x) return(y)
  # complicated processing here
}
# () to force invisible value to be displayed
(x <- 1)
# make returned objects invisible
f <- function(x) invisible(x^2)

# on exit: usu to guarantee that changes to global state are restored
on.exit(setwd(old))  # perhaps to set dir back to old dir
# use add = TRUE if multiple on.exit() 

#---------------------------------------------------------------------------------
source("filename")  # to load pre-existing functions

functionName <- function(input1, input2, ...) {
  # body of the function
  # note that "..." is an argument, to be filled when calling the function, 
  # and "..." is passed on to a function embedded within the function body
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

environment()  # current environment
ls(all.names = TRUE)  # all objects, including those beginning with '.'
objects(.GlobalEnv, all.names=TRUE)  # same
ls.str()  # look at the structure

e <- new.env()  # creates a new environment
parent.env(e)  # e's parent environment
# good practice to set parent to empty, to not accidentially inherit from elsewhere
e <- new.env(parent = emptyenv())

# object's value of a particular environment
a <- 1
e$a <- 2  # same as assign('a', 2, envir=e), and e[['a']] <- 2  
e[['c']]  # same as get('a', envir = e)
rm('a', envir = e)  # remove the object
exists('a', envir = e, inherits = FALSE)  # to check existance w/t scoping parent

# comparing environments
identical(globalenv(), environment())

# looks for the environment of an object (recursively, which is natural for trees)
pryr::where('mean')

#=================================================================================
# exceptions and debugging
#=================================================================================

#=================================================================================
# functions, expanded
#=================================================================================

#---------------------------------------------------------------------------------
# anonymous functions

sapply(mtcars, function(x) length(unique(x)))

#---------------------------------------------------------------------------------
# closures

# this is also an example of a function factory (not much benefit here, though)
power <- function(exponent) {
  function(x) x ^ exponent
}

square <- power(2)
square(2)  # 4
# the function does not change, but the enclosing environment does
as.list(environment(square))  # exponent = 2
pryr::unenclose(square)  # function(x) x^2

cube <- power(3)
cube(2)  # 8
# the function does not change, but the enclosing environment does
as.list(environment(cube))  # exponent = 3
pryr::unenclose(cube)  # function(x) x^3

# <<- with closures = mutable state (might be similer to use referenc classes)
new_counter <- function() {
  i <- 0
  function() {
    i <<- i + 1
    i
  }
}
counter_1 <- new_counter()
counter_2 <- new_counter()
counter_1()  # 1
counter_1()  # 2
counter_2()  # 1, since counter_2()'s enclosed environment still has `i <- 0`

#---------------------------------------------------------------------------------
# list of functions

# e.g. 1
x <- 1:10
compute_mean <- list(
  base = function(x) mean(x),
  sum = function(x) sum(x) / length(x)
)

# individually
compute_mean$base(x)
compute_mean$sum(x)

# together
lapply(compute_mean, function(f) f(x))  # applied over the list of functions
# or
call_fun <- function(f, ...) f(...)
lapply(compute_mean, call_fun, x)

# e.g. 2: adding additional arguements
x <- 1:10
funs <- list(
  sum = sum,
  mean = mean,
  median = median
)
lapply(funs, function(f) f(x, na.rm = TRUE))  # na.rm

# e.g. 3: moving list to the global environment
simple_tag <- function(tag) {
  function(...) {
    paste0("<", tag, ">", paste0(...), "</", tag, ">")
  }
}
tags <- c("p", "b", "i")
html <- lapply(setNames(tags, tags), simple_tag)

html$p("This is ", html$b("bold"), " text.")
# or
with(html, p("This is ", b("bold"), " text."))

#---------------------------------------------------------------------------------
# example: function as an input

composite <- function(f, a, b, n = 10, rule) {
  points <- seq(a, b, length = n + 1)

  area <- 0
  for (i in seq_len(n)) {
    area <- area + rule(f, points[i], points[i + 1])
  }

  area
}

# 1st way
midpoint <- function(f, a, b) (b - a) * f((a + b) / 2)
trapezoid <- function(f, a, b) (b - a) / 2 * (f(a) + f(b))
composite(sin, 0, pi, n = 10, rule = midpoint)
composite(sin, 0, pi, n = 10, rule = trapezoid)

# 2nd way
types <- list(
  midpoint <- function(f, a, b) (b - a) * f((a + b) / 2),
  trapezoid <- function(f, a, b) (b - a) / 2 * (f(a) + f(b))
)
lapply(types, function(h) composite(sin, 0, pi, 10, h))

#=================================================================================
# functionals
#=================================================================================

# e.g. 1
randomise <- function(f) f(runif(1e3))
randomise(mean)
randomise(median)
randomise(sd)

# e.g. 2: 
lapply()

#---------------------------------------------------------------------------------
# looping functionals

# looping patterns
# over elements = for (x in xs)
# - natural to save via extending datastructure, which is slow (making copies)
# over numeric indices = for (x in seq_along(xs))
# over names = for (nm in names(xs))

# same patterns in lapply() form
xs <- runif(1e3)
lapply(xs, function(x) {xs})  # access via
lapply(seq_along(xs), function(i) {xs[i]})
lapply(names(xs), function(nm) {xs[nm]})

# e.g. models
formulas <- list(
  mpg ~ disp,
  mpg ~ I(1 / disp),
  mpg ~ disp + wt,
  mpg ~ I(1 / disp) + wt
)
lapply(formulas, lm, data = mtcars)

# e.g. data
bootstraps <- lapply(1:10, function(i) {
  rows <- sample(1:nrow(mtcars), rep = TRUE)
  mtcars[rows, ]
})
lapply(bootstraps, function(x) lm(mpg ~ disp, data=x))

# vapply(), needs output specs, is better for error handling
df <- data.frame(x = 1:10, y = Sys.time() + 1:10)
sapply(df, class)  # y is actually two classes 
vapply(df, class, character(1))  # error shown

# multiple inputs:
# Map(): when you have 2/+ lists or dfs to process in parallel
xs <- replicate(5, runif(10), simplify=FALSE)  # no simplify = in lists
ws <- replicate(5, rpois(10, 5) + 1, simplify= FALSE)
unlist(Map(weighted.mean, xs, ws))
# or: additing additional arguements
unlist(Map(function(x, w) weighted.mean(x, w, na.rm=TRUE), xs, ws))
# Map() = same as mapply() with simplify = FALSE

# Reduce(): recursively calling a function, two arguements at a time
# first 2 arguements, then the result and the next arguement, and so on
# e.g. find the intersect of all 5 lists
l <- replicate(5, sample(1:10, 20, replace=TRUE), simplify=FALSE)
Reduce(intersect, l)  # intersect only looks at two lists at a time

# predicate = returns TRUE or FALSE 
df <- data.frame(x = 1:3, y = letters[1:3], z = letters[26-c(0:2)])
Filter(is.factor, df)  # select elements that match the predicate
Find(is.factor, df)  # returns the 1st element that match the predicate
Position(is.factor, df)  # returns the position of the result of Find()

#---------------------------------------------------------------------------------
# example: MLE

# poisson negative log likelihood in the closure
# having a closure allows precompute of values that are constant wrt the data
poisson_nll <- function(x) {
  n <- length(x)
  sum_x <- sum(x)
  function(lambda) {
    n * lambda - sum_x * log(lambda) # + terms not involving lambda
  }
}

x <- c(41, 30, 31, 38, 29, 24, 30, 29, 31, 38)  # data
nll <- poisson_nll(x)  # function to optimize
optimise(nll, c(0, 100))$minimum  # optim() is a generlization of optimise()

#---------------------------------------------------------------------------------
# example: adding

# removes NA
rm_na <- function(x, y, identity) {
  if (is.na(x) && is.na(y)) {
    identity
  } else if (is.na(x)) {
    y
  } else {
    x
  }
}

# adds pairs
add <- function(x, y, na.rm = FALSE) {
  if (na.rm && (is.na(x) || is.na(y))) rm_na(x, y, 0) else x + y
}

# sums lists
r_add <- function(xs, na.rm = TRUE) {
  Reduce(function(x, y) add(x, y, na.rm = na.rm), xs, init = 0)
}

# vectorized adding two lists
# with Map
v_add1 <- function(x, y, na.rm = FALSE) {
  stopifnot(length(x) == length(y), is.numeric(x), is.numeric(y))
  if (length(x) == 0) 
    return(numeric())
    simplify2array(Map(function(x, y) add(x, y, na.rm = na.rm), x, y))
}
# with vapply
v_add2 <- function(x, y, na.rm = FALSE) {
  stopifnot(length(x) == length(y), is.numeric(x), is.numeric(y))
  vapply(seq_along(x), function(i) add(x[i], y[i], na.rm = na.rm), numeric(1))
}

#=================================================================================
# function operators
#=================================================================================




#=================================================================================
# non-standard evaluation (NSE)
#=================================================================================
# library(dplyr) uses NSE in all important single table verbs
# - difference b/w SE and NSE is quoting of input variables 
# - NSE = good for interaction (reduce typing), but not for programming (functions)

# 3 ways to quote inputs that dplyr understands:
# - With a formula, summarise_(mtcars, ~mean(mpg))
# - With quote(), summarise_(mtcars, quote(mean(mpg)))
# - As a string: summarise_(mtcars, "mean(mpg)")
# best to use a formula b/c captures (1) expressive to eval, and (2) environment

# pass variable names
n <- 10
dots <- list(~mean(mpg), ~n)
summarise_(mtcars, .dots = dots)
# with names
summarise_(mtcars, .dots = setNames(dots, c("mean", "count")))

# mix constants and varibles (assign the following dots, as shown above)
lazyeval::interp(~ x + y, x = 10)
lazyeval::interp(~ x + y, .values = list(x = 10, y = 11))
lazyeval::interp(~ mean(x), x = as.name("mpg"))
lazyeval::interp(~ mean(x), x = quote(mpg))  # same as above

# changing function names
lazyeval::interp(~ f(a, b), f = quote(mean))

# using values in the current environment
x <- 10
y <- 11
lazyeval::interp(~ x + y, .values = environment())

# example
hist_plot <- function(x_input) {
  
  varname <- list(c('x_var'))
  vareval <- list(lazyeval::interp(~log(x), x = as.name(x_input)))

  df %>%
    mutate_(.dots = setNames(vareval, varname)) %>%
    ggplot(aes(x = x_var)) +
    geom_histogram(binwidth = 0.5)

}
hist_plot('x_input')
