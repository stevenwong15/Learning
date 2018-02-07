#================================================================================= 
# [table of contents]
# 	- base package
# 	- tidy: library(reshape2) => upgrade to library(tidyr)
# 	- tidy: library(tidyr)
#   - manipulation: library(plyr)
#   - data.frame manipulation: library(dplyr)
#   - factor: library(forcats)
#   - mapping: library(purrr)
#=================================================================================

#=================================================================================
# base package
#=================================================================================
# identify

str()  # the strutcure of the data & more
mode()  # the strutcure of the data (how R is storing it)
class()  # the object type of the data
View(data)  # allow you to view the entire dataset in a separate window
fix(data)  # changes particular entries of the data in a table view

#---------------------------------------------------------------------------------
# summarize
names(data)  # return the headers of the data
complete.cases(data)  # return a vector indicating which rows are missing data
summary(data)  # return a summary of data
table(data)  # return the number of different values of data
prop.table(x, margin)  # return entries as a fraction of the total along margin

# flat table
ftable(data, row.vars = ..., col.vars = ...)  # present n dim array as a flat table

#---------------------------------------------------------------------------------
# organize

# order
rev(x)  # reverse the elements of x
rank(x)  # gives the ranking of x, from lowest to highest
sort(data, decreasing = TRUE)
order(data$field1, data$field2, ...)  # order, by field1, then by field2, etc.

# combine
c(data1, data2, ...)  # combines all elements into on vector
stack(data)  # stack all columns to one
unstack(data)  # unstack a data, where data is a stack
expand.grid(field1 = x, field2 = y, ... )  # return all the combinations of input
split(x, f)  # where f is a list of catagories for grouping x

# create
xtabs(X ~ A + B, data)  # contingency table on X, by (marginal total of) A and B 
merge(a, b)  # merge two data by common columns or row names

# tidy (reshape from "long" to "wide" format, and back) => upgrade to library(tidyr)
# reshape(data, drop = "colToDrop", new.row.names = unique(data$col), 
# 		v.names = "vNames", timevar = "col", idvar = "row", direction = "wide")
# reshape(data, timevar = "col", times = names(data), varying = list(names(data)),
#         idvar = "row", ids = row.names(data), v.names = "vNames", direction = "long")

#---------------------------------------------------------------------------------
# extract
na.omit(x)  # suppress the observations with missing data (NA)
unique(x)  # return all the unique values in x
duplicated(x)  # return id on which elements of x are duplicates

# subset
head(data, n)  # show the top n rows
tail(data, n)  # show the bottom n rows
subset(data, condition, select = c(-field1, -field2))  # drops field1 and field2
sample(data, x, replace = TRUE)  # samples data of size x, with replacement

# location
which.max(x)  # index of the greatest element of vector x
which.min(x)  # index of the smallest element of vector x
which(x == "value")  # index of the value in vector x

#---------------------------------------------------------------------------------
# apply

# apply function to the margin of array or matrix
apply(X, margin, FUN = function)  # 1 = rowwise

# list
lapply(X, FUN = function)  # apply function to list X
sapply(X, FUN = function)  # same, but return a vector/matrix (i.e. simplify)
vapply(X, FUN = function, type)  # ibid, but tells R what the output looks like 
replicate(n, function)  # replicate a (random) function n times

# apply by catagory (index lists 1/+ groups, each of same length as X)
tapply(X, index, FUN = function)  # combines split() and sapply()
by(X, index, function)  # apply function to data.frame by index
aggregate(Y ~ X, data = data, FUN)  # apply function to Y by groups in X

#=================================================================================
# tidy: library(reshape2) => upgrade to library(tidyr)
#=================================================================================
# ID = row (ids), variable = column (values), value = inputs

# # "wide" to "long" (gather)
# melt(data, id.vars = c("row1", "row2"), measure.vars=c("value1","value2"), 
# 	 variable.name="name1", value.name="name2")

# # "long" to "wide" (spread); NOTE: unsack() also works
# dcast(data, id1 + id2 ~ row1 + row2, 
# 	  value.var = "value")

#=================================================================================
# tidy: library(tidyr)
#=================================================================================

# can remove with na.rm = TRUE while at it
gather(data, keyColName, valueColName, firstCol:lastCol) # "wide" to "long"
gather(data, keyColName, valueColName, -(firstCol:lastCol)) # all but said cols
spread(data, keyColName, valueColName)  # "long" to "wide"

