# steps:
# - understand
# - define pieces
# - reuse
# - test
# - explore
# think about tradeoffs:
# - correctness
# - efficiency
# - feature
# - elegance
# computing (e.g. sin) vs. doing (e.g. shuffle)
# - use computing unless too many states to track
# - doing changes object so harder to test

#------------------------------------------------------------------------------
import random
import itertools

# generate list with list comprehension
# [r+s for r in "23456789TJQKA" for s in "SHDC"]
def deal(numhands, n=5, deck=[r+s for r in "23456789TJQKA" for s in "SHDC"]):
    random.shuffle(deck)
    return [deck[n*i:n*(i+1)] for i in range(numhands)]

# deal(12)

def poker(hands):
    "Return a list of winning hands: poker([hand,...]) => [hand,...]"
    return allmax(hands, key=hand_rank)

# return all the max, as opposed to a random one
# assign two values at once: a, b = 1, 2
# ifelse statement with "or": a = None or 1
def allmax(iterable, key=None):
    "Return a list of all items equal to the max of the iterable."
    result, maxval = [], None
    key = key or (lambda x: x)
    for x in iterable:
        xval = key(x)
        if not result or xval > maxval:
            result, maxval = [x], xval
        elif xval == maxval:
            result.append(x)
    return result

# allmax([1, 2, 2])

def best_hand(hand):
    "From a 7-card hand, return the best 5 card hand."
    return max(itertools.combinations(hand, 5), key=hand_rank)

allranks = "23456789TJQKA"
redcards = [r+s for r in allranks for s  in "DH"]
blackcards = [r+s for r in allranks for s  in "SC"]

# get all combination first, then use set() to remove duplicates
def best_wild_hand(hand):
    "Try all values for jokers in all 5-card selections."
    hands = set(best_hand(set(h)) for h in itertools.product(*map(replacements, hand)))
    return max(hands, key=hand_rank)

def replacements(card):
    """Return a list of the possible replacements for a card.
    There will be more than 1 only for wild cards."""
    if card == "?B": return blackcards
    elif card == "?R": return redcards
    else: return [card]
  
# solution I wrote: not leveraging exisitng functions enough
# def best_wild_hand(hand):
#     "Try all values for jokers in all 5-card selections."
#     b_wild = [[r+s] for r in "23456789TJQKA" for s in "SC" if r+s not in hand]
#     r_wild = [[r+s] for r in "23456789TJQKA" for s in "HD" if r+s not in hand]
#     result = []
#     if "?R" in hand and "?B" in hand:
#         hand.remove("?R")
#         hand.remove("?B")
#         result.extend([list(itertools.chain(*i)) for i in itertools.product(itertools.combinations(hand, 3), r_wild, b_wild)])
#         result.extend([list(itertools.chain(*i)) for i in itertools.product(itertools.combinations(hand, 4), r_wild)])
#         result.extend([list(itertools.chain(*i)) for i in itertools.product(itertools.combinations(hand, 4), b_wild)])
#     elif "?R" in hand:
#         hand.remove("?R")
#         result.extend([list(itertools.chain(*i)) for i in itertools.product(itertools.combinations(hand, 4), r_wild)])
#     elif "?B" in hand:
#         hand.remove("?B")
#         result.extend([list(itertools.chain(*i)) for i in itertools.product(itertools.combinations(hand, 4), b_wild)])
#     result.extend([list(itertools.chain(*i)) for i in itertools.product(itertools.combinations(hand, 5))])
#     return max(result, key=hand_rank)

#------------------------------------------------------------------------------
# hand_rank #1

