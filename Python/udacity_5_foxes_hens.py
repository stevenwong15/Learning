#------------------------------------------------------------------------------
# foxes and hens
# 
# This problem deals with the one-player game foxes_and_hens. This 
# game is played with a deck of cards in which each card is labelled
# as a hen 'H', or a fox 'F'. 
# 
# A player will flip over a random card. If that card is a hen, it is
# added to the yard. If it is a fox, all of the hens currently in the
# yard are removed.
#
# Before drawing a card, the player has the choice of two actions, 
# 'gather' or 'wait'. If the player gathers, she collects all the hens
# in the yard and adds them to her score. The drawn card is discarded.
# If the player waits, she sees the next card. 

import random

def foxes_and_hens(strategy, foxes=7, hens=45):
    """
    Play the game of foxes and hens
    """
    state = (score, yard, cards) = (0, 0, "F"*foxes + "H"*hens)
    while cards:
        action = strategy(state)
        state = (score, yard, cards) = do(action, state)
    return score + yard

# def do(action, state):
#     """
#     Apply action to state, returning a new state.
#     """
#     score, yard, cards = state
#     cards = list(cards)
#     random.shuffle(cards)
#     card = cards.pop()
#     cards.sort()
#     cards = "".join(cards)
#     if action == "wait":
#         if card == "H":
#             return (score, yard + 1, cards)
#         elif card == "F":
#             return (score, 0, cards)
#     elif action == "gather":
#         return (score + yard, 0, cards)

# more concise than shuffling and popping
def do(action, state):
    """
    Apply action to state, returning a new state.
    """
    score, yard, cards = state
    card = random.choice(cards)
    cards_left = cards.replace(card, "", 1)
    if action == "wait":
        if card == "H":
            return (score, yard + 1, cards_left)
        elif card == "F":
            return (score, 0, cards_left)
    elif action == "gather":
        return (score + yard, 0, cards_left)
    else:
        return state

#------------------------------------------------------------------------------
# strategies

def strategy(state):
    """
    A strategy that waits until there are 8 hens in yard, then gathers.
    E[n till F] = 1/P(F) = 1/(n_f/(n_f+n_h))
    divided by 2 to be safe
    """
    _, yard, cards = state
    n_f = cards.count("F")
    n_h = cards.count("H")
    if n_f == 0:
        return "wait"
    elif n_h == 0:
        return "gather"
    elif yard < (n_f+n_h)/n_f/2:
        return "wait"
    else:
        return "gather"

def take5(state):
    """
    A strategy that waits until there are 5 hens in yard, then gathers.
    """
    _, yard, _ = state
    if yard < 5:
        return "wait"
    else:
        return "gather"

def average_score(strategy, N=1000):
    return sum(foxes_and_hens(strategy) for _ in range(N)) / float(N)

def superior(A, B=take5):
    """
    Does strategy A have a higher average score than B, by more than 1.5 point?
    """
    return average_score(A) - average_score(B) > 1.5

def test():
    gather = do('gather', (4, 5, 'F'*4 + 'H'*10))
    assert (gather == (9, 0, 'F'*3 + 'H'*10) or 
            gather == (9, 0, 'F'*4 + 'H'*9))
    
    wait = do('wait', (10, 3, 'FFHH'))
    assert (wait == (10, 4, 'FFH') or
            wait == (10, 0, 'FHH'))
    
    assert superior(strategy)
    return 'tests pass'

test()   
