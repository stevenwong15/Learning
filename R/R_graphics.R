#================================================================================= 
# [table of contents]
# 	- qplot vs. ggplot2 vs. ggvis
#	- basics
#	- stat functions
#	- ggplot2
# 		- scatter
# 		- line
# 		- bar and box
# 		- data distributions
# 		- other graphs
# 		- graph appearance
# 		- colours and shapes
# 		- output
# 	- library(GGally)
# 	- ggvis
# 	- shiny
# 	- RColorBrewer
#=================================================================================

#=================================================================================
# qplot vs. ggplot2 vs. ggvis
#=================================================================================
# - qplot (part of ggplot2, designed to be similar to base)
qplot()  # has syntax similar to R’s base plot() function
# - ggplot2 (static)
ggplot()  # is more powerful, using + (not at the start of the line) to add arguements
# geoms 	= geometric objects, drawn to represent the data
# aes 		= aesthetic attributes, visual properties of geoms (e.g. positions & color)
# scales 	= maps values in data space to those in the aesthetic space
# guides 	= maps visual properties back to the data space (e.g. tick marks & labels)
# resources: http://docs.ggplot2.org/current/
# - ggvis (interactive)
ggvis() # uses %>% (not at the start of the line), instead of +
# props() 	= aes()
# ggvis() 	= ggplot()
# resources: http://ggvis.rstudio.com, http://shiny.rstudio.com/tutorial/
# - color
# resources: http://colorbrewer2.org

#=================================================================================
# basics
#=================================================================================
last_plot()  # returns the last plot
+ geom_blank()  # blank, automatically added to ggplot()

# ggplot is based on the grammar of graphics, add new layers with geom_*() or 
# stat_*() function; both stat functions and geom functions combine a stat with a
# geom to make a layer: i.e.
stat_bin(geom = 'bar')
# is the same as
geom_bar(stat = 'bin')

#---------------------------------------------------------------------------------
# stat functions
# each stat creates additional variables to map aesthetics to, which can serve as
# additional information beyond what is in the ggplot(aes(...)); these variables 
# use a common ..name.. syntax, and they include:
# ..count.., ..ncount.., ..density.., ndensity.., ..scaled.., ..level.., ..x..,
# ..y.., ..xend.., ..yend.., ..value.., ..se.., ..xmin.., ..ymin.., ..size..,
# ..n.., ..violinwidth.., ..width..
# in general, stat_*() function has inputs of 1) variables in aes(), 2) geom = ..,
# and 3) other parameters for stat

# 1D distribution
+ stat_bin(binwidth = 1, origin = 10)
+ stat_density(adjust = 1, kernel = 'gaussian')

# 2D distribution
+ stat_bin_2d(bins = 30, drop = TRUE)
+ stat_bin_hex(bins = 30)
+ stat_density_2d(contour = TRUE, n = 100)

# 3 variables
+ stat_contour(aes(z = z))
+ geom_spoke(aes(radius = z, angle = z))  # covert angle and radius to (xend, yend)
+ stat_summary_hex(aes(z = z), bins = 30, fun = mean)
+ stat_summary_2d(aes(z = z), bins = 30, fun = mean)

# comparison
+ stat_boxplot(coef = 1.5)
+ stat_ydensity(adjust = 1, kernal = 'gaussian', scale = 'area')

# function
+ stat_ecdf(n = 40)
+ stat_quantile(quantiles = c(0.25, 0.5, 0.75), formula = y ~ log(x), method = 'rq')
+ stat_smooth(method = 'auto', formula = y ~ x, se = TRUE, 
	          n = 80, fullrange = FALSE, level = 0.95)

# general 
+ stat_identity  # as is
# args are additional arguements in dnorm
ggplot() + stat_function(aes(x = -3:3), fun = dnorm, n = 101, args = list(sd = 0.5))
ggplot() + stat_qq(aes(sample = 1:100), distribution = qt, dparams = list(df = 5))
+ stat_sum()
+ stat_summary(fun.data = ...)
+ stat_summary_bin(fun.data = ...)  # same as state_summary() but for binned data
+ stat_unique()  # remove duplicates

#=================================================================================
# scatter
#=================================================================================
qplot(data$x, data$y)  # or qplot(x, y, data=data)
# can control size, stroke, and alpha
ggplot(data, aes(x = x, y = y)) + geom_point()

# size the points according to the number of points at the overlapping points
+ geom_count()

# group points by fields; options: shape, colour, size, fillsp + stat_bin2d()
ggplot(data, aes(x = field1, y = field2, shape = field3, colour = field4, ...)) + 
  geom_point()
