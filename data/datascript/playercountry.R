if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
library(worldfootballR)
library(readr)

setwd("C:/Users/Administrateur/Desktop/ProjetIF36/projet-if36-p24-fifa-street/data")


#----- or for multiple teams: -----#
team_urls <- tm_league_team_urls(country_name = "England", start_year = 2020)
print(team_urls)
epl_xfers_2020 <- tm_team_transfers(team_url = team_urls, transfer_window = "all")
print(epl_xfers_2020)








print(colnames(epl_xfers_2020))
print(head(epl_xfers_2020))


epl_xfers_2020_subset <- subset(epl_xfers_2020, select = c("team_name", "league", "country", "player_age", "player_nationality","player_position","player_age","club_2","league_2","country_2"))

readr::write_csv(epl_xfers_2020_subset, file = "dataset/playerCountry/PlayerCountry.csv")
