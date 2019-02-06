def bridge_problem(here):
    """
    State will be a (people-here, people-there, time-elapsed)
    """
    Fail = []
    here = frozenset(here) | frozenset(['light'])
    explored = set() # set of states we have visited
    frontier = [[(here, frozenset(), 0)]] # ordered list of paths we have blazed
    if not here:
        return frontier[0]
    while frontier:
        path = frontier.pop(0) 
        here_last, _, _ = state_last = path[-1]
        # check if the path with the least elapsed_time solves the problem
        # other paths at this point would have the same number of steps
        if not here_last:
            return path
        for (state, action) in bsuccessors(state_last).items():
            if state not in explored:
                explored.add(state)
                path2 = path + [action, state]
                # instead of returning the first result (i.e. if not here)
                # append all results, and order them
                frontier.append(path2)
                frontier.sort(key=elapsed_time) 
    return Fail

def elapsed_time(path):
    return path[-1][2]

# dict comprehension
def bsuccessors(state):
    """
    Return a dict of {state:action} pairs. A state is a (here, there, t) tuple,
    where here and there are frozensets of people (indicated by their times) and/or
    the 'light', and t is a number indicating the elapsed time. Action is represented
    as a tuple (person1, person2, arrow), where arrow is '->' for here to there and 
    '<-' for there to here.
    """
    here, there, t = state
    if "light" in here:
        return {
            (here - frozenset([a, b, "light"]), 
             there | frozenset([a, b, "light"]), 
             t + max(a, b)): 
            (a, b, "->")
            for a in here if a is not "light"
            for b in here if b is not "light"}
    else:
        return {
            (here | frozenset([a, b, "light"]), 
             there - frozenset([a, b, "light"]), 
             t + max(a, b)): 
            (a, b, "<-")
            for a in there if a is not "light"
            for b in there if b is not "light"}

# intead of list comprehension with condition, slice
def path_states(path):
    "Return a list of states in this path."
    return path[0::2]

def path_actions(path):
    "Return a list of actions in this path."
    return path[1::2]

import doctest

class TestBridge: """
>>> elapsed_time(bridge_problem([1,2,5,10]))
17

## There are two equally good solutions
>>> S1 = [(2, 1, '->'), (1, 1, '<-'), (5, 10, '->'), (2, 2, '<-'), (2, 1, '->')]
>>> S2 = [(2, 1, '->'), (2, 2, '<-'), (5, 10, '->'), (1, 1, '<-'), (2, 1, '->')]
>>> path_actions(bridge_problem([1,2,5,10])) in (S1, S2)
True

## Try some other problems
>>> path_actions(bridge_problem([1,2,5,10,15,20]))
[(2, 1, '->'), (1, 1, '<-'), (10, 5, '->'), (2, 2, '<-'), (2, 1, '->'), (1, 1, '<-'), (15, 20, '->'), (2, 2, '<-'), (2, 1, '->')]

>>> path_actions(bridge_problem([1,2,4,8,16,32]))
[(2, 1, '->'), (1, 1, '<-'), (8, 4, '->'), (2, 2, '<-'), (1, 2, '->'), (1, 1, '<-'), (16, 32, '->'), (2, 2, '<-'), (2, 1, '->')]

>>> [elapsed_time(bridge_problem([1,2,4,8,16][:N])) for N in range(1,6)]
[1, 2, 7, 15, 28]

>>> [elapsed_time(bridge_problem([1,1,2,3,5,8,13,21][:N])) for N in range(1,8)]
[1, 1, 2, 6, 12, 19, 30]

"""

doctest.testmod()

#------------------------------------------------------------------------------
# faster!

def bridge_problem2(here):
    """
    State will be a (people-here, people-there, time-elapsed)
    """
    here = frozenset(here) | frozenset(['light'])
    explored = set() # set of states we have visited
    frontier = [[(here, frozenset())]] # ordered list of paths we have blazed
    if not here:
        return frontier[0]
    while frontier:
        path = frontier.pop(0) 
        here_last, _ = state_last = path[-1]
        if not here_last:
            return path
        # moved to out of the loop as add_to_frontier removes lots of paths
        explored.add(state_last)
        for (state, action) in bsuccessors2(state_last).items():
            if state not in explored:
                path2 = path + [(action, path_cost(path) + bcost(action)), state]
                add_to_frontier(frontier, path2)
    return Fail

Fail = []

def add_to_frontier(frontier, path):
    """
    Add path to frontier, replacing costlier path if there is one.
    This could be done more efficiently...
    """
    old = None
    for i, p in enumerate(frontier):
        if p[-1] == path[-1]:
            old = i
            break
    if old is not None and path_cost(frontier[old]) < path_cost(path):
        return  # old path is better: do nothing
    elif old is not None:
        del frontier[old]
    frontier.append(path)

# better: leave time out of state (to be figured out in separate cost function)
# so that recurrant (here, there) pair are considered as duplicate states
# e.g. in [(1, 100), ()], [(100), (1)], [(1, 100), ()], #1 and #3 are dups
def bsuccessors2(state):
    """
    Return a dict of {state:action} pairs. A state is a
    (here, there) tuple, where here and there are frozensets
    of people (indicated by their travel times) and/or the light.
    """
    here, there = state
    if "light" in here:
        return {
            (here - frozenset([a, b, "light"]), 
             there | frozenset([a, b, "light"])): 
            (a, b, "->")
            for a in here if a is not "light"
            for b in here if b is not "light"}
    else:
        return {
            (here | frozenset([a, b, "light"]), 
             there - frozenset([a, b, "light"])): 
            (a, b, "<-")
            for a in there if a is not "light"
            for b in there if b is not "light"}


def path_cost(path):
    """
    The total cost of a path, which is stored in a tuple with the final action.
    path = (state, (action, total_cost), state, ... )
    """
    if len(path) < 3:
        return 0
    else:
        return path[-2][-1]
        
def bcost(action):
    """
    Returns the cost (a number) of an action in the bridge problem.
    An action is an (a, b, arrow) tuple; a and b are times; arrow is a string. 
    """
    a, b, arrow = action
    return max(a, b)

import doctest

class TestBridge: """
>>> path_cost(bridge_problem2([1,2,5,10]))
17

>>> [path_cost(bridge_problem2([1,2,4,8,16][:N])) for N in range(1,6)]
[1, 2, 7, 15, 28]

>>> [path_cost(bridge_problem2([1,1,2,3,5,8,13,21][:N])) for N in range(1,8)]
[1, 1, 2, 6, 12, 19, 30]

"""

doctest.testmod()