+ geom_point(position = 'jitter')  # add random noise to (x, y) to avoid overlapping
+ geom_jitter()  # same

# make a point's size proportional to its value (default size is the baseline)
+ scale_size(max_size = n)  # mapping is to area
+ scale_radius(max_size = n)  # mapping is to radius

# reducing scatter clutter, by creating a denstiy map
+ stat_bin2d(bins = nBins)  # bins data
# use + scale_fill_gradient(etc...) to further define the type of bins
+ stat_binnex(bins = nBins)  # bins data, into bins that are hexigonal in shape

# 1D scatter plot (i.e. scatter marginal rugs)
+ geom_rug()

#---------------------------------------------------------------------------------
# scatter with fit (see "line" for info on scatter with predicted values)

# lm
+ geom_point() + stat_smooth(method = lm, level = 0.99)  # default CI = 95%
+ geom_point() + stat_smooth(method = lm, se = FALSE)  # CI not added
# loess() draws a locally weighted polynomial (exact weigth unknown)

# glm - binomial
+ geom_point(position = position_jitter(width = w, height = h))  # scatter around a box
+ stat_smooth(method = glm, family = binomial)  # logistic is glm binomial

# plot the fits for all the groups, and along the entire set's full range
+ stat_smooth(fullrange = TRUE)

#---------------------------------------------------------------------------------
# scatter matrix
paris(data)  # ggplot2 not used here; pairs() is from base

# customize each of the boxes further (examples shown):
pairs(data, upper.panel = panel.cor, diag.panel = panel.hist, lower.panel = panel.smooth)
pairs(data, upper.panel = panel.cor, diag.panel = panel.hist, lower.panel = panel.lm)
# where:
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) {
	usr <- par("usr")
	on.exit(par(usr))
	par(usr = c(0, 1, 0, 1))
	r <- abs(cor(x, y, use = "complete.obs"))
	txt <- format(c(r, 0.123456789), digits = digits)[1]
	txt <- paste(prefix, txt, sep="")
	if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
	text(0.5, 0.5, txt, cex = cex.cor * (1 + r) / 2)
}
# where:
panel.hist <- function(x, ...) {
	usr <- par("usr")
	on.exit(par(usr))
	par(usr = c(usr[1:2], 0, 1.5) )
	h <- hist(x, plot = FALSE)
	breaks <- h$breaks
	nB <- length(breaks)
	y <- h$counts
	y <- y/max(y)
	rect(breaks[-nB], 0, breaks[-1], y, col = "white", ...)
}
# where:
panel.lm <- function (x, y, col = par("col"), bg = NA, pch = par("pch"),
	cex = 1, col.smooth = "black", ...) {
	points(x, y, pch = pch, col = col, bg = bg, cex = cex)
	abline(stats::lm(y ~ x), col = col.smooth, ...)
}

#=================================================================================
# line
#=================================================================================
qplot(x, y, data = data, geom = "line")
# plot line & point together
qplot(x, y, data = data, geom = c("line", "point")) 
ggplot(data, aes(x = y, y = y)) + geom_line() + geom_point()

# group lines (by field3)
ggplot(data, aes(x = field1, y = field2, colour = field3)) + geom_line()
ggplot(data, aes(x = field1, y = field2, linetype = field3)) + geom_line()
ggplot(data, aes(x = field1, y = field2, shape = field3)) + geom_line() + geom_point()
# calling group explicity is necessary for factors
ggplot(data, aes(x = field1, y = field2, group = field3)) + geom_line()

# fill area under line 
ggplot(data, aes(x = x, y = y)) + 
  geom_area(fill = "colour", alpha = 0.5, colour = "black", size = 0.1)  # alpha is transparency
# adds a line above the fill, instead of around it
ggplot(data, aes(x = x, y = y)) + geom_area(fill = "colour", alpha = 0.5) + geom_line() 

# stack lines 
ggplot(data, aes(x = field1, y = field2, fill = field3)) + 
  geom_line(position = "stack")
# fills the stacked lines
ggplot(data, aes(x = field1, y = field2, fill = field3)) + 
  geom_area() + geom_line(position = "stack")

# shows uncertainty, by fills
ggplot(data, aes(x = x, y = y)) + geom_line() + 
  geom_ribbon(aes(ymin = y - stdv, ymax = y + stdv), alpha = 0.2)
