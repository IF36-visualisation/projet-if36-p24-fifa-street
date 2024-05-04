#install.packages(c("worldfootballR", "ggplot2", "dplyr"))

library(worldfootballR)
library(ggplot2)
library(dplyr)

# noms des ligues
liguesa <- c("ENG", "ESP", "ITA", "GER", "FRA")
liguesc <- c("England", "Spain", "Italy", "Germany", "France")

nb_matchs_par_equipe <- list()

nb_blessures_par_ligue <- list()

nb_moyen_intervalle_matc<- list()
for (i in seq_along(liguesa)) {
  ligue <- liguesa[i]
  ligue_name <- liguesc[i]
  
  match_urls <- fb_match_urls(country = ligue, gender = "M", season_end_year = 2023, tier = "1st")
  
  # Calcule nombre  matchs
  nb_matchs <- length(match_urls)
  
  #  URL des équipes de la ligue
  league_url <- fb_league_urls(country = ligue, gender = "M", season_end_year = 2023, tier = "1st")
  team_urls <- fb_teams_urls(league_url)
  
  # Calcule nombre d'équipes
  nb_equipes <- length(team_urls)
  
  # Calcule  nombre de matchs par équipe
  nb_matchs_par_equipe[[ligue]] <- round(nb_matchs / (nb_equipes / 2))
  
  #   données  joueurs blessés dan ligue
  injuries <- tm_league_injuries(country_name = ligue_name)
  
  # Calculeznombre blessures
  nb_blessures <- nrow(injuries)
  
  # Ajoute nombre  blessures à la liste
  nb_blessures_par_ligue[[ligue]] <- nb_blessures
}

df <- data.frame(
  ligue = liguesa,
  nb_matchs_par_equipe = unlist(nb_matchs_par_equipe),
  nb_blessures_par_ligue = unlist(nb_blessures_par_ligue)
)

#   graphique à points montrant la corrélation entre le nombre de matchs et le nombre de blessures
ggplot(df, aes(x = nb_matchs_par_equipe, y = nb_blessures_par_ligue, color = ligue)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Nombre de matchs par équipe", y = "Nombre de blessures", title = "Relation nombre de matchs et blessures ") +
  theme_minimal()




# Dates de début et de fin de la saison pour chaque ligue
start_dates <- c("2022-08-11", "2022-08-13", "2022-08-18", "2022-08-18", "2022-08-11")
end_dates <- c("2023-05-19", "2023-05-18", "2023-05-18", "2023-05-26", "2023-05-26")

# Convertir les dates en format Date
start_dates <- as.Date(start_dates)
end_dates <- as.Date(end_dates)

# Calculer le nombre de jours entre le début et la fin de la saison pour chaque ligue
nb_days <- end_dates - start_dates
print(nb_days)
# Calculer le nombre moyen de jours entre chaque match pour chaque ligue
nb_moyen_intervalle_match <- nb_days / unlist(nb_matchs_par_equipe)

# Ajouter les résultats à la data frame
df <- data.frame(
  ligue = liguesa,
  nb_matchs_par_equipe = unlist(nb_matchs_par_equipe),
  nb_blessures_par_ligue = unlist(nb_blessures_par_ligue),
  nb_moyen_intervalle_match = nb_moyen_intervalle_match
)

# Créer un graphique à points montrant la corrélation entre le nombre moyen de jours entre chaque match et le nombre de blessures
ggplot(df, aes(x = nb_moyen_intervalle_match, y = nb_blessures_par_ligue, color = ligue)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Nombre moyen de jours entre chaque match", y = "Nombre de blessures", title = "Relation delai  matchs et blessures") +
  theme_minimal()




