#================================================================================= 
# [table of contents]
#   - htmlwidgets
#   - time series
#   - graph
#   - heat maps
#=================================================================================

#=================================================================================
# htmlwidgets
#=================================================================================
# - htmlwidgets is "interactive", which allows for
# - Use JavaScript visualization libraries at the R console, just like plots
# - Embed widgets in R Markdown documents and Shiny web applications
# - Develop new widgets using a framework that seamlessly bridges R and JavaScript
# http://gallery.htmlwidgets.org/

#=================================================================================
# time series
#=================================================================================

#---------------------------------------------------------------------------------
# library(dygraphs) http://rstudio.github.io/dygraphs/index.html
# plots library(xts) time series objects

data <- cbind(xts_1, xts_2)  # combine xts series data
dygraph(data, main = "Title")  # xlab and ylab for axis labels, or in dyAxis()

# add options with %>%
dyOptions(colors = RColorBrewer::brewer.pal(3, "Spectral"))
dyOptions(stepPlot = TRUE)  # step
dyOptions(stackedGraph = TRUE)  # stacked
dyOptions(fillGraph = TRUE, fillAlpha = 0.4)  # fill
dyOptions(drawPoints = TRUE, pointSize = 2)  # draw points
dyOptions(strokeWidth = 2, strokePattern = "dashed")

# options for particular series
dySeries('xts_1', options_1) %>%
dySeries('xts_2', options_2)

# upper/lower bars, for the prediction
dySeries("ldeaths", label = "Actual") %>%
dySeries(c("p.lwr", "p.fit", "p.upr"), label = "Predicted")

# series highlight
dyHighlight(highlightCircleSize = 5, 
            highlightSeriesBackgroundAlpha = 0.2,
            hideOnMouseOut = FALSE,
            highlightSeriesOpts = list(strokeWidth = 3))

# axis options
dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = FALSE, includeZero = TRUE,
          axisLineColor = "navy", gridLineColor = "lightblue")

# options for particular axis
dyAxis("x", drawGrid = FALSE) %>%
dyAxis("y", label = "Temp (F)", valueRange = c(40, 60))

# second y-axis, with independent ticks
dySeries('xts_2', axis = 'y2') %>%
dyAxis("y2", label = "Rainfall", independentTicks = TRUE)

# legend
dyLegend(show = "follow", width = 400)

# range selector, with initial window
dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"), height = 20, strokeColor = "")
# for shiny to respond to changes in dateWindow
output$from <- renderText({
  if (!is.null(input$dygraph_date_window))
    strftime(input$dygraph_date_window[[1]], "%d %b %Y")      
})

# synchronization: all graphs with the same "group" sync
dygraph(ldeaths, main = "All", group = "lung-deaths")
dygraph(mdeaths, main = "Male", group = "lung-deaths")
dygraph(fdeaths, main = "Female", group = "lung-deaths")

# smooth out graph
dyRoller(rollPeriod = 5)

# shading
dyShading(from = "1940-1-1", to = "1950-1-1", color = "#CCEBD6") %>% 
dyShading(from = mn - std, to = mn + std, axis = "y")  # horizontal

# verticle event lines
dyEvent("1965-2-09", "Vietnam", labelLoc = "bottom")
# horizontal limit lines
dyLimit(value, color = "red")

# annotation
# the actual dates of the two events are not used for the annotation. Rather, 
# dates that align with the quarterly boundaries of the time series are used 
# (dygraphs will only include annotations that exactly match one of it’s x-axis values).
dyAnnotation("1950-7-1", text = "A", tooltip = "Korea") %>%
dyAnnotation("1965-1-1", text = "B", tooltip = "Vietnam")

#=================================================================================
# graph
#=================================================================================

#---------------------------------------------------------------------------------
# library(DiagrammeR) http://rich-iannone.github.io/DiagrammeR/

DiagrammeR(paste0("graph LR;", paste0(
  sprintf("%s-->%s", edges$source_name, edges$target_name), 
  collapse = ";")),
  width = 2500, height = 2500)

#---------------------------------------------------------------------------------
# library(visNetwork) http://datastorm-open.github.io/visNetwork/


#=================================================================================
# heat maps
#=================================================================================

#---------------------------------------------------------------------------------
# library(d3heatmap) https://github.com/rstudio/d3heatmap

d3heatmap(mtcars, scale = "column", colors = "Spectral")

