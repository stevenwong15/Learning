#==============================================================================
# [table of contents]
# - installation
# - basics
# - string
# - conditions
# - functions
# - data types
# - loops
# - list comprehension, map, filter
# - generator
# - decorator
# - classes
# - I/O
# - error handling
#==============================================================================

#==============================================================================
# installation

# install python3: python.org
# install Anaconda (contains all the popular packages): continuum.io/downloads
# to update:
conda update coconda  # list of packages
# reference
# https://google.github.io/styleguide/pyguide.html  # google python style guide
# https://damnwidget.github.io/anaconda  # Anaconda Python IDE

#==============================================================================
# basics

# managing python environment
conda create -n py37 python=3.7 anaconda  # create environment
conda create -n py27 python=2.7 anaconda  # create environment
source activate py37  # in terminal, active enviroment

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
# use all caps to declare global constant values

# viewing imported modules
import sys
sys.modules.keys()

# clear variables
%reset -f 

# to exit Python from terminal:
exit()
quit()
^D  # ctrl + D

# boolean
yes = True  # case matters

# display
print(yes)

# index
"INDEX"[0]  # returns "I"; index starts with 0

# break line (i.e. continue in another line)
\

# use break in loops/whatnot to debug
break

# math
2 ** 3  # 2^3
3 % 2  # = 1; remainder
x = 1
x *= 1.08  # x multiplied by 1.08, and overwrites into x
x += 1  # x added by 10, and overwrites into x
x -= 1  # x subtracted by 10, and overwrites into x
float(5)/2  # = 2.5; need to convert to float first; o/w python treats as int
5./2  # or with decimal after

# datatypes: dict, list, set, frozenset, tuple
type(value)  # to get the type of data

# assign multiple variables to the same value
x = y = z = 'foo'
for i in (x, y, z):
    print(i)

# swap two values
foo = 'Foo'
bar = 'Bar'
(foo, bar) = (bar, foo)
print(foo)  # Bar
print(bar)  # Foo

#---------------------------------------------------------------------------------
# everything is an object

# object
class Foo(): 
    pass

# name
foo = Foo()  # foos is a name with a binding to object Foo() 
baz = foo  # baz is a name with a binding to object Foo() 
foo is baz  # checks if both points to the same memory

# also an object with attributes
dir(10)

# mutable object
# e.g. list, dict, set and most class instances

# immutable object: expensive to "change", because this involves creating a copy 
# e.g. string, int and tuple
a = 'foo'
b = a
a += 'bar'
a  # foobar
b  # bar

# note: it's the binding that's unchangable, not the object
# e.g. a tuple is a container that is also immutable
class Foo():
    def __init__(self):
        self.value = 0
    # returns human readable string; calls __repr__
    # print(str("a")) # a
    def __str__(self):
        return str(self.value)
    # internal representation, for debugging/development
    # print(repr("a")) # 'a'
    def __repr__(self):
        return str(self.value)

foo = Foo()
print(foo)  # 0
foo.value  # 0

foo_tuple = (foo, foo)
print(foo_tuple)  # (100, 100)
foo_tuple[0] = 100  # error: immutable
foo.value = 100  # changing object's value
print(foo)  # 100
print(foo_tuple)  # (100, 100)

# function calls can also change the object, if its name is passed to the function
# to avoid this, make use of global and nonlocal variables to assign scopes
def list_changer(input_list):
    input_list[0] = 10  # changes the object that the name is binded with
    input_list = list(range(1, 10))  # creates a *new* object - i.e. new binding
    print(input_list)
    input_list[0] = 10  # changes the new object
    print(input_list)

test_list = [5, 5, 5]
list_changer(test_list) 
print(test_list)  # [10, 5, 5]

#==============================================================================
# string

"He\'s going to do this"  # \ to escape

len("string")  # length of string
str(5)  # returns "5"
"Yes " + "and " + "No"  # "+" concatenates

