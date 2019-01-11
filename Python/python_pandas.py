#============================================================================== 
# [table of contents]
# - series
# - dataframe
#==============================================================================
# pandas: series (built on top of numpy arrays)
# implemented on top of numpy, so most functionalities carries over

import numpy as np
import pandas as pd
from pandas import Series, DataFrame

pd.options.display.max_rows = 20

# loading data: for more, PFDA pg171
# multiple index columns
df = pd.read_csv("file.csv", index_col = ["key1", "key2"])

# writing data
data.to_csv("file.csv")

# feather to R

#==============================================================================
# Series
# like (atomic) vectors in R; cross of list and dict

a = pd.Series([4, 7, -5, 3])
a.values
a.index

# named index
a = pd.Series([4, 7, -5, 3], index=["d", "b", "a", "c"])
a["a"]  # retrieve
a[["a", "b"]]  # retrieve a list
"b" in a  # True: works like dict
# reassign index 
a.index = ["dx", "bx", "ax", "cx"]  # in place
a.reindex(["dx", "bx", "ax", "cx", "fx"])  # creates a new object

# name and index.name attributes
a.name = "random list"
a.index.name = "alphabet"
a.rename(index = "alphabet")  # new series
a.rename(index = {"a": "z"})  # rename labels

# from dict
b = {"Ohio": 35000, "Texas": 71000, "Oregon": 16000, "Utah": 5000}
b_series = pd.Series(b)

# with missing value
c = {"California": None, "Texas": 71000, "Oregon": 16000, "Utah": 5000}
c_series = pd.Series(c)
c_series.isnull()
c_series.notnull()

# arithmetic operations: auto aligment (like a full join)
b_series + c_series  # California and Ohio will be NaN

# unique
d = pd.Series(['c', 'a', 'd', 'a', 'a', 'b', 'b', 'c', 'c'])
d.unique
d.value_counts()
d.is_unique

# vectorized membership
d.isin(["b", "c"])

# sort
a.sort_index()
a.sort_values()

# rank
a.rank(method = "first")

# slicing
a = pd.Series(np.arange(4.), index=['a', 'b', 'c', 'd'])
a[0:2]
a["a":"c"]  # slicing with labels is inclusive of end point

# transform with mapping
a = pd.Series(["bacon", "pulled pork", "bacon", "pastrami", "corned beef", 
               "bacon", "pastrami", "honey ham", "nova lox"])
a_b = {
    "bacon": "pig",
    "pulled pork": "pig",
    "pastrami": "cow",
    "corned beef": "cow",
    "honey ham": "pig",
    "nova lox": "salmon"
    }
a.map(a_b)

# replace: produces new Series
a.replace(["bacon", "nova lox"], ["pancetta", "lox"])
a.replace({"bacon": "pancetta", "nova lox": "lox"})

# discretize
a = [20, 22, 25, 27, 21, 23, 37, 31, 61, 45, 41, 32]
pd.cut(a, [18, 25, 65])
pd.cut(a, [18, 25, 65]).value_counts()  # counts
pd.qcut(a, 2)  # by quantiles

# sample
a = pd.Series(np.arange(10))
a.sample(10, replace = True)

# vectorized methods through str attribute (that skips NA values)
# PFDA2 pg217
a = pd.Series({"Dave": "dave@google.com", "Steve": "steve@gmail.com",
               "Rob": "rob@gmail.com", "Wes": np.nan})
a.str.contains("gmail")

#==============================================================================
# DataFrame
# 2D Series: a dict of Series sharing the same index

data = {"state": ["Ohio", "Ohio", "Ohio", "Nevada", "Nevada", "Nevada"],
        "year": [2000, 2001, 2002, 2001, 2002, 2003],
        "pop": [1.5, 1.7, 3.6, 2.4, 2.9, 3.2]}
df = pd.DataFrame(data)
df.head()  # first 5
df.tail()  # last 5
df.index.name = "number"
df.columns.name = "feature"

# access
df.columns
df["state"]  # series
df.values  # 2d ndarray
df.index  # index, which are immutable