# shows uncertainty, by lines
ggplot(data, aes(x = x, y = y)) + geom_line() + 
  geom_line(aes(y = y - stdv)) + geom_line(ase(y = y + stdv))

# step
+ geom_step(direction 'hv')

# quantile (need library(quantreg))
+ geom_quantile()

# smooth, according to one of many methods: (see stat_smooth for more details)
# default is loess for n < 1000, gam for n >= 1000 
+ geom_smooth(method = methodOfChoice)

#---------------------------------------------------------------------------------
# prediction lines

# predict values, with input field values, and place results in a data.frame
predicted = predict(model, data.frame(xvalues))
# represent prediction with multiple points for lines
+ geom_line(data = predited)

# helper function: predictvals() 
# Given a model, predict values of yvar from xvar
# This supports one predictor and one predicted variable
#   xrange: If NULL, determine the x range from the model object. If a vector with
#     two numbers, use those as the min and max of the prediction range.
#   samples: Number of samples across the x range.
#   ...: Further arguments to be passed to predict()
predictvals <- function(model, xvar, yvar, xrange = NULL, samples = 100, ...) {
	# If xrange isn't passed in, determine xrange from the models.
	# Different ways of extracting the x range, depending on model type
	if (is.null(xrange)) {
		if (any(class(model) %in% c("lm", "glm")))
			xrange <- range(model$model[[xvar]])
		else if (any(class(model) %in% "loess"))
			xrange <- range(model$x)
	}
	newdata <- data.frame(x = seq(xrange[1], xrange[2], length.out = samples))
	names(newdata) <- xvar
	newdata[[yvar]] <- predict(model, newdata = newdata, ...)
	newdata
}

#---------------------------------------------------------------------------------
# functions

qplot(c(lbound, ubound), fun = myFunction, geom = "line", stat = "function")
ggplot(data.frame(x = c(lbound, ubound)), aes(x = x)) + 
  stat_function(fun = myFunction, geom = "line")

#---------------------------------------------------------------------------------
# line segments & arrows

# the start of the segment is in the ggplot()
ggplot(data, aes(x = x, y = y)) + 
  geom_segment(aes(yend = y + delta, xend = x + delta), 
  	           arrow = arrow(length = unit(length, "unit")))

#=================================================================================
# bar and box
#=================================================================================

#---------------------------------------------------------------------------------
# bar: 
# geom_bar() counts values at distinct value of x (does not bin the data first,
# which can be useful to show which values are used in a continuous variable)
# geom_histogram() bins the data
# use factor(x) to make x catagorical (instead of continuous)
# compute percentage yourself to get 100% stacked bar

# values: (x,y) = (catagories, number) inputs
qplot(x, y, data = data, geom = "bar", stat = "identity")
ggplot(BOD, aes(x = x, y = y)) + geom_bar(stat = 'identity')

# counts: histogram
qplot(data$x, binwidth = n)  # the narrow bands is more bars
ggplot(BOD, aes(x = x)) + geom_bar(binwidth = n)

# group bars (by z values)
ggplot(BOD, aes(x = x, y = y, fill = z)) + geom_bar(stat = 'identity') # stacked
ggplot(BOD, aes(x = x, y = y, fill = z)) + 
  geom_bar(stat = 'identity', position = 'dodge') # side-by-side

# same
+ geom_col(stat = 'identity')

# adjustments
+ geom_bar(binwidth = n, origin = xvalue)  # adjust starting point
+ geom_bar(width = 0.9)  # default bar width is 0.9 (0 < width ≤ 1)
+ geom_bar(position = 'dodge')  # side by side
+ geom_bar(position = 'stack')  # stack on top of each other
+ geom_bar(position = 'fill')  # stack on top of each other, normalizing the height
+ geom_bar(position = position_dodge(0.5))  # mannually change the proximity of bars
+ geom_bar(position = position_dodge(width = 0.5, height = 0.5))  # more control
+ guides(fill = guide_legend(reverse = T))  # match bar and legend order

#---------------------------------------------------------------------------------
# box
# use factor(x) to make x catagorical (instead of continuous)
qplot(x, y, data=data, geom="boxplot")
ggplot(data, aes(x=x, y=y)) + geom_boxplot()

# split a continuous variable into intervals of width w
geom_boxplot(aes(group = cut_width(x, w)))

# shows all interactions between multiple x variables
qplot(interaction(x1, x2), y, data=data, geom="boxplot")
ggplot(data, aes(x=interaction(x1, x2), y=y)) + geom_boxplot()

# group by field, if previously ungrouped
+ geom_boxplot(aes(group = field))
# to group all x values together, set x as arbitrary, and get rid of x-axis

