install.packages("worldfootballR")

# Chargement du package worldfootballR
library(worldfootballR)

#Load data
#man_city_url <- "https://fbref.com/en/squads/b8fd03ef/Manchester-City-Stats"
#man_city_wages <- fb_squad_wages(team_urls = man_city_url)

#write.csv(man_city_wages, "/Users/aminelazouzi/Documents/man_city_wages.csv", row.names = FALSE)

teams_urls <- list(
  man_city = "https://fbref.com/en/squads/b8fd03ef/Manchester-City-Stats",
  arsenal = "https://fbref.com/en/squads/18bb7c10/Arsenal-Stats",
  brighton = "https://fbref.com/en/squads/d07537b9/Brighton-and-Hove-Albion-Stats",
  everton = "https://fbref.com/en/squads/d3fd31cc/Everton-Stats",
  sheffield_utd = "https://fbref.com/en/squads/1df6b87e/Sheffield-United-Stats"
)

# Function to get squad wages
get_team_wages <- function(team_url) {
  fb_squad_wages(team_urls = team_url)
}

# Get wages data for each team
man_city_wages <- get_team_wages(teams_urls$man_city)
arsenal_wages <- get_team_wages(teams_urls$arsenal)
brighton_wages <- get_team_wages(teams_urls$brighton)
everton_wages <- get_team_wages(teams_urls$everton)
sheffield_utd_wages <- get_team_wages(teams_urls$sheffield_utd)

# Charger les bibliothèques nécessaires
library(dplyr)
library(ggplot2)
library(scales)

library(tibble)

