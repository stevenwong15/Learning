#------------------------------------------------------------------------------
# game of pig with doubling
#
# Doubling: at any point in the game, a player (let's say player A) can
# offer to 'double' the game. 
# Player B then has to decide to 'accept', in which case the game is played 
# through as normal, but it is now worth two points, or 'decline,' 
# in which case player B immediately loses and player A wins one point. 

import random

other = {1:0, 0:1}
goal = 40

def dierolls():
    """
    Generate die rolls.
    """
    while True:
        yield random.randint(1, 6)

def play_pig_d(A, B, dierolls=dierolls()):
    """
    Play a game of pig between two players, represented by their strategies.
    Each time through the main loop we ask the current player for one decision,
    which must be 'hold' or 'roll', and we update the state accordingly.
    When one player's score exceeds the goal, return that player.
    """
    state = (0, 0, 0, 0, 1)
    strategies = [A, B]
    while True:
        p, me, you, _, double = state
        if me >= goal:
            return strategies[p], double
        elif you >= goal:
            return strategies[other[p]], double
        else:
            action = strategies[p](state)
            state = do(action, state, dierolls)

# No more roll() and hold(); instead, do:
def do(action, state, dierolls):
    """
    Return the state that results from doing action in state.
    If action is not legal, return a state where the opponent wins.
    Can use dierolls if needed.
    """
    p, me, you, pending, double = state
    if action not in pig_actions_d(state):
        return (other[p], goal, 0, 0, double)
    elif action == "roll":
        d = next(dierolls)
        if d == 1:
            return (other[p], you, me+1, 0, double)
        else:
            return (p, me, you, pending+d, double)
    elif action == "hold":
        return (other[p], you, me+pending, 0, double)
    elif action == "double":
        return (other[p], you, me, pending, "double")
    elif action == "decline":
        return (other[p], goal, 0, 0, 1)
    elif action == "accept":
        return (other[p], you, me, pending, 2)

# def pig_actions_d(state):
#     """The legal actions from a state. Usually, ["roll", "hold"].
#     Exceptions: If double is "double", can only "accept" or "decline".
#     Can't "hold" if pending is 0.
#     If double is 1, can "double" (in addition to other moves).
#     (If double > 1, cannot "double").
#     """
#     # state is like before, but with one more component, double,
#     # which is 1 or 2 to denote the value of the game, or 'double'
#     # for the moment at which one player has doubled and is waiting
#     # for the other to accept or decline
#     _, _, _, pending, double = state
#     if double == "double":
#         return ["accept", "decline"]
#     elif double > 1:
#         if pending == 0:
#             return ["roll"]
#         else:
#             return ["roll", "hold"]
#     if double == 1:
#         if pending == 0:
#             return ["roll", "double"]
#         else:
#             return ["roll", "hold", "double"]

# intead of writing many cases, use append 
def pig_actions_d(state):
    _, _, _, pending, double = state
    if double == "double":
        actions = ["accept", "decline"]
    elif pending:
        actions = ["roll", "hold"]
    else:
        actions = ["roll"]
    if double == 1:
        actions.append("double")
    return actions

#------------------------------------------------------------------------------
# strategies

def strategy_d(state):
    _, me, you, pending, double = state
    if (double == 1) and (me + pending >= 35):
        return "double"
    elif (me + pending >= goal):
        return "hold"
    else:
        return "roll"

strategy_compare(strategy_d, hold_20_d)

def hold_20_d(state):
    _, me, _, pending, double = state
    if double == "double":
        return "accept"
    elif (pending >= 20 or me + pending >= goal):
        return "hold"
    else:
        return "roll"

def clueless_d(state):
    return random.choice(pig_actions_d(state))
     
def strategy_compare(A, B, N=1000):
    """
    Takes two strategies, A and B, and returns % of points won by strategy A
    """
    A_points, B_points = 0, 0
    for i in range(N):
        if i % 2 == 0:  # take turns with who goes first
            winner, points = play_pig_d(A, B)
        else: 
            winner, points = play_pig_d(B, A)
        if winner.__name__ == A.__name__:
            A_points += points
        else: 
            B_points += points
    A_percent = 100*A_points / float(A_points + B_points)
    print("In %s games of pig, strategy %s took %s percent of the points against %s." % (N, A.__name__, A_percent, B.__name__))
    return A_percent

def test():
    assert set(pig_actions_d((0, 2, 3, 0, 1)))          == set(['roll', 'double'])
    assert set(pig_actions_d((1, 20, 30, 5, 2)))        == set(['hold', 'roll']) 
    assert set(pig_actions_d((0, 5, 5, 5, 1)))          == set(['roll', 'hold', 'double'])
    assert set(pig_actions_d((1, 10, 15, 6, 'double'))) == set(['accept', 'decline']) 
    assert strategy_compare(strategy_d, hold_20_d) > 60 # must win 60% of the points      
    return 'test passes'

test()
