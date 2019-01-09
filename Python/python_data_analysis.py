#============================================================================== 
# [table of contents]
# - basics
# - numpy (numerical python)
#==============================================================================

#==============================================================================
# basics

# ipython encourages execute-explore workflow, instead of edit-compile-run
# - has tab completion (for magic, or "private" methods with _, start with _)
# - use ? before/after to display info about the object (?? for source, if possible)
# - * is wildcard (like command line)
# - moving cursor is the same as in command line
# - Ctrl + l to clear screen
ipython --pylab # to run ipython from terminal, with matplotlib GUI 

# to run (Ctrl+c to stop program immediately)
%run ipython_script.py  # run in an empty namespace
%run -i ipython_script.py  # script can access vars already defined in namespace

# to import script into a code cell
%load ipython_script.py

# paste text in the clipboard and executes as a single block in shell
%paste

# other magic commands
%quickref  # quick reference card
%magic  # detailed doc of all majic commands
%who  # display variables defined in interactive namespace
%who_ls  # w/ more information
%whos  # w/ even more information
%xdel variable  # delete variable
%reset  # delete all variable
%hist  # history of commands

# to return specific output/input
_  # for output
_1  # for output in line 1
_  # for input
_i1  # for input in line 1
exec _i1  # to execute again

# interacting with the os: PFDA pg60 for the list
%pwd  # current wd
%ls  # list in current wd
%cd  # navigate wd
!ls  # begin with ! to execute in system shell (in this case: list in current wd)

# sets up integration to create multiple plot windows 
%matplotlib 

#------------------------------------------------------------------------------
# jupyter notebook: https://ipython.org/

# to run:
jupyter notebook notebook.ipynb
# to quit: ctrl + c
# to execute: shift + enter
# to delete cell: esc(until green) + dd

# to cause plots to appear in notebook, rather than new window
%matplotlib inline

#==============================================================================
# numpy: ndarray (n-dimensinoal array) container for homogenenous large data
# - stores data in a contiguous block of memory, and uses much less memory
# - written in C, can operate on this memory without any overhead
# - can conduct complex vectorized operations; much faster than Python for loops

import numpy as np

data = np.array([6, 7.5, 8, 0, 1])
data.dtype  # get data type
data.shape  # get dimension
data.ndim  # get # of dimensiosn

# nested list becomes n-dimensional array
data = np.array([[1, 2, 3, 4], [5, 6, 7, 8]])
data.dtype
data.shape

np.arange(15)  # array-valued version of range function
np.zeros(10)  # array of 10 0's
np.ones(10)  # array of 10 1's
np.ones((3, 4))  # array of 12 1's, in 3 by 4
np.empty  # empty array
np.empty((3, 4, 2))  # empty array (could be garbage)
np.full((3, 4), fill_value = 5)  # array with fill arbitrary value

np.ones_like(data)  # takes another array, and produces 1's array like it
np.zeros_like(data)  # same, for 0's
np.empty_like(data)  # same, for 0's
np.full_like(data, fill_value = 5)  # same, for arbitrary value
np.eye(10)  # NxN identity matrix
np.identity(10)  # same

# casting always create a copy
# PFDA2 pg91 for more dtypes
data_float = data.astype(np.float64)  # casts to another dtype
data_float.dtype

#------------------------------------------------------------------------------
# arithmetic

a = np.array([[1, 2, 3], [4, 5, 6]], dtype = "float64")

# element-wise
a * a
a - a

# propagate scalar to each element
1/a
a ** 0.5

#------------------------------------------------------------------------------
# indexing and slicing

# array slices are views on the original array: data not copied
a = np.arange(10)
a_slice = a[5:8]
a[5:8] = 12
a_slice  # array([12, 12, 12]) because it's a view
a_slice[1] = 12345  # make changes to original array
a  # array([0, 1, 2, 3, 4, 12, 12345, 12, 8, 9]) 

# to copy
a[5:8].copy() 

# 2D arrays: rows, columns
b = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]])
b[1, 1]  # 5
b[0]  # all in 1st row
b[0, :]  # same
b[:, 1]  # all in 1st col

