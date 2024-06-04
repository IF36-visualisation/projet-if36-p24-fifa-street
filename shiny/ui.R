library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = "Premier League Stats"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visualisation", tabName = "visu", icon = icon("line-chart")),
      checkboxGroupInput("equipes", "Équipes :",
                         c("Manchester City", "Liverpool", "Chelsea", "Tottenham", "Arsenal", "Manchester Utd",
                           "West Ham", "Leicester City", "Brighton", "Wolves", "Newcastle Utd", "Crystal Palace",
                           "Brentford", "Aston Villa", "Southampton", "Everton", "Leeds United", "Burnley",
                           "Watford", "Norwich City"),
                         selected = c("Manchester City", "Liverpool", "Chelsea", "Tottenham", "Arsenal", "Manchester Utd")),
      selectInput("statistique", "Statistique :",
                  choices = c("Buts", "Reussite_pressing", "Touches", "Dribbles_reussis"),
                  selected = "Reussite_pressing")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "visu",
              fluidRow(
                box(plotlyOutput("plot", height = 600))
              )
      )
    )
  )
)
  
