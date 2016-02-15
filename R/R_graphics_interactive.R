#================================================================================= 
# [table of contents]
# 	- resources
#   - operate
#   - user-interface: ui.R
#   - running the app: server.R
#   - special functions for special purposes
#   - share
#   - htmlwidgets
#   - library(shinythemes)
#   - library(shinydashboard)
#=================================================================================

#=================================================================================
# resources
#=================================================================================
# shiny is a "reactive programming", which recomputes the data upon user's command; 
# it is meant not to replace JavaScript/HTML, but to empower R users to expand 
# the dimensions of data analysis: http://shiny.rstudio.com/

#=================================================================================
# operate
#   - bar minimums
#   - running an app
#=================================================================================

#---------------------------------------------------------------------------------
# bare minimums
# shiny has two components (at minimum) in the 'appName' folder: 
# 1. user-interface script (ui.R)
# 2. server script: instructions the computer needs to build your app (server.R)

# ui.R
# fluidPage() create a display that automatically adjusts to the browser's dim
fluidPage(...)

# server.R
function(input, output){...}

# (optional) www folder
# directory of files to share with web browser (images, CSS, .js, etc.)

# (optional) DESCRIPTION document, in DCF format
# runApply() with showcase mode can host these information on the ui

# (optional) Readme.md
# runApply() with showcase mode can host these information on the ui

# NOTE: in lieu of 2 scripts for ui.R and server.R, they can be combined in app.R:
server <- function(input, output){...}
ui <- fluidPage(...)

#---------------------------------------------------------------------------------
# running an app

# in the ui.R & server.R format
runApp("appName")  # run app from current directory
runApp("appName", display.mode = "showcase")  # show the source code

# in the app.R format
app <- shinyApp(ui = ui, server = server)
app

# exit
esc  # escape to stop: no R operations can be performed while app is running

#=================================================================================
# user-interface: ui.R
#  - standard Shiny widgets, *input
#  - R objects, *ouput
#  - alternative layouts
#  - for more control: HTML tags, added within each ___Panel()
#  - for even more control: build the entire UI with HTML
#=================================================================================
# developed with bootstrap (a front-end framework for web development)
# Shiny converts each ui.R to HTML code

# alternatively you can use fixedPage() which gives 980 pixel width
fluidPage(
  
  # to display on title panel
  titlePanel(
    
    ),

  # sidebarLayout() always takes two arguments: sidebarPanel() and mainPanel()
  sidebarLayout(
    # sidebar is on the right, instead of the default left
  	position = "right",  
  	
    # to display on side panel (usually user input: *inputs)
  	sidebarPanel(
  	  
      ),
  	
    # to display on main panel (usually visual output: *output)
  	mainPanel(
  	  
      # create tabs: 
      tabsetPanel(
        type = "tabs",  # 'tabs' for standard look, 'pills' for plain look
        position = "below",  # tabs' positions
        tabPanel("TabName1", *Output("oVar1")), 
        tabPanel("TabName2", *Output("oVar2")), 
        tabPanel("TabName3", *Output("oVar3")), ..
        )

      )

    )
)

#---------------------------------------------------------------------------------
# standard Shiny widgets, *input, added within ___Panel(), usually in sidebarPanel
# user input variables (iVar) are passed from ui.R to server.R, as R objects
# the first two arguements are:
# - name for the widget
# - label to be displayed  
*input("iVar", 'label', ...)
# in server.R, use them as such
input$iVar1
input$iVar2
# for a list of templates: http://shiny.rstudio.com/gallery/widget-gallery.html

