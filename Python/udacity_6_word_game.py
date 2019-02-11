import time

#------------------------------------------------------------------------------
# read dictionary

def prefixes(word):
    """
    A list of the initial sequences of a word, not including the complete word.
    """
    return [word[:i] for i in range(len(word))]

def readwordlist(filename):
    """
    Read the words from a file and return a set of the words 
    and a set of the prefixes.
    """
    wordset = set(open(filename).read().upper().split())
	prefixset = set(i for word in wordset for i in prefixes(word))
    return wordset, prefixset
    
WORDS, PREFIXES = readwordlist("words4k.txt")

POINTS = dict(
    A=1, B=3, C=3, D=2, E=1, F=4, G=2, H=4, I=1, J=8, K=5, L=1, M=3, N=1, 
    O=1, P=3, Q=10, R=1, S=1, T=1, U=1, V=4, W=4, X=8, Y=4, Z=10, _=0)

#------------------------------------------------------------------------------
# find words from hand

# recursively, for each L in letters:
# add each remainder (letter.replace(L, "", 1)) to it and check
def find_words(letters, pre="", results=None):
	if results is None: results = set()
    if pre in WORDS: results.add(pre)
    if pre in PREFIXES:
        for L in letters:
        	find_words(letters.replace(L, "", 1), pre+L, results)
    return results

#------------------------------------------------------------------------------
# find words from hand + letters on a board

# Find prefix + L + suffix, where L from board_letters, rest from hand
def word_plays(hand, board_letters):
    results = set()
    for pre in find_prefixes(hand, '', set()):
        for L in board_letters:
            add_suffixes(removed(hand, pre), pre+L, results)
    return results

# similar to find_words, but only adds prefixes
def find_prefixes(hand, pre='', results=None):
    """
    Find all prefixes (of words) that can be made from letters in hand.
    """
    if results is None: results = set()
    if pre in PREFIXES:
        results.add(pre)
        for L in hand:
            find_prefixes(removed(hand, L), pre+L, results)
    return results

def add_suffixes(hand, pre, results):
    """
    Return the set of words that can be formed by extending pre with letters in hand.
    """
    if results is None: results = set()
    if pre in WORDS: results.add(pre)
    if pre in PREFIXES:
        for L in hand:
            find_prefixes(removed(hand, L), pre+L, results)
    return results

def removed(letters, remove):
    """
    Return a str of letters, but with each letter in remove removed once.
    """
    for L in remove:
        letters = letters.replace(L, '', 1)
    return letters

def longest_words(hand, board_letters):
    """
    Return all word plays, longest first.
    """
    return sorted(word_plays(hand, board_letters), key=len, reverse=True)

def word_score(word):
    """
    The sum of the individual letter point scores for this word.
    """
    return sum(POINTS[i] for i in word)

def topn(hand, board_letters, n=10):
    """
    Return a list of the top n words that hand can play, sorted by word score.
    """
    return sorted(word_plays(hand, board_letters), key=word_score, reverse=True)[:n]

#------------------------------------------------------------------------------
# find words from hand + row, considering constraints

class anchor(set):
    """
    An anchor is where a new word can be placed; has a set of allowable letters
    Left of anchor: prefix
    Right of anchor: suffix
    """

