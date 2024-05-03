data <- readRDS("big5_team_standard.rds")
data2 <- readRDS("big5_team_possession.rds")
data3 <- readRDS("big5_team_defense.rds")
data4 <- readRDS("big5_team_passing.rds")
data5 <- readRDS("big5_team_shooting.rds")
# On retire les années avant 2018 pour deux dataframes
data <- data[-(1:1568),]
data5 <- data5[-(1:1568),]
merged_df <- merge(data, data2, by = c("Season_End_Year","Squad","Comp","Team_or_Opponent","Num_Players"))
merged_df <- merge(merged_df, data3, by = c("Season_End_Year","Squad","Comp","Team_or_Opponent","Num_Players"))
merged_df <- merge(merged_df, data4, by = c("Season_End_Year","Squad","Comp","Team_or_Opponent","Num_Players"))
merged_df <- merge(merged_df, data5, by = c("Season_End_Year","Squad","Comp","Team_or_Opponent","Num_Players"))
# Supprimer les colonnes dupliquées
duplicate_columns <- duplicated(colnames(merged_df))
merged_df <- merged_df[, !duplicate_columns]
write.csv(merged_df, "merged_df.csv")
