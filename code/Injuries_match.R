# Charger la bibliothèque ggplot2 pour la visualisation
library(ggplot2)

# Charger le package worldfootballR
library(worldfootballR)

# Charger le package worldfootballR

# Obtenir les données sur les joueurs blessés dans chaque ligue majeure
num_injuries_epl <- nrow(tm_league_injuries(country_name = "England"))
num_injuries_laliga <- nrow(tm_league_injuries(country_name = "Spain"))
num_injuries_bundesliga <- nrow(tm_league_injuries(country_name = "Germany"))
num_injuries_seriea <- nrow(tm_league_injuries(country_name = "Italy"))
num_injuries_ligue1 <- nrow(tm_league_injuries(country_name = "France"))

# Afficher le nombre de joueurs blessés dans chaque ligue
print("Premier League (Angleterre)")
print(num_injuries_epl)

print("La Liga (Espagne)")
print(num_injuries_laliga)

print("Bundesliga (Allemagne)")
print(num_injuries_bundesliga)

print("Serie A (Italie)")
print(num_injuries_seriea)

print("Ligue 1 (France)")
print(num_injuries_ligue1)


# Premier League
eng_data <- get_FBref_data(league = "ENG", season = 2021)
# La Liga
esp_data <- get_FBref_data(league = "ESP", season = 2021)
# Serie A
ita_data <- get_FBref_data(league = "ITA", season = 2021)
# Bundesliga
ger_data <- get_FBref_data(league = "GER", season = 2021)
# Ligue 1
fra_data <- get_FBref_data(league = "FRA", season = 2021)

# Afficher le nombre de matchs pour chaque ligue
# Premier League
eng_matches <- nrow(eng_data$matches)
# La Liga
esp_matches <- nrow(esp_data$matches)
# Serie A
ita_matches <- nrow(ita_data$matches)
# Bundesliga
ger_matches <- nrow(ger_data$matches)
# Ligue 1
fra_matches <- nrow(fra_data$matches)
