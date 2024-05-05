library(worldfootballR)
library(dplyr)
library(ggplot2)

# URL pour la FA Cup 2022-2023
fa_cup_url <- "https://fbref.com/en/comps/514/2022-2023/2022-2023-FA-Cup-Stats"

# Extraire les URLs des équipes pour la FA Cup
fa_cup_team_urls <- fb_teams_urls(fa_cup_url)

# Fonction pour obtenir les résultats des matchs d'une équipe dans la FA Cup
get_fa_cup_team_results <- function(team_url) {
  results <- fb_team_match_results(team_url)
  results <- results %>%
    mutate(Team = gsub(".*/", "", team_url),  # Extraire et nettoyer le nom de l'équipe de l'URL
           Team = gsub("-Stats", "", Team),
           Competition = "FA Cup",
           GF = as.numeric(GF),  # Assurez-vous que les buts marqués sont numériques
           GA = as.numeric(GA)) %>%
    select(Team, Date, Opponent, Result, Venue, GF, GA, Comp = Competition)
  return(results)
}

# Appliquer la fonction à chaque URL d'équipe de la FA Cup
fa_cup_team_results_list <- lapply(fa_cup_team_urls, get_fa_cup_team_results)

# Combiner les résultats de la FA Cup
fa_cup_team_results <- do.call(rbind, fa_cup_team_results_list)

# Collecter les URLs des équipes en Premier League pour la saison 2022-2023
pl_team_urls <- fb_teams_urls("https://fbref.com/en/comps/9/2022-2023/2022-2023-Premier-League-Stats")

# Fonction pour extraire les résultats de championnat
get_pl_team_results <- function(team_url) {
  results <- fb_team_match_results(team_url)
  results <- results %>%
    mutate(Team = gsub(".*/", "", team_url),
           Team = gsub("-Stats", "", Team),
           Competition = "Premier League",
           GF = as.numeric(GF),
           GA = as.numeric(GA)) %>%
    select(Team, Date, Opponent, Result, Venue, GF, GA, Comp = Competition)
  return(results)
}

# Appliquer la fonction aux URLs de Premier League
pl_team_results_list <- lapply(pl_team_urls, get_pl_team_results)

# Combiner les résultats de la Premier League
pl_team_results <- do.call(rbind, pl_team_results_list)

# Fusionner les données de la FA Cup et de la Premier League
all_results <- rbind(fa_cup_team_results, pl_team_results)

# Calculer les moyennes de buts marqués pour chaque compétition
average_goals <- all_results %>%
  group_by(Comp) %>%
  summarise(AverageGoals = mean(GF, na.rm = TRUE))

# Visualisation des moyennes de buts marqués
ggplot(average_goals, aes(x = Comp, y = AverageGoals, fill = Comp)) +
  geom_col() +
  labs(title = "Moyenne des buts marqués par match en FA Cup vs Premier League",
       x = "Compétition",
       y = "Moyenne des buts marqués par match") +
  theme_minimal() +
  theme(legend.position = "none")

# Afficher les résultats
print(average_goals)