# using regular expression to searpate/unit columns
extract(data, col, c("newColName1", ...), regex)  # extract groups into new cols
extract_numeric(stringWithNumbers)  # extract numeric component of a variable
separate(data, col, c("newColName1", ...), regex)  # turn single char to >1 cols
separate_row()  # similar, but separate into >1 rows
unite(data, newColName, col1, ..., sep = "_", remove = T)  # unite cols together

# handling missing values
df <- tibble(x = c(1, 2, NA), y = c("a", NA, "b"))
df %>% drop_na()
df %>% drop_na(x)
df %>% replace_na(list(x = 0))

# complete by combinations
df <- data_frame(
  group = c(1:2, 1),
  item_id = c(1:2, 2),
  item_name = c("a", "b", "b"),
  value1 = 1:3,
  value2 = 4:6
)
# takes a set of columns, and finds all unique combinations, ensures the original 
# dataset contains all those values, filling in explicit NAs where necessary.
df %>% complete(group, item_name)
# nesting() considers those inside as the same combination
df %>% complete(group, nesting(item_id, item_name))

# fill() carries last observations forward
treatment <- frame_data(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment %>% fill(person)

#=================================================================================
# manipulation: library(plyr)
#=================================================================================
# variations of __ply(): 
# a = array 
# l = list
# d = data.frame
# m = multiple inputs
# r = repeat multiple times
# _ = nothing (outputs discarded; useful for displaying plots, saving outputs, etc.)

# sample:
# ddply() = split data.frame by field(s), apply function, & return results as a d
# dlply() = split data.frame by field(s), apply function, & return results as a l
# ldply() = split list by field(s), apply function, and return results in a d

# examples:
# sum cumulatively field2, grouped by field1
ddply(data, "field1", transform, newColName = cumsum(field2))
# compute the means for field 3, grouped by (field1, field2)
ddply(data, c("field1","field2"), summarise, newColName = mean(field3))
# NOTE: .() allows usage without quotes: 
ddply(data, .(field1, field2), summarise, newColName=mean(field3))

#---------------------------------------------------------------------------------
# helper function:

arrange(data, col1, col2, ...)  # rearrange rows by specified columns

mutate(data, col1 = ..., newCol = ..., ...)  # altering columns

summarise(data, col1=..., newCol=..., ...) # same as mutate(), but creates new d
# example
ddply(data, "field1", summarise, newCol = function, ... )  # summarizes by field1

join(x, y, by = ..., type = ..., match = ...)  # capable of all types of SQL joins

match_df(x, y, on = ...) # join, but returns matching rows from x, with summary

colwise(function)  # operates on a vector into a function, for all columns
# examples:
# apply to all columns that are numerical, catagorical, etc.
ddply(data, .(col1, col2), colwise(function1, function2))
# same as ddply(data, .(col1, col2), colwise(function1, is.numeric))
ddply(data, .(col1, col2), numcolwise(function1)) 
# same as ddply(data, .(col1, col2), colwise(function1, is.discrete))
ddply(data, .(col1, col2), catcolwise(function1)) 

rename(data, replace = c(colname1 = colname2))  # replaces column names

round_any(x, accuracy = value, f = round)  # can be round, floor or ceiling

count(data, vars = "field1", wt_var = "field2")  # count by 1, weighted by 2

#=================================================================================
# data.frame manipulation: library(dplyr)
#=================================================================================
# focus on the verbs: filter(), select(), arrange(), mutate(), summarise()
# in general, the arguments are as follows: newdf = FUNC(data, arguments,...)
# with the "then" framework, we start with the data, and no longer repeat it
%>%  # then – works like this: data %>% toDoOnData() %>% toDoOnData() ...
# NOTE: 
# - for performance, filter first
# - one of the reasons that dplyr is fast is that it is very careful about when it 
#   makes copies of columns.

#---------------------------------------------------------------------------------
# organize
data_frame(data)  # garners the best practices of data.frame()
as_data_frame(data)  # ibid, for as.data.frame()

tbl_df(data)  # alternative way of organizing data.frame, showing less rows
arrange(data, field1, desc(field2), ...)  # reorder rows
# NOTE: arrange() is the most expensive operation here, being the only operation in
# dplyr that makes a copy; you'd want to avoid this, and use group_by() if possible
rename(data, fieldNewName = fieldOldName)  # rename the column

glimpse(data)  # information dense summary of tbl data

rowname_to_column()  # move rowname into a column
column_to_rowname()  # reverse
has_rowname()  # does the data.frame have rownames?
remove_rowname()  # remove rownames all together

# same as summarise_* counterparts
arrange_all()
arrange_at()
arrange_if()

#---------------------------------------------------------------------------------
# subset

# by rows
filter(data, field1 == value, condition2, ...)  # select rows
slice(data, rowStart:rowEnd)  # select rows by position: head(), tail(), etc.
distinct(data)  # returns distinct rows
sample_n(data, n)  # take a random sample of rows
sample_frac(data, frac)  # take a fixed fraction of rows
# uses filter & min_rank to select the top n entries in each group, ordered by wt
top_n(data, n, wt)  

# by columns
select(data, field1, specialCondition1, ...)  # select cols; to drop, use "-"
# special conditions:
starts_with("x", ignore.case = T)  # names starts with x
ends_with("x", ignore.case = T)  # names ends with x
contains("x", ignore.case = T)  # names contains x
matches("x", ignore.case = T)  # names matches regular expression x
num_range("x", 1:5, width = 2)  # select all from x01 to x05
one_of(var)  # select variables provided in a character vector, var
everything()  # all variables

# same as summarise_* counterparts
filter_all()
filter_at()
filter_if()
select_all()
select_at()
select_if()
rename_all()
rename_at()
rename_if()

#---------------------------------------------------------------------------------
# summarize
summarise(data, col1 = ..., newCol = ..., ...)  # same as in library(plyr)
# summarise() previously only gives one row summary, but it becomes much more 
# powerful when grouped by fields, summarise()-ing each group

summarise_all(func)  # applies to every column
summarise_at(c("var1", "var2"), func)  # applies to every column
summarise_if(is.numeric, func)  # applies to every column, if true

group_by(data, field1, field2, ...)  # direct other library(dplyr) to perform by group
# example:
data %>%
  group_by(field1) %>%
  summarise(average = mean(field2, na.rm = TRUE))  # average of field2 in said groups
# other useful helper functions with summarise()
n()  # number
n_distinct(field)  # number of distinct
first(field)  # first row
last(field)  # last row
nth(field, n)  # first nth rows

count(data, variable, wt)  # using n() to count, group_by() wt

# same as summarise_* counterparts
group_by_all()
group_by_at()
group_by_if()

#---------------------------------------------------------------------------------
# change
mutate(data, col1 = ..., newCol = ..., ...)  # same as mutate() in library(plyr)
# same as mutate(), returning listed cols only, and dropping original columns
transmute(data, col1 = ..., newCol = ..., ...)  

# same as summarise_* counterparts
mutate_all()
mutate_at()
mutate_if()
transmute_all()
transmute_at()
transmute_if()

# helpers that look at the entire set, instead of by row (window functions)
# ranking, with different ways of dealing with ties
row_number(x)  # same values taking consequetive ranks
min_rank(x)  # same values taking same ranks
dense_rank(x)  # same as min_rank(), with no gaps
percent_rank(x)  # a number between 0 and 1, computed by rescaling min_rank to [0,1]
cume_dist(x)  # cumulative distribution of rank number
ntile(x, n)  # breaks input into n bruckets, then rank
between(x, left, right)  # shortcut for x >= left & x <= right

# ordering, as a function
order_by(col1, function)

# difference in a time series (ordering, as an arguement)
lead(vector, n = 1, order_by = field1)  # offset values by 1 lead, order_by field1
lag(vector, n = 1, order_by = field1)  # offset value by 1 lag, order_by field1
# example:
mutate(x - lag(x), order_by = y)

# cumulation aggregates
cumsum()
cumprod()
cummean()  
cummax()
cummin()
cumany()
cumall()

# other helper
if_else()  # ifelse, but more strict
case_when()  # multiple if else statements

#---------------------------------------------------------------------------------
# join
inner_join(x, y, by = NULL)  # all rows from x with matching values in ; c('a' = 'b')
left_join(x, y, by = NULL)  # all rows from x
right_join(x, y, by = NULL)  # opposite
semi_join(x, y, by = NULL)  # inner_join(), keeping only x cols
anti_join(x, y, by = NULL)  # opposite of inner_join(), keeping only x cols
# NOTE: outer_join() and right_join() are not available in dplyr as of Nov 2014

intersect(y, z)  # row that appear in both y and z
union(y, z)  # rows that appear in either or oboth y and z
setdiff(y, z)  # rows that appear in y but not

bind_rows(y, z)  # append z to y as new rows
bind_rows(y, z, .id='source')  # append z to y as new rows, with new id
bind_cols(y, z)  # append z to y as new cols

#---------------------------------------------------------------------------------
# do: do arbitrary operations on a tbl - particularly useful working with groups
# NOTE: "." is used to represent the data in the pipeline, for functions that are
# note part of library(dplyr)

# example:
set.seed(100)
ds <- data_frame(
  group=c(rep("a",100), rep("b",100), rep("c",100)), 
  x=rnorm(n=300, mean=3, sd=2), y=rnorm(n=300, mean=2, sd=2))
my_fun <- function(x, y){
  res_x = mean(x) + 2
  res_y = mean(y) * 5 
  return(data.frame(res_x, res_y))
}
ds %>% group_by(group) %>% do(my_fun(x=.$x, y=.$y))

# example: buildling models by group (more elegant if created a f() like above)
models <- 
  data %>% 
  filter(...) %>%
  group_by(...) %>%  # rowwise() let's you group by 'everyrow' - i.e. do row ops
  do({
    ols.model <- lm(y ~ x, data = .)
    ols.pred <- predict(ols.model, newdata = data)
    beta0 <- coef(ols.model)[1]
    beta1 <- coef(ols.model)[2]
    data.frame(beta0, beta1)
  })

# extracting information for models run
summarise(models, rsq = summary(mod)$r.squared)
models %>% 
  do(data.frame(
    var = names(coef(.$mod)),
    coef(summary(.$mod)))
  )

#---------------------------------------------------------------------------------
# integration with MySQL: http://cran.r-project.org/web/packages/dplyr/index.html
# - look under vignettes: "Databases", and "Adding new database support to dplyr"
# - Generally, if your data fits in memory there is no advantage to putting it in 
# a database: it will only be slower and more hassle. The reason you'd want to use 
# dplyr with a database is because either your data is already in a database (and 
# you don't want to work with static csv files that someone else has dumped out for 
# you), or you have so much data that it does not fit in memory

# RMySQL
con <- dbConnect(RMySQL::MySQL(), user = 'root', password = 'pwd', dbname = 'db')
dbListTables(con)  # lists of tables in db
dbListFields(con, 'table')  # lists of fields in table

output <- dbSendQuery(con, 'select * from table limit 10')  # sends query
dbFetch(output)  # get output
dbClearResult(output)  # clear output

data <- dbReadTable(con, 'DB')  # transfer from MySQL to R
dbDisconnect(con)  # disconnect

# dplyr version, based on RMySQL
con <- src_mysql('db', user = 'root', password = 'pwd')
con  # lists of tables in db

tbl(con, sql('select * from table'))  # sends query
# possible dply operations (which are tend translated to SQL)
data <- tbl(con, 'tbl')  # creates a MySQL cache
# When working with databases, dplyr tries to be as lazy as possible:
# - It never pulls data back to R unless you explicitly ask for it.
# - It delays doing any work until the last possible minute, collecting together 
#   everything you want to do then sending that to the database in one step.
data %>% filter()
data %>% arrange()
data %>% mutate()
data %>% summarise()
# to see how dplyr converts R language to SQL:
query <- data %>% filter(...)
query$query  # the SQL query sent to MySQL
explain(query)  # more details
translate_sql(x == 1 && (y < 2 || z > 3))  # to see how SQL would translate a R code

# forces computation
data <- collect(query)  # pull data from MySQL to local R, as a tbl_df()
data <- compute(query)  # forces computation, but leaves data in the remote source
# doesn't force computation, but collapses a complex tbl into a form that 
# additional restrictions can be placed on.
data <- collapse(query)  

#---------------------------------------------------------------------------------
# data.frame structure: library(tibble)
# dplyr is more for data manipulation; data structure is moving to tibble

as_tibble(mtcars)

# column-wise
df <- tibble(x = 1:3, y = 3:1)
df %>% add_row(x = 0, y = 0, .before = 2)
df %>% add_column(z = -1:1, .after = "x")

# row-wise
df <- tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
df %>% .$x
df %>% .[["x"]]

#=================================================================================
# factor: library(forcats)
#=================================================================================
# for more information: http://r4ds.had.co.nz/factors.html

#=================================================================================
# factor: library(purrr)
#=================================================================================
# for more information: https://hadley.github.io/forcats/
# for more information: https://jennybc.github.io/purrr-tutorial/index.html

map()  # makes a list
map_lgl()  # makes a logical vector
map_int()  # makes an integer vector
map_dbl()  # makes a double vector
map_chr()  # makes a character vector

mtcars %>% map_dbl(mean)