actionButton()  # Action Button (more info under special functions)
actionLink()  # Action Link (more info under special functions)
checkboxGroupInput()  # A group of check boxes
checkboxInput()  # A single check box
dateInput()  # A calendar to aid date selection
dateRangeInput()  # A pair of calendars for selecting a date range
fileInput()  # A file upload control wizard
helpText()  # Help text that can be added to an input form
numericInput()  # A field to enter numbers
radioButtons()  # A set of radio buttons
selectInput()  # A box with choices to select from
selectizeInput()  # with additional options (more info under special functions)
sliderInput()  # A slider bar (can also animate)
submitButton()  # A submit button - display only when explicitly requested
textInput()  # A field to enter text

#---------------------------------------------------------------------------------
# R objects, *ouput, added within ___Panel(), usually in mainPanel
# R output variables (oVar) are passed from server.R to ui.R, as visual objects
*output("oVar")  
# in server.R, assign them as such
output$oVar1
output$oVar2

dataTableOutput()  # table
htmlOutput()  # raw HTML
imageOutput()  # image
plotOutput()  # plot
tableOutput()  # table
textOutput()  # text
uiOutput()  # raw HTML
verbatimTextOutput()  # text

#---------------------------------------------------------------------------------
# alternative layouts

# side / main
sidebarLayout(
  sidebarPanel(...),
  mainPanel(...)
  )

# 50/50
splitLayout()

# box sequence
flowLayout()

# columns and rows (can have multiple fluidRows)
# you can get creative with column offseting and nesting, and each time fluidRow() 
# is introduced, you get another 12 columns
fluidRow(
  # width is the position, between 1 and 12, with sum(w) = 12
  column(width = w, ...),
  # each unit of offset increases the left-margin of a column, by a column
  column(width = w, offset = 3, ...)
  )

# component list (vertical)
navlistPanel(
  "Header A",
  tabPanel("Component 1", *Output(...)),
  tabPanel("Component 2", *Output(...)),
  "Header B",
  tabPanel("Component 3", *Output(...)),
  tabPanel("Component 4", *Output(...)),
  "-----",
  tabPanel("Component 5", *Output(...))
)

# component bar (horizontal)
navbarPage(
  title = "My Application",
  tabPanel("Component 1", *Output(...)),
  tabPanel("Component 2", *Output(...)),
  navbarMenu("More",
    tabPanel("Sub-Component A", *Output(...)),
    tabPanel("Sub-Component B", *Output(...)))
)

#---------------------------------------------------------------------------------
# for more control: HTML tags, added within each ___Panel()
# - glossary: http://shiny.rstudio.com/articles/tag-glossary.html
# - additional arguments to change the style format (x being any of the above):
#   http://www.w3schools.com/tags/tag_hn.asp
names(tags)  # lists all the tags currently in library(shiny)

# showing shiny function, and HTML5 equivalent:
# p		   <p>		  A paragraph of text
# h1	   <h1>	    A first level header
# h2	   <h2>	    A second level header
# h3	   <h3>	    A third level header
# h4	   <h4>	    A fourth level header
# h5	   <h5>	    A fifth level header
# h6	   <h6>	    A sixth level header
# a		   <a>	    A hyper link
# br	   <br>	    A line break (e.g. a blank line)
# div	   <div>    A division of text with a uniform style
# span	 <span>	  An in-line div() (i.e. within any function in this list)
# pre		 <pre>	  Text ‘as is’ in a fixed width font
# code	 <code>	  A formatted block of code
# img		 <img>	  An image
# strong <strong> Bold text
# em		 <em>     Italicized text
# HTML	 			    Directly passes a character string as HTML code

# r style for HTML tags (try executing in the command to see the equivalents)
x('item')  # in R
<x> item </x>  # in HTML

# to create a new tag, say, 'div'
tags$div()
# to use a tag, say, 'code' that might be already used as a variable:
tags$code()

# to add an argument to a tag
tags$div(class = "header", 'line2')
# to add a conditional argument to a tag
tags$div(class = "header", if (FALSE) 'line 1', 'line2')

