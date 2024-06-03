if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
library(worldfootballR)
library(readr)



#----- or for multiple teams: -----#
team_urls <- tm_league_team_urls(country_name = "England", start_year = 2020)
print(team_urls)
epl_xfers_2020 <- tm_team_transfers(team_url = team_urls, transfer_window = "all")
print(epl_xfers_2020)








print(colnames(epl_xfers_2020))



epl_xfers_2020_subset <- subset(epl_xfers_2020, select = c("team_name", "league", "country", "player_age", "player_nationality"))

readr::write_csv(epl_xfers_2020_subset, file = "PlayerCountry.csv")