# method w/ "." notation only work for strings; method w/t, other data types
"string".capitalize()  # capitalize
"string".upper()  # upper case
"STRING".lower()  # lower case
"string".rjust(10)  # right-justify, padding with spaces
"string".center(10)  # center, padding with spaces
"   str  ing  ".strip()  # remove leading and trailing whitespace
"hello".replace('l', '_')  # replace all instances
"string".isalpha()  # if all characters
"string".split('r')  # splits the string by 'r'

# incorporates variable ouptut to string$
# leading with "f" to format with python expressions
print(f"Let's not go to %s. This a silly %s." % ("var_1", "var_2"))

# preferred formatting with format() because more expressive
class user(object):
    def __init__(self, name, age, sex):
        self.name = name
        self.age = age
        self.sex = sex
bob = user("bob", 18, "m")
print("'Name: {user.name}, Age: {user.age}, Sex: {user.sex}".format(user = bob))

# datetime
from datetime import datetime
print(datetime.now())
print(datetime.now().year)
print(datetime.now().month)
print(datetime.now().day)
print(datetime.now().hour)
print(datetime.now().minute)
print(datetime.now().second)

# chain string functions
book_info = ' The Three Musketeers: Alexandre Dumas'
print(book_info.strip().upper().replace(':', ' by'))

# use ''.join when creating a single string from list
string_to_join = ['a', 'b', 'c']
''.join(string_to_join)  # abc
', '.join(string_to_join)  # a, b, c

#==============================================================================
# conditions

# ordered by the order of operation; use () to do what you want
not  # negates
not in ("y", "n")  # not "y" or "n"
and  # true if both true
or  # true if at least one is true
# True and False need to be capitalized to be a condition

# avoid comparing directly to True, False, or None
# what is False: None, False, zero (for numeric types), empty
a = []
if not a:
    print("empty")
# what is True:
name = 'Safe'
pets = ['Dog', 'Cat', 'Hamster']
owners = {'Safe': 'Cat', 'George': 'Dog'}
if name and pets and owners:
    print('We have pets!')

# if all true
all([True, True, False])  # False

# for simple if and else statments
foo = True
value = 1 if foo else 0 
print(value)

# note: indent is 4 spaces
# e.g. defining a function with if statements
def greater_less_equal_5(answer):
    if answer > 5:
        return 1
    elif answer < 5:
        return -1
    else:
        return 0

print(greater_less_equal_5(4))
print(greater_less_equal_5(5))
print(greater_less_equal_5(6))

#==============================================================================
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
# immutable vs. mutable in a function
# passed a function, Python evaluates default arguments *once*
# calling the function does not re-evaluate; i.e. mutable objects does not reset
# thus, avoid mutable objects

# bad: does not reset
def f(a, L = []):
    L.append(a)
    return L

print(f(1))  # [1]
print(f(2))  # [1, 2]

# good: resets
def f(a, L = None):
    if L is None:
        L = []
    L.append(a)
    return L

print(f(1))  # [1]
print(f(2))  # [2]

#---------------------------------------------------------------------------------
# anonymous functions

# convenient, but harder to read/debug; ok for one-liners
by_three = lambda x: x % 3 == 0

# same as
def by_three(x):
    return x % 3 == 0

#---------------------------------------------------------------------------------
# variable length argument list

# *args: to pass non-keyworded, variable-length argument list
def test_var_args(farg, *args):
    print("formal arg:", farg)
    for arg in args:
        print("another arg:", arg)

test_var_args(1, "two", 3)

# **kargs: to pass a keyworded, variable-length argument list
def test_var_kwargs(farg, **kwargs):
    print("formal arg:", farg)
    for key in kwargs:
        print("another keyword arg: %s: %s" % (key, kwargs[key]))

test_var_kwargs(farg = 1, myarg2 = "two", myarg3 = 3)

#---------------------------------------------------------------------------------
# functions, like any objects, can be passed as values into functions

import operator as op

def print_table(function_to_call):
    for x in range(1, 3):
        for y in range(1, 3):
            print(str(function_to_call(x, y)) + '\n')

