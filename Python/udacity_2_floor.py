# Floor Puzzle
# Hopper, Kay, Liskov, Perlis, and Ritchie live on 
# different floors of a five-floor apartment building. 
#
# Hopper does not live on the top floor. 
# Kay does not live on the bottom floor. 
# Liskov does not live on either the top or the bottom floor. 
# Perlis lives on a higher floor than does Kay. 
# Ritchie does not live on a floor adjacent to Liskov's. 
# Liskov does not live on a floor adjacent to Kay's. 
# 
# Where does everyone live?  

import itertools

def floor_puzzle():
	orderings = itertools.permutations([1, 2, 3, 4, 5])
	return next(
		[Hopper, Kay, Liskov, Perlis, Ritchie]
		for [Hopper, Kay, Liskov, Perlis, Ritchie] in orderings
		if Hopper != 5
		if Kay != 1
		if Liskov != 5 and Liskov != 1
		if Perlis > Kay
		if abs(Ritchie-Liskov) > 1
		if abs(Kay-Liskov) > 1)

print(floor_puzzle())
