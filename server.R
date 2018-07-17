library(nufflytics)
library(tidyverse)
library(shiny)
library(DT)

# Data setup -----
load("data/key.rda")
teams = list(
  "[Metal]" = c(
    "[Metal] Folk S4",
    "[Metal]Rebbl Tru Form S4",
    "[Metal] 'eads S4",
    "[Metal]urgical Feats S4",
    "[Metal] Blackballers S4"
  ),
  "[FOUL]" = c(
    "[FOUL]ing Charlies S4",
    "[FOUL] ed by Judy S4",
    "[FOUL] Appearance S4",
    "[FOUL] Nekkid Men S4",
    "[FOUL] Legion S4"
  ),
  "[Lads]" = c(
    "[Lads] Amber Nectar S4",
    "[Lads] Out For A Drink S4",
    "[Lads] Biting the Dust S4",
    "[Lads] Miltorn Monks S4",
    "[Lads] in black S4"
  ),
  "[Rodder]" = c(
    "[Rodder]'s Refreshment S4",
    "[Rodder]'s Bloody Fist S4",
    "[Rodder]'s NobelBeasts S4",
    "[Rodder]s Sweet Releaf S4",
    "[Rodder]'s Retinue S4"
  ),
  "[PATH]" = c(
    "[Path] of the people S4",
    "[Path] Tao of Sulaco S4",
    "[Path] of the Crusader S4",
    "[Path]ogens S4",
    "[Path] Of The Gm S4"
  ),
  "[PUNT]" = c(
    "[PUNT]ential Heroes S3",
    "[PUNT] D.E. Delight S3",
    "[PUNT]ification S3",
    "[PUNT] HAIL HYPNOTOAD S3",
    "[PUNT] & Punch S3"
  ),
  "[O²]" = c(
    "[O²] Warc Raiders S4",
    "[O²] Ionian Resistance S4",
    "[O²]Ozzie Battlers S 4",
    "[O²] Rainbow Ponies S4",
    "[O²] Truffle Shuffle S4"
  ),
  "[O]" = c(
    "[O]Owesome Orcs S4",
    "[O]ne Oneders S4",
    "[O] WesC's Superwolves S4",
    "[O]tel Californias",
    "[O]Deserted Isle DiggerS4"
  ),
  "[PUNCH]" = c(
    "[PUNCH] Everything! S3",
    "[PUNCH] and Judy S3",
    "[PUNCH] smCHAOS S3",
    "[PUNCH] Everyone! S3",
    "[PUNCH] Skinnyrats S3"
  ),
  "[bOot]" = c(
    "[bOot] big bOys S4",
    "[bOot] Of Nuffle S4",
    "[bOot] Creepy Critters",
    "[bOot] WholelottaStuds S3",
    "[bOot]Rockman and Roll S4"
  ),
  "[FOUL²]" = c(
    "[FOUL²] Intentions S4",
    "[FOUL²]ing for Lady S4",
    "[FOUL²]Barbeerians S4",
    "[FOUL²]ing is life S4",
    " [FOUL²]Squig Hoppers S4"
  ),
  "[REL]" = c(
    "[REL] Bad Moo Rising S4",
    "[REL]Verminal Velocity S4",
    "[REL] ReBBRL Ringers S4",
    "[Rel] Cash Autocrats  S4",
    "[REL] Rockstars S4"
  ),
  "[ANZAC]" = c(
    "[ANZAC] Reavers S4",
    "[ANZAC] Malcontents S4",
    "[ANZAC]The Unforgotten S4",
    "[ANZAC] BLACK ORC DOWN S4",
    "[ANZAC] OFL Reborn S4"
  ),
  "[BBT]" = c(
    "[BBT] Little Mutants S4",
    "[BBT] Carnival of Pain S4",
    "[BBT] Bergen BLOTZ! S4",
    "[BBT] Punchin Yo Face S4",
    "[BBT] The Blood River BrothersS4"
  ),
  "[OFFAL]" = c(
    "[Offal]ly Good S4",
    "[OFFAL] Veal's Vegans S4",
    "[OFFAL]DeliciousMurder S4",
    "[OFFAL] Rage Quit S4",
    "[OFFAL] Just Offal S4"
  ),
  "[CLASSY]" = c(
    "[CLASSY]Dead Gentlemen S4",
    "[CLASSY] Iron Chewas S4",
    "[CLASSY] And Pondering S4",
    "[CLASSY] Portly Poundaz S4",
    "[CLASSY] Lassies S4"
  ),
  "[GeeMan]" = c(
    "[GeeMan] Snake Eyes S4",
    "[GeeMan]Snakes S4",
    "[GeeMan]Oh my Godess[S4]",
    "[GeeMan] Golden Laws S3",
    "[GeeMan]Leorics Beast S3"
  ),
  "[FatKids]" = c(
    "[FatKids] With Toys S4",
    "[FatKids] Chubby Boys S4",
    "[FatKids] Boro Boys S4",
    "[FatKids] Literally S4",
    "[FatKids] 1/4 Pounders S4"
  ),
  "[BEST]" = c(
    "[BEST] Periodically S4",
    "[BEST] Birdosaurs [S4]",
    "[BEST] Games S4",
    "[BEST] Pieces of Eight S4",
    "[BEST] Folklore S4"
  ),
  "[DASH]" = c(
    "[DASH] of Bob & Weave S4",
    "[DASH] of The Elf Life S4",
    "[DASH] of Lime S4",
    "[DASH] of Salt & Fail S4",
    "[DASH] D-bags S4"
  ),
  "[DAD]" = c(
    "[DAD] Imortal Elfs S4",
    "[DAD] Big Papa Pump S4",
    "[DAD] Pool S4",
    "[DAD] Onomatopoeia S4",
    "[DAD] Jokes S4"
  ),
  "[F-News]" = c(
    "[F-News] Talkin' Heads S4",
    "[F-News] Vile Vaccines S4",
    "[F-News] Click-Baiters S4",
    "[F-News] Fox & Friends S4",
    "[F-News] The Outlets S4"
  ),
  "[GODS]" = c(
    "[GODS] of War S4",
    "[GODS] of the Abyss S4",
    "[GODS] of Healing S4",
    "[GODS] of the Hunt S4",
    "[GODS] of the Sun S4"
  ),
  "[GROON]" = c(
    "[GROON] Massachewshits S4",
    "[GROON] Dream Vacation S4",
    "[GROON] Georgian Giant S4",
    "[GROON] DC Gourmands S4",
    "[GROON] Dirty Jerz S4"
  ),
  "[HrsY]" = c(
    "[HrsY] Henchmen S4",
    "[HrsY] Yabby's Cathars S4",
    "[HrsY] The Heretics S4",
    "[HrsY] N.I.R.A S4",
    "[HrsY] Mystery Babylon S4"
  ),
  "[LOWTR]" = c(
    "[LOWTR] Fellowship S4",
    "[LOWTR] McDuck Manor S4",
    "[LOWTR] Beaucoup Fish S4",
    "[LOWTR] Nyctophiles S4",
    "[LOWTR] Ogre Maunders S4"
  ),
  "[NOOBS]" = c(
    "[NOOBS] Very Uglies S4",
    "[NOOBS] Ravenloft S4",
    "[NOOBS] Divine Comedy S4",
    "[NOOBS] Grave Salt S4",
    "[NOOBS] Jewventus S4"
    ),
  "[RNG]" = c(
    "[RNG] :bird: S4",
    "[RNG] How to roll 1s S4",
    "[RNG] Heavenly Wholes S4",
    "[RNG] Horrible Cliches S4",
    "[RNG] Drunken Deja Vu S4"
  ),
  "[SUCC]" = c(
    "[SUCC]ulent Lambs s4",
    "[SUCC] [REDACTED] S4",
    "[SUCC]ess Lil Else S4",
    "[SUCC] Plague Kings [S4]",
    "[SUCC]kers of Sin - S4"
  ),
  "[SURF]" = c(
    "[SURF] Engines S4",
    "[SURF] Sacred Surfers S4",
    "[SURF] Surfari S4",
    "[SURF] SUP S4",
    "[SURF] The Surf Lords S4"
  ),
  "[SweBBA]" = c(
    "[SweBBA] L.o.A - S4",
    "[SweBBA] Swedish heroes - S4",
    "[SweBBA] Yellow- S4",
    "[SweBBA] IK IKEA S4",
    "[SweBBA] Kareoke Kings - S4"
  ),
  "[THICC]" = c(
    "[THICC] Bark S4",
    "[THICC] Bearded Men S4",
    "[THICC] Scaly Thighs S4",
    "[THICC] MusicORCS S4",
    "[THICC] 'n' Furry S4"
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
             modify_at("skills", ~map(., ~glue::glue("<img src='img/skills/{.}.png' title='{stringr::str_replace_all(.,'([a-z])([A-Z])','\\\\1 \\\\2')}' width=30 style='padding: 1px'>")) %>% glue::collapse("")) %>% 
             modify_depth(1,fill_nulls, "") %>% 
             modify_at("name",as.character)
         )
  ) %>% 
    arrange(number) %>%
    mutate(
      Type = stringr::str_replace_all(type, c(".*_"="", "([a-z])([A-Z])"="\\1 \\2")),
      nskills = stringr::str_count(skills,"<img"),
      skills = ifelse(level-nskills >1, paste0(skills,'<img src="img/skills/PositiveRookieSkills.png" title="Pending Level up" width=30 stype="padding: 1px">'), skills)
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
