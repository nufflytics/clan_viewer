library(readr)
library(purrr)

clan_teams <- read_csv("data/ClanS6") %>% split(.$Div) %>% purrr::map(~split(., .$Clan))