# nested (children) tags example #1 
tags$div(class = "header", checked = NA,
  tags$p("Ready to take the Shiny tutorial? If so"),
  tags$a(href = "shiny.rstudio.com/tutorial", "Click Here!")
)
# nested (children) tags example #2 - using withTags()
withTags({
  div(class = "header", checked = NA,
    p("Ready to take the Shiny tutorial? If so"),
    a(href = "shiny.rstudio.com/tutorial", "Click Here!")
  )
})
# nested (children) tags example #3 - passing a list()
tags$div(class = "header", checked = NA,
  list(
    tags$p("Ready to take the Shiny tutorial? If so"),
    tags$a(href = "shiny.rstudio.com/tutorial", "Click Here!"),
    "Thank you"
  )
)

# images must be located within "www" file, w/in the ui.R directory
img(src = "my_image.png", height = h, width = w)  # height and width in pixels 

# adding raw HTML, example: 
# NOTE: it's a bad idea to pass an input object to HTML
HTML("<strong>Raw HTML!</strong>")

#---------------------------------------------------------------------------------
# for even more control: build the entire UI with HTML
# write it in index.html; server.R doesn't change
# example: http://shiny.rstudio.com/articles/html-ui.html

#=================================================================================
# running the app: server.R
#=================================================================================
# objects that interacts with the ui.R
input$iVar  # inputs from ui.R
output$oVar  # outputs to pass onto ui.R

# the basic model is: reactive source -> reactive conductor -> reactive endpoint
# - the source is the input, a value that entails reactions
# - the conductor is an 'reactive expression', typically used to encapsulate slow 
#   operation, by caching values (to be used again for the future)
# - the endpoint is the output, an 'observer' that does not cach any values, but
#   passes the object to browser

# [1] run only once when the app starts up
# - a good place to declare global variables that cannot be altered with user input
data <- dataset

function(input, output) {
  # [2] run each time a user visits the app (i.e. outside any render* functions)
  # - a good place to declare user-specific local variables, if multiple users
  # - no need to arrange for outputs of this unnamed function

    # [3] run each time a user changes a widget mentioned in the chunk
    # - Shiny automatically make an object reactive if the object uses an 'input' value
    # - reruns the code inside render* each time a user changes a widget that cases 
    #   a change in the 'input' in that render* function
    # - to speed up the code, avoid placing unnecessary codes inside render*
    # - reactive() expressions are helpful
    # - swtich() and do.call(function, arguments) are also useful, allowing input 
    #   to swtich between various cases, store the inputs into an argument list, and 
    #   pass that arguement list into the function that draws the plot to be rendered

    # the reactive() expression is evaluated only if the contained input (iVar1)
    # is altered: if another input (iVar2) is altered in a render* function, Shiny 
    # will ask varInput to look for changes in iVar1, and only rerun if changes is 
    # detected; otherwise, a cached result is produced
    # - use reactive() as building blocks to create objects used in multiple outputs
    varInput <- reactive({
  
      # example:
      # the input is registered as a string, so we'd need to convert it to a variable
      # if such is our wish
      switch(input$iVar1,
             "string1" <- var1,
             "string2" <- var2,
             "string3" <- var3, ... )
  
      })

    # the isolate() expression uses the embedded input without depending on it
    # - Shiny will not rerun this render* function when the isolated input changes
    # - but when iVar2 is changed (say it's a button trigger), Shiny will rerun
    #   this render* function, looking for changes in iVar1 as well
    output$oVar3 <- render*({
      input$iVar2
       isolate(input$iVar1)
      })

    # the observe() function runs the code if its embedded inputs changes, but does not
    # produce any outputs
    observe({
      input$iVar1
      # code to run
      })

    # output back to ui.R
    output$oVar1 <- render*({
      
      varInput()
      
      })

    # output back to ui.R
    output$oVar2 <- render*({
      
      varInput()
      input$iVar2
      
      })

}

