[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)
# Dataviz sur la Premiere League

## Introduction
Nous avons décidé d'orienter notre projet sur la Premier League, qui est la première division de football en Angleterre. La Premier League fait partie des 5 grands championnats avec la Ligue 1 (France), la Liga (Espagne), la Bundesliga (Allemagne) et la Serie A (Italie).

Nous allons utiliser une librairie qui contient une multitude de fonctions qui requièrent, en fonction des requêtes, une des 3 API des sites suivants : FBref, Transfermarkt et Understat. Le lien qui décrit la librairie et toutes ses fonctionnalités est le suivant : <https://jaseziv.github.io/worldfootballR/articles/extract-fbref-data.html>

Les sources sont tirées de FBref, Transfermarkt et Understat.

<b>FBref</b> est un site web qui fournit des statistiques détaillées sur les joueurs et les équipes de football, y compris des données sur les passes, les tirs et les actions défensives. 

<b>Transfermarkt</b> est un site web qui se concentre sur les transferts de joueurs de football, les évaluations de joueurs et les rumeurs de transfert. Il fournit également des informations sur les clubs et les compétitions de football. 

<b>Understat</b> est un site web qui fournit des statistiques avancées sur les joueurs et les équipes de football, y compris des données sur les tirs, les passes et les actions défensives.

Bien que notre sujet soit le championnat anglais, nous pourrons également être amenés à le comparer aux autres championnats majeurs, afin de voir si les préjugés sur cette ligue sont fondés ou non.

Étant donné que la librairie que nous utilisons nous donne accès à un nombre gigantesque de données, nous avons décidé de n'utiliser que les données nécessaires pour répondre à nos questions de recherche. Cela nous permettra de nous concentrer sur les informations pertinentes et de ne pas être submergés par des données inutiles.

Lorsque l'on effectue des requêtes sur une API, il est fréquent d'être limité dans le nombre de requêtes que l'on peut effectuer dans un certain laps de temps. Dans ce cas, nous stockerons les données récupérées dans des fichiers CSV afin de pouvoir les réutiliser ultérieurement sans avoir à effectuer de nouvelles requêtes et de ne pas dépendre de l'API en cas de panne ou de changement dans les données fournies.

## Présentation des données 

Le jeu de données nous permet d'obtenir des informations à plusieurs échelles  :

#### À l'échelle des saisons 
On peut retrouver à l'échelle des saisons des données sur les équipes et les joueurs grâce à la méthode `fb_big5_advanced_season_stats()`, par exemple, pour obtenir la possession des joueurs en 2021, on peut utiliser la commande `fb_big5_advanced_season_stats(season_end_year=2021,stat_type="possession",team_or_player="player")`, qui nous renverra le dataframe des joueurs avec les informations suivantes  : 
- `Squad` : le nom de l'équipe du joueur, donnée nominale
  
- `Player` : le nom du joueur, donnée nominale
  
- `Nation` : la nationalité du joueur, donnée nominale
  
- `Pos` : le poste du joueur, donnée nominale
  
- `Age` : l'âge du joueur, donnée quantitative
  
- `Born` : la date de naissance du joueur, donnnée nominale
  
- `Mins_per90` : le nombre de minutes jouées par match, donnée quantitative
  
- `Touches_Touches` : le nombre de touches de balle par match, donnée quantitative
  
- `Touches_Def_Pen` : le nombre de touches de balle dans la surface de réparation adverse par match, donnée quantitative
  
- `Succ_percent_Take`: le pourcentage de réussite des dribbles par match, donnée quantitative
  
Cette liste n'est pas exhaustive, car il y a en réalité 32 colonnes dans le dataframe, mais cela donne une idée des informations que l'on peut obtenir et surtout de ce que nous allons avoir besoin pour répondre à nos questions.

#### À l'échelle des équipes 
On peut retrouver à l'échelle des équipes diverses données grâce à la méthode `fb_team_match_log_stats(team_urls, stat_type)` qui nous renverra le dataframe des équipes avec les informations suivantes :
- `Team` : le nom de l'équipe, donnée nominale
   
- `Date` : la date du match, donnée nominale
  
- `Time` : l'heure du match, donnée nominale

- `Comp` : la compétition, donnée nominale
  
- `Round` : le tour de la compétition, donnée nominale
  
- `Day` : le jour du match, donnée nominale
  
- `Venue` : le lieu du match, donnée nominale
  
- `Result` : le résultat du match, donnée nominale
  
- `Opponent` : l'équipe adverse, donnée nominale

Le reste des données dépend du `stat_type` que l'on choisit, par exemple, si on choisit `stat_type="passing"`, ou `stat_type="defense"`, on aura des informations sur les passes ou la défense de l'équipe, respectivement.

#### À l'échelle des joueurs 
Enfin, on peut retrouver à l'échelle des joueurs diverses données grâce à la méthode `fb_player_season_stats(player_url, stat_type)` qui nous renverra le dataframe des joueurs avec les informations suivantes :

- `player_name` : le nom du joueur, donnée nominale

- `Season` : la saison, de forme AN01-AN02, donnée nominale

- `Age` : l'âge du joueur, donnée quantitative

- `Squad` : le nom de l'équipe du joueur, donnée nominale

- `Country` : le pays du joueur, donnée nominale

- `Comp` : la compétition, donnée nominale

- `MP` : le nombre de matchs joués, donnée quantitative

- `Starts_Time`: le nombre de matchs joués en tant que titulaire, donnée quantitative

- `Gls` : le nombre de buts marqués, donnée quantitative

On peut rajouter une deuxième méthode `tm_player_bio()` qui retourne des informations supplémentaires.
- `player_name` : Nom du joueur, donnée nominale
  
