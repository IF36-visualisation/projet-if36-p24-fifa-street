# Installer et charger les packages nécessaires
if (!require("worldfootballR")) {
  if (!require("devtools")) install.packages("devtools")
  devtools::install_github("JaseZiv/worldfootballR")
}
library(worldfootballR)
library(dplyr)
library(ggplot2)
library(rvest)
library(xml2)

# Extraire les données des grandes ligues pour la saison 2023
big5_stats <- fb_big5_advanced_season_stats(season_end_year = 2023, stat_type = "standard", team_or_player = "team")
big5_possession <- fb_big5_advanced_season_stats(season_end_year = 2023, stat_type = "possession", team_or_player = "team")

# Séparer les buts marqués et encaissés
buts_marques <- big5_stats %>%
  filter(Team_or_Opponent == "team") %>%
  select(Squad, Comp, Gls)

buts_encaisses <- big5_stats %>%
  filter(Team_or_Opponent == "opponent") %>%
  select(Squad, Comp, GA = Gls)  # Renommer Gls en GA pour clarté

# Fusionner les données de possession avec les données de buts marqués et encaissés
data <- big5_possession %>%
  inner_join(buts_marques, by = c("Squad", "Comp")) %>%
  inner_join(buts_encaisses, by = c("Squad", "Comp"))

# Sélectionner les 10 meilleures équipes en termes de possession
top_10 <- data %>%
  filter(Team_or_Opponent == "team") %>%
  arrange(desc(Poss)) %>%
  head(10)

# Sélectionner les 10 pires équipes en termes de possession
bottom_10 <- data %>%
  filter(Team_or_Opponent == "team") %>%
  arrange(Poss) %>%
  head(10)

# Visualisation de la corrélation entre la possession et les buts marqués
ggplot(data %>% filter(Team_or_Opponent == "team"), aes(x = Poss, y = Gls)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(title = "Relation entre la possession et les buts marqués",
       x = "Possession (%)",
       y = "Buts marqués") +
  theme_minimal()

# Visualisation de la corrélation entre la possession et les buts encaissés
ggplot(data %>% filter(Team_or_Opponent == "opponent"), aes(x = Poss, y = Gls)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(title = "Relation entre la possession et les buts encaissés",
       x = "Possession (%)",
       y = "Buts encaissés") +
  theme_minimal()

# Fusionner les données des 10 meilleures et 10 pires équipes
combined_data <- bind_rows(top_10, bottom_10, .id = "Position")

# # Visualisation des résultats de la possession pour les meilleures et pires équipes par rapport à leur buts moyens par match
ggplot(combined_data, aes(x = Poss, y = reorder(Squad, Poss), fill = Comp)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste(round(Gls/38, 2),"buts/match")), hjust = 0, vjust = -0.5, size = 3) +  # Arrondir à deux chiffres après la virgule et diviser par 38 car 38 matchs dans une saison
  labs(title = "Top et bas 10 des équipes en termes de possession en 2023",
       x = "Possession (%)",
       y = "Équipe",
       fill = "Compétition",
       subtitle = "Les 10 premières sont les meilleures, les 10 dernières sont les pires") +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  theme(legend.position = "right")

# Sélectionner les 10 meilleures équipes en fonction du rapport buts marqués et possession
top_10_best <- data %>%
  filter(Team_or_Opponent == "team") %>%
  arrange(desc(Gls/Poss)) %>%
  head(10)

# Sélectionner les 10 pires équipes en fonction du rapport buts marqués / possession
bottom_10_worst <- data %>%
  filter(Team_or_Opponent == "team") %>%
  arrange(Gls/Poss) %>%
  head(10)

# Fusionner les données des 10 meilleures et 10 pires équipes
combined_data <- bind_rows(top_10_best, bottom_10_worst, .id = "Position")

# Ajouter une variable pour distinguer les meilleures et les pires équipes
combined_data <- combined_data %>%
  mutate(Type = ifelse(Position <= 10, "Top 10", "Bottom 10"))

# Visualisation des résultats avec le rapport Gls/Poss limité à deux chiffres après la virgule
ggplot(combined_data, aes(x = Gls/Poss, y = reorder(Squad, Gls/Poss), fill = Comp)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste(round(Gls/Poss, 2))), hjust = 0, vjust = -0.5, size = 3) +  # Arrondir à deux chiffres après la virgule
  labs(title = "Contraste entre les 10 meilleures et les 10 pires équipes en termes de buts marqués par rapport à la possession",
       x = "Rapport but / possession",
       y = "Équipe",
       fill = "Compétition",
       subtitle = "Les 10 premières sont les meilleures, les 10 dernières sont les pires") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  theme(legend.position = "right")


# Extraire les classements de chaque ligue
leagues <- c("Premier League", "La Liga", "Bundesliga", "Serie A", "Ligue 1")

# Map des IDs des ligues pour les URLs
league_ids <- list("Premier League" = 9, "La Liga" = 12, "Bundesliga" = 20, "Serie A" = 11, "Ligue 1" = 13)

# Fonction pour extraire les classements de chaque ligue
get_league_table <- function(league, id) {
  url <- paste0("https://fbref.com/en/comps/", id, "/2022-2023/", gsub(" ", "-", league), "-Stats")
  page <- read_html(url)
  table <- page %>%
    html_node("table.stats_table") %>%
    html_table()
  table <- table %>%
    select(Squad = Squad, Pos = Rk) %>%
    mutate(Comp = league)
  return(table)
}

# Extraire et combiner les classements
league_tables <- bind_rows(lapply(seq_along(leagues), function(i) {
  get_league_table(leagues[i], league_ids[[i]])
}))

# Fusionner les données de classement avec les données existantes
data <- data %>%
  left_join(league_tables, by = c("Squad", "Comp"))

# Extraire les équipes championnes de chaque ligue
champions <- league_tables %>%
  filter(Pos == 1) %>%
  select(Squad, Comp)

# Fusionner les données des champions avec les statistiques
champions_data <- data %>%
  inner_join(champions, by = c("Squad", "Comp"))

# Fonction pour extraire la possession de chaque équipe championne
get_champion_possession <- function(team, league_id) {
  poss <- big5_stats %>%
    filter(Squad == team, Comp == league_id) %>%
    pull(Poss)
  return(poss)
}

# Créer une liste pour stocker la possession de chaque équipe championne
champion_possessions <- c()

# Extraire la possession de chaque équipe championne
for (i in 1:nrow(champions_data)) {
  poss <- get_champion_possession(champions_data$Squad[i], champions_data$Comp[i])
  # Ajouter seulement la première valeur de possession trouvée
  champion_possessions <- c(champion_possessions, poss[1])
}

# Ajouter la possession au dataframe des équipes championnes
champions_data <- champions_data %>%
  mutate(Possession = champion_possessions)

# Visualisation des statistiques des équipes championnes avec ajustement de l'échelle de l'axe x
ggplot(champions_data, aes(x = Possession, y = reorder(Squad, -Possession), fill = Comp)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste("Buts mis:", Gls, "Buts pris:", GA, "Possession:", Possession,"%")), hjust = 0, vjust = -0.5, size = 3) +
  labs(title = "Statistiques des équipes championnes des 5 grandes ligues (2023)",
       x = "Possession (%)",
       y = "Équipe",
       fill = "Compétition",
       subtitle = "Inclut la possession, les buts marqués et les buts encaissés") +
  scale_fill_brewer(palette = "Set2") +
  scale_x_continuous(limits = c(0, 100), expand = c(0, 0)) +  # Ajustement de l'échelle de l'axe x
  theme_minimal() +
  theme(legend.position = "right")
