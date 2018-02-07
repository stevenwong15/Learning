#=================================================================================
# customizes ggplot2 theme
#=================================================================================

theme_set(theme_minimal())

#=================================================================================
# theme update
#=================================================================================
# NULL = as parent; NA = none

theme_update(

#=================================================================================
# all elements
#=================================================================================
# element_blank() draws nothing

text = element_text(
		family = "Helvetica",
		face = "plain",
		colour = "black",
		size = 11,
		hjust = 0.5,
		vjust = 0.5,
		angle = 0,
		lineheight = 0.9,
		margin = NULL,
		debug = FALSE
	),
rect = element_rect(
		fill = "white",
		colour = "black",
		size = 0.5,
		linetype 	= 1
	),
line = element_line(
		colour = "black",
		size = 0.5,
		linetype = 1,
		lineend = "butt"
	),

#=================================================================================
# plot area
#=================================================================================

plot.margin = unit(c(t = 5, r = 5, b = 5, l = 5), "pt"),

panel.border = element_rect(
		fill = NA,
		colour = "grey95"
	),
panel.grid.major = element_line(
		colour = "grey75",
		size = 0.25
	),
panel.grid.minor = element_line(
		colour = "grey85",
		size = 0.125,
	),

#=================================================================================
# axis
#=================================================================================

axis.text = element_text(
		colour = "grey25"
	),
axis.text.x = element_text(
		vjust = 1
	),
axis.text.y = element_text(
		hjust = 1
	),

#---------------------------------------------------------------------------------
# axis title

axis.title = element_text(
		colour = "grey25"
	),
axis.title.x = element_text(
	),
axis.title.y = element_text(
		angle = 90
	),

#---------------------------------------------------------------------------------
# axis ticks

axis.ticks = element_line(
		colour = "grey75"
	),

axis.ticks.length = unit(2.5, "pt"),
axis.line = element_blank(),

#=================================================================================
# title
#=================================================================================

plot.title = element_text(
		hjust = 0.5
	),
plot.subtitle = element_text(
		size = 9,
		hjust = 0.5
	),
plot.caption = element_text(
		size = 7,
		hjust = 0.5
	),

#=================================================================================
# strip
#=================================================================================

strip.text = element_text(
		colour = "grey25",
		face = "bold"
	),
strip.text.x = element_text(
	),
strip.text.y = element_text(
		angle = 90
	),

strip.background = element_rect(
		fill = "grey95",
		colour = "grey95"
	),

#=================================================================================
# legend
#=================================================================================

legend.text = element_text(
		size = 9
	),
legend.title = element_text(
		size = 9
	),
legend.text.align = 0.5,
legend.title.align = 0.5,

legend.position = "right",
legend.direction = "vertical", 
legend.justification = "center",

legend.key = element_rect(
		fill = NA,
		colour = NA
	),
legend.key.size = unit(9, "pt"),

legend.box.background = element_rect(
		fill = NA,
		colour = NA
	),
legend.box.margin = unit(c(t = 1, r = 1, b = 1, l = 1), "pt"),
legend.box.spacing = unit(c(t = 1, r = 1, b = 1, l = 1), "pt")

)
