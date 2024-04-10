[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)
# Dataviz sur la Premiere League

## Introduction
Nous avons décidé d'orienter notre projet sur la Premier League, qui est la première division de football en Angleterre. La Premier League fait partie des 5 grands championnats avec la Ligue 1 (France), la Liga (Espagne), la Bundesliga (Allemagne) et la Serie A (Italie).

Nous allons utiliser une librairie qui contient une multitude de fonctions qui requièrent, en fonction des requêtes, une des 3 API des sites suivants : FBref, Transfermarkt et Understat. Le lien qui décrit la librairie et toutes ses fonctionnalités est le suivant : <https://jaseziv.github.io/worldfootballR/articles/extract-fbref-data.html>

Les sources sont tirées de FBref, Transfermarkt et Understat. FBref est un site web qui fournit des statistiques détaillées sur les joueurs et les équipes de football, y compris des données sur les passes, les tirs et les actions défensives. 

Transfermarkt est un site web qui se concentre sur les transferts de joueurs de football, les évaluations de joueurs et les rumeurs de transfert. Il fournit également des informations sur les clubs et les compétitions de football. Understat est un site web qui fournit des statistiques avancées sur les joueurs et les équipes de football, y compris des données sur les tirs, les passes et les actions défensives.

Bien que notre sujet soit le championnat anglais, nous pourrons également être amenés à le comparer aux autres championnats majeurs, afin de voir si les préjugés sur cette ligue sont fondés ou non.

Étant donné que la librairie que nous utilisons nous donne accès à un nombre gigantesque de données, nous avons décidé de n'utiliser que les données nécessaires pour répondre à nos questions de recherche. Cela nous permettra de nous concentrer sur les informations pertinentes et de ne pas être submergés par des données inutiles.

Lorsque l'on effectue des requêtes sur une API, il est fréquent d'être limité dans le nombre de requêtes que l'on peut effectuer dans un certain laps de temps. Dans ce cas, nous stockerons les données récupérées dans des fichiers CSV afin de pouvoir les réutiliser ultérieurement sans avoir à effectuer de nouvelles requêtes et de ne pas dépendre de l'API en cas de panne ou de changement dans les données fournies.

## Présentation des données 

Le jeu de données nous permet d'obtenir des informations à plusieurs échelles différentes :

#### À l'échelle des saisons :
On peut retrouver à l'échelle des saisons des données sur les équipes et les joueurs grâce à la commande `fb_big5_advanced_season_stats()`, par exemple, pour obtenir la possession des joueurs en 2021, on peut utiliser la commande `fb_big5_advanced_season_stats(season_end_year=2021,stat_type="possession",team_or_player="player")`, qui nous renverra le dataframe des joueurs avec les informations suivantes  : 
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

### À l'échelle des équipes :
On peut retrouver à l'échelle des équipes des données sur les joueurs grâce à la commande `fb_team_match_log_stats(team_urls, stat_type)` qui nous renverra le dataframe des équipes avec les informations suivantes :
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

### À l'échelle des joueurs :

## Les questions de recherche 
Voici les questions éventuelles qu'on pourrait se poser, et comment y répondre : 

### Différences entre les 5 premières équipes de chaque championnats 
### Le nombre de blessures est-il lié au nombre de match joué ou le championnat joue une plus grosse partie (stéréotype de championnat + physique que d'autres ) 
### Quel est le profile de buteur le + prolifique (avec des stats sur la taille)
### Determiner le profil de l'équipe parfaite (possession par exemple ) 
### la valeur marchande pour chaque poste est corrélé à quoi ? 
### différences entre championnats et coupes 
