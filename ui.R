
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(DT)

# Data setup -----
clans = c("[Metal]","[FOUL]","[Lads]","[Rodder]","[PATH]","[PUNT]","[O²]","[O]","[PUNCH]","[boOt]","[FOUL²]","[REL]","[ANZAC]","[BBT]","[OFFAL]","[CLASSY]","[GeeMan]","[FatKids]")

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
    "[FOUL²] Suckerpunchers",
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
dashboardPage(title = "REBBL Clan League",
              skin="black",
              dashboardHeader(title = span(tagList(a(href="https://www.reddit.com/r/rebbl", img(src = "img/ReBBL_logo_800px_72dpi.png", width = "70px")),"Clan League"))),
              dashboardSidebar(disable = T),
              dashboardBody(
                #includeCSS("www/css/google-font.css"),
                fluidRow(
                  box(width=12,
                      h4("Clan picker and overall summary!"),
                      selectInput("clan_picker", "Clan:",clans),
                      verbatimTextOutput("clan_data"),
                      DT::dataTableOutput("clan_summary")
                  ),
                  conditionalPanel(
                    "input.clan_summary_rows_selected != ''",
                    box(width = 12,
                        h4("Team view if above selected")
                    )
                  )
                )
                # tabItems(
                #   # Leaderboard content ----
                #   tabItem(tabName = "leaderboard",
                #           fluidRow(
                #             box(
                #               title = "Current Standings",
                #               width = 12,
                #               DT::dataTableOutput("leaderboard")
                #             ),
                #             conditionalPanel(
                #               "input.leaderboard_rows_selected != ''",
                #               box(
                #                 width = 6,
                #                 plotOutput("weekly_bars")
                #               ),
                #               box(
                #                 width = 6,
                #                 plotOutput("weekly_lines")
                #               )
                #             )
                #           )
                #   ),
                #   
                #   # Second tab content
                #   tabItem(tabName = "teams",
                #           fluidRow(
                #             box(
                #               title = "Coach:",
                #               width = 6,
                #               height = 100,
                #               uiOutput("coach_select")
                #             ),
                #             box(
                #               title = "Round:",
                #               width = 6,
                #               height = 100,
                #               numericInput("selected_round", NULL, 1, min = 1, max = 13, step = 1)
                #             )
                #           ),
                #           fluidRow(
                #             box(
                #               width = 12,
                #               uiOutput("team_name"),
                #               DT::dataTableOutput("team_summary")
                #             )
                #           )
                #   ),
                #   # Third tab content 
                #   tabItem(tabName = "stats",
                #           fluidRow(
                #             tabBox(
                #               title = "Player statistics",
                #               id = "stats_tab",
                #               width = 12,
                #               selected = "Averaged",
                #               tabPanel("Averaged", DT::dataTableOutput("averaged_stats_table")),
                #               tabPanel("All", DT::dataTableOutput("stats_table"))
                #             )
                #           ),
                #           fluidRow(
                #             infoBoxOutput("best_game_stats", width = 3),
                #             conditionalPanel(
                #               "(input.stats_tab == 'Averaged' & input.averaged_stats_table_rows_selected != '') | (input.stats_tab == 'All' & input.stats_table_rows_selected != '')",
                #               box(
                #                 width = 6,
                #                 title = "Week by week",
                #                 plotOutput("points_bar_stats")
                #               )
                #             ),
                #             infoBoxOutput("worst_game_stats", width = 3)
                #           )
                #   )
                # )
              )
)