library(rvest)
library(dplyr)
library(ggplot2)
library(tidyr)

# Fonction pour extraire les tables HTML et renommer les colonnes
extract_fbref_data <- function(url, table_number) {
  page <- read_html(url)
  tables <- page %>% html_table(fill = TRUE)
  data <- tables[[table_number]]
  colnames(data) <- data[1, ]  # Utilisation de la première ligne comme noms de colonnes
  data <- data[-1, ]  # Suppression de la première ligne des données
  return(data)
}

# Extraction des données de la FA Cup
fa_cup_standard <- extract_fbref_data("https://fbref.com/en/comps/514/2022-2023/stats/2022-2023-FA-Cup-Stats", 1)
fa_cup_shooting <- extract_fbref_data("https://fbref.com/en/comps/514/2022-2023/shooting/2022-2023-FA-Cup-Stats", 1)
fa_cup_goalkeeping <- extract_fbref_data("https://fbref.com/en/comps/514/2022-2023/keepers/2022-2023-FA-Cup-Stats", 1)

# Extraction des données de la Premier League
pl_standard <- extract_fbref_data("https://fbref.com/en/comps/9/2022-2023/stats/2022-2023-Premier-League-Stats", 1)
pl_shooting <- extract_fbref_data("https://fbref.com/en/comps/9/2022-2023/shooting/2022-2023-Premier-League-Stats", 1)
pl_goalkeeping <- extract_fbref_data("https://fbref.com/en/comps/9/2022-2023/keepers/2022-2023-Premier-League-Stats", 1)

# Vérification des noms de colonnes après remplacement
colnames(fa_cup_standard)
colnames(pl_standard)

# Sélection des équipes d'intérêt
teams <- c("Arsenal", "Aston Villa", "Bournemouth", "Brentford", "Brighton", "Chelsea", 
           "Crystal Palace", "Everton", "Fulham", "Leeds United", "Leicester City", 
           "Liverpool", "Manchester City", "Manchester Utd", "Newcastle Utd", 
           "Nott'ham Forest", "Southampton", "Tottenham", "West Ham", "Wolves")

# Identifier les colonnes en double
dup_cols <- which(duplicated(names(fa_cup_standard)))

# Renommer les colonnes en double
names(fa_cup_standard)[dup_cols] <- paste0(names(fa_cup_standard)[dup_cols], ".2")

# Filtrer les données pour les équipes d'intérêt
fa_cup_data <- fa_cup_standard %>%
  filter(Squad %in% teams)

# Identifier les colonnes en double
dup_cols_pl <- which(duplicated(names(pl_standard)))

# Renommer les colonnes en double
names(pl_standard)[dup_cols_pl] <- paste0(names(pl_standard)[dup_cols_pl], ".2")

# Filtrer les données pour les équipes d'intérêt
pl_data <- pl_standard %>%
  filter(Squad %in% teams)


# Ajouter une colonne pour indiquer la compétition
fa_cup_data <- fa_cup_data %>%
  mutate(Competition = "FA Cup")

pl_data <- pl_data %>%
  mutate(Competition = "Premier League")

# Combiner les deux datasets
combined_data <- bind_rows(fa_cup_data, pl_data)

# Supprimer les colonnes spécifiées
combined_data <- combined_data %>%
  select(-c("xG", "xAG", "xG+xAG", "npxG", "npxG+xAG"))

# Convertir la colonne "Gls" en format numérique
combined_data$Gls <- as.numeric(combined_data$Gls)

# Calculer le nombre moyen de buts par match pour la FA Cup
avg_goals_facup <- combined_data %>%
  filter(Competition == "FA Cup") %>%
  summarise(avg_goals = sum(Gls) / sum(as.numeric(MP)))

# Calculer le nombre moyen de buts par match pour la Premier League
avg_goals_pl <- combined_data %>%
  filter(Competition == "Premier League") %>%
  summarise(avg_goals = sum(Gls) / sum(as.numeric(MP)))

# Créer un nouveau dataframe pour les moyennes
avg_goals <- rbind(avg_goals_facup, avg_goals_pl)

# Créer une nouvelle colonne pour stocker les noms de compétition
avg_goals$Competition <- rownames(avg_goals)

# Renommer les niveaux de la variable Competition
avg_goals$Competition <- factor(avg_goals$Competition, levels = c("1", "2"), labels = c("FA Cup", "Premier League"))

# Visualisation : Nombre moyen de buts par match selon la compétition
ggplot(avg_goals, aes(x = Competition, y = avg_goals, fill = Competition)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(avg_goals, 2), " buts/match")), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Nombre moyen de buts par match selon la compétition",
       x = "Compétition", y = "Nombre moyen de buts par match") +
  scale_fill_manual(values = c("FA Cup" = "blue", "Premier League" = "red")) +
  theme_minimal()

# Identifier les colonnes en double dans les données de goalkeeping de la FA Cup
dup_cols_fa_cup <- which(duplicated(names(fa_cup_goalkeeping)))

