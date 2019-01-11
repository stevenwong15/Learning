#============================================================================== 
# [table of contents]
# - loading data
# - series
# - dataframe
#==============================================================================
# pandas: series (built on top of numpy arrays)
# implemented on top of numpy, so most functionalities carries over

import numpy as np
import pandas as pd
from pandas import Series, DataFrame

#==============================================================================
# loading data



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
pd.Series([1, 2, 3, 3]).is_unique

# sort
a.sort_index()
a.sort_values()

# rank
a.rank(method = "first")

# slicing
a = pd.Series(np.arange(4.), index=['a', 'b', 'c', 'd'])
a[0:2]
a["a":"c"]  # slicing with labels is inclusive of end point

#==============================================================================
# DataFrame
# 2D Series: a dict of Series sharing the same index

data = {"state": ["Ohio", "Ohio", "Ohio", "Nevada", "Nevada", "Nevada"],
        "year": [2000, 2001, 2002, 2001, 2002, 2003],
        "pop": [1.5, 1.7, 3.6, 2.4, 2.9, 3.2]}
df = pd.DataFrame(data)
df.head()  # first 5
df.index.name = "number"
df.columns.name = "feature"

# access
df.columns
df["state"]  # series
df.values  # 2d ndarray
df.index  # index, which are immutable

# new column
df["debt"] = 16.5  
df["debt"] = np.arange(6)  # length must match
df["debt"] = pd.Series([-1, 0, 1], index=[0, 3, 5])  # labels realigned (like a join)
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










# groupby()
data_df.groupby('column')
data_df.groupby('column', as_index=False)  # to retain grounping variable as a column
data_df.groupby(['col1', 'col2'])  # group by multiple columns
data_df.groupby('column').groups  # shows the groups
data_df.groupby('column').sum()  # sum by group

