# Unit 6: Fun with Words

"""
A portmanteau word is a blend of two or more words, like 'mathelete',
which comes from 'math' and 'athelete'.  You will write a function to
find the 'best' portmanteau word from a list of dictionary words.
Because 'portmanteau' is so easy to misspell, we will call our
function 'natalie' instead:

    natalie(['word', ...]) == 'portmanteauword' 

In this exercise the rules are: a portmanteau must be composed of
three non-empty pieces, start+mid+end, where both start+mid and
mid+end are among the list of words passed in.  For example,
'adolescented' comes from 'adolescent' and 'scented', with
start+mid+end='adole'+'scent'+'ed'. A portmanteau must be composed
of two different words (not the same word twice).

That defines an allowable combination, but which is best? Intuitively,
a longer word is better, and a word is well-balanced if the mid is
about half the total length while start and end are about 1/4 each.
To make that specific, the score for a word w is the number of letters
in w minus the difference between the actual and ideal lengths of
start, mid, and end. (For the example word w='adole'+'scent'+'ed', the
start,mid,end lengths are 5,5,2 and the total length is 12.  The ideal
start,mid,end lengths are 12/4,12/2,12/4 = 3,6,3. So the final score
is

    12 - abs(5-3) - abs(5-6) - abs(2-3) = 8.

yielding a score of 12 - abs(5-(12/4)) - abs(5-(12/2)) -
abs(2-(12/4)) = 8.

The output of natalie(words) should be the best portmanteau, or None
if there is none. 

Note (1): I got the idea for this question from
Darius Bacon.  Note (2): In real life, many portmanteaux omit letters,
for example 'smoke' + 'fog' = 'smog'; we aren't considering those.
Note (3): The word 'portmanteau' is itself a portmanteau; it comes
from the French "porter" (to carry) + "manteau" (cloak), and in
English meant "suitcase" in 1871 when Lewis Carroll used it in
'Through the Looking Glass' to mean two words packed into one. Note
(4): the rules for 'best' are certainly subjective, and certainly
should depend on more things than just letter length.  In addition to
programming the solution described here, you are welcome to explore
your own definition of best, and use your own word lists to come up
with interesting new results.  Post your best ones in the discussion
forum. Note (5) The test examples will involve no more than a dozen or so
input words. But you could implement a method that is efficient with a
larger list of words.
"""

# strategy:
# - find all eligible triples with the help of permutation and indexes
# - score triples

import itertools

def natalie(words):
    "Find the best Portmanteau word formed from any two of the list of words."
    results = set()
    for i,j in itertools.permutations(range(len(words)), 2):
        results.update(find_natalie(words[i], words[j]))
    return results if results else None
    # return max(results, key=lambda x: x[0])[1] if results else None

def find_natalie(w1, w2):
    results = set()
    i = 1
    while i < min(len(w1), len(w2)):
        mid = w2[:i]
        if mid == w1[(len(w1)-i):]:
            start = w1.replace(mid, "", 1)
            end = w2.replace(mid, "", 1)
            results.add(score_natalie(start, mid, end))
        i += 1
    return results

def score_natalie(start, mid, end):
    w = start + mid + end
    W, S, M, E = map(len, (w, start, mid, end))
    return (W-abs(S-W/4.)-abs(M-W/2.)-abs(E-W/4.), w)

#------------------------------------------------------------------------------
# solution from DCP
# strategy:
# - find all eligible triples with the help of dictionary
# - score triples

from collections import defaultdict

def natalie(words):
    triples = alltriples(words)
    if not triples: return None
    return ''.join(max(triples, key=portman_score))

# get triples by:
# split word1 into start and mid
# find mid in {mid: endings}
# if found, mid+end is not the entire word (i.e. duplicates)
def alltriples(words):
    ends = compute_ends(words)
    return [(start, mid, end)
            for w in words
            for start, mid in splits(w)
            for end in ends[mid]
            if w != mid+end]

