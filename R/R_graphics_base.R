#================================================================================= 
# [table of contents]
#  	- plots (regular)
#  	- unit
#================================================================================= 

#=================================================================================
# plot (regular)
#=================================================================================

#---------------------------------------------------------------------------------
# plot
plot(y ~ x, dataset) # plot x against y, from the dataset
matplot(A, B) # plots columns of matrix A against columns of matrix B

# plot, showing arguments
plot(y ~ x, dataset, 
	 xlab = "", ylab = "", main = "",
	 pch = ptChar, col = "color", cex = size, lty=1, asp=1, 
	 xaxt = "n", yaxt = "n", xlim = c(low, high), ylim = c(low, high))

#---------------------------------------------------------------------------------
# plot attributes

# additive texts
title("title") # if main = "" is not used in plot()
# first three arguments: side (1 = x, 2 = y), at, and label; 
axis(side, at, expression(xi[q]), cex.axis = 1.3, col.axis = "blue") 
legend("topleft", legend = c(expression(y > hat(y)), expression(y < hat(y))), 
       pch = 19, col = c("blue","red"), cex = 0.7, inset = 0.12) 

# show point characters
plot(1:20,1:20, pch=1:20) 

# facets
par(mfrow = c(nRows,nCols)) # a matrix of multiple plots

#---------------------------------------------------------------------------------
# types of plots

# histogram
hist(object$name, breaks = nBars, prob = TRUE) # prob = T to convert to probability 
plot(density(data)) # empirical probability desnity distribution

# scatter
pairs(dataset) # a scatter plots between all attributes

# lines & points added to existing plots
curve(function(x), from = left, to = right, add = TRUE, n = nDiscretization, col = "blue")
curve(function(x), from = left, to = right, add = TRUE, type = "h") # shade
lines(Y ~ X)
abline(B0, B1, etc) # plot a line with intercept and slope
abline(h = y) # horizontal line at y
abline(v = x) # verticale line at x
points(X, Y)

#---------------------------------------------------------------------------------
# data edits
fix(dataset) # fix the dataset in a table format

#=================================================================================
# unit
#=================================================================================
unit(x, units)
# "npc" = normalised parent coordinates (default): the entire box = (0,0) to (1,1)
# "cm"
# "mm"
# "lines" = lines of text, multiples of default text size of the viewport
# "char" = multiples of nominal font
# "native" = relative to viewport's xscale and yscale
# "snpc" = square npc (i.e. uses the letter npc height/width)
# "strwidth" = mutiplies of the width of string
# "strheight" = mutiplies of the height of string
# "grobwidth" = mutiplies of the width of grob
# "grobheight" = mutiplies of the height of grob
# "inches"
# "points" 72.27 pt = 1 in
# "picas" 1 pc = 12 pt
# "bigpts" 72 bp = 1 in
# "dida" 1157 dd = 1238 pt
# "cicero" 1 cc = 12 dd
# "scaledpts" 65536 sp = 1 pt

#---------------------------------------------------------------------------------
# symbols: library(scales)
comma()  # add commas to numbers, in the thousands, million, billion, etc.
dollar()
percent()
scientific()