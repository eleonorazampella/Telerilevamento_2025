# PROGETTO ESAME - ANALISI DELLA VEGETAZIONE PRE E POST- INCENDIO NELLA SIERRA DE LA CULEBRA ATTRAVERSO LE IMMAGINI SATELLITARI AVVENUTO NEL 2022 
# Telerilevamento Geo-ecologico in R
# Eleonora Zampella 

# CODICE IN R PER L'ELABORAZIONE DELLE IMMAGINI 

# Le immagini sono scaricate da Google Earth Engine attraverso il codice di Rocio Beatriz Cortes Lobos e sono relative all'incendio avventuto a Sierra de la Culebra

# Pacchetti richiesti e utilizzati
library(terra) # Pacchetto per l'analisi spaziale dei dati con vettori e dati raster
library(imageRy) # Pacchetto per manipolare, visualizzare ed esportare immagini raster in R
library(viridis) # Pacchetto per cambiare le palette di colori anche per chi è affetto da colorblindness
library(ggplot2) # Pacchetto per creare grafici ggplot
library(patchwork) # Pacchetto per comporre più grafici ggplot insieme

# Imposto la working directory 
setwd("~/Desktop/TELERILEVAMENTO_R")

pre=rast("PreIncendio_Maggio2022.tif") # Importo la prima immagine
plot(pre) # Per visulaizzare l'immagine importata

post=rast("PostIncendio_Agosto2022.tif") #Importo la seconda immagine
plot(post) # Per visulizzare la seconda immagine

#Visualizzo le immagini in RGB
im.plotRGB(pre, r = 1, g = 2, b = 3, title = "Pre-incendio")
im.plotRGB(post, r = 1, g = 2, b = 3, title = "Post-incendio")