# dictionary of {mid: endings}
def compute_ends(words):
    ends = defaultdict(list)
    for w in words:
        for mid, end in splits(w):
            ends[mid].append(end)
    return ends

def splits(w):
    return [(w[:i], w[i:]) for i in range(1, len(w))]

def portman_score(triple):
    S, M, E = map(len, triple)
    T = S+M+E
    return T - abs(S-T/4.) - abs(M-T/2.) - abs(E-T/4.)

#------------------------------------------------------------------------------
# test

def test_natalie():
    "Some test cases for natalie"
    assert (natalie(['eskimo', 'escort', 'kimchee', 'kimono', 'cheese']) == 'eskimono')
    assert (natalie(['kimono', 'kimchee', 'cheese', 'serious', 'us', 'usage']) == 'kimcheese')
    assert (natalie(['circus', 'elephant', 'lion', 'opera', 'phantom']) == 'elephantom')
    assert (natalie(['adolescent', 'scented', 'centennial', 'always', 'ado', 'centipede'])
            in ( 'adolescented', 'adolescentennial', 'adolescentipede'))
    assert (natalie(['programmer', 'coder', 'partying', 'merrymaking']) == 'programmerrymaking')
    assert (natalie(['int', 'intimate', 'hinter', 'hint', 'winter']) == 'hintimate')
    assert (natalie(['morass', 'moral', 'assassination']) == 'morassassination')
    assert (natalie(['entrepreneur', 'academic', 'doctor', 'neuropsychologist', 
                     'neurotoxin', 'scientist', 'gist'])
            in ('entrepreneuropsychologist', 'entrepreneurotoxin'))
    assert (natalie(['perspicacity', 'cityslicker', 'capability', 'capable']) 
            == 'perspicacityslicker')
    assert (natalie(['backfire', 'fireproof', 'backflow', 'flowchart', 'background', 'groundhog']) 
            == 'backgroundhog')
    assert (natalie(['streaker', 'nudist', 'hippie', 'protestor', 'disturbance', 'cops']) 
            == 'nudisturbance')
    assert (natalie(['night', 'day']) == None)
    assert (natalie(['dog', 'dogs']) == None)
    assert (natalie(['test']) == None)
    assert (natalie(['']) ==  None)
    assert (natalie(['ABC', '123']) == None)
    assert (natalie([]) == None)
    assert (natalie(['pedestrian', 'pedigree', 'green', 'greenery']) == 'pedigreenery')
    assert (natalie(['armageddon', 'pharma', 'karma', 'donald', 'donut']) == 'pharmageddon')
    assert (natalie(['lagniappe', 'appendectomy', 'append', 'lapin']) == 'lagniappendectomy')
    assert (natalie(['angler', 'fisherman', 'boomerang', 'frisbee', 'rangler', 
                     'ranger', 'rangefinder'])
            in ('boomerangler', 'boomerangefinder'))
    assert (natalie(['freud', 'raelian', 'dianetics', 'jonestown', 'moonies']) 
            == 'freudianetics')
    assert (natalie(['atheist', 'math', 'athlete', 'psychopath'])
            in ('psychopatheist', 'psychopathlete'))
    assert (natalie(['hippo', 'hippodrome', 'potato', 'dromedary']) == 'hippodromedary')
    assert (natalie(['taxi', 'taxicab', 'cabinet', 'cabin', 'cabriolet', 'axe'])
            in ('taxicabinet', 'taxicabriolet'))
    assert (natalie(['pocketbook', 'bookmark', 'bookkeeper', 'goalkeeper'])
            in ('pocketbookmark', 'pocketbookkeeper'))
    assert (natalie(['athlete', 'psychopath', 'athletic', 'axmurderer'])
            in ('psychopathlete', 'psychopathletic'))
    assert (natalie(['info', 'foibles', 'follicles']) == 'infoibles')
    assert (natalie(['moribund', 'bundlers', 'bundt']) == 'moribundlers')
    return 'tests pass'

test_natalie()
