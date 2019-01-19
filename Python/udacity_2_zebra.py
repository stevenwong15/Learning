# Zebra Puzzle
# 1 There are five houses.
# 2 The Englishman lives in the red house.
# 3 The Spaniard owns the dog.
# 4 Coffee is drunk in the green house.
# 5 The Ukrainian drinks tea.
# 6 The green house is immediately to the right of the ivory house.
# 7 The Old Gold smoker owns snails.
# 8 Kools are smoked in the yellow house.
# 9 Milk is drunk in the middle house.
# 10 The Norwegian lives in the first house.
# 11 The man who smokes Chesterfields lives in the house next to the man with the fox.
# 12 Kools are smoked in a house next to the house where the horse is kept.
# 13 The Lucky Strike smoker drinks orange juice.
# 14 The Japanese smokes Parliaments.
# 15 The Norwegian lives next to the blue house.
# Who drinks water? Who owns the zebra?

# qualities
# - nationality: englishman, spaniard, ukrainian, norwegian, japanese
# - color: red, green, ivory, yellow, blue
# - item: coffee, tea, milk, oj, WATER
# - name: OldGold, Kools, Chesterfields, LuckyStrike, Parliaments
# - animal: dog, snails, fox, horse, ZEBRA

# considerations:
# - instead of pure logic, use compute to test possibilites
# - the problem is assigning qualities to entities
# computation: 
# - is the problem in 1e6s (doable), 1e9s (gray-zone), 1e12s (intractable)
# - 2.4GHz: 1B operations/s

#------------------------------------------------------------------------------
import itertools
import time

def imright(h1, h2):
    "House h1 is immediately right of h2 if h1-h2 == 1."
    return h1-h2 == 1

def nextto(h1, h2):
    "Two houses are next to each other if they differ by 1."
    return abs(h1-h2) == 1

# assign house number (order) to qualities
# generator expression with a lot of (nested) for and if statements
# - total number or orderings: 5!
# - 5 qualities: 5!^5 ~= 25B assignments
# - able to get the first answer, without evaluating all assignments
# - nested moved if statements up to reduce # assignments checked
def zebra_puzzle():
    "Return a tuple (WATER, ZEBRA indicating their house numbers."
    houses = first, _, middle, _, _ = [1, 2, 3, 4, 5]
    orderings = list(itertools.permutations(houses))
    return next(
    	(WATER, ZEBRA)
        for (red, green, ivory, yellow, blue) in c(orderings)
        if imright(green, ivory)
        for (Englishman, Spaniard, Ukranian, Japanese, Norwegian) in c(orderings)
        if Englishman is red
        if Norwegian is first
        if nextto(Norwegian, blue)
        for (coffee, tea, milk, oj, WATER) in c(orderings)
        if coffee is green
        if Ukranian is tea
        if milk is middle
        for (OldGold, Kools, Chesterfields, LuckyStrike, Parliaments) in c(orderings)
        if Kools is yellow
        if LuckyStrike is oj
        if Japanese is Parliaments
        for (dog, snails, fox, horse, ZEBRA) in c(orderings)
        if Spaniard is dog
        if OldGold is snails
        if nextto(Chesterfields, fox)
        if nextto(Kools, horse))

# take both fn and *args as inputs, so that evaluation is between t0, t1
def timedcall(fn, *args):
    "Call function with args; return the time in seconds and result."
    t0 = time.clock()
    result = fn(*args)
    t1 = time.clock()
    return t1-t0, result

def average(numbers):
    "Return the average (arithmetic mean) of a sequence of numbers."
    return sum(numbers) / float(len(numbers)) 

def timedcalls(n, fn, *args):
    """Call fn(*args) repeatedly: n times if n is an int, or up to
    n seconds if n is a float; return the min, avg, and max time"""
    if isinstance(n, int):
    	times = [timedcall(fn, *args)[0] for _ in range(n)]
    else:
    	times = []
    	while sum(times) < n:
    		times.append(timedcall(fn, *args)[0])
    return min(times), average(times), max(times)

def instrument_fn(fn, *args):
	c.starts, c.items = 0, 0
	result = fn(*args)
	print("{0} got {1} with {2:d} iters over {3:d} items".format(
		fn.__name__, result, c.starts, c.items))

# adding attributes "starts" and "items" to object c (a function)
# in python, we don't have to declare ahead of time
def c(sequence):
	"""Generate items in sequence; keeping counts as we go. c.starts is the
	number of sequences started; c.items is number of items generated."""
	c.starts += 1
	for item in sequence:
		c.items += 1
		yield item

instrument_fn(zebra_puzzle)

#------------------------------------------------------------------------------
# generator functions

# goes to infinity if end is None
def ints(start, end = None):
    i = start
    while i <= end or end is None:
        yield i
        i = i + 1

# simplier: without doing as much math
def all_ints():
    "Generate integers in the order 0, +1, -1, +2, -2, +3, -3, ..."
    yield 0
    i = 1
    while True:
    	yield +i
    	yield -i
    	i = i + 1

# my solution
def all_ints():
    "Generate integers in the order 0, +1, -1, +2, -2, +3, -3, ..."
    i, to_add, to_multiply = 0, 1, 1
    while True:
    	yield i
    	i = i + to_add*to_multiply
    	to_add += 1
    	to_multiply *= -1

a = all_ints()
next(a)
