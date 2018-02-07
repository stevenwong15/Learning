#================================================================================= 
# [table of contents]
# 	- data.table: library(data.table), faster version of data.frame
#   - comparisons with library(dplyr)
#=================================================================================

#=================================================================================
# data.table: library(data.table), faster version of data.frame
#=================================================================================
# can use library(dplyr) for data manipulation; data.table, for everything else
# - data.table can be faster: can use multiple verbs at the same time within []
# - data still needs to fit in memory
# - reference: https://github.com/Rdatatable/data.table/wiki/Getting-started
# - reference: http://brooksandrew.github.io/simpleblog/articles/advanced-data-table/

#---------------------------------------------------------------------------------
# basics:
# - columns of character are never converted to factors by default
# - idea: Take DT, subset rows using i, then calculate j, grouped by by
# - DT[i , j, by]: i = where; j = select/update; by = group by

flights <- fread('~/Downloads/flights14.csv')  # reads directly as a data.table
DT <- data.table(a = letters, b = 1:length(letters))  # create a data.table 
DT <- as.data.table(df)  # create a data.table from a data.frame

# faster version of read/write: library(fst) (www.fstpackage.org)
write.fs(DT, "DT.fst")
read.fst("DT.fst", as.data.table = TRUE)

# remove duplicate
flights[!duplicated(flights)]  # on every column
flights[!duplicated(air_time)]  # on specific column

# i = row slices: no need for '$' and ','
flights[1:2]  # first 2 rows
flights[origin == 'JFK' & month == 6L]

# mechanism same as with(), which treats columns as variables 
flights[flights$day == 1, ]  # data.frame (also works w/ data.table)
flights[with(flights, day == 1), ]  # data.table
flights[day == 1, with=TRUE]  # same: with=TRUE by default

# DT's order() uses '-' for desc and forder(), which is faster than base::order 
flights[order(origin, -dest)]  # order 'origin' in asc order, 'dest' in desc order
setorder(flights, origin, -dest)  # same, but by reference

# j = column slices: 
flights[, arr_delay] %>% head()  # output in array
flights[, list(arr_delay, dep_delay)]  # output in data.table
flights[, .(arr_delay, dep_delay)]  # same: .() is an alias for list()
flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]  # select and rename

# with=FALSE means not treating columns as variables
flights[, c('arr_delay', 'dep_delay'), with=FALSE]  # select
flights[, !c('arr_delay', 'dep_delay'), with=FALSE]  # select everything but
flights[, -c('arr_delay', 'dep_delay'), with=FALSE]  # same
flights[, year:month, with=FALSE]  # select inclusive
flights[, -(year:month), with=FALSE]  # select everything but

# compute on columns
flights[, sum(distance)]
flights[, sum((arr_delay + arr_delay) < 0)]  # conditional count
flights[, .N, by = .(is_arr_delay = arr_delay > 0)]  # conditional count

# update column names by reference
setnames(flights, 'year', 'Year')
# reorder columns by reference
setcolorder(flights, sort(names(flights)))

# i and j
# .N = length(column), since same length regardless of column 
flights[
  origin == 'JFK' & month == 6L,
  .(m_arr = mean(arr_delay), m_dep = mean(dep_delay), .N)
]
flights[.N]  # last row
flights[sample(.N, 4)]  # sample 4 rows

#---------------------------------------------------------------------------------
# aggregation: i, j and by

flights[, .N, by=origin]
flights[, .(.N, d=sum(distance)), by=.(origin, carrier)]  # >1 grouping variables
flights[, .(.N, d=sum(distance)), by=c('origin', 'carrier')]  # same

# keyby: order results by grouping variables, which become the keys
flights[
  carrier == 'AA',
  .(mean(arr_delay), mean(dep_delay)),
  keyby = .(origin, dest, month)
]

# chaining operations
flights[, .N, by=.(origin, dest)][order(origin, -dest)]  # one in asc; one, desc

# expressions in by
flights[, .N, .(carrier, dep_delay>0, arr_delay>0)]  # conditions

