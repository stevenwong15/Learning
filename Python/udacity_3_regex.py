# describing grammar as a string
# grammar: a description of the language
# language: set of strings

# .: wildcard
# a*: a repeated 0 or more times
# a+: a repeated 1 or more times
# ^a: starts with a
# a$: ends with a
# colou?r: u is optional; u repeated 0 or 1 times

# break the problem down into: "appear first" and "appear anywhere"
def search(pattern, text):
    """Return true if pattern appears anywhere in text"""
	# "appear first" is a problem solved by match()
    if pattern.startswith("^"):
        return match(pattern[1:], text)
	# "appear anywhere" is a problem that can be solved by match()
	# but with leading ".*" to move beyond "first"
    else:
        return match(".*"+pattern, text)

# uses recursion to break the problem down
def match(pattern, text):
    """Return True if pattern appears at the start of text"""
	# empty string, "", matches to everything
    if pattern == "":
        return True
	# $ only matches if the string is ""
    elif pattern == "$":
        return (text == "")
    # * and ? depends on what comes before it, so break it down:
    # p: first-pattern
    # op: operation
    # pat: sub-pattern
    elif len(pattern) > 1 and pattern[1] in "*?":
        p, op, pat = pattern[0], pattern[1], pattern[2:]
        if op == "*":
            return match_star(p, pat, text)
        elif op == "?":
        	# do not skip pattern before ?; match it against text
        	# recursively go through the rest of the pattern/text
            if match1(p, text) and match(pat, text[1:]):
                return True
        	# skip pattern before ?
        	# recursively go through the rest of the pattern/text
            else:
                return match(pat, text)
    # match first pattern
    # recursively go through the rest of the pattern/text
    else:
        return match1(pattern[0], text) and match(pattern[1:], text[1:])

# uses recursion to break the problem down
def match_star(p, pattern, text):
	"""Return true if any number of char p, followed by pattern, matches text."""
	# rest of the pattern (pattern -> pat) match against text exactly
	# OR, match first, and pass the rest of the text through the same check
	return (match(pattern, text) or
			(match1(p, text) and match_star(p, pattern, text[1:])))

def match1(p, text):
	"""Return true if first character of text matches pattern character p."""
	if not text:
		return False
	return p == text[0] or p == "."

# examples
search("a*c","abc")
search("^a*","abc")
search("c$","abc")
search("abd?c","abc")

#------------------------------------------------------------------------------
# describing grammar more compositionally with tree-structure: using API
# concepts:
# * pattern
# * text - result
# * partial result
# * control over iteration
# note this is an interpreter:
# matchset() is the underlying function that supports search() and match()
# matchset() takes a pattern and a text as input; returns a set of remainders
# e.g. pattern star(lit(a)) on text "aaab"; returns {"aaab", "aab", "ab", "b"}
# that is: a* can consume 1, 2 or all 3 of the a"s in the text

# API
# lit(s): literal; lit("a"): {a}
# seq(s1, s2): sequence; seq(lit("a"), lit("b")): {ab}
# alt(s1, s2): alternative; alt(lit("a"), lit("b")): {a, b}
# star(s): repetition; star("a"): {"", a, aa, aaa, ...}
# oneof(s): one of; oneof("abc"): {a, b, c}
# eol: end of line; eol: {""}; seq(lit("a"), eol): {a}
# dot: any possible character; dot: {a, b, c, d, ...}

def search(pattern, text):
    "Match pattern anywhere in text; return longest earliest match or None."
    for i in range(len(text)):
        m = match(pattern, text[i:])
        # "" is a true value, so have to use "m is not None"
        if m is not None:
            return m
        
def match(pattern, text):
    "Match pattern against start of text; return longest match found or None."
    remainders = matchset(pattern, text)
    if remainders:
        shortest = min(remainders, key=len)
        return text[:len(text)-len(shortest)]

# lit: return the rest of the text, if starts with pattern
# seq: in remainder of x, find y
# alt: union of set of x and y
# eol: return "" if end of line
# dot: instead of text != "", text can act as a logical
# oneof: use str.startswith(x), which can also take a tuple
# star: union of entire text, and in remainder of x, find pattern again
def matchset(pattern, text):
    "Match pattern at start of text; return a set of remainders of text."
    op, x, y = components(pattern)
    if "lit" == op:
        return set([text[len(x):]]) if text.startswith(x) else null
    elif "seq" == op:
        return set(t2 for t1 in matchset(x, text) for t2 in matchset(y, t1))
    elif "alt" == op:
        return matchset(x, text) | matchset(y, text)
    elif "dot" == op:
        return set([text[1:]]) if text else null
    elif "oneof" == op:
        return set([text[1:]]) if text.startswith(x) else null
    elif "eol" == op:
        return set([""]) if text == "" else null
    elif "star" == op:
        return (set([text]) |
                set(t2 for t1 in matchset(x, text) if t1 != text
                    for t2 in matchset(pattern, t1)))
    else:
        raise ValueError("unknown pattern: %s" % pattern)
        
