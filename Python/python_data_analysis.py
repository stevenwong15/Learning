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

# interacting with the os: PFDA2 pg60 for the list
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
# for more dtypes, PFDA2 pg91
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
b.T  # transpose; special case of np.swapaxes()

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
# broadcasting

a = np.array([[1, 2, 3], [4, 5, 6]])
b = np.array([1, 2, 3]).reshape(1, 3)  # good idea to reshape into matrix
c = np.array([1, 2]).reshape(2, 1)  # good idea to reshape into matrix

# good idea to reshape into matrix 
d = np.random.randn(1, 5)
e = np.random.randn(5, 1)

# cold be +, -, *, /
a + b  # duplicate b rowwise into a matrix before adding
a + c  # duplicate c colwise into a matrix before adding

#------------------------------------------------------------------------------
# linear algebra
# for more, PFDA2 pg117

a = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]])
np.dot(a.T, a)  # matrix multiplication
a.T @ a  # same

from numpy.linalg import inv, qr
b = np.random.randn(5, 5)
inv(b)  # inverse
q, r = qr(b)  # QR decomposition

#------------------------------------------------------------------------------
# ufunc (universal functions): fast element-wise array functions

a = np.arange(-5, 6)

# unary: for more, PFDA2 pg107
np.abs(a)
np.sqrt(a)
np.exp(a)

# binary: for more, PFDA2 pg107
np.add(a, a)
np.subtract(a, a)

# example: takes two 1d array and produces two 2d matrices
points = np.arange(-5, 5, 0.01)
xs, ys = np.meshgrid(points, points)
z = np.sqrt(xs ** 2 + ys ** 2)

# vectorized version of ternary expression
xarr = np.array([1.1, 1.2, 1.3, 1.4, 1.5])
yarr = np.array([2.1, 2.2, 2.3, 2.4, 2.5])
cond = np.array([True, False, True, True, False])
np.where(cond, xarr, yarr)
np.where(cond, 1, 0)  # 2nd and 3rd arg need not be array

# math: for more, PFDA2 pg112
a = np.random.randn(5, 4)
a.mean()
a.mean(axis = 0)  # by column
a.mean(axis = 1)  # by row
a.sum()
a.cumsum() 

# boolean
(a > 0).sum()
(a > 0).any()
(a > 0).all()

# sort: creates a copy
a_large = np.random.randn(1000)
a_large.sort()
a_large[int(0.05 * len(a_large))]  # 5th quantile

# set operations; for more, PFDA2 pg115 
a = np.array(["d", "a", "b", "c", "c", "d", "c"])
b = np.array(["d", "a", "e", "f", "g"])
np.unique(a)  # unique and sorted
np.intersect1d(a, b)  # intersect and sorted
np.union1d(a, b)  # union and sorted
np.in1d(a, b)  # boolean if a in b

#------------------------------------------------------------------------------
# random number generation
# faster than build in random because generate whole array
# for more, PFDA2 pg119

# set seed at the global set
np.random.seed(123)
np.random.normal(size=(4, 4))

# create a generator isolated from others
rng = np.random.RandomState(123)
rng.normal(size=(4, 4))