# compute on multiple columns
# .SD (subset of data) contains all the columns, except the grouping ones
# .SDcols specifies which subsets (if none, then all columns)
# since lapply returns a list, no need to wrap with .()
flights[, 
  lapply(.SD, mean), 
  by=.(origin, dest),
  .SDcols = c('arr_delay', 'dep_delay')
]

# slicing
flights[, head(.SD, 2), by=month]  # first 2 rows for each month
flights[flights[, .I[1:2], by=month]$V1]  # same, but can do more with .I[]
flights[, .SD[1:2], by=month]  # same
flights[, .SD[.N], by=month]  # last row
flights[, .SD[sample(.N, 10)], by=month]  # sample 10 for month

# unique
flights[, unique(.SD), .SDcols = "origin"]  # unique by a column
flights[, unique(.SD), .SDcols = "origin", by = "month"]  # same, but by group

# j is evaluated = can pretty much do everything (useful for debugging)
DT <- data.table(ID = c("b","b","b","a","a","c"), a = 1:6, b = 7:12, c = 13:18)
# gather a:c by ID
DT[, .(value = c(a, b, c)), by=ID]
# gather a:c by ID, as lists
DT[, .(value = list(c(a, b, c))), by=ID]
# printing
DT[, print(c(a, b, c)), by=ID]
DT[, print(list(c(a, b, c))), by=ID]

# .SD is essentially the same table: useful for nesting
data.table(mtcars)[, mean(mpg), by = .(cyl, gear)]
data.table(mtcars)[,  .SD[, mean(mpg), by = cyl], by = gear]  # same

# multiple expression
DT[, {print(a); plot(b, c)}]
# surpressing intermediate output
dt <- data.table(mtcars)
dt[, {
  tmp1 = mean(mpg); 
  tmp2 = mean(abs(mpg-tmp1)); 
  tmp3 = round(tmp2, 2);
  list(tmp2 = tmp2, tmp3 = tmp3)}, 
  by = cyl]
# same, but altering the table, and keeping form
dt[, 
  tmp1 := mean(mpg), by = cyl][,
  tmp2 := mean(abs(mpg-tmp1)), by = cyl][,
  tmp3 := round(tmp2, 2)][, 
  tmp1 := NULL]

# 

# shift (can add key and use by to do fast ordering/shifting by group)
dt <- data.table(mtcars)[,.(mpg, cyl)]
dt[, mpg_lag1 := shift(mpg, 1)]
dt[, mpg_forward1 := shift(mpg, 1, type = 'lead')]

#---------------------------------------------------------------------------------
# add, remove and modify subsets of columns, by reference (i.e. not copies)

# add
flights[, `:=`(speed = distance / (air_time/60), delay = arr_delay + dep_delay)]
# same as
flights[, c('speed', 'delay') := .(distance / (air_time/60), arr_delay + dep_delay)]

# conditional add 
flights[origin == "JFK", temp := 1]
# multiple conditions
flights[origin == "JFK", temp := 1][origin == "LGA", temp := 2][origin == "EWR", temp := 3]

# remove
flights[, c('delay') := NULL]
flights[, delay := NULL]  # same
flights[, `:=`(delay = NULL)]  # same

# modify by condition
flights[hour == 24L, hour := 0L]

# add summary statistics as a column
flights[, max_speed := max(speed), by=.(origin, dest)]

# add same summary statistics for multiple columns
in_cols <- c('dep_delay', 'arr_delay')
out_cols <- c('max_dep_delay', 'max_arr_delay')
# wrapping out_cols with c() or (), so that it is not read as another column
flights[, c(out_cols) := lapply(.SD, max), by=month, .SDcols=in_cols]

#---------------------------------------------------------------------------------
# when copies are needed

# since temp reference flights, changes in temp affect flights
flights <- fread('~/Downloads/flights14.csv')
temp <- flights
temp[, speed := distance / (air_time/60)]
flights  # speed added to flights 

# to avoid this, make a copy (deep/memory-based copy) 
flights <- fread('~/Downloads/flights14.csv')
temp <- copy(flights)  # in the future, this could be shallow/pointer-based copy
temp[, speed := distance / (air_time/60)]
flights  # speed not added to flights 

