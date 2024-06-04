#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(plotly)
library(readr)

server <- function(input, output) {
  big5_data_by_team <- read_csv("../data/dataset/big5_data_by_teams/big5_data_by_team.csv", show_col_types = FALSE)
  
  output$plot <- renderPlotly({
    df_filtered <- big5_data_by_team %>%
      filter(Season_End_Year == 2022 & Squad %in% input$equipes) %>%
      select(Squad, Team_or_Opponent, Gls, Succ_Pressures, Touches_Touches, Succ_Dribbles) %>%
      rename(Equipe = Squad, Buts = Gls, Reussite_pressing = Succ_Pressures, Touches = Touches_Touches, Dribbles_reussis = Succ_Dribbles) %>%
      group_by(Equipe) %>%
      summarise(Buts = sum(Buts), Reussite_pressing = sum(Reussite_pressing), Touches = sum(Touches), Dribbles_reussis = sum(Dribbles_reussis))
    
    # Définir l'ordre des niveaux de la variable Equipe
    df_filtered$Equipe <- factor(df_filtered$Equipe, levels = c("Manchester City", "Liverpool", "Chelsea", "Tottenham", "Arsenal", "Manchester Utd",
                                                                "West Ham", "Leicester City", "Brighton", "Wolves", "Newcastle Utd", "Crystal Palace",
                                                                "Brentford", "Aston Villa", "Southampton", "Everton", "Leeds United", "Burnley",
                                                                "Watford", "Norwich City"))
    
    # Trier les données en fonction de l'ordre de la variable Equipe
    df_filtered <- df_filtered %>% arrange(Equipe)
    
    ggplot_object <- ggplot(df_filtered, aes(x = Equipe, y = !!sym(input$statistique), fill = Equipe)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = paste("Nombre de", input$statistique, "par équipe"),
           x = "Equipe",
           y = paste("Nombre de", input$statistique)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
    
    ggplotly(ggplot_object)
  })
}

