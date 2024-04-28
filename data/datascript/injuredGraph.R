#partyies sur les blessés
print(players_stats_list)
# Calculer le nombre total de matchs manqués par chaque joueur
players_stats <- do.call(rbind, players_stats_list) %>%
  group_by(player_url) %>%
  summarise(total_games_missed = sum(games_missed, na.rm = TRUE))

# Trier les joueurs en fonction du nombre total de matchs manqués
players_stats <- arrange(players_stats, desc(total_games_missed))

# Sélectionner les 100 joueurs ayant manqué le plus de matchs
top_100_players <- head(players_stats, 100)

# Créer un dictionnaire avec les joueurs URL comme clés et les matchs manqués comme valeurs
top_100_dict <- setNames(top_100_players$total_games_missed, top_100_players$player_url)