# important when using a function for DT:
# no assignment, and therefore does not follow regular R scoping/environment rules 
fn <- function(DT) {
  DT <- copy(DT)
  DT[, speed := distance / (air_time/60)]  # does not affect flights
  DT[, .(max_speed = max(speed)), by = month]
}
fn(flights)

# important when accessing column's names
DT <- data.table(x = 1L, y = 2L)
DT_n <- names(DT)  # x y
DT_n_c <- copy(names(DT))  # x y
DT[, z := 3L]
DT_n  # x y z
DT_n_c  # x y

#---------------------------------------------------------------------------------
# keys: supercharged rownames (data.table has no data.frame-like row names) 
# - set by reference, and reorders rows by keys, in increasing order
# - reordering = allows for the faster, binary search
# - no longer keys if the key columns are altered
# - group variables automatically become keys (like group_by() in dplyr)

# can also set directly with the key arguement in data.table()
setkey(flights, origin)  # good for interactive use
setkeyv(flights, 'origin')  # good for programming
key(flights)  # see the keys

# filter by key
flights[.('JFK')]
flights[J('JFK')]  # same
flights[list('JFK')]  # same
flights['JFK']  # same

# filter by >1 values
flights[.(c('JFK', 'LGA'))] 
flights[c('JFK', 'LGA')]  # same

# >1 keys: 1st key ordered 1st
setkey(flights, origin, dest)
setkeyv(flights, c('origin', 'dest'))  # same
key(flights)  # see the keys

# for each values of key, compute
flights[.('JFK', 'SFO'), .(mean(arr_delay), mean(dep_delay)), by=.EACHI]

# filter by >1 keys
flights[.('JFK', 'MIA')]  # JFK matched 1st, then MIA
flights[.('JFK')]  # only match 1st key
flights[.(unique(origin), 'MIA')]  # only match 2nd key
flights[.(c('JFK', 'LGA'), 'MIA')]  # match either for 1st key, 1 for 2nd key

# only the first/last matching rows
flights[.('JFK', 'MIA'), mult='first']  # first (arg could be last)
flights[.(c('JFK', 'LGA'), 'XNA'), mult='first', nomatch=0L]  # select if matched

# speed gain with keys
N <- 3e7L
DT <- data.table(
  x = sample(letters, N, TRUE),
  y = sample(1000L, N, TRUE),
  val = runif(N),
  key = c('x', 'y')
  )
print(object.size(DT), units='Mb')  # ~.5Gb
system.time(DT[x == 'g' & y == 500L])  # vector scan
system.time(DT[.('g', 500L)])  # binary search: much faster
# vector scan = goes through all the element, O(N)
# binary search = O(log N)

#---------------------------------------------------------------------------------
# filter 

# by group
# .I is an integer vector equal to seq_len(nrow(x))
DT[, .I[1], by = x]  # row number in DT corresponding to each group x
DT[DT[, .I[1], by = x]$V1]  # top 1 in each group 

# row number
DT[, .(seq_len(.N)), by = x]  # row number in DT to each element in each group x
DT[, .(rowid(x))]  # same

# .GRP is an integer, length 1, containing a simple group counter
DT[, grp := .GRP, by = x]

# by another table - like join
DT1[DT2, on = .(col1)]  # filter DT1 by values in DT2; like DT2 left join DT1
DT1[!DT2, on = .(col1)]  # filter DT1 by values NOIT in DT2
DT1[DT2, on = .(col1, val1>val2)]  # filter DT1 by values in DT2, and where val1>val2
DT1[DT2, on = .(col1), nomatch = 0L]  # same, but remove no match; like inner join
DT1[DT2, on = .(col1), mult = "first", nomatch = 0L]  # same, but show first match
DT1[DT2, on = .(col1), .(col1, val1, val2, i.val2)]  # return val2 from both DT1 and DT2
DT1[DT2, on = .(col1), val3 := val2*i.val2]  # given match, val3 = val2 of DT1 * val2 of DT2
DT1[DT2, on = .(col1), min(val1), by = .EACHI]  # min of each match type

#---------------------------------------------------------------------------------
# reshaping: library(data.table) uses an extension of library(reshape2)
# - variable as factors by default

DT <- flights[, .(year, month, day, origin, dest, dep_time, arr_time)]
setkey(DT, year, month, day, origin, dest)
DT <- DT[, .SD[1], by=.(year, month, day, origin, dest)]

