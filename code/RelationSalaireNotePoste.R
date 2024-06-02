install.packages("worldfootballR")

# Chargement du package worldfootballR
library(worldfootballR)

#Load data
man_city_url <- "https://fbref.com/en/squads/b8fd03ef/Manchester-City-Stats"
man_city_wages <- fb_squad_wages(team_urls = man_city_url)

# Charger les bibliothèques nécessaires
library(dplyr)
library(ggplot2)
library(scales)

# Recoder les postes en nouveaux groupes
man_city_wages <- man_city_wages %>%
  mutate(Groupe_poste = case_when(
    Pos %in% c("FW", "FW,MF", "MF,FW") ~ "Attaquant",
    Pos %in% c("MF", "DF,MF") ~ "Milieu",
    Pos %in% c("DF", "DF,FW", "RB", "AM") ~ "Défenseur",
    Pos == "GK" ~ "Gardien de but",
    TRUE ~ "Autre"
  ))

library(tibble)

# Créer un dataframe avec les données de note
notes_df <- tribble(
  ~Joueur,               ~Note,
  "Kevin De Bruyne",     7.60,
  "Erling Haaland",      7.35,
  "Bernardo Silva",      7.10,
  "Jack Grealish",       6.75,
  "John Stones",         6.58,
  "Phil Foden",          7.26,
  "Rodri",               7.59,
  "Joško Gvardiol",      6.93,
  "Rúben Dias",          6.80,
  "Manuel Akanji",       6.81,
  "Kyle Walker",         6.84,
  "Nathan Aké",          6.78,
  "Kalvin Phillips",     6.27,
  "Mateo Kovačić",       6.62,
  "Matheus Nunes",       6.37,
  "Ederson",             6.60,
  "Julián Álvarez",      7.15,
  "Stefan Ortega",       6.67,
  "Jeremy Doku",         7.26,
  "Sergio Gómez",        6.24,
  "Zack Steffen",        6.60,
  "Scott Carson",        NA,
  "Rico Lewis",          6.56,
  "Oscar Bobb",          NA
)

# Ajouter la colonne "Note" à man_city_wages
man_city_wages$Note <- notes_df$Note[match(man_city_wages$Player, notes_df$Joueur)]
man_city_wages <- select(man_city_wages, -Url, -Notes, -AnnualWageGBP, -AnnualWageUSD, -WeeklyWageUSD, -WeeklyWageGBP, -Comp)

# Visualisation : Comparaison des salaires annuels des joueurs de Manchester City en fonction des notes et des postes
ggplot(man_city_wages, aes(x = Note, y = AnnualWageEUR, shape = Groupe_poste, color = Groupe_poste)) +
  geom_point(size = 4, alpha = 0.7) +
  labs(title = "Relation entre les salaires annuels, les notes et les postes des joueurs de Manchester City",
       x = "Note",
       y = "Salaire annuel (en euros)",
       shape = "Poste",
       color = "Poste") +
  scale_x_continuous(breaks = seq(5, 10, by = 0.5)) +
  scale_y_continuous(labels = scales::comma) +
  scale_shape_manual(values = c(17, 19, 15, 16, 18, 3, 4)) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal() +
  theme(legend.title = element_text(face = "bold"),
        legend.position = "top",
        legend.direction = "horizontal",
        legend.key.size = unit(1.5, "lines"))



