notes_df_city <- tribble(
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
notes_df_arsenal <- tribble(
  ~Joueur,                   ~Note,
  "Bukayo Saka",             7.67,
  "Declan Rice",             7.38,
  "Martin Ødegaard",         7.37,
  "Kai Havertz",             7.16,
  "Gabriel Magalhães",       6.99,
  "Ben White",               6.93,
  "Gabriel Jesus",           6.89,
  "Gabriel Martinelli",      6.89,
  "William Saliba",          6.85,
  "Leandro Trossard",        6.82,
  "Oleksandr Zinchenko",     6.81,
  "Thomas Partey",           6.67,
  "Takehiro Tomiyasu",       6.60,
  "Jakub Kiwior",            6.58,
  "David Raya",              6.54,
  "Eddie Nketiah",           6.53,
  "Jurriën Timber",          6.43,
  "Jorginho",                6.41,
  "Fábio Vieira",            6.40,
  "Emile Smith Rowe",        6.35,
  "Aaron Ramsdale",          6.26,
  "Ethan Nwaneri",           6.22,
  "Reiss Nelson",            6.19,
  "Mohamed Elneny",          6.16,
  "Cédric Soares",           6.10
)

notes_df_brighton <- tribble(
  ~Joueur,                   ~Note,
  "Solly March",             7.43,
  "Pascal Groß",             7.13,
  "João Pedro",              6.93,
  "Kaoru Mitoma",            6.88,
  "Simon Adingra",           6.86,
  "Lewis Dunk",              6.73,
  "Pervis Estupiñán",        6.73,
  "Jan Paul van Hecke",      6.72,
  "Bart Verbruggen",         6.64,
  "Jack Hinshelwood",        6.63,
  "Danny Welbeck",           6.58,
  "Igor Julio",              6.52,
  "Joël Veltman",            6.51,
  "Julio Enciso",            6.50,
  "James Milner",            6.49,
  "Evan Ferguson",           6.49,
  "Facundo Buonanotte",      6.47,
  "Adam Webster",            6.47,
  "Billy Gilmour",           6.39,
  "Carlos Baleba",           6.33,
  "Tariq Lamptey",           6.32,
  "Mahmoud Dahoud",          6.32,
  "Ansu Fati",               6.26,
  "Jakub Moder",             6.23,
  "Jason Steele",            6.20,
  "Valentín Barco",          6.20,
  "Adam Lallana",            6.17,
  "Odeluga Offiah",          6.14,
  "Benicio Baker-Boaitey",   6.01,
  "Mark O’Mahony",           5.95
)

notes_df_sheffield <- tribble(
  ~Joueur,                   ~Note,
  "Auston Trusty",           7.63,
  "Oliver Norwood",          7.24,
  "Chris Basham",            7.18,
  "John Egan",               6.94,
  "Oliver McBurnie",         6.82,
  "Ben Brereton",            6.80,
  "Vinicius Souza",          6.62,
  "Gustavo Hamer",           6.58,
  "Yasser Larouci",          6.55,
  "Oliver Arblaster",        6.53,
  "Jili Buyabu",             6.47,
  "Jayden Bogle",            6.47,
  "Wes Foderingham",         6.45,
  "Ismaila Coulibaly",       6.44,
  "George Baldock",          6.42,
  "Cameron Archer",          6.42,
  "James McAtee",            6.38,
  "Louie Marsh",             6.37,
  "Jack Robinson",           6.36,
  "Anel Ahmedhodzic",        6.28,
  "Ivo Grbic",               6.27,
  "Luke Thomas",             6.26,
  "Femi Seriki",             6.19,
  "Andre Brooks",            6.18,
  "Ben Osborn",              6.17,
  "Adam Davies",             6.16,
  "Mason Holgate",           6.09,
  "Bénie Traoré",            6.08,
  "Sydie Peck",              6.04,
  "Anis Ben Slimane",        6.01,
  "William Osula",           6.00,
  "John Fleck",              5.98,
  "Sam Curtis",              5.95,
  "Tom Davies",              5.95,
  "Rhys Norrington-Davies",  5.94,
  "Rhian Brewster",          5.93,
  "Antwoine Hackford",       5.92,
  "Daniel Jebbison",         5.89,
  "Ryan Oné",                5.81
)

notes_df_everton <- tribble(
  ~Joueur,                   ~Note,
  "James Tarkowski",         7.08,
  "Dwight McNeil",           6.97,
  "Jarrad Branthwaite",      6.90,
  "Vitalii Mykolenko",       6.85,
  "James Garner",            6.84,
  "Idrissa Gueye",           6.83,
  "Dominic Calvert-Lewin",   6.79,
  "Ben Godfrey",             6.76,
  "Amadou Onana",            6.71,
  "Jordan Pickford",         6.71,
  "Abdoulaye Doucouré",      6.63,
  "Jack Harrison",           6.62,
  "Alex Iwobi",              6.55,
  "Nathan Patterson",        6.41,
  "Ashley Young",            6.40,
  "Séamus Coleman",          6.36,
  "Beto",                    6.32,
  "Lewis Dobbin",            6.26,
  "Michael Keane",           6.24,
  "Arnaut Danjuma",          6.23,
  "André Gomes",             6.22,
  "Youssef Chermiti",        6.11,
  "Lewis Warrington",        6.00,
  "Thomas Cannon",           6.00,
  "Tyler Onyango",           6.00,
  "Neal Maupay",             5.99
)

# Combiner les dataframes pour toutes les équipes
all_notes_df <- bind_rows(
  mutate(notes_df_city, Team = "Manchester City"),
  mutate(notes_df_arsenal, Team = "Arsenal"),
  mutate(notes_df_brighton, Team = "Brighton"),
  mutate(notes_df_sheffield, Team = "Sheffield United"),
  mutate(notes_df_everton, Team = "Everton")
)
# Combine all team wages into one dataframe
team_wages <- bind_rows(
  man_city_wages %>% mutate(Team = "Manchester City"),
  arsenal_wages %>% mutate(Team = "Arsenal"),
  brighton_wages %>% mutate(Team = "Brighton"),
  everton_wages %>% mutate(Team = "Everton"),
  sheffield_utd_wages %>% mutate(Team = "Sheffield United")
)


# Ajouter la colonne "Note" à man_city_wages
team_wages$Note <- all_notes_df$Note[match(team_wages$Player, all_notes_df$Joueur)]
team_wages <- select(team_wages, -Url, -Notes, -AnnualWageGBP, -AnnualWageUSD, -WeeklyWageUSD, -WeeklyWageGBP, -Comp)

# Recoder les postes en nouveaux groupes
team_wages <- team_wages %>%
  mutate(Groupe_poste = case_when(
    Pos %in% c("FW", "FW,MF", "MF,FW", "CF", "FW,DF", "LW") ~ "Attaquant",
    Pos %in% c("MF", "DF,MF", "CM", "MF,DF") ~ "Milieu",
    Pos %in% c("DF", "DF,FW", "RB", "AM") ~ "Défenseur",
    Pos == "GK" ~ "Gardien de but",
    TRUE ~ "Autre"
  ))
team_wages <- team_wages %>%
  mutate(Nation = recode(Nation, "ENG" = "UK"))

# Visualisation : Comparaison des salaires annuels des joueurs en fonction des notes et des postes
ggplot(team_wages, aes(x = Note, y = AnnualWageEUR, shape = Groupe_poste, color = Team)) +
  geom_point(size = 4, alpha = 3) +
  labs(title = "Relation entre les salaires annuels, les notes et les postes des joueurs de PL",
       x = "Note",
       y = "Salaire annuel (en euros)",
       shape = "Poste",
       color = "Equipe") +
  scale_x_continuous(breaks = seq(5, 10, by = 0.5)) +
  scale_y_continuous(labels = scales::comma) +
  scale_shape_manual(values = c(17, 19, 15, 16, 18, 3, 4)) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 20), # Centrer et agrandir le titre
    axis.title.x = element_text(size = 16), # Agrandir le titre de l'axe x
    axis.title.y = element_text(size = 16), # Agrandir le titre de l'axe y
    axis.text.x = element_text(size = 14),  # Agrandir les labels de l'axe x
    axis.text.y = element_text(size = 14),  # Agrandir les labels de l'axe y
    legend.title = element_text(face = "bold", size = 14), # Agrandir le titre de la légende
    legend.text = element_text(size = 12),   # Agrandir le texte de la légende
    legend.position = "top",
    legend.direction = "horizontal",
    legend.key.size = unit(1.5, "lines")
  )