# wide to long (gather)
melt(DT, 
  id.vars = c('year', 'month', 'day', 'origin', 'dest'),
  measure.vars = c('dep_time', 'arr_time'))
melt(DT, measure.vars = c('dep_time', 'arr_time'))  # no id.vars: assume rest 
# with changing varialbe and value names
melt(DT, measure.vars = c('dep_time', 'arr_time'),
  variable.name = 'type', value.name = 'hm')

# long to wide (spread)
DT.w <- melt(DT, measure.vars = c('dep_time', 'arr_time'),
  variable.name = 'type', value.name = 'hm')
dcast(DT.w, year + month + day + origin + dest ~ type, value.var = 'hm')

# long to wide with aggregate functions
dcast(DT.w, origin + dest ~ type, value.var = 'hm', 
  fun.agg = function(x) length(unique(x)))
# subset
dcast(DT.w, origin + dest ~ type, value.var = 'hm', 
  subset = .(dest %in% c('SFO', 'HNL')),
  fun.agg = function(x) length(unique(x)))
# >1 functions
a <- function(x) length(unique(x))
b <- function(x) sd(x)
dcast(DT.w, origin + dest ~ type, value.var = 'hm', fun=list(a, b))

# can gather multiple columns (with the same suffix) at the same time
colA <- paste('a', 1:3, sep='')
colB <- paste('b', 1:3, sep='')
DT <- data.table(letters[1:10], replicate(6, runif(10)))
colnames(DT) <- c('id', colA, colB)
melt(DT, measure=list(colA, colB), value.name=c('a', 'b'))
# use patters (regular expression) instead
melt(DT, measure=patterns('^a', '^b'), value.name=c('a', 'b'))

# can spread multiple columns (with the same suffix) at the same time
DT.w <- melt(DT, measure=patterns('^a', '^b'), value.name=c('a', 'b'))
dcast(DT.w, id ~ variable, value.var = c('a', 'b'))

#---------------------------------------------------------------------------------
# join

X <- data.table(X1=c(1L,2L),
  X2=LETTERS[1:4],
  X3=round(rnorm(8),4),
  X4=1:8,
  key=c('X1', 'X2'))
Y <- data.table(Y1=c(1L,2L),
  Y2=LETTERS[1:3],
  Y3=round(runif(6),4),
  key=c('Y1', 'Y2'))

# on shared keys
X[Y]  # X left outer on Y
X[Y, nomatch=0L]  # X left inner on Y
Y[X]  # Y right outer on X
Y[X, nomatch=0L]  # Y right inner on X

# data.table::merge()
# merged with shared keys; however, can override w/ by, by.x and by.y
merge(X, Y, by.x=c('X1', 'X2'), by.y=c('Y1', 'Y2'))  # inner
merge(X, Y, by.x=c('X1', 'X2'), by.y=c('Y1', 'Y2'), all=TRUE)  # outer
merge(X, Y, by.x=c('X1', 'X2'), by.y=c('Y1', 'Y2'), all.x=TRUE)  # left outer
merge(X, Y, by.x=c('X1', 'X2'), by.y=c('Y1', 'Y2'), all.y=TRUE)  # right outer

#=================================================================================
# comparisons with library(dplyr)
#=================================================================================

flights <- fread('~/Downloads/flights14.csv')
flights_df <- tbl_df(flights)  # data.frame

# data.frame w/ dplyr
system.time(
  flights_df %>%
  mutate(delay = arr_delay + dep_delay) %>%
  group_by(origin, carrier) %>%
  summarise(
    n = n(),
    delay_mean = mean(delay),
    delay_sd = sd(delay))
)

# data.table w/ dplyr
system.time(
  flights %>%
  mutate(delay = arr_delay + dep_delay) %>%
  group_by(origin, carrier) %>%
  summarise(
    n = n(),
    delay_mean = mean(delay),
    delay_sd = sd(delay))
)

# data.table
system.time(
  flights[, 
    delay := arr_delay + dep_delay
  ][,
    .(.N, delay_mean = mean(delay), delay_sd = sd(delay)), 
    by=.(origin, carrier)
  ]
)