# violin plot, with no trim, scaling area ~ nObservations, banwidth is n
+ geom_violin(trim = FALSE, scale = "count", adjust = n)

# adjustments
+ geom_boxplot(width = n, outlier.size = n, outlier.shape = n) # change shape
+ stat_summary(fun.y="mean", geom="point", fill="white") # adds means

#---------------------------------------------------------------------------------
# rectangle
+ geom_rect(aes(xmin = long, ymin = lat, xmax = long + delta_long, ymax = lat + delta_lat))

#---------------------------------------------------------------------------------
# other
ggplot(data, aes(x=x, y=y)) + geom_point()  # Cleveland
ggplot(data, aes(x=x, y=y)) + geom_dotplot() # Wilkinson: counts (see book for more info)

#=================================================================================
# data distributions
#=================================================================================

#---------------------------------------------------------------------------------
# empirical PDF

# condition on a particular variable
ggplot(data, aes(x = field1)) + geom_bar() + facet_grid(field2 ~ .)
ggplot(data, aes(x = field1)) + geom_bar() + 
  facet_grid(. ~ field2)  # rotates by 90 degree
ggplot(data, aes(x = field1)) + geom_bar() + 
  facet_grid(field2 ~ ., scales="free")  # allows individual plots' scales to vary
ggplot(data, aes(x=field1, fill=factor(field2))) + 
  geom_bar(position="identity")  # different fill colors on the same graph

# include density curves
+ geom_line(stat = "density", adjust = n) + 
  expand_limits(y = 0)  # include y = 0 on the graph, and adjust the banwidth to n
+ geom_density(fill = "blue", color = NA, alpha = 0.2)  # fill the area under the line
# kernel could be:  "gaussian", "epanechnikov", "rectangular", "triangular", 
# "biweight", "cosine", "optcosine" 
+ geom_density(kernel = 'gaussian')
ggplot(data, aes(x = field1, y = ..density..)) + geom_bar()  # add a histogram

# include density curves of multiple data
ggplot(data, aes(x = field1, fill = factor(field2))) + geom_density()
ggplot(data, aes(x = field1)) + geom_density() + 
  facet_grid(field2 ~ .) # on separate graphs
ggplot(data, aes(x = field1, y = ..density..)) + geom_bar()  # add a histogram

# frequency ploygon (histogram with lines, and no curves)
+ geom_freqpoly(banwidth = n)
+ geom_area(stat = 'bin')  # fills

#---------------------------------------------------------------------------------
# 2D empirical PDF (essentially the same as the 1D empirical PDF)
ggplot(data, aes(x = x, y = y)) + geom_point() + stat_density2d() # points & contour
ggplot(data, aes(x = x, y = y)) + stat_density2d(aes(colour=..level..)) # colour id

# raster / tiles (these are estimates, like density)
+ stat_density2d(aes(fill = ..density..), geom = "raster", contour = FALSE)
+ stat_density2d(aes(alpha = ..density..), geom = "raster", contour = FALSE) + 
  geom_point() # takes different shades, and add points
+ stat_density2d(aes(alpha = ..density..), geom = "raster", contour = FALSE, 
	             h = c(xBand, yBand)) # adds banwidth, in the x and y direction
# bins (these are actual counts, like histograms)
+ stat_bin_2d()

# similarly
+ geom_bind2d(binwidth = c(5, 5))
+ geom_density2_d()  # contour
+ geom_hex()  # requires library(hexbin)

#---------------------------------------------------------------------------------
# other
+ stat_ecdf()  # empirical CDF
qqnorm(data)  # QQ plot, compared to a normal distribution
qqline(data)  # adds a line to the qq plot

#=================================================================================
# other graphs
#=================================================================================
pie(data) # pie
corrplot(cor(data), method="shade") # # correlation (for more options, get help)
plot3d(x, y, z, type = "s", lit = FALSE) # 3D; s for sphere (pg283 for more info)
+ geom_tile(aes(fill = z))  # heatmap, with tiles
+ geom_raster(aes(fill = z), hjust = 0.5, vjust = 0.5, interpolate = F)  # w/ raster
+ geom_contour(aes(z = z))  # contour
+ geom_segment()  # vector field: essentially using segments (pg294 for more info)
+ geom_curve()  # same as segment, but curved
+ stat_function(fun = FUNCTION)  # function

#---------------------------------------------------------------------------------
# network
set.seed("number") # vertex are place randomly
gd <- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6)) # define edges
gd <- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6), directed=FALSE) # define undirected edges
plot(gd)

