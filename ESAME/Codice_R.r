# PROGETTO ESAME - ANALISI DELLA VEGETAZIONE PRE E POST INCENDIO NELLA SIERRA DE LA CULEBRA AVVENUTO NEL 2022 
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
im.multiframe(1,2)
im.plotRGB(pre, r = 1, g = 2, b = 3, title = "Pre-incendio")
im.plotRGB(post, r = 1, g = 2, b = 3, title = "Post-incendio")
dev.off()

# Visualizzo le quattro bande separate (RGB e NIR) per entrambe le immagini
im.multiframe(1,2)
plot(pre, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100))
plot(post, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100))
dev.off() # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

im.multiframe(2,4) #apro un pannello multiframe, ancora vuoto, di n°2 righe e n°4 colonne
plot(pre[[1]], col = magma(100), main = "Pre - Red") #viene specificata la banda, il colore e il titolo
plot(pre[[2]], col = magma(100), main = "Pre - Green")
plot(pre[[3]], col = magma(100), main = "Pre - Blue")
plot(pre[[4]], col = magma(100), main = "Pre - NIR")

plot(post[[1]], col = magma(100), main = "Post - Red")
plot(post[[2]], col = magma(100), main = "Post - Green")
plot(post[[3]], col = magma(100), main = "Post - Blue")
plot(post[[4]], col = magma(100), main = "Post - NIR")
dev.off()




