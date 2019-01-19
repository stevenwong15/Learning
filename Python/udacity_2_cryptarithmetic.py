import re
import itertools
import time

def solve(formula):
    """Given a formula like 'ODD + ODD == EVEN', fill in digits to solve it.
    Input formula is a string; output is a digit-filled-in string or None."""
    for f in fill_in(formula):
    	if valid(f):
    		return f

# generator because find first
# make a set because want unique letters in mapping
def fill_in(formula):
    "Generate all possible fillings-in of letters in formula with digits."
    letters = "".join(set(re.findall("[A-Z]", formula)))
    for digits in itertools.permutations("1234567890", len(letters)):
        table = str.maketrans(letters, "".join(digits))
        yield formula.translate(table)

def valid(f):
    "Formula f is valid iff it has no numbers with leading zero and evals true."
    try:
        return not re.search(r"\b0[0-9]", f) and eval(f) is True
    except ArithmeticError:
    	return False

#------------------------------------------------------------------------------
# speed up, by using eval() once
# parameterize, to reduce overhead of repeated eval() call:
# - parsing str into a tree structure
# - generating code to evaluate
# that said, show minimize the use of eval() because:
# - security: hackers can pass dangerous code into eval()
# - clarity: hard to spot what functions are doing

# the expression is compiled once in compile_formula()
# the rest is a matter of going through all the permutations
# noticee: convert digit back to str only one, given True, unlike before
def faster_solve(formula):
	"""Given a formula like 'ODD + ODD == EVEN', fill in digits to solve it.
	Input formula is a string; output is a digit-filled-in string or None.
	This version precompiles the formula; only one eval per forumla"""
	f, letters = compile_formula(formula)
	for digits in itertools.permutations((1,2,3,4,5,6,7,8,9,0), len(letters)):
		try:
			if f(*digits) is True:
				table = str.maketrans(letters, "".join(map(str, digits)))
				return formula.translate(table)
		except ArithmeticError:
			pass

# for each formula, parse into an expression to be evaluated
# key to returning False: False and (1 + 2) = False
# ok to have zero by itself; not followed by another digit: r"\b([A-Z])[A-Z]"
def compile_formula(formula, verbose=False):
	"""
	Compile formula into a function. Also return letters found, as a str,
	in same order as parms of function. The first digit of a multi-digit 
    number can't be 0. So if YOU is a word in the formula, and the function
    is called with Y eqal to 0, the function should return False.
    For example "YOU == ME**2" =>
	lambda Y, M, E, U, O: Y!=0 and M!=0 and ((U+10*O+100*Y) == (E+10*M)**2)
	"""	
	letters = "".join(set(re.findall("[A-Z]", formula)))
	firstletters = set(re.findall(r"\b([A-Z])[A-Z]", formula))
	tokens = map(compile_word, re.split("([A-Z]+)", formula))
	body = "".join(tokens)
	if firstletters:
		tests = " and ".join(L+"!=0" for L in firstletters)
		body = "%s and (%s)" % (tests, body)
	f = "lambda %s: %s" % (", ".join(letters), body)
	if verbose: print(formula)
	return eval(f), letters

# for each word, parse into a tree-like structure
def compile_word(word):
    """Compile a word of uppercase letters as numeric digits.
    E.g., compile_word('YOU') => '(1*U+10*O+100*Y)'
    Non-uppercase words unchanged: compile_word('+') => '+'"""
    if word.isupper():
    	terms = [("%s*%s" % (10**i, d)) for (i, d) in enumerate(word[::-1])]
    	return "(" + "+".join(terms) + ")"
    else:
    	return word

#------------------------------------------------------------------------------
# test

def timedcall(fn, *args):
    "Call function with args; return the time in seconds and result."
    t0 = time.clock()
    result = fn(*args)
    t1 = time.clock()
    return t1-t0, result

examples = """TWO + TWO == FOUR
A**2 + B**2 == C**2
A**2 + BE**2 == BY**2
X / X == X
A**N + B**N == C**N and N > 1
ATOM**0.5 == A + TO + M
GLITTERS is not GOLD
ONE < TWO and FOUR < FIVE
ONE < TWO < THREE
RAMN == R**3 + RM**3 == N**3 + RX**3
sum(range(AA)) == BB
sum(range(POP)) == BOBO
ODD + ODD == EVEN
PLUTO not in set([PLANENTS])""".splitlines()

def test():
	t0 = time.clock()
	for example in examples:
		print(example)
		print("%6.4f sec: %s" % timedcall(solve, example))
	print("%6.4f tot." %(time.clock()-t0))

def test_faster():
	t0 = time.clock()
	for example in examples:
		print(example)
		print("%6.4f sec: %s" % timedcall(faster_solve, example))
	print("%6.4f tot." %(time.clock()-t0))

test()
test_faster()
