def mc_problem(start=(3, 3, 1, 0, 0, 0), goal=None):
    """
    Solve the missionaries and cannibals problem.
    State is ints: (M1, C2, B1, M2, C2, B2) on the start (1) and other (2) sides.
    Find a path that goes from the initial state to the goal state (which, if
    not specified, is the state with no people or boats on the start size)
    """
    if goal is None:
        goal = (0, 0, 0) + start[:3]
    if start == goal:
        return [start]
    explored = set()
    frontier = [[start]]
    while frontier:
        path = frontier.pop(0)
        s = path[-1]
        for (state, action) in csuccessors(s).items():
            print(state)
            if state not in explored:
                explored.add(state)
                path2 = path + [action, state]
                if state == goal:
                    return path2
                else:
                    frontier.append(path2)
    return {}

def csuccessors(state):
    """Find successors (including those that result in dining) to this
    state. But a state where the cannibals can dine has no successors."""
    M1, C1, B1, M2, C2, B2 = state
    if (C1 > M1) or (C2 > M2):
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

def test():
    assert csuccessors((2, 2, 1, 0, 0, 0)) == {(2, 1, 0, 0, 1, 1): 'C->', 
                                               (1, 2, 0, 1, 0, 1): 'M->', 
                                               (0, 2, 0, 2, 0, 1): 'MM->', 
                                               (1, 1, 0, 1, 1, 1): 'MC->', 
                                               (2, 0, 0, 0, 2, 1): 'CC->'}
    assert csuccessors((1, 1, 0, 4, 3, 1)) == {(1, 2, 1, 4, 2, 0): '<-C', 
                                               (2, 1, 1, 3, 3, 0): '<-M', 
                                               (3, 1, 1, 2, 3, 0): '<-MM', 
                                               (1, 3, 1, 4, 1, 0): '<-CC', 
                                               (2, 2, 1, 3, 2, 0): '<-MC'}
    assert csuccessors((1, 4, 1, 2, 2, 0)) == {}
    return 'tests pass'

test()

mc_problem((3, 3, 1, 0, 0, 0))