#---------------------------------------------------------------------------------
# R functions, render*, whose output, assigned to output$oVar, are passed to ui.R
# the render* functions takes a single arguement: an R expression surrounded by 
# braces, {}; Shiny will run the instructions when the app is initially launched,
# and re-run the instructions everytime the object is updated

renderDataTable()  # any table like object
renderImage({})  # images: http://shiny.rstudio.com/articles/images.html
renderPlot({})  # plots
renderPrint({})  # any printed output
renderTable({})  # data frame, matrix, other table like structures
renderText({})  # character strings
renderUI({})  # a Shiny tag object or HTML

#=================================================================================
# special functions for special purposes
#  - dynamic UI
#  - action buttons
#  - selectize input
#  - download 
#  - time
#  - process indicators, inside server.R
#=================================================================================

#---------------------------------------------------------------------------------
# dynamic UI
# - conditionalPanel
# - renderUI
# - JavaScript

# conditionalPanel, used in ui.R
# (partial) example: if 'Smooth' is checked 'true', smooth options shows
checkboxInput("smooth", "Smooth"),
conditionalPanel(
  condition = "input.smooth == true",
  selectInput("smoothMethod", "Method",
              list("lm", "glm", "gam", "loess", "rlm"))
)
# you can also use output values, but avoid this practice, since this involves
# server side computation, and is thus rather slow

# renderUI
# use the renderUI expression to dynamically create controls based on inputs
# (partial) example:
# ui.R
numericInput("lat", "Latitude"),
numericInput("long", "Longitude"),
uiOutput("cityControls")

# server.R
output$cityControls <- renderUI({
  cities <- getNearestCities(input$lat, input$long)
  checkboxGroupInput("cities", "Choose Cities", cities)
})

# JavaScript
# read more at: http://shiny.rstudio.com/articles/dynamic-ui.html

#---------------------------------------------------------------------------------
# action buttons
# - actionButton() and actionLink() work with observeEvent() or eventReactive()
# - observeEvent() notice change, irrespective of what changes
# - eventReactive() returns NULL, until it notices change 
# - observeEvent() an deventReactive() use isolate() in the 2nd argument

# example 1: command
ui <- fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  actionButton("do", "Click Me")
)
# observeEvent()' 1st argument notices change in 'do', and reacts with 2nd argument
server <- function(input, output, session) {
  observeEvent(input$do, {
    session$sendCustomMessage(type = 'testmessage',
      message = 'Thank you for clicking')
  })
}
shinyApp(ui, server)

# example 2: delayed reactions
ui <- fluidPage(
  actionButton("go", "Go"),
  numericInput("n", "n", 50),
  plotOutput("plot")
)
server <- function(input, output) {
  # only when 'Go' is pressed does the server evaluates the 'n' input
  randomVals <- eventReactive(input$go, {
    runif(input$n)
  })
  output$plot <- renderPlot({
    hist(randomVals())
  })
}
shinyApp(ui, server)

# example 3: dueling buttons, and reset
ui <- fluidPage(
  actionButton("runif", "Uniform"),
  actionButton("rnorm", "Normal"), 
  actionButton("reset", "Clear"), 
  hr(),
  plotOutput("plot")
)
server <- function(input, output){
  # reactiveValues() creates reactive value objetcs: much like 'input' object
  # but can be updated 
  v <- reactiveValues(data = NULL)
  # update scenario 1
  observeEvent(input$runif, {
    v$data <- runif(100)
  })
  # update scenario 2
  observeEvent(input$rnorm, {
    v$data <- rnorm(100)
  })  
  # update scenario 3: the plots resets, since data is once again NULL
  # note that you can reset v$data to NULL through other triggers as well
  observeEvent(input$reset, {
    v$data <- NULL
  })  
  output$plot <- renderPlot({
    if (is.null(v$data)) return()
    hist(v$data)
  })
}
shinyApp(ui, server)

#---------------------------------------------------------------------------------
# selectize input
# - useful when the number of selections is very large (so as to not display all)
# the additional argument is 'options'

