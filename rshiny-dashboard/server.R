#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)

# load data
gapminder <- read.csv('data/gapminder.csv', header = T)

# Define server logic
function(input, output, session) {
    output$xselect <- renderUI({
        selectInput(inputId = "xcol",
                    label = "Select first country:",
                    choices = gapminder$country)
    })
    
    output$yselect <- renderUI({
        selectInput(inputId = "ycol",
                    label = "Select second country:",
                    choices = gapminder$country)
    })
    
    output$timeselect <- renderUI({
        selectInput(inputId = "time",
                    label = "Select year:",
                    choices = gapminder$year)
    })
    
    output$Border_Arg1 <- renderUI({
        tags$head(tags$style(HTML( "#xcol ~ .selectize-control.single .selectize-input {border: 1px solid magenta;}")))
    })
    
    output$Border_Arg2 <- renderUI({
        tags$head(tags$style(HTML( "#ycol ~ .selectize-control.single .selectize-input {border: 1px solid blue;}")))
    })
    
    
    # select only countries left of first selection
    outVar = reactive({
        values = gapminder$country[gapminder$country != input$xcol]
    })
    observe({
        updateSelectInput(session, "ycol",
                          choices = outVar())
    })
    
    # filter dataframe to get data to be highligheted
    dataFirstCountry = reactive({
        highlight <- gapminder[gapminder$country == input$xcol & gapminder$year == input$time, ]
    })
    
    dataSecondCountry = reactive({
        highlight <- gapminder[gapminder$country == input$ycol & gapminder$year == input$time, ]
    })
    
    output$plot <- renderPlotly({
        # interpret as dynamic input
        p <- ggplot(data=gapminder, aes(x=lifeExp,y=gdpPercap)) +
            geom_point(alpha = (1/3)) + scale_x_log10() +
            geom_point(data=dataFirstCountry(), aes(x=lifeExp,y=gdpPercap), color="blue", size=3) +
            geom_point(data=dataSecondCountry(), aes(x=lifeExp,y=gdpPercap), color="magenta", size=3)
        fig <- ggplotly(p)
        fig
    })
    
    output$plot1 <- renderPlotly({
        p <- ggplot(data=gapminder, aes(x=lifeExp,y=gdpPercap, color=continent, text=paste("country:", country))) +
            geom_point(alpha = (1/3)) + scale_x_log10()  
        fig <- ggplotly(p)
        fig
    })
    
    output$summary <- renderPrint({
        summary(gapminder)
    })
    
    output$table <- DT::renderDataTable({
        DT::datatable(gapminder)
    })
}