median_wages <- team_wages %>%
  group_by(Groupe_poste) %>%
  summarise(MedianWageEUR = median(AnnualWageEUR, na.rm = TRUE))

# Créer une colonne pour les labels
median_wages$label <- paste0(median_wages$Groupe_poste, "\n", scales::comma(median_wages$MedianWageEUR))

# Créer le donut chart
ggplot(median_wages, aes(x = 2, y = MedianWageEUR, fill = Groupe_poste)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y", start = 0) +
  xlim(0.5, 2.5) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 20),
    legend.title = element_text(face = "bold", size = 14),
    legend.text = element_text(size = 12),
    legend.position = "right"
  ) +
  geom_text(aes(label = label), position = position_stack(vjust = 0.5)) +
  labs(title = "Médiane des rémunérations annuelles par groupe de poste")

median_wages_by_note <- team_wages %>%
  filter(Note >= 6 & Note < 10) %>%
  mutate(Note_tranche = case_when(
    Note >= 6 & Note < 6.5 ~ "6 - 6.5",
    Note >= 6.5 & Note < 7 ~ "6.5 - 7",
    Note >= 7 & Note < 7.5 ~ "7 - 7.5",
    Note >= 7.5 ~ ">= 7.5"
  )) %>%
  group_by(Note_tranche) %>%
  summarise(MedianWageEUR = median(AnnualWageEUR, na.rm = TRUE))

# Créer une colonne pour les labels
median_wages_by_note$label <- paste0(median_wages_by_note$Note_tranche, "\n", scales::comma(median_wages_by_note$MedianWageEUR))

# Créer le donut chart
ggplot(median_wages_by_note, aes(x = 2, y = MedianWageEUR, fill = Note_tranche)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y", start = 0) +
  xlim(0.5, 2.5) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 20),
    legend.title = element_text(face = "bold", size = 14),
    legend.text = element_text(size = 12),
    legend.position = "right"
  ) +
  geom_text(aes(label = label), position = position_stack(vjust = 0.5)) +
  labs(title = "Médiane des rémunérations annuelles par tranche de notes")