# ui.R
selectizeInput(inputId, label, choices = NULL, selected = NULL, multiple = FALSE, 
               options = list(maxItems = n1,  # number of items selectable
                              maxOptions = n2,  # number to show on the list
                              placeholder = 'enter',  # instruction
                              create = TRUE,  # allows new items not in list
                              searchConjunction = 'and',  # or 'or'
                              render = I(),  # custom render message in HTML
                              ...))
# 'choices = NULL' in the beginning to initialize fasters

# server.R
shinyServer(function(input, output, session) {
  updateSelectizeInput(session, 'foo', choices = data, server = TRUE)
})

#---------------------------------------------------------------------------------
# download

# ui.R
fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:", choices = c("c1", "c2", "c3", ...)),
      downloadButton('downloadData', 'Download'),
      mainPanel()
    )
  )
)

# server.R
function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "c1" = dataset1,
           "c2" = dataset2,
           "c3" = dataset3, ... )
  })
  
  output$downloadData <- downloadHandler(

    # because filename is reactive, 'filename = paste(input$dataset, '.csv')' won't
    # work the way you want it to, unless it's a function
    filename <- function() { paste(input$dataset, '.csv', sep = '') },
    content <- function(file) { write.csv(datasetInput(), file) }
  )
}

#---------------------------------------------------------------------------------
# time

# ui.R
fluidPage(
  textOutput("currentTime")
)

# server.R
function(input, output, session) {
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
}

#---------------------------------------------------------------------------------
# process indicators, inside server.R

# 1: adding withProgress() + incProgress() inside reactive(), observer(), or render*()
# - can nest calls to withProgress(): 2nd progress bar will be below the 1st
output$oVar1 <- render*({

  # 'message text' is presented in bold
  withProgress(message = 'rendering', value = 0, {
    
    n <- 10  # number of times we'll go through the loop
    for (i in 1:n) {

      # Increment the progress bar, and update 'detail text', which is in regular
      incProgress(1/n, detail = paste("Doing part", i))
      Sys.sleep(0.1)  # Pause for 0.1 seconds to simulate a long computation.

    }

  })

})

# 2: for more control, creat a Progress object
# 3: using it inside a function
# for more information: http://shiny.rstudio.com/articles/progress.html

#=================================================================================
# share
#  - fileshares
#  - webshares
#=================================================================================

#---------------------------------------------------------------------------------
# fileshares, for people with R and library(Shiny) on their computer

runUrl("<the weblink>")  # if you have your own webpage to host the files
runGitHub( "<your repository name>", "<your user name>")  # host from Github
runGist("<gist number>")  # host anonymously at gist.github.com

#---------------------------------------------------------------------------------
# webshares
# read more at RStudio

#=================================================================================
# library(shinythemes)
#=================================================================================
# available shiny themes: http://rstudio.github.io/shinythemes/
# other themes to download: http://bootswatch.com/

#---------------------------------------------------------------------------------
# shiny themes

# ui.R
fluidPage(theme = shinytheme("cerulean"),
  ...
)

#---------------------------------------------------------------------------------
# other bootswatch themes: load it in the www folder

# ui.R
fluidPage(
  theme = "mytheme.css",
  ...
)

#---------------------------------------------------------------------------------
# create your own css themes
# https://www.codecademy.com/learn/web
# https://blog.udemy.com/learn-html-learn-the-foundations-of-html/


#=================================================================================
# htmlwidgets
#=================================================================================
# - Use JavaScript visualization libraries at the R console, just like plots
# - Embed widgets in R Markdown documents and Shiny web applications
# - Develop new widgets using a framework that seamlessly bridges R and JavaScript
# http://www.htmlwidgets.org/index.html

#---------------------------------------------------------------------------------
# library(dygraphs) for time series: http://rstudio.github.io/dygraphs/index.html
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
# library(shinydashboard)
#=================================================================================