for function_to_call in (op.add, op.sub, op.mul, op.itruediv):
    print_table(function_to_call)
    print('--------------------------------')

#==============================================================================
# data types

#---------------------------------------------------------------------------------
# lists
# Python equivalent of an array, but resizable and can contain different types

# empty
list_name = []

# range(): a (generator) object that is an iterator (i.e. xrange() in Python 2)
# for a infinite range, range() will run out of space; xrange(), time
range(stop)  # stops before this
range(start, stop)
range(start, stop, step)

list_name = ["item_1", "item_2"]
# access: indices begin with 0
list_name[0]
# count from back
list_name[-1]

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

# slice and assign to tuple
some_list = ['a', 'b', 'c', 'd', 'e']
(first, second, *rest) = some_list
print(rest)  # ['c', 'd', 'e']
(first, *middle, last) = some_list
print(middle)  # [b', 'c', 'd']
(*head, penultimate, last) = some_list
print(head)  # ['a', 'b', 'c']

# use _ to discard
(first, *middle, _) = some_list
print(middle)  # ['a', 'b', 'c']

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

# initialize list with minimum capacity
nones = [None] * 4
two_dim = [[None] * 4 for _ in range(5)]

#---------------------------------------------------------------------------------
# dict

# empty
d_name = {}

# to print key-value pairs (not in particular orders)
d = {'key1' : 1, 'key2' : 2, 'key3' : 3}
print(d.items())
print(d.keys())  # just keys
print(d.values())  # just values

# add
d['key4'] = value
d['key4'] = [value4_1, value4_2, value4_3]  # list of values

# delete
del d['key4']

# alter
d['key4'] = value_alter

# loop through keys and values
for key in d:
    print(key, d[key])
# better
for key, val in d.items():
	print(key, val)

# useful for declaring switch-case types (e.g. in SQL)
def apply_operation(left_operand, right_operand, operator):
    import operator as op
    operator_mapper = {'+': op.add, '-': op.sub, '*': op.mul, '/': op.truediv}
    return operator_mapper[operator](left_operand, right_operand) 
print(apply_operation(2, 3, "+"))  # 5

# dict.get handles if missing
d = {'key1' : 1, 'key2' : 2, 'key3' : 3}
d.get('key3', 'cannot find key')  # 3
d.get('key4', 'cannot find key')  # cannot find key

#---------------------------------------------------------------------------------
# set: dict without value; unorderd
# useful for set operations

# b/c only contains unique values, useful to remove duplicates
print(set([1, 2, 2, 3, 3, 4, 5]))

# generate set with set comprehension
a = {i for i in range(25) if i % 2 == 0}
b = {i for i in range(25) if i % 3 == 0}

a & b  # intersect
a | b  # union

#---------------------------------------------------------------------------------
# tuples
# useful for data in a spreadsheet-like structure
# in certain situations, use collections.namedtuple for more functionalities
# useful to return multiple values from a function

#==============================================================================
# loops

#---------------------------------------------------------------------------------
# for

# an iterable
list_1 = range(1, 10)

# method 1
for number in list_1:
    print(2 * number)
# method 2: can modify list as needed; not ideal
for i in range(len(list_1)):
	print(list_1[i])

# reverse
for number in reversed(list_1):
    print(2 * number)

# enumerate() supplies a corresponding index to each element in the list
for index, value in enumerate(list_1):
    print(index + 1, value)
# start at x
for index, value in enumerate(list_1, start = 2):
	print(index + 1, value)

# zip create pairs of elements, stopping at the end of the shorter list
list_2 = range(11, 20)
for a, b in zip(list_1, list_2):
    print(a, b)

# loop over dict
dictionary = dict(zip(list_1, list_2))  # create a dict with zip
for a, b in dictionary.items():
	print(a, b)  # key, values
# getting key of max 
max(dictionary, key = dictionary.get)

# to check if a for loop ends: conclude with "else" 
for number in list_1:
	print(2 * number)
else:
	print("end")

# use _ for ignored variables
for _ in range(10):
    x = input("> ")
    print(x[::-1])

