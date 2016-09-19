#================================================================================= 
# [table of contents]
# 	- operating R
# 	- style
#	- math
#   - objects
#   - flow
#	- I/O
#=================================================================================

#=================================================================================
# operating R
#=================================================================================

#---------------------------------------------------------------------------------
# commands
cmd + shift + n  # new .r file
cmd + enter  # run line
cmd + shift + enter  # run entire script
esc  # exit current commands
cmd + c  # catches current run
cmd + opt + l  # clears consoles
ctrl + p  # reprints the previously ran code
;  # separates > 1 commands in one line: this is a bad habbit
ls -l /Library/Frameworks/R.framework/Versions/  # check in terminal the version of R

#----------------------------------------------------------------------w-----------
# workspace
ls()  # list of objects in directory
ls.str()  # list of objects in directory, with str() shown
dir()  # show files in current directory
rm(object)  # remove object 
rm(list = ls())  # remove all objects at once

# garbage collection
gc()

# terminal
system("open .")  # example of terminal command

# object size
format(object.size(df), units = 'Mb')

# working directory
getwd() 
setwd("~/filePath")  # set new directory, "~" meaning continue from before
q()  # quits the current R session

#---------------------------------------------------------------------------------
# packages
# - the most packages loaded package will take precedence, in the event of conflict
library(package)  # needs to specify packages everytime, same as require()
detach('package:name')  # detach package
library(help="package")  # to receive help on a specific function
install.packages("package")  # installs packages: cloest CRAN mirror is USA(CA1)
update.packages()  # to update packages
download.packages()  # to copmare versions, and update outdated packages on the fly
remove.packages()  
search()  # show all packages loaded
library()  # show all packages installed
citation("package")  # show the citation of the package
demo("TOPIC", "package")  # show demos of a package; use demo() for availabilities
example("TOPIC", "package")  # show examples of a package
vignette("TOPIC", "package")  # show vignettes of a package

# installed stuff
x <- installed.packages()
str(x)

# where packaegs are installed
.libPaths()

# available stuff
options(repose='https://cran.rstudio.com')
x <- available.packages()
dim(x)

#---------------------------------------------------------------------------------
# help
?TOPIC  # followed by a function to show help on the TOPIC
help(TOPIC)  # same as ?
help.search("TOPIC")  # search the help system, with all the TOPICs
apropos("TOPIC")  # list all the functions with the string "TOPIC" in it
methods(TOPIC)  # lists all the methods for a generic function / class
# websearch
RSiteSearch("TOPIC")  # search for key words in help pages, vignettes or task views

#---------------------------------------------------------------------------------
# assignment
<-  # for assignment (-> is the other way)
=  # for use inside brackets
<<-  # changes an existing variable in a parent.env() (if none, create one in globalenv())
# `name <<- value` is the same as `assign('name', value, inherits = TRUE)`

with(data, expression, ...)  # expression to evaluate
assign("x", value)  # value to be assigned to character string "x"
get("x")  # get the value of "x"

#---------------------------------------------------------------------------------
# display
options(digits = x)  # prints x number of digits
system.time()  # include in the bracket items you wish to time

#=================================================================================
# style
#=================================================================================
# summary:
# - avoid using "attach": sends the names of a data.frame to the working directory 
# - in functions, errors should be raised using stop()
# - avoid using S4 objects and methods, and never mix S3 and S4

#---------------------------------------------------------------------------------
# notation and naming
# file names:
# - file names should be meaningful, and never use names differentiated only by CAP
# - if files need to be run in sequence, prefix them with numbers:
# 0_download.R, 1_parse.R, 2_explore.R, etc.
# object names:
# - variable & function names should be lowercase, separated by "." or CAPs
# - variable names should be nouns; function names should be verbs

#---------------------------------------------------------------------------------
# syntax
# - always add space around operators, and after ","
# - "{"" should not be it's own line, but "}" should
# - place a space before (, unless it's a function
# - limit to 80 characters per line
# - indent with 2 spaces, instead of tab or a mixture of tabs and spaces
# - "<-", and not "=" for assignment
# - do not use ";"
# - use TRUE and FALSE, instead of T and F

#---------------------------------------------------------------------------------
# functions
# - only use return() for early returns
# - try to keep blocks within a function on one screen (i.e. 20-30 lines)
# - first list variables without default values, followed by those with
# - should contain a comments section immediately below the definition line, and
#   one that's descriptive enough renders reading the code unnecessary to know it 
# - Args: lists the function's arguments
# - Returns: lists the function's return value

#---------------------------------------------------------------------------------
# comments
# - comments should explain the why, not the what
# - use "-" and "=" to break your line into readable chucks
# - keep 2 spaces before "#" for short comments at the end of hte line

