#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

# Define UI logic
navbarPage(
    "Gapminder Dashboard",
    tabPanel("Plot",
             sidebarLayout(
                 sidebarPanel(uiOutput(outputId = "xselect"),
                              uiOutput(outputId = "yselect"),
                              uiOutput(outputId = "timeselect"),
                              uiOutput(outputId = "Border_Arg1"),
                              uiOutput(outputId = "Border_Arg2")),
                 mainPanel(plotlyOutput("plot"),
                           plotlyOutput("plot1"))
             )),
    tabPanel("Summary",
             verbatimTextOutput("summary")),
    navbarMenu(
        "More",
        tabPanel("Table",
                 DT::dataTableOutput("table")),
        tabPanel("About",
                 fluidRow(column(
                     12,
                     includeMarkdown("about.md")
                 )))
    )
)
