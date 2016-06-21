#================================================================================= 
# [table of contents]
# - basics
# - - jupyter notebook 
# - - i/o (unicodescsv)
# - - investigation
# - visualization
# - numpy (numerical python)
#=================================================================================

#=================================================================================
# basics

# Ipython encourages execute-explore workflor, instead of edit-compile-run
# - has tab completion (for magic, or "private" methods with _, start with _)
# - use ? before/after to display info about the object (?? for source, if possible)
# - * is wildcard (like command line)
# - moving cursor is the same as in command line
# - Ctrl + l to clear screen
Ipython --pylab # to run ipython from terminal, with matplotlib GUI 

# to run (Ctrl+c to stop program immediately)
%run ipython_script.py  # run in an empty namespace
%run -i ipython_script.py  # script can access vars already defined in namespace

# other magic commands: PFDA pg55 for the list
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

#---------------------------------------------------------------------------------
# jupyter notebook: https://ipython.org/

import IPython

# to run:
jupyter notebook notebook.ipynb
# to quit: ctrl + c
# to execute: shift + enter
# to delete cell: esc(until green) + dd

%matplotlib inline  # to cause plots to appear in notebook, rather than new window

#---------------------------------------------------------------------------------
# i/o

# read csv
import unicodecsv
# read all as strings; need to convert the data types after
with open('/path/file.csv', 'rb') as f:
	reader = unicodecsv.DictReader(f)
	data = list(reader)

# if you really want to write a function for this:
def read_csv(file):
	with open(file, 'rb') as f:
		reader = unicodecsv.DictReader(f)
		return list(reader)

#---------------------------------------------------------------------------------
# investigation

# number of rows
len(data)

# number of unique id (a 'set' is an unordered collection of unique elements)
unique_id = set()
for i in data:
	unique_id.add(i['feature'])

# create a dictionary w/ defaultdict, which returns empty (not error) for unknown key
from collections import defaultdict
dictionary = defaultdict(list)
for i in data:
  dictionary[i['key']].append(i)

#=================================================================================
# visualization

import matplotlib.pyplot as plt
plt.hist(data)

conda install seaborn
import seasborn as sns
data.plot()

#=================================================================================
# numpy: ndarray (n-dimensinoal array)
# - implemented in C, so much faster
# - array designed to hold one data types (but can take different ones)
# - can be multi-dimensional
# - can conduct vectorized operations (operate on blocks like scalar)
# - logical operations (only with booleans): &, |, ~
# - index arrays (i.e. array of True or False to index)
# - easy-to-use C API

import numpy as np

data = np.arange(15)

data.dtype  # get data type (maps to machine rep.; part of what makes numpy fast)
data.shape  # get dimension
data.ndim  # get # of dimensiosn

np.arange(15)  # array-valued version of range function
np.zeros(10)  # array of 10 0's
np.ones(10)  # array of 10 1's
np.ones((3, 4))  # array of 12 1's, in 3 by 4
np.empty  # empty array
np.empty((3, 4, 2))  # empty array (could be garbage)

np.ones_like(data)  # takes another array, and produces 1's array like it
np.zeros_like(data)  # same, for 0's
np.empty_like(data)  # same, for 0's
np.eye(10)  # or np.identity(10) NxN identity matrix

# PFDA pg83-84 for more dtypes
data_float = data.astype(np.float64)  # casts to another dtype
data_float.dtype

#---------------------------------------------------------------------------------
# indexing
# - array slices are views on the original array (data not copied) 
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

# slicing: numpy does fast slicing, by not creating a new copy
# thus when you alter the slice, the original array is also altered
a = np.array([1, 2, 3, 4, 5])
slice = a[:3]
slice[0] = 100
print(a)  # array([100, 2, 3, 4, 5])
# to actually make a copy
a_slice = a[1:3].copy()

# 2D arrays (as opposed to list of lists in Python)
# access information with a[x, y] (as opposed to a[x][y])
data = np.array([
    [   0,    0,    2,    5,    0],
    [1478, 3877, 3674, 2328, 2539]
])
data.mean()  # for the entire thing
data.mean(axis = 0)  # by column
data.mean(axis = 1)  # by row
# access data in a series
data[0, :]  # all in 1st row
data[:, 1]  # all in 1st col

# n-dimensional
data2d = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
data2d[1:, :2]
data2d[[0, 1]]  # select rows
data2d[[-0, -1]]  # select rows from bottem
data2d[[0, 1], [0, 1]]  # 2 sets of coordinates
data2d[[0, 1]][:, [0, 1]]  # to get the rectangle
data2d[np.ix_([0, 1], [0, 1])]  # another way to get the rectangle

# boolean indexing: always creates a copy of the data
data = data2d[data2d%2 == 1]
data[0] = 50
print(data2d)  # no change

# swapping axes
data2d.swapaxes(0, 1)
data2d.T  # transpose (special case of swapping axes)

#---------------------------------------------------------------------------------
# ufunc: universal functions = fast element-wise array functions
# PFDA pg96 for the list

# unary
np.sqrt(data2d)

# binary
np.add(data2d[1], data2d[2])

# example
points = np.arange(-5, 5, 0.01)
xs, ys = np.meshgrid(points, points)
z = np.sqrt(xs ** 2 + ys ** 2)

#---------------------------------------------------------------------------------
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

#---------------------------------------------------------------------------------
# linear algebra
# PFDA pg106, for the list
# from numpy.linalg import inv, qr  # to local namespace if commonly used

np.dot(data2d.T, data2d)  # matrix multiplication
np.linalg.inv(data2d)
q, r = np.linalg.qr(data2d)

#---------------------------------------------------------------------------------
# random numbers
# PFDA pg107, for the list

# example: random walk
nsteps = 1000
draws = np.random.randint(0, 2, size=nsteps)
steps = np.where(draws > 0, 1, -1)
walk = steps.cumsum()
