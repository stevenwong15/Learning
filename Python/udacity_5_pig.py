#------------------------------------------------------------------------------
# utilities

from functools import update_wrapper

def decorator(d):
    """
    Make function d a decorator: d wraps a function fn.
    """
    def _d(fn):
        return update_wrapper(d(fn), fn)
    update_wrapper(_d, d)
    return _d

@decorator
def memo(f):
    """
    Decorator that caches the return value for each call to f(args).
    Then when called again with same args, we can just look it up.
    """
    cache = {}
    def _f(*args):
        try:
            return cache[args]
        except KeyError:
            cache[args] = result = f(*args)
            return result
        except TypeError:
            # some element of args can't be a dict key
            return f(args)
    return _f

#------------------------------------------------------------------------------
# game of pig 

import random

other = {0:1, 1:0}  # mapping table, instead of if-else statement
goal = 40

def hold(state):
    """
    Apply the hold action to a state to yield a new state:
    Reap the 'pending' points and it becomes the other player's turn.
    """
    p, me, you, pending = state
    return (other[p], you, me+pending, 0)

def roll(state, d):
    """
    Apply the roll action to a state (and a die roll d) to yield a new state:
    If d is 1, get 1 point (losing any accumulated 'pending' points),
    and it is the other player's turn. If d > 1, add d to 'pending' points.
    """
    p, me, you, pending = state
    if d == 1:
        return (other[p], you, me+d, 0)
    else:
        return (p, me, you, pending+d)

# separate out the dierolls() iterator to do dependency injection
# dependency injection: 
def dierolls():
    while True:
        yield random.randint(1, 6)

# def play_pig(A, B, dierolls=dierolls()):
#     """
#     Play a game of pig between two players, represented by their strategies.
#     Each time through the main loop we ask the current player for one decision,
#     which must be 'hold' or 'roll', and we update the state accordingly.
#     When one player's score exceeds the goal, return that player.
#     """
#     p, me, you, pending = state = (0, 0, 0, 0)
#     player = {0:A, 1:B}
#     while max(me, you) < goal:
#         if p:
#             state = roll(state, next(dierolls)) if A(state) == "roll" else hold(state)
#         else:
#             state = roll(state, next(dierolls)) if B(state) == "roll" else hold(state)
#         p, me, you, _ = state
#     return player[p]

# less repeat, by using a continuous loop (i.e. always True, till return)
def play_pig(A, B, dierolls=dierolls()):
    state = (0, 0, 0, 0)
    strategies = [A, B]
    while True:
        p, me, you, _ = state
        if me >= goal:
            return strategies[p]
        elif you >= goal:
            return strategies[other[p]]
        elif strategies[p](state) == "hold":
            state = hold(state)
        elif strategies[p](state) == "roll":
            state = roll(state, next(dierolls))
        else:
            return strategies[other[p]]

#------------------------------------------------------------------------------
# strategies

# 1
def always_roll(state):
    return 'roll'

# 2
def always_hold(state):
    return 'hold'

# 3
def clueless(state):
    """
    A strategy that ignores the state and chooses at random from possible moves.
    """
    return random.choice(['roll', 'hold'])

# 4
def hold_at(x):
    """
    Return a strategy that holds iff pending >= x or player reaches goal.
    """
    def strategy(state):
        _, me, _, pending = state
        return "hold" if (pending >= x) or (me+pending == goal) else "roll"
    strategy.__name__ = 'hold_at(%d)' % x
    return strategy

# 5
def max_wins(state):
    return best_action(state, pig_actions, Q_pig, Pwin)

# 6
def max_diffs(state):
    return best_action(state, pig_actions, Q_pig, win_diff)

# 5 & 6
# general purpose expectation optimization
def best_action(state, actions, Q, U):
    """
    Return the "max" action for a state, given U:
    state: current state
    actions(state): all actions possible for that state
    EU: expected U for that state and action
    """
    def EU(action): 
        return Q(state, action, U)
    return max(actions(state), key=EU)

# let's say win = 1, loose = 0
# recursively traverse backwards from end point
# assumes opponent also plays with optimal strategy
@memo
def Pwin(state):
    """
    The utility of a state = probability that an optimal player
    whose turn it is to move can win from the current state
    """
    _, me, you, pending = state
    if me + pending >= goal:
        return 1
    elif you >= goal:
        return 0
    else:
        return max(Q_pig(state, action, Pwin) for action in pig_actions(state))

@memo
def win_diff(state):
    """
    The utility of a state: here the winning differential (pos or neg).
    """
    _, me, you, pending = state
    if me + pending >= goal or you >= goal:
        return me + pending - you
    else:
        return max(Q_pig(state, action, win_diff) for action in pig_actions(state))

# expected value of choosing action in state:
# here, utility = probability of winning = Pwin
# 1) E(me win | me hold) = 1 - p(you win | me hold -> your turn)
# me hold means you now get to roll
# 2) E(me win | me roll) = (p(me win | me roll 1) + p(win | me roll 2:6))/6
# = ((1 - p(you win | me roll 1 -> your turn)) + p(win | me roll 2:6))/6
# divide by 6 because equal probability for each of the 6 actions
def Q_pig(state, action, Pwin):  
    if action == 'hold':
        return 1 - Pwin(hold(state))
    if action == 'roll':
        return (
            1 - Pwin(roll(state, 1)) 
            + sum(Pwin(roll(state, d)) for d in (2,3,4,5,6))
            )/6.
    raise ValueError

# The legal actions from a state
def pig_actions(state):
    _, _, _, pending = state
    return ['roll', 'hold'] if pending else ['roll']

#------------------------------------------------------------------------------
# max_wins vs. max_diffs
# breaking program down to understand differences and why

from collections import defaultdict

# all states (where it's my turn)
states = [
    (0, me, you, pending)
    for me in range(goal+1) for you in range(goal+1) for pending in range(goal+1)
    if me + pending <= goal]
len(states)  # 35301

# create a dict that counts instances where the 2 strategies differ
r = defaultdict(int)
for s in states: 
    r[max_wins(s), max_diffs(s)] += 1
# ~12% difference: max_wins is more aggressive by rolling more!
(r[("roll", "hold")])/len(states)
(r[("hold", "roll")])/len(states)

# why?
# let's only look at instances where actions are different
# and how different strategies decide to "roll" based on amount pending:
# * if pending is large enough, max_wins will roll
# * pending is large when gap between me and goal is large
# * so max_wins is more willing to risk to go back to 1 for a chance at winning
# * where as max_diffs will minimize loss
def story():
    r = defaultdict(lambda: [0, 0])  # use lambda for value of default keys
    for s in states:
        w, d = max_wins(s), max_diffs(s)
        if w != d:
            _, _, _, pending = s
            r[pending][0 if (w == "roll") else 1] += 1
    for (delta, (wrolls, drolls)) in sorted(r.items()):
        print("%4d: %3d %3d" % (delta, wrolls, drolls))
story()
