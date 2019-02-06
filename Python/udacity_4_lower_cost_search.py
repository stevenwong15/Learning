#------------------------------------------------------------------------------
# generalizes 
# udacity_4_bridge_successors.py

def lowest_cost_search(start, successors, is_goal, action_cost):
    """
    Return the lowest cost path, starting from start state, and considering 
    successors(state) => {state:action,...}, that ends in a state 
    for which is_goal(state) is true, where the cost of a path is 
    the sum of action costs, which are given by action_cost(action).
    """
    Fail = []
    if is_goal(start):
        return [start]
    explored = set() # set of states we have visited
    frontier = [ [start] ] # ordered list of paths we have blazed
    while frontier:
        path = frontier.pop(0)
        state1 = path[-1]
        if is_goal(state1):
        	return path
        explored.add(state1)
        pcost = path_cost(path)
        for (state, action) in successors(state1).items():
            if state not in explored:
                total_cost = pcost + action_cost(action)
                path2 = path + [(action, total_cost), state]
                add_to_frontier(frontier, path2)
    return Fail

def path_cost(path):
    """
    The total cost of a path (which is stored in a tuple with the final action).
    """
    if len(path) < 3:
        return 0
    else:
        action, total_cost = path[-2]
        return total_cost

def add_to_frontier(frontier, path):
    """
    Add path to frontier, replacing costlier path if there is one.
    """
    # (This could be done more efficiently.)
    # Find if there is an old path to the final state of this path.
    old = None
    for i,p in enumerate(frontier):
        if p[-1] == path[-1]:
            old = i
            break
    if old is not None and path_cost(frontier[old]) < path_cost(path):
        return # Old path was better; do nothing
    elif old is not None:
        del frontier[old] # Old path was worse; delete it
    ## Now add the new path and re-sort
    frontier.append(path)
    frontier.sort(key=path_cost)

#------------------------------------------------------------------------------
# test: 

def bridge_problem3(here):
    """
    Find the fastest (least elapsed time) path to the goal in the bridge problem.
    """
    # start = (here, there)
    start = (frozenset(here) | frozenset(['light']), frozenset())
    return lowest_cost_search(start, bsuccessors2, all_over, bcost)

def bsuccessors2(state):
    """Return a dict of {state:action} pairs.  A state is a (here, there) tuple,
    where here and there are frozensets of people (indicated by their times) and/or
    the light."""
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
        
def all_over(state):
    here, there = state
    return not here or here == set(['light'])

def bcost(action):
    "Returns the cost (a number) of an action in the bridge problem."
    # An action is an (a, b, arrow) tuple; a and b are times; arrow is a string
    a, b, arrow = action
    return max(a, b)

def test():
    here = [1, 2, 5, 10]
    assert bridge_problem3(here) == [
            (frozenset([1, 2, 'light', 10, 5]), frozenset([])), 
            ((2, 1, '->'), 2), 
            (frozenset([10, 5]), frozenset([1, 2, 'light'])), 
            ((2, 2, '<-'), 4), 
            (frozenset(['light', 10, 2, 5]), frozenset([1])), 
            ((5, 10, '->'), 14), 
            (frozenset([2]), frozenset([1, 10, 5, 'light'])), 
            ((1, 1, '<-'), 15), 
            (frozenset([1, 2, 'light']), frozenset([10, 5])), 
            ((2, 1, '->'), 17), 
            (frozenset([]), frozenset([1, 10, 2, 5, 'light']))]
    return 'test passes'

test()

#------------------------------------------------------------------------------
# test: 

def bridge_problem4(here):
    """
    Find the fastest (least elapsed time) path to the goal in the bridge problem.
    """
    start = (frozenset(here), frozenset(), 0)
    return lowest_cost_search(start, bsuccessors3, all_over, bcost)

# more succinct by separating "light"
def bsuccessors3(state):
    """
    Return a dict of {state:action} pairs.  State is (here, there, light)
    where here and there are frozen sets of people, light is 0 if the light is 
    on the here side and 1 if it is on the there side.
    Action is a tuple (travelers, arrow) where arrow is '->' or '<-'
    """
    here, there, light = state
    if not light:
        return {
            (here  - frozenset([a, b]), there | frozenset([a, b]), 1):
            ({a, b}, '->')
            for a in here for b in here}
    else:
        return {
            (here  | frozenset([a, b]), there - frozenset([a, b]), 0):
            ({a, b}, '<-')
            for a in there for b in there}

def all_over(state):
    here, there, _ = state
    return not here

def bcost(action):
    """Returns the cost (a number) of an action in the bridge problem."""
    s, arrow = action
    return max(s)

bridge_problem4([1, 2, 5, 10])
