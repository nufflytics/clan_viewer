
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(DT)

# Data setup -----
clans <- clan_teams %>% map(~as.list(names(.)))

clan_ui <- HTML(paste0('<div id="clan_picker" class="btn-toolbar form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline shiny-bound-input" data-toggle="buttons">
        <p><strong>Div 1:</strong><div class="clearfix"></div>',
                       glue::glue_data(clans,'<label class="btn btn-primary">
     <input type="radio" name="clan_picker" value="{Div1}"> {Div1}
     </label>') %>% glue::collapse("\n") ,
                       '<div class="clearfix"></div>
     <br>
     <p><strong>Div 2:</strong></p>',
                       glue::glue_data(clans,'<label class="btn btn-primary">
     <input type="radio" name="clan_picker" value="{Div2}"> {Div2}
     </label>')%>% glue::collapse("\n"),
                       '<div class="clearfix"></div>
     <br>
                       <p><strong>Div 3:</strong></p>',
                       glue::glue_data(clans,'<label class="btn btn-primary">
                                       <input type="radio" name="clan_picker" value="{Div3}"> {Div3}
                                       </label>')%>% glue::collapse("\n"),
                       '<div class="clearfix"></div>
     <br>
                       <p><strong>Div 4:</strong></p>',
                       glue::glue_data(clans,'<label class="btn btn-primary">
                                       <input type="radio" name="clan_picker" value="{Div4}"> {Div4}
                                       </label>')%>% glue::collapse("\n"),
                       '</div>')
                )


# Actual code -----
dashboardPage(title = "REBBL Clan League",
              skin="black",
              dashboardHeader(title = span(tagList(a(href="https://www.reddit.com/r/rebbl", img(src = "img/ReBBL_logo_800px_72dpi.png", width = "70px")),"Clan League"))),
              dashboardSidebar(clan_ui),
              dashboardBody(
                includeCSS("./www/css/dt.css"),
                fluidRow(
                  #box(width=12, title = "Select Clan", collapsible = T,
                  #    clan_ui),
                  conditionalPanel(
                    "input.clan_picker != null",
                    box(width=12,title = "Clan summary",
                        div(p("For game results and standings, see the ", a("spreadsheet", href="https://docs.google.com/spreadsheets/d/1j28GoLTS07dCB6xC85oD0ebkr8c56Aiz_9tGldyvCAc", target = "_blank"))),
                        DT::dataTableOutput("clan_summary")
                        )
                  ),
                  conditionalPanel(
                    "input.clan_summary_rows_selected > 0",
                    box(width = 12, title = "Team summary",
                        DT::dataTableOutput("team_summary")
                    )
                  )
                )
              )
)