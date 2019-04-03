library(nufflytics)
library(tidyverse)
library(shiny)
library(DT)

# Data setup -----
load("data/key.rda")
teams = read_csv("data/ClanS6") %>% split(.$Clan) %>% map("Name")

# Actual code -----
get_team_summary <- function(t) {
  # If no team with that name, exit
  if(!("team" %in% names(t))) return(NULL)
  
  #remove the stupid cards component of team info
  r = t$team[names(t$team)!="cards"]
  
  #but keep the stadium enhancement if they have one
  r$stadium_enhancement <- t$team$cards %>% keep(~(.$type == "Building")) %>%  pluck(1,"name") %>% fill_nulls("")
  
  r$race = id_to_race(r$idraces)
  r$coach = t$coach$name
  
  r
}

get_player_summary <- function(t) {
  if(!("team" %in% names(t))) return(NULL)
  map_df(t$roster, 
         ~(keep(., names(.)!="attributes") %>% 
             modify_at("casualties_state", ~map(.,state_to_casualty) %>% glue::collapse(", ")) %>% 
             modify_at("skills", ~map(., ~glue::glue("<img class='skillimg' src='img/skills/{.}.png' title='{stringr::str_replace_all(.,'([a-z])([A-Z])','\\\\1 \\\\2')}' width=30>")) %>% glue::collapse("")) %>% 
             modify_depth(1,fill_nulls, "") %>% 
             modify_at("name",as.character) %>% 
             modify_at("casualties_state_id", as.integer)
         )
  ) %>% 
    arrange(number) %>%
    mutate(
      Type = stringr::str_replace_all(type, c(".*_"="", "([a-z])([A-Z])"="\\1 \\2")),
      nskills = stringr::str_count(skills,"<img"),
      skills = ifelse(level-nskills >1, paste0(skills,'<img class="skillimg" src="img/skills/PositiveRookieSkills.png" title="Pending Level up" width=30>'), skills)
    ) %>% 
    select(
      Player = name,
      Type,
      Level=level,
      SPP = xp,
      TV = value,
      Injuries = casualties_state,
      `Acquired Skills` = skills
    )
  
}

get_clan_data <- function(clan_data) {
  #if(all(clan_data == FALSE)) return(NULL)
  
  map_df(clan_data, get_team_summary) %>% 
    mutate(
      logo = glue::glue("<img src='img/logos/Logo_{logo}.png' width=50 />"), 
      apothecary = ifelse(apothecary>0, "<i class = 'fa fa-check-circle-o'>",""),
      Bank = glue::glue("{cash/1000}k")
    )  %>% 
    select(
      logo,
      Team=name,
      Coach=coach,
      Race=race,
      TV = value,
      Bank, 
      RR=rerolls, 
      Apo=apothecary, 
      FF=popularity, 
      Cheer = cheerleaders, 
      `Asst.C`=assistantcoaches, 
      Stadium=stadium_enhancement
    )
}

get_player_data <- function(clan_data) {
  #if(all(clan_data == FALSE)) return(NULL)
  
  map(clan_data, get_player_summary) %>% discard(is.null)
}

load_data <- function(teamname) {
  incProgress(0.2, detail = teamname)
  api_team(key, name = teamname)
}

shinyServer(function(input, output, session) {
  
  clan_data <- reactiveValues()
  
  team_data <- reactiveValues()
  
  update_data <- function() {
    if(input$clan_picker %in% names(clan_data) | input$clan_picker == "") return(NULL)
    
    api_response <- withProgress(map(teams[[input$clan_picker]], load_data), message = "Loading team:", value = 0)
    
    clan_data[[input$clan_picker]] = get_clan_data(api_response)
    
    team_data[[input$clan_picker]] = get_player_data(api_response)
   }
  
  
  observeEvent(input$clan_picker,
               {update_data()}
  )
  
  output$clan_summary <- DT::renderDataTable(
    DT::datatable(
      {if(is.null(input$clan_picker)) return(NULL); clan_data[[input$clan_picker]]},
      class = "display compact",
      selection = list(mode = "single", selected = 1),
      escape = F,
      rownames = F,
      colnames = c(" "="logo"),
      options = list(
        dom = "t",
        ordering = F,
        scrollX = T
      )
    )
  )
  
  output$team_summary <- DT::renderDataTable(
    DT::datatable(
      {if(input$clan_picker == "") return(NULL); team_data[[input$clan_picker]][[input$clan_summary_rows_selected]]},
      class = "display compact",
      selection = "none",
      escape  = F,
      rownames = F,
      options = list(
        dom = "t",
        pageLength = 16,
        ordering = F,
        scrollX = T
      )
    )
  )
})
