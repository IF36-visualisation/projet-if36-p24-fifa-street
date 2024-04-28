# Charger les packages nécessaires
# Installer le package 'wordcloud'
#install.packages("wordcloud")

# Installer le package 'tm'
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

# Créer une matrice de termes-documents à partir du texte nettoyé
tdm <- TermDocumentMatrix(corpus)

# Convertir la matrice de termes-documents en matrice de fréquences
freq <- rowSums(as.matrix(tdm))

# Créer le nuage de mots à partir de la matrice de fréquences
wordcloud(names(freq), freq, min.freq = 1, max.words = 200, random.order = FALSE, colors = brewer.pal(8, "Dark2"))



install.packages("igraph")
# Charger le package igraph
# Charger le package igraph
library(igraph)

# Lire le fichier CSV et extraire la colonne 'injury'
players <- read.csv("dataset/playersInjuryPL/playersInjuryPL.csv")
injuries <- players$injury

# Nettoyer le texte en supprimant les ponctuations, les chiffres et les mots vides
corpus <- Corpus(VectorSource(injuries))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Créer une matrice de co-occurrence des mots
tdm <- TermDocumentMatrix(corpus)
m <- as.matrix(tdm)
co_occurrence <- crossprod(m)

# Créer un graph à partir de la matrice de co-occurrence
g <- graph_from_adjacency_matrix(co_occurrence, weighted = TRUE, mode = "undirected")

# Supprimer les arêtes avec un poids inférieur à un seuil donné
g <- delete.edges(g, E(g)[weight < 3])

# Définir les marges du graphique
par(mar = c(0, 0, 0, 0))

# Dessiner le graph centré sur la page
plot(g, vertex.label.cex = 0.8, vertex.label.color = "black", edge.width = E(g)$weight, edge.arrow.size = 0.5, layout = layout_with_fr(g))