#=================================================================================
# math
#=================================================================================

#---------------------------------------------------------------------------------
# operation

x %% y  # return the remainder of the division x / y
x %/% y  # integer division of x / y
abs(x)  # absolute value
sign(x)  # sign of x
log(x,n)  # log of base n
exp(); log10(); log2(); sqrt()
sin(); cos(); tan(); acos(); asin(); atan(); atan2()
scale(x)  # center and scale
sweep(x, margin, value)  # return with the "value" (summary stats) sweeped out
choose(n,k)  # combination
combn(x, m)  # generates all the combination of elements in x, by size of m
factorial(x) 
round(x, n)  # round x to n decimals
signif(x, n) # retain n significant digits
floor(x / y)  # round down
ceiling(x / y)  # round up
trunc(x)  # return the integer portion of a numerical object
fft(x)  # fast fourier transform

# sweep() example: often used with apply
x <- matrix(rnorm(20, 0, 10), nrow=4)
sweep(x, 1, apply(x, 1, min), '-')  # subtract min of each row, from each row
#---------------------------------------------------------------------------------
# vector operation

rep(x, n)  # repeat x, n times
rep_len(x, n)  # repeat x, until the vector has a length of n
seq(l, h, by = increment)
seq(l, h, length = nValues)
seq_len(x)  # sequence of length x
seq_along(x)  # sequence of the length(x)

#---------------------------------------------------------------------------------
# matrix operation
%*%  # matrix multiplication
%o%  # outer product
outer(x, y, FUN = "*")  # outer product
%x%  # Kronecker product
%^%  # matrix nth power
solve(x)  # inverse
rcond(x)  # estimate the reciprocal of the condition number of x
eigen(x)  # compute the eigenvalues and eigenvectors
svd(x)  # compute the singular-value decomposition of x
svd(x)  # compute the QR decomposition of x
t(x)  # transpose
crossprod(x, y)  # slightly faster version of t(x) $*$ y
tcrossprod(x, y)  # slightly faster version of x $*$ t(y)
diag(x)  # diagonal
nrow(); ncol(); rowSums(); colSums(); rowMeans(); colMeans()

#---------------------------------------------------------------------------------
# charateristics 
mean(); median(); cor(); sd(); var()  # simple summarizing parameters
range(x)  # return low and high end
sum(x)  # return the sum of all elements in x
diff(x)  # return the difference between subsequent numbers in x
prod(x)  # return the product of all elemetns in x
cumsum(x)  # cumulative sum
cumprod(x)  # id. for product
cummin(x)  # id. for min
cummax(x)  # id. for max
pmin(x,y,...)  # ith element is the min of x[i], y[i], etc.
pmax(x,y,...)  # id. for max
rle(x)  # compute the lengths and values of runs of equal values in a vector

#---------------------------------------------------------------------------------
# condition
!=; ==; >; >=; <; <=;
all.equal(x, y, tolerance = 0)  # show the degree of approximate equality
identical(x, y)  # return true iff x and y are exactly equal
# apply De Morgan's laws:
# - !(X & Y) is the same as !X | !Y
# - !(X | Y) is the same as !X & !Y

# multiple comparison
&  # AND, for elementwise comparisons, returning a vector of TRUE or FALSE
|  # OR, for elementwise comparisons, returning a vector of TRUE or FALSE
xor(x, y)  # exclusive OR: x or y, but not x and y; x and y are logical vectors
# longer form is appropriate for programming control-flow (i.e. "if" clause)
&&  # AND, evaluate left to right, returning a single TRUE or FALSE
||  # AND, evaluate left to right, returning a single TRUE or FALSE

# function form
all(logicalArguement)  # if all is true
any(logicalArguement)  # if all is true
union(x, y)  # union of x and y
intersect(x, y)  # union of x and y
setdiff(x, y)  # return values that are different
setequal(x, y)  # return TRUE if they are equal
is.element(x, y)  # is identical to 
x %in% y  # id.
match(x, y)  # return the index in y, that match the value in x in the x index 
pmatch(x,table)  # partial match
which(logicalArguement)  # return the index of TRUE

#=================================================================================
# objects
#=================================================================================

#---------------------------------------------------------------------------------
# characteristics
(is, as).(character, numeric, logical, ...)  # lots of combo, too many to list all
is.na(x); is.null(x)
any(is.na(x))  # is at least one of them is true (i.e. missing?)?

# how many missing values in a data.frame
sapply(df, function(x)sum(is.na(x)))

#---------------------------------------------------------------------------------
# catagorical
factor(x)  # make x catagorical, instead of continuous
levels(x)  # get the catagories for the catagorical random variable
nlevels(x)  # get number of levels
reorder(x, X)  # order x (usually catagorical) by X (usually numerical)
relevel(x, ref = "factor")  # to move a reference factor to the front
droplevels(data)  # remove unused levels
gl(n,k,length=n*k,labels=1:n)  # generate k levels, repeated n times
interaction(x, y)  # return all combination of the levels in x and y