# duplicates
df.duplicated()
df.drop_duplicates()

# new column
df["debt"] = 16.5  
df["debt"] = np.arange(6)  # length must match
df["debt"] = pd.Series([-1, 0, 1], index=[0, 3, 5])  # labels aligned
del df["debt"]  # deletes

# drop entries by index: returns new object
df.drop(0)  # row
df.drop("state", axis = 1)  # column
df.drop(0, inplace = True)  # in place

# set operations on Index (though pandas Index can contain duplicates)
# for more, see PFDA2 pg136
"year" in df.columns
1 in df.index

# sorting
df.sort_values(by = ["year", "pop"])

# indexing
# many ways; for more, PFDA2 pg144
df.reindex(index = [1, 2, 3, 4, 5, 6])  # creates a new object
df.reindex(columns = ["state", "year", "pop", "stuff"])  # by column
# more succinctly with label-indexing, using numpy-like notation
df.loc[[1, 2, 3, 6], ["state"]]  # by labels
df.iloc[:1, :1]  # by integers

# arithmetic operations: auto aligment by rows and columns
df1 = pd.DataFrame(np.arange(9.).reshape((3, 3)), columns=list('bcd'),
                   index=['Ohio', 'Texas', 'Colorado'])
df2 = pd.DataFrame(np.arange(12.).reshape((4, 3)), columns=list('bde'),
                   index=['Utah', 'Ohio', 'Texas', 'Oregon'])
df1 + df2
df1 + df2.loc["Ohio"]  # broadcasted down column
df1.add(df2.loc[:, "b"], axis = 0)  # broadcasted down row

# summary statistics
# for more, PFDA2 pg160
df1.describe()
df1.sum()
df1.mean()
df1.idxmax()  # index of max
df1.cumsum()

# applying functions
f = lambda x: x.max() - x.min()
df1.apply(f)  # by column
df1.apply(f, axis = 1)  # by row
# element wise
f = lambda x: "{0:.2f}".format(x)
df1.applymap(f)
# return multiple values
def f(x):
  return pd.Series([x.min(), x.max()], index = ["min", "max"])
df1.apply(f)

# correlation
pd.DataFrame(np.random.randn(100, 5)).corr()
pd.DataFrame(np.random.randn(100, 5)).cov()

# dummary variable
df3 = pd.DataFrame({"key": ["b", "b", "a", "c", "a", "b"], 
                    "data1": range(6)})
pd.get_dummies(df["key"])

# hierarchical indexing
df4 = pd.DataFrame(np.arange(12).reshape((4, 3)),
                   index=[["a", "a", "b", "b"], [1, 2, 1, 2]],
                   columns=[["Ohio", "Ohio", "Colorado"],
                            ["Green", "Red", "Green"]])
df4.index.names = ["key1", "key2"]
df4.columns.names = ["state", "color"]
df4.swaplevel("key1", "key2").sort_index()  # sort outermost level is faster
df4.sum(level = "key2")  # summary statistics by level
df4.reset_index()  # index to columns
df4.reset_index().set_index(["key1", "key2"], drop=False)  # back; keep column

# merge (if by index, use join)
df5 = pd.DataFrame({"key": ["a", "b", "d"], 
                    "data2": range(3)})
pd.merge(df3, df5, on = "key")  # inner join
pd.merge(df3, df5, on = "key", how = "outer")  # outer join

# binding
s1 = pd.Series([0, 1], index=['a', 'b'])
s2 = pd.Series([2, 3, 4], index=['c', 'd', 'e'])
s3 = pd.Series([5, 6], index=['f', 'g'])
s4 = pd.concat([s1, s3])
pd.concat([s1, s4], axis = 1)  # outer join
pd.concat([s1, s4], axis = 1, join = "inner")  # inner join

# wide <> long form
# pivot(): the same as set_index() then unstack(); can reset_index() after
# melt(): reverse
df4.stack()
df4.stack(0) # stack different level
df4.unstack()

#------------------------------------------------------------------------------
# split-apply-combine


