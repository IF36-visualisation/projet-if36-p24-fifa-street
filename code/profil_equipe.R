# Installer et charger les packages nécessaires
if (!require("worldfootballR")) {
  if (!require("devtools")) install.packages("devtools")
  devtools::install_github("JaseZiv/worldfootballR")
}
library(worldfootballR)
library(dplyr)
library(ggplot2)

# Extraire les données des grandes ligues pour la saison 2023
big5_stats <- fb_big5_advanced_season_stats(season_end_year = 2023, stat_type = "standard", team_or_player = "team")
big5_possession <- fb_big5_advanced_season_stats(season_end_year = 2023, stat_type = "possession", team_or_player = "team")

# Préparation des données
meilleures_possessions <- big5_possession %>%
  slice_max(order_by = Poss, n = 20) %>%
  select(Equipe = Squad, Competition = Comp, Possession = Poss)

buts_encaisses_adversaires <- big5_stats %>%
  filter(Team_or_Opponent == "opponent") %>%
  arrange(desc(Gls)) %>%
  slice_tail(n = 20) %>%
  select(Equipe = Squad, Competition = Comp, Buts_Encaisses = Gls)

buts_mis_equipe <- big5_stats %>%
  filter(Team_or_Opponent == "team") %>%
  slice_max(order_by = Gls, n = 20) %>%
  select(Equipe = Squad, Competition = Comp, Buts_mis = Gls)

# Visualisation des meilleures possessions
ggplot(meilleures_possessions, aes(x = Possession, y = reorder(Equipe, Possession), fill = Competition)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 20 des équipes avec le plus de possession en 2023",
       x = "Possession (%)",
       y = "") +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  scale_fill_brewer(palette = "Set2", name = "Compétition") +
  theme_minimal() +
  theme(legend.position = "right")

# Visualisation des buts encaissés
ggplot(buts_encaisses_adversaires, aes(x = Buts_Encaisses, y = reorder(Equipe, Buts_Encaisses), fill = Competition)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 20 des équipes avec le moins de buts encaissés en 2023",
       x = "Buts encaissés",
       y = "") +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  scale_fill_brewer(palette = "Set2", name = "Compétition") +
  theme_minimal() +
  theme(legend.position = "right")

# Visualisation des buts marqués
ggplot(buts_mis_equipe, aes(x = Buts_mis, y = reorder(Equipe, Buts_mis), fill = Competition)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 20 des équipes avec le plus de buts marqués en 2023",
       x = "Buts marqués",
       y = "") +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  scale_fill_brewer(palette = "Set2", name = "Compétition") +
  theme_minimal() +
  theme(legend.position = "right")



# Fonction pour extraire et compter les victoires d'une équipe
get_wins <- function(team_url) {
  results <- fb_team_match_results(team_url)
  wins <- nrow(results[results$Result == "W",])
  league <- results$Comp[1]  # Prendre le nom de la compétition
  team_name <- gsub(".*/", "", team_url)  # Extraire le nom de l'équipe de l'URL
  team_name <- gsub("-Stats", "", team_name)  # Nettoyer le nom de l'équipe
  
  # Standardiser les noms des ligues
  league <- gsub(" Stats", "", league)
  league <- ifelse(league == "DFL-Supercup", "Bundesliga", league)
  league <- ifelse(league == "Community Shield", "Premier League", league)
  league <- ifelse(league == "DFB-Pokal", "Bundesliga", league)
  
  data.frame(Team = team_name, Wins = wins, League = league)
}

# Liste des URL des ligues des Big 5
league_urls <- c(
  "https://fbref.com/en/comps/9/Premier-League-Stats",
  "https://fbref.com/en/comps/12/La-Liga-Stats",
  "https://fbref.com/en/comps/13/Ligue-1-Stats",
  "https://fbref.com/en/comps/20/Bundesliga-Stats",
  "https://fbref.com/en/comps/11/Serie-A-Stats"
)

# Extraire les URLs des équipes pour chaque ligue
team_urls <- unlist(lapply(league_urls, fb_teams_urls))

# Appliquer la fonction get_wins à chaque URL d'équipe
team_wins <- do.call(rbind, lapply(team_urls, get_wins))

# Sélectionner les 20 meilleures équipes par nombre de victoires
top_teams <- team_wins %>%
  top_n(20, Wins) %>%
  arrange(Wins)  # Ordonner par victoires croissantes

# Création d'une visualisation - Diagramme en nuage de points
ggplot(top_teams, aes(x = Wins, y = reorder(Team, Wins), color = League)) +
  geom_point(size = 5) +
  labs(title = "Top 20 des équipes avec le plus de victoires dans les 5 ligues",
       x = "Nombre de Victoires",
       y = "") +
  scale_x_continuous(limits = c(0, max(top_teams$Wins) + 5)) +
  theme_minimal() +
  theme(
    legend.position = "right",
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.title.y = element_blank()
  ) +
  scale_color_brewer(palette = "Set2", name = "Ligue")