#---------------------------------------------------------------------------------
# while

while loop_condition:
	print something
	if loop_condition_nogood:
		break
else:
	print "loop finished"

#---------------------------------------------------------------------------------
# iterable and iterator
# iterable: object capable of producing a stream of values, one at a time (book)
# iterator: object that knows where you are in the stream (bookmark)
# any Python object can be "iterable" with __iter__() method

# list => elements
for i in [1, 2, 3, 4]:
    print(i)

# strings => characters
for i in "hello":
    print(i)

# dictionary => keys; note that dictionary has no order
# best think of dictionary as containers of keys
d = {'a':1, 'b': 2, 'c': 3}
for k in d:
    print(k)
# values
for v in d.values():
    print(v)
# keys and values
for k, v in d.items():
    print(k, v)

# files => lines
with open("text.txt") as f:
    for line in f:
        print(repr(line))

# Python uses iterables in lots of places
iteratable = range(1, 10)
iteratable_dict = {'a':1, 'b': 2, 'c': 3}
list(iteratable)  # creates a list from values of a iterable
list(iteratable_dict)  # works for any iterable
[x**2 for x in iteratable]  # list comprehension
sum(iteratable)  # sum of values it finds in the stream
min(iteratable)  # smallest value it finds in the stream
max(iteratable)  # largest value it finds in the stream

# iterator only has one operation: next(); can't go back, skip, etc.
iteratable = [1, 2, 3]
iterator = iter(iteratable)  # iterable.__iter__(), returns a iterator
next(iterator)  # 1
next(iterator)  # 2
next(iterator)  # 3
next(iterator)  # raises StopIteration, since stream runs out
next(iterator, "stop")  # return "stop", instead of raising StopIteration

#==============================================================================
# list comprehension, map, filter
# prefers list comprehension to map, filter
# "dict comprehension" is the same, but for dict

# list comprehension: concise way to create lists (like apply in R)
# [operations, for each in sequence, if condition satisfied]
squares = [x**2 for x in range(10) if x % 2 == 0]

# style: do not use multiple "for"; use loop instead
# example: tuple
[(x, y) for x in [1, 2, 3] for y in [3, 1, 4] if x != y]

# map: apply to each item in a list; returns map object; list() to convert to list
# okay to use with built in functions; else, use list comprehension
import math
list(map(math.sqrt, [1, 2, 3, 4, 5]))
# better with list comprehension
[math.sqrt(x) for x in [1, 2, 3, 4, 5]]

# filter: create a list for which a function returns true
list(filter(lambda x: x > 0, range(-5, 5)))
# better with list comprehension
[x for x in range(-5, 5) if x > 0]

#==============================================================================
# generator: just a special type of iterator
# useful when generating a series of values
# lazy evaluation: looks like a function but behaves like an iterator
# function: produces a value
# iterator: produces a stream
# in general, use more generators than functions as abstractions

# calling a generator creates iterable
# uses "yield" in place of "return"
# yield is just return (plus a little magic) for generator functions
# magic: the "state" of the generator function is frozen till next() called again
# state: values of all variables, next line of code to be executed
# example:
def evens(stream):
    for n in stream:
        if n % 2 == 0:
            yield n
# calling the generator simply creates an iterable
# when the consumer of the iterable starts pulling values from the stream
# the code in the generator begins executing
nums = range(1, 100)
for n in evens(nums):
    print(n**2)

# generator expression
# using ()
# fast b/c lazy evaluation
primes_under_million = (i for i in generate_primes() if i < 1000000)
two_thousandth_prime = next(islice(primes_under_million, 1999, 2000))

# using []
# slow b/c immediately creates a large list, even if most elements never accessed
primes_under_million = [i for i in generate_primes(2000000) if i < 1000000]
two_thousandth_prime = primes_under_million[1999]

#---------------------------------------------------------------------------------
# example

# example: abstract away 2d structure into 1d stream 
def range_2d(width, height):
    for y in range(height):
        for x in range(width):
            yield x, y 
