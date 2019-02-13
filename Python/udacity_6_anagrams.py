#------------------------------------------------------------------------------
# read dictionary

def prefixes(word):
    """
    A list of the initial sequences of a word, not including the complete word.
    """
    return [word[:i] for i in range(len(word))]

def readwordlist(filename):
    """
    Return a pair of sets: all the words in a file, and all the prefixes. (Uppercased.)
    """
    wordset = set(open(filename).read().upper().split())
    prefixset = set(p for word in wordset for p in prefixes(word))
    return wordset, prefixset

WORDS, PREFIXES = readwordlist('words4k.txt')

#------------------------------------------------------------------------------
# read list

def anagrams(phrase, shortest=2):
    """
    Return a set of phrases with words from WORDS that form anagram
    of phrase. Spaces can be anywhere in phrase or anagram. All words 
    have length >= shortest. Phrases in answer must have words in 
    lexicographic order (not all permutations).
    """
    return find_anagrams(phrase.replace(" ", ""), "", shortest)

# recursion:
#
# w > pre: 
# to ensure lexicographic order
# works as find_words(phrase) provides all first words
# 
# for rest in find_anagrams(remainder, w, shortest):
# each of the rest to w, if the rest if they are words
def find_anagrams(phrase, pre, shortest):
    results = set()
    for w in find_words(phrase):
        if len(w) >= shortest and w > pre:
            remainder = removed(phrase, w)
            if remainder:
                for rest in find_anagrams(remainder, w, shortest):
                    results.add(w + " " + rest)
            else:
                results.add(w)
    return results

def removed(letters, remove):
    """
    Return a str of letters, but with each letter in remove removed once.
    """
    for L in remove:
        letters = letters.replace(L, '', 1)
    return letters

def find_words(letters):
    return extend_prefix('', letters, set())

def extend_prefix(pre, letters, results):
    if pre in WORDS: results.add(pre)
    if pre in PREFIXES:
        for L in letters:
            extend_prefix(pre+L, removed(letters, L), results)
    return results

#------------------------------------------------------------------------------
# test

def test():
    assert 'DOCTOR WHO' in anagrams('TORCHWOOD')
    assert 'BOOK SEC TRY' in anagrams('OCTOBER SKY')
    assert 'SEE THEY' in anagrams('THE EYES')
    assert 'LIVES' in anagrams('ELVIS')
    assert anagrams('PYTHONIC') == set([
        'NTH PIC YO', 'NTH OY PIC', 'ON PIC THY', 'NO PIC THY', 'COY IN PHT',
        'ICY NO PHT', 'ICY ON PHT', 'ICY NTH OP', 'COP IN THY', 'HYP ON TIC',
        'CON PI THY', 'HYP NO TIC', 'COY NTH PI', 'CON HYP IT', 'COT HYP IN',
        'CON HYP TI'])
    return 'tests pass'

test()