# use return as conditional statements
def hand_rank(hand):
    "Return a value indicating how high the hand ranks."
    ranks = card_ranks(hand)
    if straight(ranks) and flush(hand):            # straight flush
        return (8, max(ranks))
    elif kind(4, ranks):                           # 4 of a kind
        return (7, kind(4, ranks), ranks)
    elif kind(3, ranks) and kind(2, ranks):        # full house
        return (6, kind(3, ranks), kind(2, ranks))
    elif flush(hand):                              # flush
        return (5, ranks)
    elif straight(ranks):                          # straight
        return (4, max(ranks))
    elif kind(3, ranks):                           # 3 of a kind
        return (3, kind(3, ranks), ranks)
    elif two_pair(ranks):                          # 2 pair
        return (2, two_pair(ranks))
    elif kind(2, ranks):                           # kind
        return (1, kind(2, ranks), ranks)
    else:                                          # high card
        return (0, ranks)

# split string of an iterable
# use index to match list with rank
# return a ifelse statement
def card_ranks(cards):
    "Return a list of the ranks, sorted with higher first."
    ranks = ["--23456789TJQKA".index(r) for r,s in cards]
    ranks.sort(reverse=True)
    return [5, 4, 3, 2, 1] if ranks == [14, 5, 4, 3, 2] else ranks

# ["--23456789TJQKA".index(r) for r,s in ["AC", "JC", "QC", "KC", "TC"]]

# see what straight is trying to do
def straight(ranks):
    "Return True if the ordered ranks form a 5-card straight."
    return (max(ranks)-min(ranks) == 4) and len(set(ranks)) == 5

# unique using set comprehension and length
def flush(hand):
    "Return True if all the cards have the same suit."
    return len(set(s for r,s in hand)) == 1

# .count() to get number
def kind(n, ranks):
    """Return the first rank that this hand has exactly n of.
    Return None if there is no n-of-a-kind in the hand."""
    for r in ranks:
        if ranks.count(r) == n:
            return r
    return None

# use existing function kind() to help
def two_pair(ranks):
    """If there are two pair, return the two ranks as a
    tuple: (highest, lowest); otherwise return None."""
    high_pair = kind(2, ranks)
    low_pair = kind(2, list(reversed(ranks)))
    if high_pair != low_pair:
        return (high_pair, low_pair)
    else:
        return None

#------------------------------------------------------------------------------
# hand_rank #2

# uses an extended tenary statement in return
# tuples, like lists, compare left ot right
def hand_rank(hand):
    "Return a value indicating how high the hand ranks."
    groups = group(["--23456789TJQKA".index(r) for r,s in hand])
    counts, ranks = unzip(groups)
    if ranks == (14, 5, 4, 3, 2):
        ranks = (5, 4, 3, 2, 1)
    straight = (max(ranks)-min(ranks) == 4) and len(set(ranks)) == 5
    flush = len(set(s for r,s in hand)) == 1
    return (
        9 if (5, ) == counts else  # trailing comma to turn into a tuple
        8 if straight and flush else
        7 if (4, 1) == counts else
        6 if (3, 2) == counts else
        5 if flush else
        4 if straight else
        3 if (3, 1, 1) == counts else
        2 if (2, 2, 1) == counts else
        1 if (2, 1, 1, 1) == counts else
        0), ranks

# tuple of count and value; tuple because sortable, unlike dictionary
def group(items):
    "Return a list of [(count, x)...], highest count first, then highest x first"
    groups = [(items.count(x), x) for x in set(items)]
    return sorted(groups, reverse=True)

def unzip(pairs): return zip(*pairs)

#------------------------------------------------------------------------------
# hand_rank #3

# uses a dictionary to look up values: rankings will be slightly different
def hand_rank(hand):
    "Return a value indicating how high the hand ranks."
    groups = group(["--23456789TJQKA".index(r) for r,s in hand])
    counts, ranks = unzip(groups)
    if ranks == (14, 5, 4, 3, 2):
        ranks = (5, 4, 3, 2, 1)
    straight = (max(ranks)-min(ranks) == 4) and len(set(ranks)) == 5
    flush = len(set(s for r,s in hand)) == 1
    return max(count_rankings[counts], 4*straight + 5*flush), ranks

