#================================================================================= 
# [table of contents]
# - Series
# - DataFrame
#=================================================================================
# pandas: series (built on top of numpy arrays)
# - implemented on top of numpy, so most functionalities carries over
# - series = a cross between a list and a dictionary
# - dataframe = 2D series
# from pandas import Series, DataFrame  # to local namespace if commonly used

import pandas as pd

#=================================================================================
# Series
# - unlike NumPy arrays, can use index to select from Series
# - automatically aligns differently-indexed data in arithmetic operations
# - like a fixed-length ordered dict; can use many functions expecting a dict

s = pd.Series([1, 2, 3, 4, 5])
s.describe()

# index preserved in NumPy array operations
data = pd.Series([1, 2, 3, 4, 5], index = ['a', 'b', 'c', 'd', 'e'])
data['a']  # to access
data.max()  # to get the max in the data
data.argmax()  # to get index associated with the max data
# if adding: adds by index

# works like a dict
'a' in data
'f' in data

# is something in the series?
data = {'Ohio': 35000, 'Texas': 71000, 'Oregon': 16000, 'Utah': 5000}
data = pd.Series(data)
states = ['California', 'Ohio', 'Oregon', 'Texas']
data = pd.Series(data, index=states)
pd.isnull(data)
pd.notnull(data)

data.name = 'population'  # Series name
data.index.name = 'state'  # index name

# apply()
s.apply(function)

# sort
data.sort_values()

# plots
data.hist()
data.plot()

#=================================================================================
# DataFrame
# - 2-d tabular format to represent higher-d data w/ hiearchical indexing
# - dict of series; under the hood: 1/more 2-d blocks 

#---------------------------------------------------------------------------------
# properties

# 2D dataframes where each column can be different types (as opposed to numpy's array)
data_df = pd.DataFrame(
    data=[[   0,    0,    2,    5,    0],
          [1478, 3877, 3674, 2328, 2539]],
    index=['05-01-11', '05-02-11'],
    columns=['R003', 'R004', 'R005', 'R006', 'R007']
)

# or, from a dic
data = {
  'state': ['Ohio', 'Ohio', 'Ohio', 'Nevada', 'Nevada'],
  'year': [2000, 2001, 2002, 2001, 2002],
  'pop': [1.5, 1.7, 3.6, 2.4, 2.9]
}
data_df = pd.DataFrame(data)

# access
data_df.columns  # column names
data_df.index  # row/index names
data_df.values  # to get all the values
data_df['state']  # column
data_df[['state', 'pop']]  # multiple columns
data_df.state  # column, another way
data_df.iloc[0]  # get element by row
data_df.iloc[0, 1]  # get element by position
data_df.loc[1]  # get element by row index (i.e. name of row)
data_df.loc[[0, 1], 'year']  # get element by index (i.e. name of row and column)

# columns modified by assignment (if array, length must match)
data_df['debt'] = 16.5
data = pd.Series([-1.2, -1.5, -1.7], index = [2, 4, 5])
data_df['debt'] = data  # match by index, if assigning a Series
del data_df['debt']  # to delete
data_df.drop(2001)  # to drop row
data_df.drop('Nevada', axis=1)  # to drop column

# nested dict of dicts, with outer dict keys are columns; inner, rows
pop = {
  'Nevada': {2001: 2.4, 2002: 2.9},
  'Ohio': {2000: 1.5, 2001: 1.7, 2002: 3.6}
}
data_df = pd.DataFrame(pop)
data_df.columns.name = 'state'  # column name
data_df.index.name = 'year'  # index name
# PFDA pg120 for other possible inputs to DataFrame constructor

# index object: immutable (cannot be modified by user)
# - functions like fixed-size set
index = data_df.index
2001 in data_df.index
'Ohio' in data_df.columns
# PFDA pg122 for index methods and properties

#---------------------------------------------------------------------------------
# essential functionality

# reindex (like factors in R)
data = pd.Series([4.5, 7.2, -5.3, 3.6], index=['d', 'b', 'a', 'c'])
data = data.reindex(['a', 'b', 'c', 'd', 'e'], fill_value=0)
# reindex with interpolation
data = pd.Series([4.5, 7.2, -5.3, 3.6], index=[0, 2, 4, 8])
data = data.reindex(range(6), method='ffill')  # fill value forward
data = data.reindex(range(6), method='bfill')  # fill value backward
# reindex columns
states = ['Nevada', 'Ohio', 'Texas']
data_df.reindex(columns=states)
# succiently and both at once
data_df.ix[[2000, 2001, 2002, 2003], states]
# PFDA pg124 for reindex function arguments

# selects rows or columns by index seemlessly
# pandas indexing is endpoint inclusive, and works well with booleans
data = pd.DataFrame(
  np.arange(16).reshape((4, 4)),
  index = ['Ohio', 'Colorado', 'Utah', 'New York'],
  columns = ['one', 'two', 'three', 'four']
  )
data['one']  # column
data['Ohio':'Utah']  # row
# syntatcially like an ndarray
data[data['three'] > 5]
data[data < 5] = 0
# PFDA pg128 for indexing options with DataFrame

# ix: back to slicing with NumPy-like notation
data.ix[['Colorado', 'New York'], ['two', 'three']]  # by index names
data.ix[1, 2]  # by index
data.ix[2]  # row by index
data.ix[:, 2]  # column by index








# drop 

data_df.mean(axis = 0)  # by column (along row)
data_df.mean(axis = 'rows')  # along row
data_df.mean(axis = 1)  # by row (along column)
data_df.mean(axis = 'columns')  # along column


# shift
data_df.shift(1)  # shift row index by 1 forwad

# loading files
data = pd.read_csv('filename.csv')
data.head()  # for the head
data.describe()  # for summary

# apply() vs. applymap() for df
data_df.apply()  # works on each column
data_df.applymap()  # works on each element

# df + s: adding series to dataframes 
# - matches df's column names by s's index names

# groupby()
data_df.groupby('column')
data_df.groupby('column', as_index=False)  # to retain grounping variable as a column
data_df.groupby(['col1', 'col2'])  # group by multiple columns
data_df.groupby('column').groups  # shows the groups
data_df.groupby('column').sum()  # sum by group

