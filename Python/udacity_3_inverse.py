def slow_inverse(f, delta=1/128.):
    """Given a function y = f(x) that is a monotonically increasing function on
    non-negatve numbers, return the function x = f_1(y) that is an approximate
    inverse, picking the closest value to the inverse, within delta."""
    def f_1(y):
        x = 0
        while f(x) < y:
            x += delta
        # Now x is too big, x-delta is too small; pick the closest to y
        return x if (f(x)-y < y-f(x-delta)) else x-delta
    return f_1 

def inverse(f, delta = 1/128.):
    def f_1(y):
        x = 0
        while abs(f(x)-y) > delta:
            b = (f(x+delta)-f(x))/delta
            a = (f(x)-y) - b*x
            x = -a/b
        return x
    return f_1 
    
def square(x): return x*x
sqrt_slow = slow_inverse(square)
%timeit sqrt_slow(1000000000)

def square(x): return x*x
sqrt = inverse(square)
%timeit sqrt(1000000000)

import math
%timeit math.sqrt(1000000000)