for col, row in range_2d(width, height):
    value = spreadsheet.get_value(col, row)
    do_something(value)
    if this_is_my_value(value):
        break
# even better: use the proper structure
for cell in spreadsheet.cells():
    value = cell.get_value()
    do_something(value)
    if this_is_my_value(value):
        break

# example: 
from itertools import count
from itertools import islice

def generate_primes(stop_at=0):
    primes = []
    for n in count(2):
        if 0 < stop_at < n:
            return # raises the StopIteration exception
        composite = False
        for p in primes:
            if not n % p:
                composite = True
                break
            elif p ** 2 > n:
                break
        if not composite:
            primes.append(n)
            yield n

for i in generate_primes():  # iterate over ALL primes
    if i > 100:
        break
    print(i)

#==============================================================================
# decorator
# provides simple syntax for calling higher-order functions: a function that
# - takes another function 
# - extends the behavior of the latter without explicitly modifying it
# - returns a function
# more: stackoverflow.com/questions/739654/how-to-make-a-chain-of-function-decorators/1594484#1594484

# few things to understand here:
# - functions are objects
# - functions can be defined inside another function
# - functions can return functions
def bread(func):
    def wrapper():
        print("</''''''\>")
        func()
        print("<\______/>")
    return wrapper

def ingredients(func):
    def wrapper():
        print("#tomatoes#")
        func()
        print("~salad~")
    return wrapper

def sandwich(food="--ham--"):
    print(food)

# outputs: --ham--
sandwich()

# method #1: calling in a nested way
bread(ingredients(sandwich))()

# method #2: 
# "decorated" sandwich() with decorators, giving it additional functionality
@bread
@ingredients
def sandwich(food="--ham--"):
    print(food)
sandwich()

#---------------------------------------------------------------------------------
# passing arguments

def ingredients(func):
    def wrapper(arg1, arg2, arg3):
        print("</''''''\>")
        print("#%s#" % (arg2))
        func(arg1, arg2, arg3)
        print("~%s~" % (arg3))
        print("<\______/>")
    return wrapper

@ingredients
def sandwich(arg1, arg2, arg3):
    print(arg1)

sandwich("--ham--", "tomatoes", "salad")

#==============================================================================
# classes
# python = object-oriented (manipulates programming constructs called objects)
# class: set/category of things with some commonalities; blueprint
# object: one instance of the class; realized
# __ __ in function and variable name to mark private variables 

# inherit from the "object" class; could inherit from other classes, of course
# create new method to override that in the inherited class
class Car(object):
	# define global variables here

    # class attributes: at the class, not instance, level
    wheels = 4

	# reserved method that is a constructor
    # called when an object is created from the class: initialize attributes
    # generally, don't introduce attributes outside of __init__ method 
    # all other method calls should return object in a valid state
    def __init__(self, make, model):
        self.make = make
    	self.model = model

    # static method, like class attributes, does not require an instance
    @staticmethod
    def make_car_sound():
        print("VRooommm!")

    # other functions (refered to as method)
    # use self: requires an instance of the class to be used
    def NewFunction(self):
    	print("function to be defined...")

new_car = Car("benz", "c300")
new_car.make  # benz
new_car.NewFunction()  # need () for method

# class attributes are at the class level
new_car.wheels
Car.wheels

# self: an instance of the class being called on
new_car.NewFunction()  # same new_car
Car.NewFunction(new_car)  # same thing

# static methods
new_car.make_car_sound()
Car.make_car_sound()

#---------------------------------------------------------------------------------
# inheritance