# remap/revalue catagorical data
revalue(data, c(field1 = "newname1", field2 = "newname2",...))  # or
mapvalues(data, c(field1,field2, ...), c("newname1", "newname2",...))  # or
levels(data)[levels(data) == field1] = "newname1"

# turns continuous variable to catagorical (and apply the labels)
cut(data, breaks = c(breakpt1, ...), labels = c(band1, ...))
findInterval(data, v)  # where v is a vector of interval breakpoints

#---------------------------------------------------------------------------------
# time series object
as.numeric(time(timeData))  # to get the time 
as.numeric(timeData)  # to get the data

#---------------------------------------------------------------------------------
# date
date()  # gives the currend date
as.Date("string", format = "formatecode")  # see below for format code
ISOdatetime(year, month, day, hour, min, sec, tz = "")  # date-times numeric rep
ISOdate(year, month, day, hour = 12, min = 0, sec = 0, tz = "GMT")
difftime(time1, time2, unit = c("auto", "secs", "mins", "hours", "days", "weeks"))

# formate code
# Code	Value
# %d	Day of the month (decimal number)
# %m	Month (decimal number)
# %b	Month (abbreviated)
# %B	Month (full name)
# %y	Year (2 digit)
# %Y	Year (4 digit)

# others to further understand at a later date, when they become more relevant:
# strftime, strptime, julian, months, quarters, weekdays
# library(libridate)

#=================================================================================
# flow
#=================================================================================
# cases
if () {
  # something
} else {
  # something else
}
ifelse(test, yes, no)
switch(variable,
	   case1 = ...,
	   case2 = ..., ...)

# loop
for () {
  break  # to short circuit
  next  # to halt current loop, and advance to next
}
while () {
  break  # to short circuit
  next  # to halt current loop, and advance to next
}

#=================================================================================
# I/O
#=================================================================================

#---------------------------------------------------------------------------------
# import
data(dataset)  # import a dataset within one of the packages
load("data.Rdata")  # load overrides any existing workspace if there're duplicates
readRDS(object, file = "Example.rds")  # reads a single object

# process dataset in another format
count.fields("~/dir/filename", sep = ",") # count the number of fields
read.table("http://...", header = T, sep = ",")  # table
read.csv("~/dir/filename", stringsAsFactors = F)  # to not convert strings to factors

#---------------------------------------------------------------------------------
# import: library(readr)
# allows for more changes / control in addition to reading

data_path <- tempfile(fileext = ".csv")
write_csv(mtcars, data_path)

read_csv(data_path)  # Read a csv file into a data frame
read_lines(data_path)  # Read lines into a vector
read_file(data_path)  # Read whole file into a single string

col_logical()  # [l], containing only T, F, TRUE or FALSE.
col_integer()  # [i], integers.
col_double()  # [d], doubles.
col_euro_double()  # [e], "Euro" doubles that use , as decimal separator.
col_character()  # [c], everything else.
col_date(format = "")  # [D]: Y-m-d dates.
col_datetime(format = "", tz = "UTC")  # [T]: ISO8601 date times

col_skip()  # [_], don't import this column.
col_datetime(date)  #, dates with given format.
col_datetime(format, tz)  #, date times with given format. 
# If the timezone is UTC, this is >20x faster than loading then parsing with strptime()
col_numeric()  # [n], a sloppy numeric parser that ignores everything apart from 0-9, 
# - and . (this is useful for parsing data formatted as currencies).
col_factor(levels, ordered)  #, parse a fixed set of known values into a factor

# example
read_csv("iris.csv", col_types = list(
  Sepal.Length = col_double(),
  Sepal.Width = col_double(),
  Petal.Length = col_double(),
  Petal.Width = col_double(),
  Species = col_factor(c("setosa", "versicolor", "virginica"))
))

#---------------------------------------------------------------------------------
# import: library(data.table)
# faster than readr, and automatically detects delimiter

fread(data_path, sep = 'auto')

#---------------------------------------------------------------------------------
# output
save(data, file = "Example.Rdata")  # save an object
save(list = ls(all=TRUE), file = "Workspace.Rdata")  # save the entire workspace
save.image(file = "Workspace.Rdata")  # id.
saveRDS(object, file = "Example.rds")  # save a single object

# process dataset into another format
write.table(data, file="Example.txt", sep = " ")  # default separator is space
write.csv(data, file="Example.csv")

# others to further understand at a later date, when they become more relevant: 
# readLines, writeLines, read.fwf, read.delim, write.delim
# library(foreign)