# adjustments
g <- graph.data.frame(data)
plot(g, layout = layout.fruchterman.reingold, vertex.size = 8, edge.arrow.size = 0.5, 
	 vertex.label = NA)
plot(g, layout = layout.circle, vertex.size = 8, edge.arrow.size = 0.5, 
	 vertex.label = NA)
# vertex adjustments
V(g)$size <- 4
V(g)$label <- V(g)$name
V(g)$label.cex <- 0.4
V(g)$label.dist <- 0.8
V(g)$label.color <- "black"
# edges adjustments
E(g)$label <- ...
E(g)$color <- ...

#---------------------------------------------------------------------------------
# dendrogram
data <- scale(data) # weighs each attribute equally
hc <- hclust(dist(data)) # cluster based on (euclidean) distance (other types available)
plot(data, hang = -1) # "hang = -1" to put all the names on the same line

#---------------------------------------------------------------------------------
# mosaic
mosaic(~ field1 + field2 ..., data = data, 
	   highlighting = "field1", highlighting_fill = c("field1value1","field1value2", ...),
	   direction = c("v", "h", ...)) # direction of each fields

#---------------------------------------------------------------------------------
# map
map <- map_data(data)
ggplot(map, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "white", colour = "black") + coord_map("mercator")
ggplot(map, aes(x = long, y = lat, group = group)) + geom_path()  # clear map

# similarly
geom_map(aes(map_id = group), map = map)

# read from shapefile
map_shp <- readShapePloy("file")
map_map <- fortify(map_shp)

#=================================================================================
# graph appearance
#=================================================================================
# Elements in theme()
# All located in: http://docs.ggplot2.org/current/theme.html
#---------------------------------------------------------------------------------
# Theme elements 	Text geoms 		Description
#---------------------------------------------------------------------------------
# family 			family 			Helvetica, Times, Courier
# face 				fontface 		plain, bold, italic, bold.italic
# colour 			colour 			Color (name or "#RRGGBB")
# size 				size 			Font size (in points for theme elements; 
#                                   in mm for geoms)
# hjust 			hjust 			Horizontal alignment: 0=left, 0.5=center, 1=right
# vjust 			vjust 			Vertical alignment: 0=bottom, 0.5=middle, 1=top
# angle 			angle 			Angle in degrees
# lineheight 		lineheight 		Line spacing multiplier
#---------------------------------------------------------------------------------
# Name 				Description 									Element type
#---------------------------------------------------------------------------------
# text 				All text elements 								element_text()
# rect 				All rectangular elements 						element_rect()
# line 				All line elements 								element_line()
# axis.line 		Lines along axes 								element_line()
# axis.title 		Appearance of both axis labels 					element_text()
# axis.title.x 		X-axis label appearance 						element_text()
# axis.title.y 		Y-axis label appearance 						element_text()
# axis.text 		Appearance of tick labels on both axes 			element_text()
# axis.text.x 		X-axis tick label appearance 					element_text()
# axis.text.y 		Y-axis tick label appearance 					element_text()
# legend.background Background of legend 							element_rect()
# legend.text 		Legend item appearance 							element_text()
# legend.title 		Legend title appearance 						element_text()
# legend.position 	Position of the legend 							"left", "right", 
# 					"bottom", "top", or two-element numeric vector if you wish to place it
# 					inside the plot area (for more on legend placement, see Recipe 10.2)
# panel.background 	Background of plotting area 					element_rect()
# panel.border 		Border around plotting area 					element_rect(
#																	linetype = "dashed")
# panel.grid.major 	Major grid lines 								element_line()
# panel.grid.major.x 	Major grid lines, vertical 					element_line()
# panel.grid.major.y 	Major grid lines, horizontal 				element_line()
# panel.grid.minor 	Minor grid lines 								element_line()
# panel.grid.minor.x 	Minor grid lines, vertical 					element_line()
# panel.grid.minor.y 	Minor grid lines, horizontal 				element_line()
# plot.background 	Background of the entire plot 					element_rect(
#																	fill = "white", 
#																	colour = NA)
# plot.title 		Title text appearance 							element_text()
# strip.background 	Background of facet labels 						element_rect()
# strip.text 		Text appearance for v & h facet labels 			element_text()
# strip.text.x 		Text appearance for h facet labels 				element_text()
# strip.text.y 		Text appearance for v facet labels 				element_text()

#---------------------------------------------------------------------------------
# annotation
# - to make something standout, overlay the original plot with a new layer

