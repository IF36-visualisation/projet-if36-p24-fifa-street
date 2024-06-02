# Vérifier si les packages "wordcloud" et "tm" sont installés
if (!require("wordcloud")) {
  install.packages("wordcloud")
  library("wordcloud")
}

if (!require("tm")) {
  install.packages("tm")
  library("tm")
}

#!!! IL FAUT METTRE LE CHEMIN ABSOLUT DU DOSSIER DATA
setwd("C:/Users/Administrateur/Desktop/ProjetIF36/projet-if36-p24-fifa-street/data")

#install.packages("tm")
library(wordcloud)
library(tm)

# Lire le fichier CSV et extraire la colonne 'injury'
players <- read.csv("dataset/playersInjuryPL/playersInjuryPL.csv")
injuries <- players$injury

# Nettoyer le texte en supprimant les ponctuations, les chiffres et les mots vides
corpus <- Corpus(VectorSource(injuries))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

corpus <- tm_map(corpus, removeWords, c("injury"))
corpus <- tm_map(corpus, removeWords, c("problems"))
corpus <- tm_map(corpus, removeWords, c("problem"))
corpus <- tm_map(corpus, removeWords, c("unknown"))

# Créer une matrice de termes-documents à partir du texte nettoyé
tdm <- TermDocumentMatrix(corpus)

# Convertir la matrice de termes-documents en matrice de fréquences
freq <- rowSums(as.matrix(tdm))

# Créer le nuage de mots à partir de la matrice de fréquences
# Définir la palette de couleurs
n_colors <- 100
palette <- colorRampPalette(c("blue", "red"))(n_colors)

# Créer le nuage de mots
wordcloud(names(freq), freq, min.freq = 1, max.words = 200, random.order = FALSE, colors = palette)
title("Blessures joueurs Premier League")



# Trier les fréquences par ordre décroissant
freq_sorted <- sort(freq, decreasing = TRUE)

# Sélectionner les 5 blessures les plus fréquentes
top_5_injuries <- head(names(freq_sorted), 5)
top_5_freq <- head(freq_sorted, 5)

# Calculer les fréquences en pourcentages
total_freq <- sum(freq)
top_5_percent <- (top_5_freq / total_freq) * 100

# Créer une palette de couleurs allant du gris au rouge
colors <- colorRampPalette(c("gray", "red"))(25)

# Créer le graphique à barres horizontal avec les couleurs en fonction des pourcentages
barplot(top_5_percent, names.arg = top_5_injuries, main = "Top 5 des blessures en Premier League (en %)", xlab = "Fréquence (en %)", ylab = "Blessures", col = colors[top_5_percent], horiz = TRUE, xlim = c(0, 12), cex.names = 1, cex.axis = 1)
top_5_percent<-round(top_5_percent,1)

# Ajouter les valeurs précises des pourcentages à l'intérieur des barres
text(x = top_5_percent - 0.3, y = 1:5, labels = top_5_percent, cex = 0.8, pos = 3, srt = 0, font = 2)

