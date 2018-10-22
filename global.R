library(readr)
library(purrr)

clan_teams <- read_csv("data/clanS5teams.csv") %>% split(.$Division) %>% purrr::map(~split(., .$Clan))