# fancy indexing: unlike slicing, always creates a copy
b[[1, 0]]  # select multiple rows in set order orders
b[[-0, -1]]  # select multiple rows from bottom
b[[0, 1], [0, 1]]  # [1, 5]

# reshape: returns a view without copying
b.reshape((3, 4)) 
b.T  # transpose

# condition
a = np.array(["a", "b", "c"])
b = np.array([1, 2, 3])
b[a == "a"]
b[a != "a"]
b[~(a == "a")]  # same
b[(a == "a") | (a == "b")]  # cannot use "or"
b[(a == "a") & (a == "b")]  # cannot use "and"
# boolean indexing always creates a copy of the data
c = b[a == "a"]
c[0] = 4
print(b)  # no change

#------------------------------------------------------------------------------
# linear algebra

b = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]])
np.dot(b.T, b)  # matrix multiplication

#------------------------------------------------------------------------------
# ufunc (universal functions): fast element-wise array functions

a = np.arange(10)

# unary
np.sqrt(a)

# binary
np.add(a[1], a[2])

# example
points = np.arange(-5, 5, 0.01)
xs, ys = np.meshgrid(points, points)
z = np.sqrt(xs ** 2 + ys ** 2)

b.mean()  # for the entire thing
b.mean(axis = 0)  # by column
b.mean(axis = 1)  # by row







np.linalg.inv(data2d)
q, r = np.linalg.qr(data2d)





# - making copies is slow, but this means keeping track of pointers

# += (operates in place)
a = np.array([1, 2, 3, 4])
b = a
a += np.array([1, 1, 1, 1])  # updates, so b still points to this
print(b)  # array([2, 3, 4, 5])

# + (much easier to track changes for vectorized operations)
a = np.array([1, 2, 3, 4])
b = a
a = a + np.array([1, 1, 1, 1])  # creates a new array
print(b)  # array([1, 2, 3, 4])






# swapping axes
data2d.swapaxes(0, 1)
data2d.T  # transpose (special case of swapping axes)

#------------------------------------------------------------------------------
# data processing
# PFDA pg101, for the list

# condition (faster than if/elif/else)
arr = np.random.randn(4, 4)
np.where(arr > 0, 2, arr)  # similar to R's ifelse(); could be nested of course

# boolean operations
bools = np.array([False, False, True, True])
bools.any()  # any true?
bools.all()  # all true?

# sort, by different axis
arr.sort(0)
arr.sort(1)

# sets
names = np.array(['Bob', 'Bob', 'Joe'])
np.unique(names)
values1 = np.array([6, 0, 0, 3, 2, 5, 6])
values2 = np.array([2, 3, 4])
np.in1d(values1, values2)  # contains
np.union1d(values1, values2)  # union (sorted and unique)
np.intersect1d(values1, values2)  # in both
np.setdiff1d(values1, values2)  # in values1, but not values2
np.setxor1d(values1, values2)  # in either, but not both

#------------------------------------------------------------------------------
# random numbers
# PFDA pg107, for the list

# example: random walk
nsteps = 1000
draws = np.random.randint(0, 2, size=nsteps)
steps = np.where(draws > 0, 1, -1)
walk = steps.cumsum()

















# #------------------------------------------------------------------------------
# # i/o

# # read csv
# import unicodecsv
# # read all as strings; need to convert the data types after
# with open('/path/file.csv', 'rb') as f:
# 	reader = unicodecsv.DictReader(f)
# 	data = list(reader)

# # if you really want to write a function for this:
# def read_csv(file):
# 	with open(file, 'rb') as f:
# 		reader = unicodecsv.DictReader(f)
# 		return list(reader)

# #------------------------------------------------------------------------------
# # investigation

# # number of rows
# len(data)

# # number of unique id (a 'set' is an unordered collection of unique elements)
# unique_id = set()
# for i in data:
# 	unique_id.add(i['feature'])

# # create a dictionary w/ defaultdict, which returns empty (not error) for unknown key
# from collections import defaultdict
# dictionary = defaultdict(list)
# for i in data:
#   dictionary[i['key']].append(i)

# #==============================================================================
# # visualization

# import matplotlib.pyplot as plt
# plt.hist(data)

# conda install seaborn
# import seasborn as sns
# data.plot()