# Renommer les colonnes en double dans les données de goalkeeping de la FA Cup
names(fa_cup_goalkeeping)[dup_cols_fa_cup] <- paste0(names(fa_cup_goalkeeping)[dup_cols_fa_cup], ".fa_cup")

# Identifier les colonnes en double dans les données de goalkeeping de la Premier League
dup_cols_pl <- which(duplicated(names(pl_goalkeeping)))

# Renommer les colonnes en double dans les données de goalkeeping de la Premier League
names(pl_goalkeeping)[dup_cols_pl] <- paste0(names(pl_goalkeeping)[dup_cols_pl], ".pl")

# Fusionner les données de goalkeeping en tenant compte des noms de colonnes renommés
combined_data_goalkeeping_teams <- bind_rows(
  filter(fa_cup_goalkeeping, Squad %in% teams),
  filter(pl_goalkeeping, Squad %in% teams)
)
# Ajouter une colonne Competition aux données combined_data_goalkeeping_teams
combined_data_goalkeeping_teams <- combined_data_goalkeeping_teams %>%
  mutate(Competition = if_else(Squad %in% teams[1:length(teams) / 2], "FA Cup", "Premier League"))

# Renommer la colonne %Save en Arret
combined_data_goalkeeping_teams <- combined_data_goalkeeping_teams %>%
  rename(Arret = 'Save%' )


# Conversion de la colonne Arret en type numérique
combined_data_goalkeeping_teams <- combined_data_goalkeeping_teams %>%
  mutate(Arret = as.numeric(Arret))

# Calcul des moyennes des sauvegardes pour chaque compétition
avg_saves <- combined_data_goalkeeping_teams %>%
  group_by(Competition) %>%
  summarise(avg_save_percentage = sum(Arret, na.rm = TRUE) / n())



# Renommer les niveaux de la variable Competition
avg_saves$Competition <- factor(avg_saves$Competition, levels = c("FA Cup", "Premier League"))

# Visualisation : Comparaison des moyennes des pourcentages d'arrêts de tirs entre la FA Cup et la Premier League
ggplot(avg_saves, aes(x = Competition, y = avg_save_percentage, fill = Competition)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(avg_save_percentage, 2), " %")), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Comparaison des moyennes des pourcentages d'arrêts de tirs entre la FA Cup et la Premier League",
       x = "Compétition", y = "Moyenne des pourcentages de saves") +
  scale_fill_manual(values = c("FA Cup" = "blue", "Premier League" = "red")) +
  theme_minimal()

# Conversion de la colonne CS% en type numérique
combined_data_goalkeeping_teams <- combined_data_goalkeeping_teams %>%
  mutate(`CS%` = as.numeric(`CS%`))

# Calcul des moyennes des pourcentages de cleans sheet pour chaque compétition
avg_cleansheet <- combined_data_goalkeeping_teams %>%
  group_by(Competition) %>%
  summarise(avg_cleansheet_percentage = sum(`CS%`, na.rm = TRUE) / n())


ggplot(avg_cleansheet, aes(x = Competition, y = avg_cleansheet_percentage, fill = Competition)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(avg_cleansheet_percentage, 2), " %")), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Comparaison des moyennes des pourcentages de cleans sheet entre la FA Cup et la Premier League",
       x = "Compétition", y = "Moyenne des pourcentages de cleans sheet") +
  scale_fill_manual(values = c("FA Cup" = "blue", "Premier League" = "red")) +
  theme_minimal()


# Convertir les colonnes Gls et MP en format numérique
combined_data <- combined_data %>%
  mutate(Gls = as.numeric(Gls),
         MP = as.numeric(MP))

# Filtrer les données pour Arsenal et Wolves
teams_of_interest <- combined_data %>%
  filter(Squad %in% c("Manchester City", "Southampton", "Fulham"))

# Remplacer les valeurs NA par 0 pour éviter les erreurs lors des calculs
teams_of_interest <- teams_of_interest %>%
  mutate(Gls = ifelse(is.na(Gls), 0, Gls),
         MP = ifelse(is.na(MP), 1, MP))  # Remplacer les valeurs NA par 1 pour éviter la division par zéro

# Visualisation : Nombre moyen de buts par match pour Arsenal et Wolves
ggplot(teams_of_interest, aes(x = Competition, y = Gls / MP, fill = Squad)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(Gls / MP, 2), " buts/match")), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Nombre moyen de buts par match pour Arsenal et Wolves selon la compétition",
       x = "Compétition", y = "Nombre moyen de buts par match") +
  scale_fill_manual(values = c("Manchester City" = "skyblue", "Southampton" = "red", "Fulham" = "black")) +
  theme_minimal()


# Filtrer les données de goalkeeping pour Manchester City, Southampton et Fulham
goalkeeping_teams_of_interest <- combined_data_goalkeeping_teams %>%
  filter(Squad %in% c("Manchester City", "Southampton", "Fulham"))

