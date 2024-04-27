install.packages(c("worldfootballR", "ggplot2", "dplyr"))

library(worldfootballR)
library(ggplot2)
library(dplyr)

# noms des ligues
liguesa <- c("ENG", "ESP", "ITA", "GER", "FRA")
liguesc <- c("England", "Spain", "Italy", "Germany", "France")

nb_matchs_par_equipe <- list()

nb_blessures_par_ligue <- list()

for (i in seq_along(liguesa)) {
  ligue <- liguesa[i]
  ligue_name <- liguesc[i]
  
  match_urls <- fb_match_urls(country = ligue, gender = "M", season_end_year = 2021, tier = "1st")
  
  # Calcule nombre  matchs
  nb_matchs <- length(match_urls)
  
  #  URL des équipes de la ligue
  league_url <- fb_league_urls(country = ligue, gender = "M", season_end_year = 2021, tier = "1st")
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
  labs(x = "Nombre de matchs par équipe", y = "Nombre de blessures", title = "Corrélation entre le nombre de matchs et les blessures dans les ligues majeures") +
  theme_minimal()

#inverse axe
ggplot(df, aes(x = nb_blessures_par_ligue, y = nb_matchs_par_equipe, color = ligue)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Nombre de blessures", y = "Nombre de matchs par équipe", title = "Corrélation entre le nombre de blessures et les matchs dans les ligues majeures") +
  theme_minimal()
