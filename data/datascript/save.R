library(worldfootballR)

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
  
  # Parcourez chaque URL d'équipe et obtenez les URL des joueurs
  for (team in team_urls) {
    player_urls <- fb_player_urls(team)
    players_list[[league]] <- rbind(players_list[[league]], data.frame(player_url = player_urls))
  }
}

for (league in leagues) {
  
# Écrivez les données dans un fichier CSV
filename <- paste0(league, "players.csv")
write.csv(players_list[[league]], file = filename, row.names = FALSE)
}
# Affichez les résumés des data frames pour chaque championnat
for (league in leagues) {
  cat(league, "\n")
  print(summary(players_list[[league]]))
  cat("\n")
}

