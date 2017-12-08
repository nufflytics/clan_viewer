
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(DT)

# Data setup -----
clans = list("",
             "Div 1" = list("[FOUL]","[CLASSY]","[Lads]","[Rodder]","[O]","[REL]","[Metal]","[PATH]","[GeeMan]"),
             "Div 2" = list("[FOUL²]","[PUNCH]","[boOt]","[PUNT]","[O²]","[OFFAL]","[ANZAC]","[BBT]","[FatKids]")
)

# Actual code -----
dashboardPage(title = "REBBL Clan League",
              skin="black",
              dashboardHeader(title = span(tagList(a(href="https://www.reddit.com/r/rebbl", img(src = "img/ReBBL_logo_800px_72dpi.png", width = "70px")),"Clan League"))),
              dashboardSidebar(disable = T),
              dashboardBody(
                includeCSS("www/css/dt.css"),
                fluidRow(
                  box(width=12,
                      selectizeInput("clan_picker",label=NULL,choices = clans, options = list(placeholder = "Select a clan:", hideSelected = T)),
                      DT::dataTableOutput("clan_summary")
                  ),
                  conditionalPanel(
                    "input.clan_summary_rows_selected > 0",
                    box(width = 12,
                        DT::dataTableOutput("team_summary")
                    )
                  )
                )
              )
)