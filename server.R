
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(nufflytics)
library(shiny)
library(DT)

shinyServer(function(input, output) {
  
  clan_data <- reactiveValues()
  
  team_data <- reactiveValues()
  
  update_data <- function() {
    if(input$clan_picker %in% names(clan_data)) return(NULL)
    
    clan_data[[input$clan_picker]] = paste0(input$clan_picker," selected")
    
    team_data[[input$clan_picker]] = paste0(input$clan_picker," also selected")
  }
  
  observeEvent(input$clan_picker,
               {update_data()}
               )
  
  output$clan_summary <- DT::renderDataTable(
    DT::datatable(
      mtcars,
      selection = "single",
      options = list(
        dom = "t"
      )
    )
  )
  
  output$clan_data <- renderText(clan_data %>% as.list %>% unlist)
    
  output$team_data <- renderText(team_data %>% as.character())
})