# text
# at points' locations (essentially one plot per datapoint)
+ geom_text(aes(label = valueLabled), vjust = byY, hjust = byX, colour = "color")
# byY and byX can be 'left', 'center', 'right', 'bottom', 'middle', 'top', 'inward', 'outward'
# position_nudge() can be used for other geoms as well
+ geom_text(position = position_nudge(y = byY, x = byx))
# or 
+ geom_text(nudge_x = byX, nudge_y = byY)
# at a specific location ((x = -Inf, y = Inf) means top left)
+ annotate("text", label = "label", x = x, y = y,
	       familiy = "serif", fontface = "italic")
# same as geom_text, but with rounded rectangle underneath each label
+ geom_label()

# mathematical expressions 
+ annotate("text", label = "label", parse = TRUE, x = x, y = y)
# initiate "parse" to use R's math expression syntax (NOTE: "==" is needed)
# e.g.: label = "frac(1, sqrt(2 * pi)) * e ^ {-x^2 / 2}"
# e.g.: label = "'Function: ' * y == frac(1, sqrt(2*pi)) * e^{-x^2/2}"

# lines (essentially the same as geom_line)
+ geom_hline(yintercept = y)
+ geom_vline(xintercept = x)
+ geom_abline(intercept = i, slope = s)

# segments, with arrows
+ annotate("segment", x = x, xend = xend, y = x, yend = yend, 
		   arrow = arrows(end = "both", angle = x, length = unit(l, "cm")))

# shaded rectangle
+ annotate("rect", xim = x1, xmax = x2, ymin = y1, ymax = y2, 
	       alpha = 0.1, fill = "colour")

# error bar
+ geom_errorbar(aes(ymin = y - se, ymax = y + se), width = 0.2)
+ geom_errorbar(aes(ymin = y - se, ymax = y + se), width = 0.2,
	            position = position_dodge(0.9)) # space out with multiple histograms
+ geom_crossbar(fatten = 2)  # box
+ geom_linerange()  # line
+ geom_pointrange()  # points + line

# different annotations in each facet
+ geom_text(x = x, y = y, aes(label = label), data = label_data)
# where label_data is a data.frame of a column that contains the original data's factors

# helper function: lm_labels() 
# This function returns a data frame with strings representing the regression
# equation, and the r^2 value
# These strings will be treated as R math expressions
lm_labels <- function(dat) {
	mod <- lm(hwy ~ displ, data=dat)
	formula <- sprintf("italic(y) == %.2f %+.2f * italic(x)",
						round(coef(mod)[1], 2), round(coef(mod)[2], 2))
	r <- cor(dat$displ, dat$hwy)
	r2 <- sprintf("italic(R^2) == %.2f", r^2)
	data.frame(formula=formula, r2=r2, stringsAsFactors=FALSE)
}

#---------------------------------------------------------------------------------
# axes
+ scale_x_continuous(expand = c(0, 0))  # get rid of padding on the left/right
+ scale_x_continuous(position = "top")  # axis on top
+ scale_y_continuous(position = "right")  # axis on the right
+ coord_flip()  # swaps x- and y-axes
+ coord_fixed(ratio = 1)  # fix aspect ratio
+ coord_polar()  # circular
+ coord_trans(ytrans = 'sqrt')  # transform axis

# range
+ xlim(minX, maxY) # short for scale_x_continuous(limits = c(minX, maxX))
+ coord_cartesian(ylim = c(...), xlim = c(...)) # zooms in, without clipping
+ scale_x_reverse(limtis = c(...)) # reverse the axes
+ scale_x_discrete(limits = c(...)) # change the order
+ scale_x_discrete(limits = rev(levels(...)))  # an example of such change

# tick marks (necessary to use the _continuous version to add other elements)
+ scale_x_continuous(breaks = NULL)  # get rid of axes and lines
+ scale_y_continuous(limts = c(minY,maxY), 
                     breaks = c(...), labels = c(...))  # assign breaks & labels
# gets rid of axes ticks, texts, titles, and lines
+ theme(axis.ticks = element_blank(), axis.text.x = element_blank(),
		axis.title.x = element_blank(), axis.line = element_blank()) 
