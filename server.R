library(nufflytics)
library(tidyverse)
library(shiny)
library(DT)

# Data setup -----
load("data/key.rda")
teams = list(
  "[Metal]" = c(
    "[Metal] Folk S3",
    "[Metal]ReBBL True form S3",
    "[Metal] 'Eads II S3",
    "[Metal]lurgical Feats S3",
    "[METAL] Blackballers - S3"
  ),
  "[FOUL]" = c(
    "[FOUL]ing you to death S3",
    "[FOUL] Legion S3",
    "[FOUL] Beasts S3",
    "[FOUL]ing Charlies S3",
    "[FOUL] Fowls S3"
  ),
  "[Lads]" = c(
    "[Lads] The Gatormen S3",
    "[Lads] in black S3",
    "[Lads] Amber Nectar s3",
    "[Lads] Miltorn Monks S3",
    "[Lads] Enskede IK - S3"
  ),
  "[Rodder]" = c(
    "[Rodder]'s Renaissance S3",
    "[Rodder]'s Supplies S3",
    "[Rodder]'s Elf Problems 3",
    "[Rodder]'s Bone-ers S3",
    "[Rodder]'s Potent Persona"
  ),
  "[PATH]" = c(
    "[PATH] Of Destruction s3",
    "[PATH] Tao of Sulaco S3",
    "[PATH] of Love S3",
    "[PATH]ogens S3",
    "[PATH] Of The GM S3"
  ),
  "[PUNT]" = c(
    "[PUNT]ential Heroes S3",
    "[PUNT] D.E. Delight S3",
    "[PUNT]ification S3",
    "[PUNT] HAIL HYPNOTOAD S3",
    "[PUNT] & Punch S3"
  ),
  "[O²]" = c(
    "[O²] Oceanic Raiders S3",
    "[O²] Jester's Deck S3",
    "[O²] Ozzie Battlers S3",
    "[O²] Rainbow Ponies S3 ",
    "[O²] Be Loved S3"
  ),
  "[O]" = c(
    "[O]Owesome Orcs S3",
    "[O]ne Oneders S3",
    "[O] WesC's Superwolves S3",
    "[O]nerable 'Orrors S3",
    "[O]Deserted Isle DiggerS3"
  ),
  "[PUNCH]" = c(
    "[PUNCH] Everything! S3",
    "[PUNCH] and Judy S3",
    "[PUNCH] smCHAOS S3",
    "[PUNCH] Everyone! S3",
    "[PUNCH] Skinnyrats S3"
  ),
  "[bOot]" = c(
    "[bOot] WholelottaStuds S3",
    "[bOot] scOnes S3",
    "[bOot] Of Nuffle S3",
    "[bOot]Rockman and Roll S3",
    "[bOot] big bOys S3"
  ),
  "[FOUL²]" = c(
    "[FOUL²] Beyond Mesure S3",
    "[FOUL²] Stunty Gits S3",
    "[FOUL²] Intentions S3",
    "[FOUL²]ing for Odin S3",
    "[FOUL²] Appearance S3"
  ),
  "[REL]" = c(
    "[Rel] Bad Moo Rising S3",
    "[REL]Verminal Velocity S3",
    "[REL] ReBBRL Ringers S3",
    "[REL]Blue Bloods S3",
    "[REL] Rockstars s3"
  ),
  "[ANZAC]" = c(
    "[ANZAC] Reavers S3",
    "[ANZAC] Mammoths S3",
    "[ANZAC]The Unforgotten S3",
    "[ANZAC] Hornets S3",
    "[ANZAC] Malcontents S3"
  ),
  "[BBT]" = c(
    "[BBT]Blaviken Valkyrs S3",
    "[BBT] Carnival of Pain S3",
    "[BBT] Punchin Yo Face S3",
    "[BBT] Little Mutants S3",
    "[BBT] Insert Name Here S3"
  ),
  "[OFFAL]" = c(
    "[OFFAL]ly Salty S3",
    "[OFFAL]DeliciousMurder S3",
    "[OFFAL] Rage Quit S3",
    "[OFFAL] Veal's Vegans S3",
    "[OFFAL]lyGood"
  ),
  "[CLASSY]" = c(
    "[CLASSY] Pond Dibblers S3",
    "[CLASSY] Cheesy Cheats S3",
    "[CLASSY] PortlyPoundaz S3",
    "[CLASSY]Dead Gentlemen S3",
    "[CLASSY] Ice Dancers S3"
  ),
  "[GeeMan]" = c(
    "[GeeMAN] Slash-n-Dash S3",
    "[GeeMan] Oh my Goddess S3",
    "[GeeMan]Magic of av7 S3",
    "[GeeMan] Golden Laws S3",
    "[GeeMan]Leorics Beast S3"
  ),
  "[FatKids]" = c(
    "[FatKids] Literally S3",
    "[FatKids] 1/4 Pounders S3",
    "[FatKids] Storm S3",
    "[FatKids] With Toys S3",
    "[FatKids]The Weirdos  S3 "
  )
)

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
             modify_at("skills", ~map(., ~glue::glue("<img src='http://images.bb2.cyanide-studio.com/skillicons/{.}.png' alt={str_replace_all(.,'([a-z])([A-Z])','\\1 \\2')} width=30 style='padding: 1px'>")) %>% glue::collapse("")) %>% 
             modify_depth(1,fill_nulls, "") %>% 
             modify_at("name",as.character)
         )
  ) %>% 
    arrange(number) %>%
    mutate(
      Type = str_replace_all(type, c(".*_"="", "([a-z])([A-Z])"="\\1 \\2"))
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
  map_df(clan_data, get_team_summary) %>% 
    mutate(
      logo = glue::glue("<img src='http://images.bb2.cyanide-studio.com/logos/Logo_{logo}.png' width=50 />"), 
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
      `Asst. C`=assistantcoaches, 
      Stadium=stadium_enhancement
      )
}

get_player_data <- function(clan_data) {
  map(clan_data, get_player_summary) %>% discard(is.null)
}

shinyServer(function(input, output) {
  
  clan_data <- reactiveValues()
  
  team_data <- reactiveValues()
  
  update_data <- function() {
    if(input$clan_picker %in% names(clan_data) | input$clan_picker == "") return(NULL)
    
    api_response <- map(teams[[input$clan_picker]], ~api_team(key, name = .))
    
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
        ordering = F
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
        ordering = F
      )
    )
  )
})
