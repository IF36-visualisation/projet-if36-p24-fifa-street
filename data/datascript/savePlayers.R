library(worldfootballR)
library(readr)
setwd("C:/Users/Administrateur/Desktop/ProjetIF36/projet-if36-p24-fifa-street/data")


players <- list()
leagues <- c("ENG", "ESP", "ITA", "GER", "FRA")
# Créez une liste de data frames vides pour stocker les URL des joueurs de chaque championnat
players_list <- list()
for (league in leagues) {
  players_list[[league]] <- data.frame(player_url = character())
}

# Parcourez chaque championnat
for (league in leagues) {
  # Obtenez les URL des équipes du championnat
  league_url <- fb_league_urls(country = league, gender = "M", season_end_year = 2023, tier = '1st')
  team_urls <- fb_teams_urls(league_url)
  
  # Parcour chaque URL d'équipe pour avoir URL des joueurs
  for (team in team_urls) {
    player_urls <- fb_player_urls(team)
    players_list[[league]] <- rbind(players_list[[league]], data.frame(player_url = player_urls))
  }
}


# Écrivez les données dans un fichier CSV
for (league in leagues) {
  filename <- paste0("dataset/playerslinkFbref/",league, "players.csv")
  readr::write_csv(players_list[[league]], file = filename)
}

# Affichez les résumés des data frames pour chaque championnat
for (league in leagues) {
  cat(league, "\n")
  print(summary(players_list[[league]]))
  cat("\n")
}



mapped_players <- player_dictionary_mapping()
dplyr::glimpse(mapped_players)
filename <- paste0("dataset/playerslinkALL/players.csv")
readr::write_csv(mapped_players, file = filename)

