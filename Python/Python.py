#================================================================================= 
# [table of contents]
# - installation
# - basics
# - string
# - conditions
# - functions
# - data types
# - loops
# - classes
# - I/O
# - bitwise operators
#=================================================================================

#=================================================================================
# installation

# install python3: python.org
# install Anaconda (contains all the popular packages): continuum.io/downloads
# to update:
conda update conda
conda update anaconda

# reference
"https://google.github.io/styleguide/pyguide.html"  # google python style guide
"http://damnwidget.github.io/anaconda"  # Anaconda Python IDE

#=================================================================================
# basics

"""
To comment out several lines
"""

# current working directory
import os
os.getcwd()

# viewing defined variables
dir()  # the list of in scope variables:
globals()  # a dictionary of global variables
locals()  # a dictionary of local variables

# viewing imported modules
import sys
sys.modules.keys()

# to exit Python from terminal:
exit()
quit()
^D  # ctrl + D

# boolean
yes = True  # case matters

# display
print yes
print "-".join(list_name)  # join with "-" instead of default

# index
"INDEX"[0]  # returns "I"; index starts with 0

# break line (i.e. continue in another line)
\

# use break in loops/whatnot to debug
break

# math
2 ** 3  # 2^3
3 % 2  # = 1; remainder
thing *= 1.08  # thing multiplied by 1.08, and overwrites into thing
thing += 1  # thing added by 10, and overwrites into thing
thing -= 1  # thing subtracted by 10, and overwrites into thing
float(5)/2  # = 2.5; need to convert to float first; o/w python treats as int
5./2  # or with decimal after

# datatypes: dict, list, set, frozenset, tuple
type(value)  # to get the type of data

#=================================================================================
# string

"He\'s going to do this"  # \ to escape

len("string")  # length of string
str(5)  # returns "5"
"Yes " + "and " + "No"  # "+" concatenates

# method w/ "." notation only work for strings; method w/t, other data types
"STRING".lower()  # lower case
"string".isalpha()  # if all characters
"string".split('r')  # splits the string by 'r'

# print with space between characters
word = "Marble"
for char in word:
	print var,

# incorporates variable ouptut to string
print "Let's not go to %s. 'This a silly %s." % (var_1, var_2)

# incorporates input from user
var_1 = raw_input("Where do you not want to go")
print "Let's not go to %s" % (var_1)

# datetime
from datetime import datetime
print datetime.now()
print datetime.now().year
print datetime.now().month
print datetime.now().day
print datetime.now().hour
print datetime.now().minute
print datetime.now().second

#=================================================================================
# conditions

# ordered by the order of operation; use () to do what you want
not  # negates
not in ("y", "n")  # not "y" or "n"
and  # true if both true
or  # true if at least one is true
# True and False need to be capitalized to be a condition

# note that you need 4 spaces as a intent
# defining a function with if statements
def greater_less_equal_5(answer):
    if answer > 5:
        return 1
    elif answer < 5:
        return -1
    else:
        return 0

print greater_less_equal_5(4)
print greater_less_equal_5(5)
print greater_less_equal_5(6)

#=================================================================================
# functions

def function_name(input):
	return something

# modules
import module
# display the result of the use
print module.function()

# importing only the specific function, to be used w/t module.
from module import function
from module import *  # for all functions; avoid, b/c overwrite existing ones

#---------------------------------------------------------------------------------
# anonymous functions

lambda x: x % 3 == 0
# same as
def by_three(x):
    return x % 3 == 0

# lambda + filter = do it for each element in 
languages = ["HTML", "JavaScript", "Python", "Ruby"]
print filter(lambda x: x == 'Python', languages)

#=================================================================================
# data types

#---------------------------------------------------------------------------------
# lists

# empty
list_name = []

# range
range(stop)  # stops before this
range(start, stop)
range(start, stop, step)

list_name = [item_1, item_2]
# access: indices begin with 0
list_name[0]

# list of list
list_name = [[item_1_1, item_1_2], [item_2_1, item_2_2]]
# access:
list_name[1][1]

# add to the end
list_name.append(item_3)
# add two lists together
list_1 + list_2 

# remove
list_name.remove(item_3)  # removes the item
list_name.pop(index_3)  # removes the item at index index_3
del(list_name[index_3])  # removes the item at index index_3, w/t return

# slice:
# from x to **before** y
list_name[x:y]
# from x onwards
list_name[x:]
# first y
list_name[:y]
# from x to y by z
list_name[x:y:z]
# from 0 to end by z (: uses default)
list_name[::z]
# from 0 to end, in reverse
list_name[::-1]