LETTERS = list("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
ANY = anchor(LETTERS)  # an anchor that can be any letter

# example: |A.....BE.C...D.|
# using "|" to keep track of which spaces/letters are end of the board
mnx, moab = anchor("MNX"), anchor("MOAB")  # anchors that are more restricted
a_row = ["|", "A", mnx, moab, ".", ".", ANY, "B", "E", 
    ANY, "C", ANY, ".", ANY, ".", ANY, "D", ANY, "|"]

def is_letter(sq):
    return isinstance(sq, str) and sq in LETTERS

def is_empty(sq):
    """
    Is this an empty square (no letters, but a valid position on board).
    """
    return sq  == '.' or sq == '*' or isinstance(sq, set) 

# plays a row:
# for each square (sq) in the row, if anchor:
# find all legal prefixes:
# 1) if there are existing prefixes, add suffixes
# 2) else, for all available prefixes that fits the length, add suffixes
def row_plays(hand, row):
    """
    Return a set of legal plays in a row. A row play is an (i, "WORD") pair
    """
    for (i, sq) in enumerate(row[1:-1], 1):
        if isinstance(sq, anchor):
            pre, maxsize = legal_prefix(i, row)
            if pre: 
                start = i - len(pre)
                add_suffixes(hand, pre, start, row, results, 
                    anchored=False)
            else:
                for pre in find_prefixes(hand):
                    if len(pre) <= maxsize:
                        start = i - len(pre)
                        add_suffixes(removed(hand, pre), pre, start, row, results, 
                            anchored=False)
    return results

# example: legal_prefix(9, a_row) == ('BE', 2); for 6, ('', 2)
# move left from anchor, till the first non-letter
# if there is 1/+ letters: return (letters, spaces)
# else, move left, till empty and not an anchor: return ("", spaces)
def legal_prefix(i, row):
    """
    A legal prefix of an anchor at row[i] is either a string of letters
    already on the board, or new letters that fit into an empty space.
    Return the tuple (prefix_on_board, maxsize) to indicate this.
    """
    s = i
    while is_letter(row[s-1]): s -= 1 
    if s < i: return (''.join(row[s:i]), i-s)
    while is_empty(row[s-1]) and not isinstance(row[s-1], set): s -= 1
    return ('', i-s)

# anchored=True means added anchor (i.e. not just letters on the board)
# if pre is a word, anchor included and no letter to the right, include pre
# else if pre is a prefix:
# * if there's a letter at i, add the letter
# * else go through possibilities
def add_suffixes(hand, pre, start, row, results, anchored=True):
    """
    Add all possible suffixes, and accumulate (start, word) pairs in results
    """
    i = start + len(pre)
    if pre in WORDS and anchored and not is_letter(row[i]):
        results.add((start, pre))
    if pre in PREFIXES:       
        sq = row[i]
        if is_letter(sq):
            add_suffixes(hand, pre+sq, start, row, results)        
        elif is_empty(sq):        
            possibilities = sq if isinstance(sq, set) else ANY
            for L in hand:
                if L in possibilities:
                    add_suffixes(hand.replace(L, '', 1), pre+L, start, row, results)
    return results

# in row_plays(), find_prefixes() gets called in every loop, which is slow
# so, build a cache for find_prefixes(), and set it as global variables
# find_prefixes() returns both prefixes and words, since:
# * the "pivot" between pre/suff is an anchor, not letter
# * thus, you can go without suffix to form a word
prev_hand, prev_results = "", set()
def find_prefixes(hand, pre="", results=None):
    global prev_hand, prev_results
    if hand == prev_hand: return prev_results
    if results is None: results = set()
    # at the root of recursion, cache results
    if pre == "": prev_hand, prev_results = hand, results
    if pre in WORDS or pre in PREFIXES: results.add(pre)
    if pre in PREFIXES:
        for L in hand:
            find_prefixes(hand.replace(L, "", 1), pre+L, results)
    return results

#------------------------------------------------------------------------------
# find words from hand + board, considering constraints

def neighbors(board, i, j):
    """
    Return the four neighboring squares, in the order N,S,E,W
    """
    return [board[j-1][i], board[j+1][i],
            board[j][i+1], board[j][i-1]]

def find_cross_word(board, i, j):
    """
    Find the vertical word that crosses board[j][i]; return (starting row, word)
    """
    sq = board[j][i]
    w = sq if is_letter(sq) else '.'
    # from j, go up
    for j2 in range(j, 0, -1):
        sq2 = board[j2-1][i]
        if is_letter(sq2): w = sq2 + w
        else: break
    # from j, go down
    for j3 in range(j+1, len(board)):
        sq3 = board[j3][i]
        if is_letter(sq3): w = w + sq3
        else: break
    return (j2, w)

def set_anchors(row, j, board):
    """
    Adjust the board to include anchors
    Anchors are empty squares with a neighboring letter or "*"
    Some are resticted by cross-words to be only a subset of letters.
    """
    for (i, sq) in enumerate(row[1:-1], 1):
        neighborlist = (N,S,E,W) = neighbors(board, i, j)
        if sq == '*' or (is_empty(sq) and any(map(is_letter, neighborlist))):    
            if is_letter(N) or is_letter(S):   
                _, w = find_cross_word(board, i, j)
                row[i] = anchor(L for L in LETTERS if w.replace('.', L) in WORDS)
            else:
                row[i] = ANY

def horizontal_plays(hand, board):
    """
    Find all horizontal plays -- ((i, j), word) pairs -- across all rows.
    """
    results = set()
    for (j, row) in enumerate(board[1:-1], 1):
        set_anchors(row, j, board)
        for i, word in row_plays(hand, row):
            results.add(((i, j), word))
    return results

def transpose(matrix):
    return list(map(list, zip(*matrix)))

ACROSS, DOWN = (1, 0), (0, 1) # Directions that words can go

def all_plays(hand, board):
    """
    All plays in both directions. A play is a (pos, dir, word) tuple,
    where pos is an (i, j) pair, and dir is ACROSS or DOWN.
    """
    hplays = horizontal_plays(hand, board)            # set of ((i, j), word)
    vplays = horizontal_plays(hand, transpose(board)) # set of ((j, i), word)
    return (
        {((i, j), ACROSS, word) for ((i, j), word) in hplays} |
        {((i, j), DOWN, word) for ((j, i), word) in vplays})

#------------------------------------------------------------------------------
# computing score

def calculate_score(board, pos, direction, hand, word):
    """
    Return the total score for this play.
    """
    total, crosstotal, word_mult = 0, 0, 1
    starti, startj = pos
    di, dj = direction
    other_direction = DOWN if direction == ACROSS else ACROSS
    for (n, L) in enumerate(word):
        i, j = starti + n*di, startj + n*dj
        sq = board[j][i]
        b = BONUS[j][i]
        word_mult *= (1 if is_letter(sq) else
                      3 if b == TW else 2 if b in (DW,'*') else 1)
        letter_mult = (1 if is_letter(sq) else
                       3 if b == TL else 2 if b == DL else 1)
        total += POINTS[L] * letter_mult
        if isinstance(sq, set) and sq is not ANY and direction is not DOWN:
            crosstotal += cross_word_score(board, L, (i, j), other_direction)
    return crosstotal + word_mult * total

def cross_word_score(board, L, pos, direction):
    """
    Return the score of a word made in the other direction from the main word.
    """
    i, j = pos
    (j2, word) = find_cross_word(board, i, j)
    return calculate_score(board, (i, j2), DOWN, L, word.replace('.', L))    

#------------------------------------------------------------------------------
# play

# def make_play(play, board):
#     """
#     Put the word down on the board.
#     """
#     (score, (i, j), (di, dj), word) = play
#     if dj:
#         board = transpose(board)
#         board[i][j:(j+len(word))] = word
#         board = transpose(board)
#     elif di:
#         board[j][i:(i+len(word))] = word
#     return board

# cleaner: with iteration
def make_play(play, board):
    """
    Put the word down on the board.
    """
    for (n, L) in enumerate(word):
        board[j + n*dj][i + n*di] = L
    return board

NOPLAY = None

def best_play(hand, board):
    plays = all_plays(hand, board)
    return sorted(plays)[-1] if plays else NOPLAY

#------------------------------------------------------------------------------
# printing a board

def bonus_template(quadrant):
    """
    Make a board from the upper-left quadrant.
    """
    return mirror(list(map(mirror, quadrant.split())))

def mirror(sequence): 
    return sequence + sequence[-2::-1]

SCRABBLE = bonus_template("""
|||||||||
|3..:...3
|.2...;..
|..2...:.
|:..2...:
|....2...
|.;...;..
|..:...:.
|3..:...*
""")

WWF = bonus_template("""
|||||||||
|...3..;.
|..:..2..
|.:..:...
|3..;...2
|..:...:.
|.2...3..
|;...:...
|...:...*
""")

BONUS = WWF
DW, TW, DL, TL = '23:;'   

def show(board):
    """Print the board."""
    for row, row_bonus in zip(board, BONUS):
        row_mod = [i_bonus if is_empty(i) else i 
            for i, i_bonus in zip(row, row_bonus)]
        print(" ".join(row_mod)) 

#------------------------------------------------------------------------------
# tests

def timedcall(fn, *args):
    "Call function with args; return the time in seconds and result."
    t0 = time.clock()
    result = fn(*args)
    t1 = time.clock()
    return t1-t0, result

# regression test
hands = {
    'ABECEDR': set(['BE', 'CARE', 'BAR', 'BA', 'ACE', 'READ', 'CAR', 'DE', 'BED', 'BEE',
         'ERE', 'BAD', 'ERA', 'REC', 'DEAR', 'CAB', 'DEB', 'DEE', 'RED', 'CAD',
         'CEE', 'DAB', 'REE', 'RE', 'RACE', 'EAR', 'AB', 'AE', 'AD', 'ED', 'RAD',
         'BEAR', 'AR', 'REB', 'ER', 'ARB', 'ARC', 'ARE', 'BRA']),
    'AEINRST': set(['SIR', 'NAE', 'TIS', 'TIN', 'ANTSIER', 'TIE', 'SIN', 'TAR', 'TAS',
         'RAN', 'SIT', 'SAE', 'RIN', 'TAE', 'RAT', 'RAS', 'TAN', 'RIA', 'RISE',
         'ANESTRI', 'RATINES', 'NEAR', 'REI', 'NIT', 'NASTIER', 'SEAT', 'RATE',
         'RETAINS', 'STAINER', 'TRAIN', 'STIR', 'EN', 'STAIR', 'ENS', 'RAIN', 'ET',
         'STAIN', 'ES', 'ER', 'ANE', 'ANI', 'INS', 'ANT', 'SENT', 'TEA', 'ATE',
         'RAISE', 'RES', 'RET', 'ETA', 'NET', 'ARTS', 'SET', 'SER', 'TEN', 'RE',
         'NA', 'NE', 'SEA', 'SEN', 'EAST', 'SEI', 'SRI', 'RETSINA', 'EARN', 'SI',
         'SAT', 'ITS', 'ERS', 'AIT', 'AIS', 'AIR', 'AIN', 'ERA', 'ERN', 'STEARIN',
         'TEAR', 'RETINAS', 'TI', 'EAR', 'EAT', 'TA', 'AE', 'AI', 'IS', 'IT',
         'REST', 'AN', 'AS', 'AR', 'AT', 'IN', 'IRE', 'ARS', 'ART', 'ARE']),
    'DRAMITC': set(['DIM', 'AIT', 'MID', 'AIR', 'AIM', 'CAM', 'ACT', 'DIT', 'AID', 'MIR',
         'TIC', 'AMI', 'RAD', 'TAR', 'DAM', 'RAM', 'TAD', 'RAT', 'RIM', 'TI',
         'TAM', 'RID', 'CAD', 'RIA', 'AD', 'AI', 'AM', 'IT', 'AR', 'AT', 'ART',
         'CAT', 'ID', 'MAR', 'MA', 'MAT', 'MI', 'CAR', 'MAC', 'ARC', 'MAD', 'TA',
         'ARM']),
    'ADEINRST': set(['SIR', 'NAE', 'TIS', 'TIN', 'ANTSIER', 'DEAR', 'TIE', 'SIN', 'RAD', 
         'TAR', 'TAS', 'RAN', 'SIT', 'SAE', 'SAD', 'TAD', 'RE', 'RAT', 'RAS', 'RID',
         'RIA', 'ENDS', 'RISE', 'IDEA', 'ANESTRI', 'IRE', 'RATINES', 'SEND',
         'NEAR', 'REI', 'DETRAIN', 'DINE', 'ASIDE', 'SEAT', 'RATE', 'STAND',
         'DEN', 'TRIED', 'RETAINS', 'RIDE', 'STAINER', 'TRAIN', 'STIR', 'EN',
         'END', 'STAIR', 'ED', 'ENS', 'RAIN', 'ET', 'STAIN', 'ES', 'ER', 'AND',
         'ANE', 'SAID', 'ANI', 'INS', 'ANT', 'IDEAS', 'NIT', 'TEA', 'ATE', 'RAISE',
         'READ', 'RES', 'IDS', 'RET', 'ETA', 'INSTEAD', 'NET', 'RED', 'RIN',
         'ARTS', 'SET', 'SER', 'TEN', 'TAE', 'NA', 'TED', 'NE', 'TRADE', 'SEA',
         'AIT', 'SEN', 'EAST', 'SEI', 'RAISED', 'SENT', 'ADS', 'SRI', 'NASTIER',
         'RETSINA', 'TAN', 'EARN', 'SI', 'SAT', 'ITS', 'DIN', 'ERS', 'DIE', 'DE',
         'AIS', 'AIR', 'DATE', 'AIN', 'ERA', 'SIDE', 'DIT', 'AID', 'ERN',
         'STEARIN', 'DIS', 'TEAR', 'RETINAS', 'TI', 'EAR', 'EAT', 'TA', 'AE',
         'AD', 'AI', 'IS', 'IT', 'REST', 'AN', 'AS', 'AR', 'AT', 'IN', 'ID', 'ARS',
         'ART', 'ANTIRED', 'ARE', 'TRAINED', 'RANDIEST', 'STRAINED', 'DETRAINS']),
    'ETAOIN': set(['ATE', 'NAE', 'AIT', 'EON', 'TIN', 'OAT', 'TON', 'TIE', 'NET', 'TOE',
         'ANT', 'TEN', 'TAE', 'TEA', 'AIN', 'NE', 'ONE', 'TO', 'TI', 'TAN',
         'TAO', 'EAT', 'TA', 'EN', 'AE', 'ANE', 'AI', 'INTO', 'IT', 'AN', 'AT',
         'IN', 'ET', 'ON', 'OE', 'NO', 'ANI', 'NOTE', 'ETA', 'ION', 'NA', 'NOT',
         'NIT']),
    'SHRDLU': set(['URD', 'SH', 'UH', 'US']),
    'SHROUDT': set(['DO', 'SHORT', 'TOR', 'HO', 'DOR', 'DOS', 'SOUTH', 'HOURS', 'SOD',
         'HOUR', 'SORT', 'ODS', 'ROD', 'OUD', 'HUT', 'TO', 'SOU', 'SOT', 'OUR',
         'ROT', 'OHS', 'URD', 'HOD', 'SHOT', 'DUO', 'THUS', 'THO', 'UTS', 'HOT',
         'TOD', 'DUST', 'DOT', 'OH', 'UT', 'ORT', 'OD', 'ORS', 'US', 'OR',
         'SHOUT', 'SH', 'SO', 'UH', 'RHO', 'OUT', 'OS', 'UDO', 'RUT']),
    'TOXENSI': set(['TO', 'STONE', 'ONES', 'SIT', 'SIX', 'EON', 'TIS', 'TIN', 'XI', 'TON',
         'ONE', 'TIE', 'NET', 'NEXT', 'SIN', 'TOE', 'SOX', 'SET', 'TEN', 'NO',
         'NE', 'SEX', 'ION', 'NOSE', 'TI', 'ONS', 'OSE', 'INTO', 'SEI', 'SOT',
         'EN', 'NIT', 'NIX', 'IS', 'IT', 'ENS', 'EX', 'IN', 'ET', 'ES', 'ON',
         'OES', 'OS', 'OE', 'INS', 'NOTE', 'EXIST', 'SI', 'XIS', 'SO', 'SON',
         'OX', 'NOT', 'SEN', 'ITS', 'SENT', 'NOS'])}

def test_words():
    assert removed('LETTERS', 'L') == 'ETTERS'
    assert removed('LETTERS', 'T') == 'LETERS'
    assert removed('LETTERS', 'SET') == 'LTER'
    assert removed('LETTERS', 'SETTER') == 'L'
    t, results = timedcall(map, find_words, hands)
    for ((hand, expected), got) in zip(hands.items(), results):
        assert got == expected, "For %r: got %s, expected %s (diff %s)" % (
            hand, got, expected, expected ^ got)
    return t

test_words()
