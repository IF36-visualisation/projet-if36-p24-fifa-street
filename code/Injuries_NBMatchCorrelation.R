# Installez et chargez les packages nécessaires
#install.packages(c("worldfootballR", "ggplot2", "dplyr"))

library(worldfootballR)
library(ggplot2)
library(dplyr)

# Définissez les noms des ligues
liguesa <- c("ENG", "ESP", "ITA", "GER", "FRA")
liguesc <- c("England", "Spain", "Italy", "Germany", "France")

# Définissez une liste vide pour stocker les nombres de matchs par équipe
nb_matchs_par_equipe <- list()

# Définissez une liste vide pour stocker les nombres de blessures par ligue
nb_blessures_par_ligue <- list()

# Calculez le nombre de matchs par équipe pour chaque ligue
for (i in seq_along(liguesa)) {
  ligue <- liguesa[i]
  ligue_name <- liguesc[i]
  
  # Obtenez les URL des matchs de la ligue pour la saison 2020-2021
  match_urls <- fb_match_urls(country = ligue, gender = "M", season_end_year = 2021, tier = "1st")
  
  # Calculez le nombre de matchs
  nb_matchs <- length(match_urls)
  
  # Obtenez les URL des équipes de la ligue
  league_url <- fb_league_urls(country = ligue, gender = "M", season_end_year = 2021, tier = "1st")
  team_urls <- fb_teams_urls(league_url)
  
  # Calculez le nombre d'équipes
  nb_equipes <- length(team_urls)
  
  # Calculez le nombre de matchs par équipe
  nb_matchs_par_equipe[[ligue]] <- round(nb_matchs / (nb_equipes / 2))
  
  # Obtenez les données sur les joueurs blessés dans la ligue
  injuries <- tm_league_injuries(country_name = ligue_name)
  
  # Calculez le nombre de blessures
  nb_blessures <- nrow(injuries)
  
  # Ajoutez le nombre de blessures à la liste
  nb_blessures_par_ligue[[ligue]] <- nb_blessures
}

df <- data.frame(
  ligue = liguesa,
  nb_matchs_par_equipe = unlist(nb_matchs_par_equipe),
  nb_blessures_par_ligue = unlist(nb_blessures_par_ligue)
)

# Créez un graphique à points montrant la corrélation entre le nombre de matchs et le nombre de blessures
ggplot(df, aes(x = nb_matchs_par_equipe, y = nb_blessures_par_ligue, color = ligue)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Nombre de matchs par équipe", y = "Nombre de blessures", title = "Corrélation entre le nombre de matchs et les blessures dans les ligues majeures") +
  theme_minimal()

ggplot(df, aes(x = nb_blessures_par_ligue, y = nb_matchs_par_equipe, color = ligue)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Nombre de blessures", y = "Nombre de matchs par équipe", title = "Corrélation entre le nombre de blessures et les matchs dans les ligues majeures") +
  theme_minimal()
