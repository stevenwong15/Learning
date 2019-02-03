#------------------------------------------------------------------------------
# generalizes 
# udacity_4_missionaries_and_cannibals.py
# udacity_4_water_pouring.py

def shortest_path_search(start, successors, is_goal):
    """
    Find the shortest path from start state to a state
    such that is_goal(state) is true.
    """
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
    return []

Fail = []

#------------------------------------------------------------------------------
# test: 

def mc_problem2(start=(3, 3, 1, 0, 0, 0), goal=None):
    # your code here if necessary
    if goal is None:
        def goal_fn(state): return state[:3] == (0, 0, 0)
    else:
        def goal_fu(state): return state == goal
    return shortest_path_search(start, csuccessors, goal_fn)

def csuccessors(state):
    """Find successors (including those that result in dining) to this
    state. But a state where the cannibals can dine has no successors."""
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