+ theme(axis.text.x = element_text(angle = degree, hjust = h, vjust = v))  # tilts
+ theme(axis.text.x = element_text(size = rel(0.9))  # adjust the relative font size
+ theme(axis.line = element_line(colour = "colour", lineend = "square", size = s))

# label
labs(x = "", y = "")  # or xlab(), ylab(); in this case, the labels are blank
scale_x_continuous(name = "line1\nline2")  # id., with two lines

# secondary axis: one-to-one transformation 
+ scale_y_continuous("primary", sec.axis = sec_axis(~ . * 1.2, name = "secondary"))

# sqrt scale
+ scale_x_sqrt()

# log scale
+ scale_x_log10(breaks = , labels = trans_format("log10")) # log scale
+ scale_x_log10(breaks = , labels = trans_format("log10", math_format(10^.x)))  # 10^()
+ scale_x_continuous(trans = log_trans(), 
	                 breaks = trans_breaks("log", function(x){exp(x)}),
                     labels = trans_format("log", math_format(e^.x)))  # e
+ scale_x_continuous(trans = log2_trans(), 
	                 breaks = trans_breaks("log2", function(x){2^x}),
                     labels = trans_format("log2", math_format(2^.x)))  # 2
+ annotation_logticks() # tic marks
# to get the internal grid lines to match the tic marks better:
+ scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
				labels = trans_format("log10", math_format(10^.x)),
				minor_breaks = log10(5) + -1:3)

# time
+ scale_x_date(breaks = seq(as.Date("1992-06-01"), as.Date("1993-06-01"), 
               by = "2 month"), labels=date_format("%Y %b")) # only year & month shown
# %Y Year with century (2012)
# %y Year without century (12)
# %m Month as a decimal number (08)
# %b Abbreviated month name in current locale (Aug)
# %B Full month name in current locale (August)
# %d Day of month as a decimal number (04)
# %U Week of the year as a decimal number, with Sunday as the first day of the week (00–53)
# %W Week of the year as a decimal number, with Monday as the first day of the week (00–53)
# %w Day of week (0–6, Sunday is 0)
# %a Abbreviated weekday name (Thu)
# %A Full weekday name (Thursday)
# also has: date_breaks, date_minor_breaks, and date_labels

# helper function: timeHM_formatter(), and timeHMS_formatter() 
# Define a formatter function - converts time in minutes to a string
timeHM_formatter = function(x) {
	h = floor(x/60)
	m = floor(x %% 60)
	lab = sprintf("%d:%02d", h, m) # Format the strings as HH:MM
	return(lab)
}
# To convert to HH:MM:SS format
timeHMS_formatter = function(x) {
	h = floor(x/3600)
	m = floor((x/60) %% 60)
	s = round(x %% 60) # Round to nearest second
	lab = sprintf("%02d:%02d:%02d", h, m, s) # Format the strings as HH:MM:SS
	lab - sub("^00:", "", lab) # Remove leading 00: if present
	lab = sub("^0", "", lab) # Remove leading 0 if present
	return(lab)
}
# usage
+ scale_x_continuous(name = "time", breaks = ..., labels = timeHM_formatter)

#---------------------------------------------------------------------------------
# appearance 
theme_set(...) # set the default theme in R
theme_get() # get the current theme
theme_update() # update the current theme

# background and base (see ggplot2_theme.R for more information)
+ theme_gray() # default: grey background + white gridlines
+ theme_bw() # dark on light
+ theme_linedraw() # darker lines than theme_bw()
+ theme_light() # lighter words than theme_bw()
+ theme_minimal() # no background
+ theme_classic() # no gridlines
+ theme_void()  # empty
+ theme_dark()  # dark, to make colours pop out

# title
+ labs(title = "title", subtitle = "subtitle", caption = "caption")  # same as ggtitle()
+ theme(plot.title = element_text(...)) # to change the plot title's text format
+ annotate("text", x=mean(range(xValues)), y=Inf,label="Title", vjust=1.5, size=6,
		   fontface="bold.italic", family="Times") # use annotate() instead

#---------------------------------------------------------------------------------
# legends
# - ggplot2 tends to reverse the order of the graph and the legend; so, either 
#   adjust it in order in ggplot(), or in scale_fill_brewer()
ggplot(data, aes(x=x, y=y, fill=group))
# - the types of legends, matching the types of groupings
# scale_fill_discrete() # can use this to change the order
# scale_fill_hue() # id.
# scale_fill_manual()
# scale_fill_grey()
# scale_fill_brewer()
# scale_colour_discrete()
# scale_colour_hue()
# scale_colour_manual()
# scale_colour_grey()
# scale_colour_brewer()
# scale_shape_manual()
# scale_linetype()
# scale_linetype_manual()
# scale_*_identity()  # use data values as visual values

