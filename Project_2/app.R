library(shiny)
library(tidyverse)
library(DT)
source("Project_2/functions_for_shiny.R")

args <- commandArgs(trailingOnly=TRUE);
port <- args[1] %>% as.numeric();

CapStr <- function(y) {
    c <- strsplit(y, " ")[[1]]
    paste(toupper(substring(c, 1,1)), substring(c, 2),
          sep="", collapse=" ")
}

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Wine Recommendation and Average Rating for Descriptive Word of Choice"),

    # Sidebar with a slider input for number of bins 

    sidebarLayout(
       sidebarPanel(
        selectInput(inputId = "word", 
                        label = "What Word Would You Like to Describe the Wine?", 
                        choices = list("sweet",
                                       "price",
                                       "smooth",
                                       "dry",
                                       "light",
                                       "fruit",
                                       "cheap",
                                       "flavorful",
                                       "affordable"), 
                        selected = "sweet"),
        radioButtons(inputId = "typewine", 
                         label = "For Which Wine Type Would You Like To Display a Recommendation and Average Rating?", 
                         choices = list("Red Wine",
                                        "White Wine",
                                        "Rose",
                                        "Other Wine Type",
                                        "Display All Types"), 
                         selected = "Display All Types")
    
        ),

        # Show a plot of the generated distribution
        mainPanel(
                h4("This shiny app provides a wine recommendation based on a word that the user chooses to describe the wine.
               This word was used in reviews to describe the wine. The shiny app provides a recommendation based
               on the highest rated wine whose reviews included that word. The app also displays the average wine rating for that characteristic and wine type."),
            DT::dataTableOutput("mytable"),
            plotOutput(outputId = "distPlot")
            )
        )
        
    
    )




server <- function(input, output) {

    
    output$mytable = DT::renderDataTable({
        x = input$word
        y = input$typewine
        z = winerec(x, y)
        comment(z) = "Recommended Wine"
        z
    })
    
    
    output$distPlot <- renderPlot({
        title1 = paste(CapStr(input$word),  "Wine Average Rating")
        # generate bins based on input$bins from ui.R
        x = input$word
        y = input$typewine
        graphforword(x, y) + ggtitle(title1)
        
    })
    
    
}


# Run the application 
shinyApp(ui=ui,server=server, options=list(port=port, host="0.0.0.0"))
