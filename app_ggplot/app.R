library(shiny)
library(datasets)
library(ggplot2)

# Replace 'ui <- fluidPage('...')' with
#       'shinyUI(fluidPage('...'))' if in separate ui.R file
ui <- fluidPage(
    titlePanel("App Title (change)"),
    sidebarLayout(
        sidebarPanel(
            width = 2,
            fileInput("filein","Choose file")
            #wellPanel() # OPTIONAL GROUPING OF INPUTS
        ),
        mainPanel(
            width = 10,
            tabsetPanel(
                type = "tabs",
                tabPanel("Plot", plotOutput(outputId = "myPlot")),
                tabPanel("Table", tableOutput("myTable")),
                tabPanel("Text", textOutput("myText")),
                tabPanel("VText", verbatimTextOutput("myVText")),
                tabPanel("File", verbatimTextOutput("myFileText"))
            )
        )
    )
)

# Replace 'server <- function(input, output) {'...'}' with
#       'shinyServer(function(input, output) {'...'})' if in separate server.R file
server <- function(input, output) {
    output$myPlot <- renderPlot({
        mm <- mtcars
        mm$fcyl <- as.factor(mm$cyl)
        gg <- ggplot(data=mm, aes_string(x="mpg",y="wt"))
        gg <- gg + geom_point(data=mm ,aes_string(color="fcyl",shape="fcyl"), size=3, alpha=0.7)
        gg <- gg + ggtitle("Graph Title (change)") + xlab("MPG") + ylab("Weight")
        gg
    })
    output$myTable <- renderTable({
        mtcars
    })
    output$myText <- renderText({
        paste(mtcars, collapse = "|\n")
    })
    output$myVText <- renderPrint({
        mtcars
    })
    output$myFileText <- renderPrint({
        req(input$filein$datapath)
        dd <- read.csv(input$filein$datapath)
        dd
    })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)