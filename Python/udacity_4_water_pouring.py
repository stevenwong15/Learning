
def pour_problem(X, Y, goal, start=(0, 0)):
	"""
	X and Y are the capacity of glasses; (x, y) is current fill levels
	and represents a state. The goal is a level thaht can be in eitherh glass.
	Start at teh start state and follow successors until we reach the goal.
	Keep track of frontier and previously explored; fail when no frontier.
	"""
	if goal in start:
		return [start]
	explored = set()
	frontier = [[start]]
	while frontier:
		path = frontier.pop(0)
		(x, y) = path[-1]
		for (state, action) in successors(x, y, X, Y).items():
			if state not in explored:
				explored.add(state)
				path2 = path + [action, state]
				if goal in state:
					return path2
				else:
					frontier.append(path2)
	return Fail

Fail = []

def successors(x, y, X, Y):
	"""
	Return a dict of {state:action} pairs describing what can be reached from
	the (x, y) state, and how.
	"""
	assert x <= X and y <= Y 
	return {
		((0, y+x) if y+x<=Y else (x-(Y-y), y+(Y-y))): "X->Y",
		((x+y, 0) if x+y<=X else (x+(X-x), y-(X-x))): "X<-Y",
		(X, y): "fill X",
		(x, Y): "fill Y",
		(0, y): "empty X",
		(x, 0): "empty Y"}


pour_problem(4, 9, 6)