count_rankings = {
    (5,):10,
    (4,1):7,
    (3,2):6,
    (3,1,1):3,
    (2,2,1):2,
    (2,1,1,1):1,
    (1,1,1,1,1):0}

# tuple of count and value; tuple because sortable, unlike dictionary
def group(items):
    "Return a list of [(count, x)...], highest count first, then highest x first"
    groups = [(items.count(x), x) for x in set(items)]
    return sorted(groups, reverse=True)

def unzip(pairs): return zip(*pairs)

#------------------------------------------------------------------------------
# test, for #2

def test():
    "Test cases for the functions in poker program"
    sf = "6C 7C 8C 9C TC".split() # Straight Flush
    fk = "9D 9H 9S 9C 7D".split() # Four of a Kind
    fh = "TD TC TH 7C 7D".split() # Full House
    tp = "5S 5D 9H 9C 6S".split() # Two pairs
    fkranks = card_ranks(fk)
    tpranks = card_ranks(tp)
    assert kind(4, fkranks) == 9
    assert kind(3, fkranks) == None
    assert kind(2, fkranks) == None
    assert kind(1, fkranks) == 7
    assert straight([9, 8, 7, 6, 5]) == True
    assert straight([9, 8, 8, 6, 5]) == False
    assert card_ranks(sf) == [10, 9, 8, 7, 6]
    assert card_ranks(fk) == [9, 9, 9, 9, 7]
    assert card_ranks(fh) == [10, 10, 10, 7, 7]
    assert poker([sf, fk, fh]) == [sf]
    assert poker([fk, fh]) == [fk]
    assert poker([fh, fh]) == [fh, fh]
    assert poker([sf]) == [sf]
    assert poker([sf] + 99*[fh]) == [sf]
    # assert hand_rank(sf) == (8, 10)
    # assert hand_rank(fk) == (7, 9, [9, 9, 9, 9, 7])
    # assert hand_rank(fh) == (6, 10, 7)
    assert hand_rank(sf) == (8, (10, 9, 8, 7, 6))
    assert hand_rank(fk) == (7, (9, 7))
    assert hand_rank(fh) == (6, (10, 7))
    # assert hand_rank(sf) == (9, (10, 9, 8, 7, 6))
    # assert hand_rank(fk) == (7, (9, 7))
    # assert hand_rank(fh) == (6, (10, 7))
    return 'tests pass'

def test_best_hand():
    assert (sorted(best_hand("6C 7C 8C 9C TC 5C JS".split()))
            == ['6C', '7C', '8C', '9C', 'TC'])
    assert (sorted(best_hand("TD TC TH 7C 7D 8C 8S".split()))
            == ['8C', '8S', 'TC', 'TD', 'TH'])
    assert (sorted(best_hand("JD TC TH 7C 7D 7S 7H".split()))
            == ['7C', '7D', '7H', '7S', 'JD'])
    return 'test_best_hand passes'

def test_best_wild_hand():
    assert (sorted(best_wild_hand("6C 7C 8C 9C TC 5C ?B".split()))
            == ['7C', '8C', '9C', 'JC', 'TC'])
    assert (sorted(best_wild_hand("TD TC 5H 5C 7C ?R ?B".split()))
            == ['7C', 'TC', 'TD', 'TH', 'TS'])
    assert (sorted(best_wild_hand("JD TC TH 7C 7D 7S 7H".split()))
            == ['7C', '7D', '7H', '7S', 'JD'])
    return 'test_best_wild_hand passes'

test_best_wild_hand()

#------------------------------------------------------------------------------
# shuffle, without using random.shuffle

# range(N-1) because last one doesn't need to be shuffled
def shuffle(deck):
    "Knuth's Algorithm P."
    N = len(deck)
    for i in range(N-1):
        swap(deck, i, random.randrange(i, N))

def swap(deck, i, j):
    "Swap elements i and j of a collection"
    print("swap", i, j)
    deck[i], deck[j] = deck[j], deck[i]

a = [1, 2, 3]
shuffle(a)
print(a)

