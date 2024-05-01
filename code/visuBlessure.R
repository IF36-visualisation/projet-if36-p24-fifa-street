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