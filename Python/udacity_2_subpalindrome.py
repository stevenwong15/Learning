# check for both 1) both sides around a value, 2) both sides around a gap
# thus: 2 loops: start in ..., end in ... 
# use self-defined function for list comprehension
def longest_subpalindrome_slice(text):
    "Return (i, j) such that text[i:j] is the longest palindrome in text."  
    if text == "":
        return (0, 0)
    slices = [grow(text, start, end)
        for start in range(len(text))
        for end in (start, start+1)]
    return max(slices, key=length)

def length(slice):
    start, end = slice
    return end-start

# grow with while function that tests for palindrome
def grow(text, start, end):
    while(start > 0 and end < len(text) and (text[start-1].upper() == text[end].upper())):
        start -= 1
        end += 1
    return (start, end)
    
def test():
    L = longest_subpalindrome_slice
    assert L("racecar") == (0, 7)
    assert L("Racecar") == (0, 7)
    assert L("RacecarX") == (0, 7)
    assert L("Race carr") == (7, 9)
    assert L("") == (0, 0)
    assert L("something rac e car going") == (8,21)
    assert L("xxxxx") == (0, 5)
    assert L("Mad am I ma dam.") == (0, 15)
    return "tests pass"

print(test())
