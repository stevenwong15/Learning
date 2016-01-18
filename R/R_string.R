#================================================================================= 
# [table of contents]
# 	- base package
# 	- library(stringr)
#=================================================================================

#=================================================================================
# base package
#=================================================================================
# NOTE: R is not the greatest parser - better to do this in Python

#---------------------------------------------------------------------------------
# string
nchar()  # number of characters
tolower(x); toupper(x)  # to lower / upper case

# display
cat(..., sep = " ")  # prints the argument after coercing to character
paste(..., sep = " ")  # concatenate vectors into string, after coercing to character
format(x, ...)  # formats R object for pretty printing

#---------------------------------------------------------------------------------
# substring
substr(text, start, stop)
strsplit(text, "splitByThisWord")  # note that strsplit is a regular expression

#---------------------------------------------------------------------------------
# replace
chartr("old", "new", string)  # replace each character in "old" to "new"

# pattern matching (x is a vector; text is a value)
grep(pattern, x)  # returns a vector of the indices of elements with a pattern match 
grepl(pattern, x)  # returns a vector of logics, indicting if elements match pattern
agrep(pattern, x)  # approximate grep()
agrepl(pattern, x)  # approximate grepl()
gsub(pattern, replacement, x)  # search and replace
sub(pattern, replacement, x)  # search and replace first
regexpr(pattern, text)  # return the position of the 1st match, or -1 if none (vector)
gregexpr(pattern, text)  # return the position of the all matches, or -1 if none (list)
regexec(pattern, text)  # return the position of the 1st match, or -1 if none (list)

#---------------------------------------------------------------------------------
# extended regular expression
# - R uses extended regular expression as default

# pattern scripting
# must enter "\" to prevent R from interpreting the leading backslashes below
# must bracket with "[]" to prevent R from interpreting the leading backslashes below
# () 	= grouping, for stanced to express gr(a|e)y
# \w 	= matches a character
# \s 	= matches a space (" ")
# \d 	= matches a digit
# \S 	= the negation of \s (i.e. anything but \s)
# \D 	= the negation of \d (i.e. anything but \d)
# \W 	= the negation of \w (i.e. anything but \w)
# \b 	= matches empty string at either edge of character
# \B 	= matches empty string, provided it is not at an edge of a word
# ^ 	= matches empty string at the beginning of a line
# $ 	= matches empty string at the end of a line
# \< 	= matches empty string at the beginning of a word
# \> 	= matches empty string at the end of a word
# | 	= matches either the expression before, or after the "|"

# repetition quantifiers
# ? 	= the preceding element is matched 0/1
# * 	= the preceding element is matched 0/more
# + 	= the preceding element is matched 1/more
# {n} 	= the preceding item is matched exactly n times
# {n,} 	= the preceding item is matched n or more times
# {n,m} = the preceding item is matched n times, but not more than m times

#=================================================================================
# library(stringr)
#=================================================================================
# regular expression reference: http://www.regular-expressions.info/reference.html
# regular expression test: http://regexr.com/
# build regular expression: http://www.txt2re.com/

#---------------------------------------------------------------------------------
# basics
str_c()  # same as paste() with sep = "" as the default, and silently removes NULL
str_length()  # same as nchar() with NA's preserved, instead of being nchar of 2
str_sub()  # same as substr(), but takes negative (to mean left from last char)
str_dub('xyx', n)  # duplicate the characters within a string n times
str_trim(" sentences with excess white space in front and behind    ")
str_pad()  # pad the string with extra spaces on the left, right or both sides

#---------------------------------------------------------------------------------
# pattern matching: detect, locate, extract, match, replace, and split
str_detect(strings, pattern)  # detects the presence / absence
str_subset(strings, pattern)  # returns elements that matches a regular expression
(str_locate(strings, pattern))  # returns first position; () for matrix form
str_locate_all(strings, pattern)  # returns all matches, in a list form
str_extract()  # str_locate() but extracts
str_extract_all()  # str_locate_all() but extracts
str_match()  # str_extract() but captures the complete match, and each () match
str_match_all()  # str_extract_all() but captures the complete match, and each () match
str_replace(string, pattern, replacement)  # replaces first
str_replace_all(string, pattern, replacement)  # replaces all
str_split_fixed(string, pattern, n)  # split based on first n pieces of pattern
str_split(string, pattern)  # split based on variable number of pieces