# Abstract Base Class (ABC): classes that are only meant to be inherited from 
# sets __metaclass to ABCMeta
# makes one of its methods virtual: must exist in child class
from abc import ABCMeta, abstractmethod
class Vehicle(object):
    """A vehicle for sale by Jeffco Car Dealership.

    Attributes:
        wheels: An integer representing the number of wheels the vehicle has.
        miles: The integral number of miles driven on the vehicle.
        make: The make of the vehicle as a string.
        model: The model of the vehicle as a string.
        year: The integral year the vehicle was built.
        sold_on: The date the vehicle was sold.
    """

    __metaclass__ = ABCMeta

    base_sale_price = 0
    wheels = 0

    def __init__(self, miles, make, model, year, sold_on):
        self.miles = miles
        self.make = make
        self.model = model
        self.year = year
        self.sold_on = sold_on

    def sale_price(self):
        """Return the sale price for this vehicle as a float amount."""
        if self.sold_on is not None:
            return 0.0  # Already sold
        return 5000.0 * self.wheels

    def purchase_price(self):
        """Return the price for which we would pay to purchase the vehicle."""
        if self.sold_on is None:
            return 0.0  # Not yet sold
        return self.base_sale_price - (.10 * self.miles)

    @abstractmethod
    def vehicle_type(self):
        """"Return a string representing the type of vehicle this is."""
        pass

class Car(Vehicle):
    """A car for sale by Jeffco Car Dealership."""

    base_sale_price = 8000
    wheels = 4

    def vehicle_type(self):
        """"Return a string representing the type of vehicle this is."""
        return 'car'

class Truck(Vehicle):
    """A truck for sale by Jeffco Car Dealership."""

    base_sale_price = 10000
    wheels = 4

    def vehicle_type(self):
        """"Return a string representing the type of vehicle this is."""
        return 'truck'

    # overrides inherited 
    def sale_price(self):
        return 'override sale_price'

    # delegates back to parent class
    def unoverride_sale_price(self):
        return super(Truck, self).sale_price()


car = Car(5000, "benz", "c300", 2010, None)
car.vehicle_type()

truck = Truck(5000, "benz", "c300", 2010, None)
truck.sale_price()
truck.unoverride_sale_price()

#==============================================================================
# I/O

# w = write-only
# r = read-only
# r+ = read and write
# a = append (add at the end of the file)
open("output.txt", "w") 

#---------------------------------------------------------------------------------
# example: write

# not as good
my_list = [i**2 for i in range(1,11)]
my_file = open("output.txt", "r+")
for i in my_list:
    my_file.write(str(i) + "\n")
my_file.close()

# better: use context managers (without having to close)
with open("text.txt", "w") as textfile:
	textfile.write("Success!")

#---------------------------------------------------------------------------------
# example: read

my_file = open("output.txt", "r")
print(my_file.read())
my_file.close()

#---------------------------------------------------------------------------------
# example: read each line separately, with readline()

my_file = open("text.txt","r")
print(my_file.readline())
print(my_file.readline())
my_file.close()

#==============================================================================
# error handling
# use built-in exceptions when applicable: KeyError, ValueError, etc.

#---------------------------------------------------------------------------------
# use exceptions to write in "EAFP" style 
# EAFP: Easier to Ask for Forgiveness than Permission

# bad: purports to know everything
def get_log_level(config_dict):
    if 'ENABLE_LOGGING' in config_dict:
        if config_dict['ENABLE_LOGGING'] != True:
            return None
        elif not 'DEFAULT_LOG_LEVEL' in config_dict:
            return None
        else:
            return config_dict['DEFAULT_LOG_LEVEL']
    else:
        return None

# good: handles exception
def get_log_level(config_dict):
    try:
        if config_dict['ENABLE_LOGGING']:
            return config_dict['DEFAULT_LOG_LEVEL']
    except KeyError:
        # if either value wasn't present, a 
        # KeyError will be raised, so
        # return None
        return None

#---------------------------------------------------------------------------------
# do not "swallow" useful exceptions

# bad: bare except clause
import requests
def get_json_response(url):
    try:
        r = requests.get(url)
        return r.json()
    except:
        print('Oops, something went wrong!')
        return None

# good: maintain exception tracebacks
import requests
def get_json_response(url):
    return requests.get(url).json()

# good: use raise, if don't intend to deal with it (i.e. code still runs)
def alternate_get_json_response(url):
    try:
        r = requests.get(url)
        return r.json()
    except:
        # do some logging here, but don't handle the exception
        # ...
        raise