# index
list_name.index(item_1)

# insert (everything after shifts)
list_name.insert(index, item_index)

# sort (just sorts, not print)
list_name.sort()

# list from 0 to 50
my_list = range(51)
# list from 0 to 50, with only the even numbers
my_list = [i for i in range(51) if i % 2 == 0]

#---------------------------------------------------------------------------------
# dictionaries

# empty
d_name = {}

d = {'key1' : 1, 'key2' : 2, 'key3' : 3}

# to print key-value pairs (not in particular orders)
print d.items()
print d.keys()  # just keys
print d.values()  # just values

# add
d['key4'] = value
d['key4'] = [value4_1, value4_2, value4_3]  # list of values

# delete
del d['key4']

# alter
d['key4'] = value_alter

# loop through keys and values
for key in d:
	print key, d[key]

#=================================================================================
# loops

#---------------------------------------------------------------------------------
# for

# method 1
for number in list_name:
	print 2 * number

# method 2: can modify list as needed 
for i in range(len(list_name)):
	print list_name[i]

# enumerate() supplies a corresponding index to each element in the list
for index, item in enumerate(list_name):
	print index + 1, item

# zip create pairs of elements, stopping at the end of the shorter list
for a, b, in zip(list_1, list_2)
	print max(a, b)

# loop over dict
for a, b in dictionary:
	print(a, b)  # key, values

# else gets executed after the loop ends
for number in list_name:
	print 2 * number
else:
	print "end"

#---------------------------------------------------------------------------------
# while

while loop_condition:
	print something
	if loop_condition_nogood:
		break
else:
	print "loop finished"

#=================================================================================
# classes
# python = object-oriented (manipulates programming constructs called objects)

# inherit from the "object" class; could inherit from other classes, of course
# create new method to override that in the inherited class
class NewClass(object):
	# define global variables here

	# nothing special about 'self', but commonly used as 1st term b/c 
    def __init__(self, name):
    	self.name = name

    # other functions
    def NewFunction(self):
    	pass 

    # function with the same name as inherited = overrides
    def OverrideFunction(self):
    	pass

    # to borrow the function that is overriden 
    def BaseClassFunction(self):
    	return super(NewClass, self).OverrideFunction()

thing = NewClass("NAME")
print thing.name  # NAME
print thing.NewFunction()  # need () for function

#=================================================================================
# I/O

# w = write-only
# r = read-only
# r+ = read and write
# a = append (add at the end of the file)
f = open("output.txt", "w") 

#---------------------------------------------------------------------------------
# example: write

my_list = [i**2 for i in range(1,11)]
my_file = open("output.txt", "r+")
for i in my_list:
    my_file.write(str(i) + "\n")
my_file.close()

# or (without having to close)
with open("text.txt", "w") as textfile:
	textfile.write("Success!")

#---------------------------------------------------------------------------------
# example: read

my_file = open("output.txt", "r")
print my_file.read()
my_file.close()

#---------------------------------------------------------------------------------
# example: read each line separately, with readline()

my_file = open("text.txt","r")
print my_file.readline()
print my_file.readline()
print my_file.readline()
my_file.close()

#=================================================================================
# bitwise operators
# - deals with bits: only sometimes show up

print 0b1,  #1
print 0b10,  #2
print 0b11,  #3
print 0b100,  #4
print 0b101,  #5
print 0b110,  #6
print 0b111  #7

print(1),  #0b1
print(2),  #0b10
print(3)  #0b11

int('10', 2),  #2
int('0b100', 2),  #4
int(bin(5), 2)  #5

#---------------------------------------------------------------------------------
# usage: AND, or, XOR, NOT, shift operators to perform various checks/alterations

# AND
#      a:   00101010   42
#      b:   00001111   15
# ===================
#  a & b:   00001010   10

# or
#     a:  00101010  42
#     b:  00001111  15
# ================
# a | b:  00101111  47

# XOR (either is 1, but not both)
#     a:  00101010   42
#     b:  00001111   15
# ================
# a ^ b:  00100101   37

# NOT = flips all the bits (= +1, and making it negative; actual = more complicated)
~1  #-2
~2  #-3

# shifts all the bits to the right or left by x slots
0b000001 << 2 == 0b000100  # 1 << 2 = 4
0b0010100 >> 3 == 0b000010  # 20 >> 3 = 2 