# change the labels for >1 scales: list them separately
+ scale_fill_discrete(labels = c(...)) + scale_colour_discrete(labels=c(...)) 

# remove legend
+ guides(fill = FALSE)  # or
+ scale_fill_discrete(guide = FALSE)  # or
+ theme(legend.position = "none")

# reverse the legend order
+ guides(fill = guide_legend(reverse = TRUE))  # or
+ scale_fill_hue(guide = guide_legend(reverse = TRUE))

# position
+ theme(legend.position = c(x,y), legend.justification = c(x,y)) # j is (.5,.5) by default
+ theme(legend.background = element_blank(), legend.key() = element_blank()) # transparant

# text
+ guides(fill = guide_legend(label.theme = element_text(...)))  # text
+ scale_fill_discrete(name = "Title")  # title, or
+ labs(fill = "Title")  # title
+ scale_fill_hue(guide = guide_legend(title = NULL)) # no title

#---------------------------------------------------------------------------------
# groups (facets)

# which fields
+ facet_grid(field1 ~ .) # field1 vs. all
+ facet_grid(. ~ field1) # all vs. field1 
+ facet_grid( ~ field1) # each of the other fields vs. field2
+ facet_grid(field1 ~ field2) # field1 vs. field2

# format
+ facet_wrap(~ field1, nrow = y, ncol = x, strip.position = 'bottom')  # position
+ theme(strip.placement = "outside")  # position with respect to the entire plot
+ facet_grid(field1 ~ field2, scales = 'free', space = 'free') # or free_y, free_x

# labeling both variables, in each facet; more info: http://docs.ggplot2.org/dev/labellers.html
+ facet_grid(field1 ~ ., labeller = label_both)  # both variable and value
+ facet_grid(field1 ~ ., labeller = label_parsed)  # if label is a mathematical exp.
+ facet_grid(field1 ~ ., labeller = label_bquote(alpha.^(X)))  # math

# add expressions to cut continuous r.v. into discrete r.v. that's facet-able
+ facet_warp(~cut_interval(x, n))  # cut x into n equal range 
+ facet_warp(~cut_number(x, n))  # cut x into n groups of roughly equal observations
+ facet_warp(~cut_width(x, width))  # cut x into groups of certain width

#=================================================================================
# colors and shapes
#=================================================================================
# fill = area colour
# colour = outline colour 
muted("colour") # return a less-saturated version of the color chosen
+ scale_colour_discrete(l = 45) # default luminance is 65 (range of (0,100))

# sequential, diverging and qualitative colour schemes
+ scale_fill_brewer(palette = 'palettetype') # guide=F to rid of color legend
+ scale_fill_brewer(palette = 'palettetype', breaks = rev(levels(x)))  # reverse

# gradient (fill and / or color)
+ scale_fill_gradient(low = "lColor", high = "uColour", limits = c(lEnd, uEnd))  # continuous
+ scale_fill_gradient(low = "lColor", high = "uColour", limits = c(lEnd, uEnd), 
	                  breaks=c(...), guide=guide_legend())  # discrete
+ scale_colour_gradient2(low = muted("red"), mid = "white", high = muted("blue"), 
	                   midpoint=110) # with white mid-point (i.e. divergent)
+ scale_colour_gradientn(colours = c("darkred", "orange", "yellow"))  # gradient of n colors

# user-input
+ scale_fill_manual(values = c("color1", "color2"))  # colors;  NA = no fill
+ scale_shape_manual(values = c(1, 2, etc...))  # shapes
+ scale_shape(solid = F)  # hollow shapes

#=================================================================================
# output
#=================================================================================
ggsave("myplot.pdf", width = x, height = y, units = "cm")
ggsave("myplot.svg", width = x, height = y, units = "cm")  # web
ggsave("myplot.eps", width = x, height = y, units = "cm")  # print

#=================================================================================
# library(GGally)
#=================================================================================
# better correlation matrices, pairwise plots, etc.
# https://ggobi.github.io/ggally/

#=================================================================================
# ggvis
#=================================================================================
# the goal is to leverage library(shiny)
# NOTE: ggvis() is still very early in its development, as of November 2014

#=================================================================================
# shiny
#=================================================================================
# shiny is a "reactive programming", which recomputes the data upon user's command; 
# it is meant not to replace JavaScript/HTML, but to empower R users to expand 
# the dimensions of data analysis
# see R_graphics_interactive.R for more info

#=================================================================================
# RColorBrewer
#=================================================================================
# sensible colour schemes for R

display.brewer.all()  # to show all schemes