# Mettre à jour les valeurs de la colonne Competition
goalkeeping_teams_of_interest[2, "Competition"] <- "FA Cup"
goalkeeping_teams_of_interest[3, "Competition"] <- "FA Cup"
goalkeeping_teams_of_interest[4, "Competition"] <- "Premier League"

# Visualisation : Pourcentage d'arrêts pour Manchester City, Southampton et Fulham
ggplot(goalkeeping_teams_of_interest, aes(x = Competition, y = Arret, fill = Squad)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(Arret, 2), " %")), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Pourcentage d'arrêts pour Manchester City, Southampton et Fulham selon la compétition",
       x = "Compétition", y = "Pourcentage d'arrêts") +
  scale_fill_manual(values = c("Manchester City" = "skyblue", "Southampton" = "red", "Fulham" = "black")) +
  theme_minimal()

# Filtrer les données de tir pour les équipes d'intérêt
fa_cup_shooting <- fa_cup_shooting %>%
  filter(Squad %in% teams)

pl_shooting <- pl_shooting %>%
  filter(Squad %in% teams)

# Ajouter une colonne pour indiquer la compétition
fa_cup_shooting <- fa_cup_shooting %>%
  mutate(Competition = "FA Cup")

pl_shooting <- pl_shooting %>%
  mutate(Competition = "Premier League")

# Combiner les deux datasets
combined_shooting <- bind_rows(fa_cup_shooting, pl_shooting)

# Convertir les colonnes Sh/90, SoT/90 et Gls en format numérique
combined_shooting <- combined_shooting %>%
  mutate(`Sh/90` = as.numeric(`Sh/90`),
         `SoT/90` = as.numeric(`SoT/90`),
         `G/Sh` = as.numeric(`G/Sh`))

avg_shooting <- combined_shooting %>%
  group_by(Competition) %>%
  summarise(`Sh/90` = mean(`Sh/90`, na.rm = TRUE),
            `SoT/90` = mean(`SoT/90`, na.rm = TRUE),
            `G/Sh` = mean(`G/Sh`, na.rm = TRUE))
# Visualisation pour les 20 équipes
# Sh/90
ggplot(avg_shooting, aes(x = Competition, y = `Sh/90`, fill = Competition)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Nombre de tirs par match selon la compétition",
       x = "Compétition", y = "Nombre de tirs par match") +
  scale_fill_manual(values = c("FA Cup" = "blue", "Premier League" = "red")) +
  theme_minimal()

# SoT/90
ggplot(avg_shooting, aes(x = Competition, y = `SoT/90`, fill = Competition)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Nombre de tirs cadrés par match selon la compétition",
       x = "Compétition", y = "Nombre de tirs cadrés par match") +
  scale_fill_manual(values = c("FA Cup" = "blue", "Premier League" = "red")) +
  theme_minimal()

# G/Sh
ggplot(avg_shooting, aes(x = Competition, y = `G/Sh`, fill = Competition)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Ratio buts/tirs selon la compétition",
       x = "Compétition", y = "Ratio buts/tirs") +
  scale_fill_manual(values = c("FA Cup" = "blue", "Premier League" = "red")) +
  theme_minimal()

# Filtrer les données pour Manchester City, Southampton, et Fulham
shooting_teams_of_interest <- combined_shooting %>%
  filter(Squad %in% c("Manchester City", "Southampton", "Fulham"))

# Visualisation pour les trois équipes spécifiques
# Sh/90
ggplot(shooting_teams_of_interest, aes(x = Competition, y = `Sh/90`, fill = Squad)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = round(`Sh/90`, 2)), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Nombre de tirs par match pour Manchester City, Southampton et Fulham selon la compétition",
       x = "Compétition", y = "Nombre de tirs par match") +
  scale_fill_manual(values = c("Manchester City" = "skyblue", "Southampton" = "red", "Fulham" = "black")) +
  theme_minimal()

# SoT/90
ggplot(shooting_teams_of_interest, aes(x = Competition, y = `SoT/90`, fill = Squad)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = round(`SoT/90`, 2)), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Nombre de tirs cadrés par match pour Manchester City, Southampton et Fulham selon la compétition",
       x = "Compétition", y = "Nombre de tirs cadrés par match") +
  scale_fill_manual(values = c("Manchester City" = "skyblue", "Southampton" = "red", "Fulham" = "black")) +
  theme_minimal()

# G/Sh
ggplot(shooting_teams_of_interest, aes(x = Competition, y = `G/Sh`, fill = Squad)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = round(`G/Sh`, 2)), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Ratio buts/tirs pour Manchester City, Southampton et Fulham selon la compétition",
       x = "Compétition", y = "Ratio buts/tirs") +
  scale_fill_manual(values = c("Manchester City" = "skyblue", "Southampton" = "red", "Fulham" = "black")) +
  theme_minimal()


                               
