library(worldfootballR)
library(readr)
setwd("C:/Users/Administrateur/Desktop/ProjetIF36/projet-if36-p24-fifa-street/data")

clubs_list <- list(
  "Arsenal FC",
  "Aston Villa",
  "Bournemouth",
  "Brentford",
  "Brighton & Hove Albion",
  "Burnley",
  "Chelsea",
  "Crystal Palace",
  "Everton FC",
  "Fulham",
  "Leeds United",
  "Leicester City",
  "Liverpool",
  "Manchester City",
  "Manchester United",
  "Newcastle United",
  "Norwich City",
  "Nottingham Forest",
  "Sheffield United",
  "Southampton",
  "Tottenham Hotspur",
  "Watford",
  "West Bromwich Albion",
  "West Ham United",
  "Wolverhampton Wanderers",
  "Brighton & Hove Albion"
)


players <- readr::read_csv("dataset/playerslinkALL/players.csv")
colnames(players)

players_stats_list <- list()

for (i in 1:nrow(players)) {
  player_url <- players$UrlTmarkt[i]
  stat <- tm_player_injury_history(player_url)
  if (any(!is.na(stat$club))) {
    print("carre")
    found <- FALSE
    clubs <- strsplit(stat$club, ", ")[[1]]
    for (club in clubs) {
      found <- grepl(club, clubs_list, ignore.case = TRUE)
      if (any(found)) {
        print("en PL")
        players_stats_list[[i]] <- stat
        break
      } else {
        print("zeubio jdevoisn foiu")
      }
    }
  }
}

print(players_stats_list)

players_stats_df <- do.call(rbind, players_stats_list)

readr::write_csv(players_stats_df, file = "dataset/playersInjuryPL/playersInjuryPL.csv")


