#------------------------------------------------------------------------------
# generalizes 
# udacity_4_missionaries_and_cannibals.py
# udacity_4_water_pouring.py

def shortest_path_search(start, successors, is_goal):
    """
    Find the shortest path from start state to a state 
    such that is_goal(state) is true.
    """
    Fail = []
    if is_goal(start):
        return [start]
    explored = set() # set of states we have visited
    frontier = [ [start] ] # ordered list of paths we have blazed
    while frontier:
        path = frontier.pop(0)
        for (state, action) in successors(path[-1]).items():
            if state not in explored:
                explored.add(state)
                path2 = path + [action, state]
                if is_goal(state):
                    return path2
                else:
                    frontier.append(path2)
    return Fail

#------------------------------------------------------------------------------
# test: 

def mc_problem2(start=(3, 3, 1, 0, 0, 0), goal=None):
    if goal is None:
        def goal_fn(state): return state[:3] == (0, 0, 0)
    else:
        def goal_fu(state): return state == goal
    return shortest_path_search(start, csuccessors, goal_fn)

def csuccessors(state):
    """
    Find successors (including those that result in dining) to this
    state. But a state where the cannibals can dine has no successors.
    """
    M1, C1, B1, M2, C2, B2 = state
    if (C1 > M1 > 0) or (C2 > M2 > 0):
      return {}
    elif B1:
      return {
        (M1-m, C1-c, 0, M2+m, C2+c, 1): "M"*m+"C"*c+"->"
        for m in range(3) if (M1-m >= 0)
        for c in range(2-m+1) if (C1-c >= 0) and (not m == c == 0)
      }
    else:
      return {
        (M1+m, C1+c, 1, M2-m, C2-c, 0): "<-"+"M"*m+"C"*c
        for m in range(3) if (M2-m >= 0)
        for c in range(2-m+1)if (C2-c >= 0) and (not m == c == 0)
      }

mc_problem2(start=(3, 3, 1, 0, 0, 0), goal=None)

#------------------------------------------------------------------------------
# test: 

def more_pour_problem(capacities, goal, start=None):
    """
    The first argument is a tuple of capacities (numbers) of glasses; the
    goal is a number which we must achieve in some glass. Start is a tuple
    of starting levels for each glass; if None, that means 0 for all.
    Start at start state and follow successors until we reach the goal.
    Keep track of frontier and previously explored; fail when no frontier.
    On success return a path: a [state, action, state2, ...] list, where an
    action is one of ('fill', i), ('empty', i), ('pour', i, j), where
    i and j are indices indicating the glass number.
    """
    if start is None:
        start = (0,)*len(capacities)

    def replace(state, i, val):
        s = list(state)
        s[i] = val
        return type(state)(s)

    # instead of dict comprehension with tuples (too complicated)
    # use loop and lists, converting them back to tuples
    def successors(state):
        indices = range(len(state))
        succ = {}
        for i in indices:
            succ[replace(state, i, capacities[i])] = ("fill", i)
            succ[replace(state, i, 0)] = ("empty", i)
            for j in indices:
                if i != j:
                    delta = min(state[i], capacities[j] - state[j])
                    state_i = replace(state, i, state[i] - delta)
                    succ[replace(state_i, j, state[j] + delta)] = ("pour", i, j)
        return succ

    def is_goal(state): 
        return goal in state

    return shortest_path_search(start, successors, is_goal)

def test_more_pour():
    assert more_pour_problem((1, 2, 4, 8), 4) == [
        (0, 0, 0, 0), ('fill', 2), (0, 0, 4, 0)]
    assert more_pour_problem((1, 2, 4), 3) == [
        (0, 0, 0), ('fill', 2), (0, 0, 4), ('pour', 2, 0), (1, 0, 3)] 
    starbucks = (8, 12, 16, 20, 24)
    assert not any(more_pour_problem(starbucks, odd) for odd in (3, 5, 7, 9))
    assert all(more_pour_problem((1, 3, 9, 27), n) for n in range(28))
    assert more_pour_problem((1, 3, 9, 27), 28) == []
    return 'test_more_pour passes'

test_more_pour()

#------------------------------------------------------------------------------
# test: 

def subway(**lines):
    """
    Define a subway map. Input is subway(linename='station1 station2...'...).
    Convert that and return a dict of the form: {station:{neighbor:line,...},...}
    """
    subway_map = {}
    for line, stations in lines.items():
        stations = stations.split()
        for i, v in enumerate(stations):
            (subway_map
                .setdefault(stations[i], {})
                .update({stations[j]: line for j in (i-1, i+1) if j in range(len(stations))}))
    return subway_map    

# better:
# use collection to define a dict of dict
# look at opposing directions for a pair of stations at once
import collections
def subway(**lines):
    subway_map = collections.defaultdict(dict)
    for line, stations in lines.items():
        stations = stations.split()
        pairs = [stations[i:i+2] for i in range(len(stations)-1)]
        for i, j in pairs:
            subway_map[i][j] = line
            subway_map[j][i] = line
    return subway_map    

boston = subway(
    blue='bowdoin government state aquarium maverick airport suffolk revere wonderland',
    orange='oakgrove sullivan haymarket state downtown chinatown tufts backbay foresthills',
    green='lechmere science north haymarket government park copley kenmore newton riverside',
    red='alewife davis porter harvard central mit charles park downtown south umass mattapan')

def ride(here, there, system=boston):
    """
    Return a path on the subway system from here to there.
    """
    def successors(state):
        return system[state]
    def is_goal(state):
        return there in state
    return shortest_path_search(here, successors, is_goal)

# better: shorter
def ride(here, there, system=boston):
    return shortest_path_search(here, lambda s: system[s] , lambda s: s == there)

def longest_ride(system):
    """
    return the longest possible 'shortest path' ride between any two stops in the system.
    """
    return max([ride(i, j) for i in system for j in system], key=len)

def path_states(path):
    "Return a list of states in this path."
    return path[0::2]
    
def path_actions(path):
    "Return a list of actions in this path."
    return path[1::2]

def test_ride():
    assert ride('mit', 'government') == [
        'mit', 'red', 'charles', 'red', 'park', 'green', 'government']
    assert ride('mattapan', 'foresthills') == [
        'mattapan', 'red', 'umass', 'red', 'south', 'red', 'downtown',
        'orange', 'chinatown', 'orange', 'tufts', 'orange', 'backbay', 'orange', 'foresthills']
    assert ride('newton', 'alewife') == [
        'newton', 'green', 'kenmore', 'green', 'copley', 'green', 'park', 'red', 'charles', 'red',
        'mit', 'red', 'central', 'red', 'harvard', 'red', 'porter', 'red', 'davis', 'red', 'alewife']
    assert (path_states(longest_ride(boston)) == [
        'wonderland', 'revere', 'suffolk', 'airport', 'maverick', 'aquarium', 'state', 'downtown', 'park',
        'charles', 'mit', 'central', 'harvard', 'porter', 'davis', 'alewife'] or 
        path_states(longest_ride(boston)) == [
                'alewife', 'davis', 'porter', 'harvard', 'central', 'mit', 'charles', 
                'park', 'downtown', 'state', 'aquarium', 'maverick', 'airport', 'suffolk', 'revere', 'wonderland'])
    assert len(path_states(longest_ride(boston))) == 16
    return 'test_ride passes'

test_ride()