- `date_of_birth` : Date de naissance, donnée nominale
  
- `place_of_birth` : Lieu de naissance, donnée nominale
  
- `height` : Taille, donnée quantitative
  
- `nationality` : Nationalité, donnée nominale
  
- `position` : Poste, donnée nominale
  
- `strong_foot` : Pied fort, donnée nominale
  
- `current_club` : Club actuel, donnée nominale
  
- `joined` : Date d`arrivée dans le club actuel, donnée nominale
  
- `contract_expires` : Date d`expiration du contrat, donnée nominale
  
- `date_of_last_contract_extension` : Date de la dernière extension de contrat, donnée nominale

- `player_valuation` : Valeur marchande du joueur, donnée nominale
  
- `max_player_valuation` : Valeur marchande maximale du joueur, donnée quantitative
  
- `max_player_valuation_date` : Date de la valeur marchande maximale du joueur, donnée quantitative
  
- `URL` : URL du joueur, donnée nominale




<span style="color:red;">⚠️ Warning: On pourrait être amené à puiser des informations sur d'autres méthodes.</span>

#### Blessure 
On aura l'historique des joueurs grâce à `tm_player_injury_history()`, qui retourne différentes informations :
- `player_url` : l'URL du joueur, donnée nominale
  
- `season_injured` : la saison de blessure du joueur, donnée nominale
  
- `injury` : le type de blessure du joueur, donnée nominale
  
- `injured_since` : la date de début de la blessure du joueur, donnée temporelle
  
- `injured_until` : la date de fin de la blessure du joueur, donnée temporelle
  
- `duration` : la durée de la blessure du joueur, donnée nominale
  
- `games_missed` : le nombre de matchs manqués par le joueur en raison de la blessure, donnée nominale
  
- `club` : le club du joueur, donnée nominale



Une fois de plus, cette liste n'est pas exhaustive, mais cela donne une idée des informations que l'on peut obtenir et surtout de ce que nous allons avoir besoin pour répondre à nos questions.

## Les questions que nous pouvons nous poser 

Nous allons à présent vous présenter les différentes questions que nous nous sommes posées sur le championnat. Pour chacune de ces questions, nous allons vous expliquer comment nous allons y répondre et quelles données nous allons utiliser pour cela. 

#### <ins>Quelles sont les différences entre les 5 premières équipes de chaque championnats ? (traité par Ewen)

Pour répondre à cette question, nous allons nous concentrer sur les 5 premières équipes de chaque championnat pour voir s'il y a des différences significatives entre elles. Nous allons nous intéresser à des statistiques comme la possession de balle (obtenu avec le `stat_type="possession"`), le nombre de passes réussies (avec `stat_type="passing"`),puis  le nombre de tirs et le nombre de buts marqués (`stat_type="attack"`).

Pour représenter et mettre en relation les données, nous allons utiliser plusieurs graphiques en barres pour comparer les différentes équipes entre elles sur les différentes statistiques. Nous pourrons également utiliser des graphiques en nuages de points pour voir s'il y a une corrélation entre certaines statistiques. Cela nous permettra d'observer quelles statistiques sont les plus importantes pour se démarquer des autres équipes, et si ces statistiques sont inchangées d'un championnat à l'autre.

#### <ins>Le nombre de blessures est-il lié au nombre de match joué ou le championnat joue une plus grosse partie (stéréotype de championnat + physique que d'autres ) (traité par Ahmed)
Pour répondre à cette question, nous utiliserons deux requêtes. La première nous donnera le nombre de matchs joués, éventuellement accompagné d'un calcul du temps de jeu. Pour des raisons de clarté et de compréhension, nous sélectionnerons probablement les 100 joueurs les plus blessés en utilisant la méthode 'tm_player_injury_history()' et en filtrant sur la somme de la différence entre injured_until et injured_since.

#### <ins>Quel est le profil de buteur le plus prolifique (avec des statistiques sur la taille) ?
Nous examinerons les meilleurs buteurs des championnats et leurs caractéristiques (physiques, temps de jeu, blessures, etc.) pour trouver la meilleure corrélation. Nous pourrons également créer une carte thermique (heatmap) avec PowerBI (ou avec R) sur les origines de ces joueurs en utilisant la méthode `tm_player_bio()`.

#### <ins>Déterminer le profil de l'équipe parfaite (possession par exemple) (traité par Nassim)
Nous analyserons les statistiques des meilleures équipes et les comparerons à celles des équipes moins performantes pour déterminer les caractéristiques d'une équipe parfaite, telles que la possession de balle,nombre de buts moyens encaissés... On utilisera `fb_team_match_log_stats()` pour recuperer tout les matchs et faire des moyennes sur leurs matchs . 

#### <ins>Quelle est la corrélation entre la valeur marchande des joueurs et leurs postes ? (traité par Amine)
Nous étudierons la corrélation entre la valeur marchande des joueurs et différents critères spécifiques à leur poste. Par exemple, nous examinerons le nombre de buts pour les attaquants et le nombre d'interceptions pour les défenseurs parmi les joueurs les plus chers. Pour ce faire, nous utiliserons la méthode mentionnée précédemment dans la section "À l'échelle des joueurs".

#### <ins>Quelles sont les différences entre les championnats et les coupes ? (traité par Nassim)
Il existe plusieurs différences entre les championnats et les coupes. Nous pourrions les distinguer en examinant différents aspects tels que le nombre moyen de buts marqués par match ou les performances moyennes des joueurs en coupe par rapport au championnat.
Par exemple, en utilisant la méthode `fb_player_scouting_report()`, nous pouvons spécifier le championnat comme paramètre et obtenir des retours standard pour analyser ces différences.