null = frozenset()

# break pattern down into sub-patterns:
# op: operation
# x: first part of the pattern, if exists
# y: 2nd part of the pattern, if exists
def components(pattern):
    "Return the op, x, and y arguments; x and y are None if missing."
    x = pattern[1] if len(pattern) > 1 else None
    y = pattern[2] if len(pattern) > 2 else None
    return pattern[0], x, y

# constructors   
def lit(string): return ("lit", string)
def seq(x, y): return ("seq", x, y)
def alt(x, y): return ("alt", x, y)
def star(x): return ("star", x)
def plus(x): return seq(x, star(x))
def opt(x): return alt(lit(""), x) # opt(x) means that x is optional
def oneof(chars): return ("oneof", tuple(chars))
dot = ("dot",)
eol = ("eol",)

def test():
    assert matchset(lit("abc"), "abcdef") == set(["def"])
    assert matchset(("seq", lit("hi "), lit("there ")), 
                   "hi there nice to meet you") == set(["nice to meet you"])
    assert matchset(alt(lit("dog"), lit("cat")), 
    			   "dog and cat") == set([" and cat"])
    assert matchset(dot, "am i missing something?") == set(["m i missing something?"])
    assert matchset(oneof("a"), "aabc123") == set(["abc123"])
    assert matchset(eol, "") == set([""])
    assert matchset(eol, "not end of line") == frozenset([])
    assert matchset(star(lit("hey")), "heyhey!") == set(["!", "heyhey!", "hey!"])
    
    return "tests pass"

test()

#------------------------------------------------------------------------------
# describing grammar more compositionally with tree-structure: using API
# note this is an compiler:
# pattern is defined once, but interpreter matchset() repeatedly look for op
# there's an inherent inefficiency that complier solves for in 2 steps:
# 1) takes pattern and compiles it into an object; done once
# 2) executes the compiled object on text; every time there's a new text
# so instead of using constructors, let's use compilers
# compiler code:
# * the one here consists of Python functions
# * lower level: compilers for Java (and Python) generates VM instructions
# * low level: compilers for C generates machine instructions

# same as before
def search(pattern, text):
    "Match pattern anywhere in text; return longest earliest match or None."
    for i in range(len(text)):
        m = match(pattern, text[i:])
        if m is not None:
            return m

# interface with compiler is different
def match(pattern, text):
    "Match pattern against start of text; return longest match found or None."
    remainders = pattern(text)
    if remainders:
        shortest = min(remainders, key=len)
        return text[:len(text)-len(shortest)]

# compilers: returns a function that operations on input
# less code: no need to construct then interpret
# plus, opt same as before
# seq wrote in an alternative way: 
# * apply y on remainder of "x applied to t, text"
# * use "*" to break collection down to arguments
def lit(s): return lambda t: set([t[len(s):]]) if t.startswith(s) else null
def seq(x, y): return lambda t: set().union(*map(y, x(t)))
def alt(x, y): return lambda t: x(t) | y(t)
dot = lambda t: set([t[1:]]) if t else null
def oneof(chars): return lambda t: set([t[1:]]) if (t and t[0] in chars) else null
eol = lambda t: set(['']) if t == '' else null
def star(x): return lambda t: (set([t]) | 
                               set(t2 for t1 in x(t) if t1 != t
                                   for t2 in star(x)(t1)))
def plus(x): return seq(x, star(x))
def opt(x): return alt(lit(""), x) 

null = frozenset([])

def test():
    assert match(star(lit('a')), 'aaaaabbbaa') == 'aaaaa'
    assert match(lit('hello'), 'hello how are you?') == 'hello'
    assert match(lit('x'), 'hello how are you?') == None
    assert match(oneof('xyz'), 'x**2 + y**2 = r**2') == 'x'
    assert match(oneof('xyz'), '   x is here!') == None
    return 'tests pass'

test()

#------------------------------------------------------------------------------
# recognizer vs. generator
# recognizer: match() and search() look for pattern in given text
# generator: generates all possible texts matching pattern
# * could use a write the compiler as a generator
# * in this case, we are just restricting the length of the list

# compiler optimization: put set([s]) outside so it's only done once
def lit(s): 
	set_s = set([s])
	return lambda Ns: set_s if len(s) in Ns else null
def alt(x, y): return lambda Ns: x(Ns) | y(Ns)
def star(x): return lambda Ns: opt(plus(x))(Ns)
def plus(x): return lambda Ns: genseq(x, star(x), Ns, startx=1) # Tricky
def oneof(chars): 
	set_c = set(chars)
	return lambda Ns: set_c if 1 in Ns else null
