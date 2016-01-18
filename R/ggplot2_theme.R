#=================================================================================
# customizes ggplot2 theme
#=================================================================================

#=================================================================================
# empty cell, for library(grid) and library(gridExtra)
#=================================================================================
empty <- 
   ggplot() + 
   geom_point(aes(1, 1), colour = "white") +
   theme(
     plot.background = element_blank(), 
     panel.grid = element_blank(), 
     panel.border = element_blank(), 
     panel.background = element_blank(),
     axis.title = element_blank(),
     axis.text = element_blank(),
     axis.ticks = element_blank()
   )

#=================================================================================
# theme
#=================================================================================
# NULL = as before / as default 
# NA = none

new <- theme_set(theme_bw())
new <- theme_update(

#=================================================================================
# all elements
#=================================================================================
line = element_line(
		colour 		= "black",
		size 		= 0.5,
		linetype 	= 1,
		lineend 	= "butt"
	),
rect = element_rect(
		fill 		= "white",
		colour 		= "black",
		size 		= 0.5,
		linetype 	= 1
	),
text = element_text(
		family 		= "Helvetica",
		face 		= "plain",
		colour 		= "black",
		size 		= 12,
		hjust 		= 0.5,
		vjust 		= 0.5,
		angle 		= 0,
		lineheight 	= 0.9
	),

#=================================================================================
# text
#=================================================================================

#---------------------------------------------------------------------------------
# axis
axis.text = element_text(
		family 		= NULL,
		face 		= NULL,
		colour 		= "grey25",
		size 		= rel(3/4),
		hjust 		= NULL,
		vjust 		= NULL,
		angle 		= NULL,
		lineheight 	= NULL
	),
	axis.text.x = element_text(
			family 		= NULL,
			face 		= NULL,
			colour 		= NULL,
			size 		= NULL,
			hjust 		= NULL,
			vjust 		= 1,
			angle 		= NULL,
			lineheight 	= NULL
		),
	axis.text.y = element_text(
			family 		= NULL,
			face 		= NULL,
			colour 		= NULL,
			size 		= NULL,
			hjust 		= 1,
			vjust 		= NULL,
			angle 		= NULL,
			lineheight 	= NULL
		),

#---------------------------------------------------------------------------------
# title
plot.title = element_text(
		family 		= NULL,
		face 		= NULL,
		colour 		= NULL,
		size 		= rel(5/4),
		hjust 		= NULL,
		vjust 		= NULL,
		angle 		= NULL,
		lineheight 	= NULL
	),
axis.title = element_text(
		family 		= NULL,
		face 		= "plain",
		colour 		= NULL,
		size 		= NULL,
		hjust 		= NULL,
		vjust 		= NULL,
		angle 		= NULL,
		lineheight 	= NULL
	),
	axis.title.x = element_text(
			family 		= NULL,
			face 		= NULL,
			colour 		= NULL,
			size 		= NULL,
			hjust 		= NULL,
			vjust 		= NULL,
			angle 		= NULL,
			lineheight 	= NULL
		),
	axis.title.y = element_text(
			family 		= NULL,
			face 		= NULL,
			colour 		= NULL,
			size 		= NULL,
			hjust 		= NULL,
			vjust 		= NULL,
			angle 		= 90,
			lineheight 	= NULL
		),

#---------------------------------------------------------------------------------
# strip
strip.text = element_text(
		family 		= NULL,
		face 		= NULL,
		colour 		= "grey25",
		size 		= NULL,
		hjust 		= NULL,
		vjust 		= NULL,
		angle 		= NULL,
		lineheight 	= NULL
	),
	strip.text.x = element_text(
			family 		= NULL,
			face 		= NULL,
			colour 		= NULL,
			size 		= NULL,
			hjust 		= NULL,
			vjust 		= NULL,
			angle 		= NULL,
			lineheight 	= NULL
		),
	strip.text.y = element_text(
			family 		= NULL,
			face 		= NULL,
			colour 		= NULL,
			size 		= NULL,
			hjust 		= NULL,
			vjust 		= NULL,
			angle 		= 90,
			lineheight 	= NULL
		),

#---------------------------------------------------------------------------------
# legend
legend.text = element_text(
		family 		= NULL,
		face 		= NULL,
		colour 		= NULL,
		size 		= NULL,
		hjust 		= NULL,
		vjust 		= NULL,
		angle 		= NULL,
		lineheight 	= NULL
	),
legend.title = element_text(
		family 		= NULL,
		face 		= NULL,
		colour 		= NULL,
		size 		= NULL,
		hjust 		= NULL,
		vjust 		= NULL,
		angle 		= NULL,
		lineheight 	= NULL
	),
legend.text.align   = 0.5, # 0 to 1
legend.title.align   = 0.5, # 0 to 1

#=================================================================================
# plot area
#=================================================================================

#---------------------------------------------------------------------------------
# plot area
plot.background = element_rect(
		fill		= "white",
		colour		= NA,
		size		= NULL,
		linetype	= NULL
	),
panel.background = element_rect(
		fill 		= NA,
		colour 		= NA,
		size 		= NULL,
		linetype 	= NULL,
	),
strip.background = element_rect(
		fill 		= "grey90",
		colour 		= NA,
		size		= NULL,
		linetype	= NULL
	),

#---------------------------------------------------------------------------------
# grids
panel.border = element_rect(
		fill 		= NA,
		colour 		= "grey90",
		size 		= 0.25,
		linetype 	= NULL,
	),
axis.ticks = element_line(
		colour 		= "grey75",
		size 		= NULL,
		linetype 	= NULL,
		lineend 	= NULL
	),
axis.ticks.length   = unit(1/4, "lines"),
axis.line			= element_blank(),
panel.grid.major = element_line(
		colour 		= "grey75",
		size 		= 0.25,
		linetype 	= NULL,
		lineend 	= NULL
	),
	panel.grid.major.x = element_line(
			colour 		= NULL,
			size 		= NULL,
			linetype 	= NULL,
			lineend 	= NULL
		),
	panel.grid.major.y = element_line(
			colour 		= NULL,
			size 		= NULL,
			linetype 	= NULL,
			lineend 	= NULL
		),
panel.grid.minor = element_line(
		colour 		= "grey90",
		size 		= 0.125,
		linetype 	= NULL,
		lineend 	= NULL
	),
	panel.grid.minor.x = element_line(
			colour 		= NULL,
			size 		= NULL,
			linetype 	= NULL,
			lineend 	= NULL
		),
	panel.grid.minor.y = element_line(
			colour 		= NULL,
			size 		= NULL,
			linetype 	= NULL,
			lineend 	= NULL
		),

#---------------------------------------------------------------------------------
# legend
legend.background = element_rect(
		fill		= NULL,
		colour		= NA,
		size		= NULL,
		linetype	= NULL
	),
legend.position 	= "right", # or left, bottom, top or two-element numeric vector
legend.direction 	= "vertical", # or horizontal
legend.justification= "center", # or two-element numeric vector
legend.key = element_rect(
		fill		= NULL,
		colour		= NA,
		size		= NULL,
		linetype	= NULL
	),
legend.key.size 	= unit(1, "lines"),
legend.key.height   = NULL,
 legend.key.width    = NULL,
 legend.box          = NULL,

#---------------------------------------------------------------------------------
# margins
plot.margin			= unit(c(1/4,1/4,1/4,1/4), "lines"),
panel.margin     	= unit(1/4, "lines"),
panel.margin.x      = NULL,
panel.margin.y      = NULL,
axis.ticks.margin 	= unit(1/4, "lines"),
legend.margin     	= unit(1/4, "lines")

)