def seq(x, y): return lambda Ns: genseq(x, y, Ns)
def opt(x): return alt(epsilon, x)
dot = oneof('?')  # You could expand the alphabet to more chars.
epsilon = lit('')  # The pattern that matches the empty string.

null = frozenset([])

def genseq(x, y, Ns, startx=0):
	"Set of matches to xy whose total len is in Ns, with x-match's len in Ns_x"
	# Tricky part: x+ is defined as: x+ = x x*
	# To stop the recursion, the first x must generate at least 1 char,
	# and then recursive x* has that many fewer characters. We usue
	# startx=1 to say that x must match at least 1 character
	if not Ns:
		return null
	xmatches = x(set(range(startx, max(Ns)+1)))  # set that matches x
	# for each length in the set, find set that matches y
	Ns_x = set(len(x) for m in xmatches)
	ymatches = y(set(n-m for n in Ns for m in Ns_x if n-m >= 0)) 
	return set(m1 + m2
			   for m1 in xmatches for m2 in ymatches
			   if len(m1+m2) in Ns)

def test():
    f = lit('hello')
    assert f(set([1, 2, 3, 4, 5])) == set(['hello'])
    assert f(set([1, 2, 3, 4]))    == null 
    
    g = alt(lit('hi'), lit('bye'))
    assert g(set([1, 2, 3, 4, 5, 6])) == set(['bye', 'hi'])
    assert g(set([1, 3, 5])) == set(['bye'])
    
    h = oneof('theseletters')
    assert h(set([1, 2, 3])) == set(['t', 'h', 'e', 's', 'l', 'r'])
    assert h(set([2, 3, 4])) == null
    
    return 'tests pass'

test()

#------------------------------------------------------------------------------
# decorators

# helpful to do debugging: to know what the correct names of the functions are
from functools import update_wrapper

# instead of repeating "update_wrapper(n_ary_f, f)"/etc. for every decorator
# use a decorator to do that for you: 
# _d wraps around d: e.g. new decorator(n_ary) gets old n_ary doc
# d(fn) wraps around fn: e.g. new n_ary(seq) gets old seq doc
def decorator(d):
	"Make function d a decorator: d wraps a function fn:"
	def _d(fn):
		return update_wrapper(d(fn), fn)
	update_wrapper(_d, d)
	return _d

# an expressive tool
@decorator
def n_ary(f):
    """Given binary function f(x, y), return an n_ary function such
    that f(x, y, z) = f(x, f(y,z)), etc. Also allow f(x) = x."""
    def n_ary_f(x, *args):
    	return x if not args else f(x, n_ary_f(*args))
    return n_ary_f

@n_ary
def seq(x, y): return ("seq", x, y)

# e.g.
seq("a", "b", "c", "d", "e")

#------------------------------------------------------------------------------
# cache management: memoization with decorator

# a performance tool
# using "try" not "if" structure to handle TypeError case
@decorator
def memo(f):
	"""Decorator that caches the return value for each call to f(args).
	Then when called again with some args, we can just look it up"""
	cache = {}
	def _f(*args):
		try:
			return cache[args]
		except KeyError:
			cache[args] = result = f(*args)
			return result
		except TypeError:
			# some element of args can't be a dict key (hashable)
			# e.g. list, which are mutable
			return f(args)
	return _f

# a debugging tool
@decorator
def countcalls(f):
	"Decorator that makes the function count calls to it, in callcounts[f]."
	def _f(*args):
		callcounts[_f] += 1
		return f(*args)
	callcounts[_f] = 0
	return _f
callcounts = {}

@countcalls
def fib(n): return 1 if n <= 1 else fib(n-1) + fib(n-2)
%timeit fib(30)  # 840 ms ± 8.52 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

@countcalls
@memo
def fib(n): return 1 if n <= 1 else fib(n-1) + fib(n-2)
%timeit fib(30)  # 333 ns ± 5.47 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

# a debugging tool
@decorator
def trace(f):
	indent = "    "
	def _f(*args):
		signature = "%s(%s)" % (f.__name__, ", ".join(map(repr, args)))
		print("%s--> %s" % (trace.level*indent, signature))
		trace.level += 1
		try: 
			result = f(*args)
			print("%s<-- %s === %s" % ((trace.level-1)*indent, signature, result))
		finally:
			trace.level -= 1  # if error, restore before trying again
		return result
	trace.level = 0
	return _f

@trace
def fib(n): return 1 if n <= 1 else fib(n-1) + fib(n-2)
fib(6)

# a debugging tool
# disable decorator
def disabled(f): return f
fib = disabled
fib(6)
