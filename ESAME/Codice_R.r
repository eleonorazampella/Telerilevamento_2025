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

pre=rast("PreIncendio_Maggio2022.tif") # Importo la prima immagine e la nomino
plot(pre) # Per visulaizzare l'immagine importata

post=rast("PostIncendio_Agosto2022.tif") #Importo la seconda immagine e la nomino 
plot(post) # Per visulizzare la seconda immagine

#Visualizzo le immagini in RGB
im.multiframe(1,2) # Visualizzare un pannello grafico con 1 riga e 2 colonne 
im.plotRGB(pre, r = 1, g = 2, b = 3, title = "Pre-incendio")  # Visualizzare l'immagine a veri colori 
im.plotRGB(post, r = 1, g = 2, b = 3, title = "Post-incendio") # Visualizzare l'immagine a veri colori 
dev.off() # Chiudere il pannello di Visualizzazione delle immagini

# Visualizzo le quattro bande separate (RGB e NIR) per entrambe le immagini
im.multiframe(1,2) # Visualizzare un pannello grafico con 1 riga e 2 colonne 
plot(pre, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100)) 
plot(post, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100))
dev.off() # Chiudo il pannello grafico dopo aver salvato l'immagine in .png

im.multiframe(2,4) # Visualizzare un pannello grafico con 2 righe e 4 colonne
plot(pre[[1]], col = magma(100), main = "Pre - Red") #viene specificata la banda, il colore e il titolo
plot(pre[[2]], col = magma(100), main = "Pre - Green")
plot(pre[[3]], col = magma(100), main = "Pre - Blue")
plot(pre[[4]], col = magma(100), main = "Pre - NIR")

plot(post[[1]], col = magma(100), main = "Post - Red")
plot(post[[2]], col = magma(100), main = "Post - Green")
plot(post[[3]], col = magma(100), main = "Post - Blue")
plot(post[[4]], col = magma(100), main = "Post - NIR")
dev.off() # Chiudere il pannello di visualizzazione delle immagini

# Calcolo degli indici

# Indice NBR (Normalized Burn Ratio)
# L'indice sfrutta la banda NIR (B8) e la banda SWIR2 (B12)
# L'indice serve a visualizzare le aree bruciate: valori più bassi indicano vegetazione compromessa
nbr_pre=(pre[["B8"]] - pre[["B12"]]) / (pre[["B8"]] + pre[["B12"]]) # Calcolo NBR pre-incendio
nbr_post=(post[["B8"]] - post[["B12"]]) / (post[["B8"]] + post[["B12"]]) # Calcolo NBR post-incendio
dnbr=nbr_pre - nbr_post # Differenza NBR (dNBR)

im.multiframe(1,3)  #  Visualizzare un pannello grafico con 1 righe e 3 colonne
plot(nbr_pre, main="NBR Pre", col=viridis::viridis(100)) # Visualizzazione NBR pre-incendio
plot(nbr_post, main="NBR Post", col=viridis::viridis(100)) # Visualizzazione NBR post-incendio
plot(dnbr, main="dNBR", col=viridis::inferno(100)) # Visualizzazione della differenza NBR-Evidenzia l'impatto dell'incendio: valori positivi indicano perdita di vegetazione
dev.off()  # Chiudere il pannello di visualizzazione delle immagini

# Indice DVI ((Difference Vegetation Index))
# NIR - RED
# Misura la quantità assoluta di vegetazione senza normalizzazione
dvi_pre=pre[["B8"]] - pre[["B4"]] # Calcolo DVI pre-incendio
dvi_post=post[["B8"]] - post[["B4"]] # Calcolo DVI post-incendio
ddvi=dvi_pre - dvi_post # Differenza DVI

im.multiframe(1,3)
plot(dvi_pre, main="DVI Pre", col=viridis::viridis(100)) # Visualizzazione DVI pre-incendio 
plot(dvi_post, main="DVI Post", col=viridis::viridis(100)) # Visualizzazione DVI post-incendio 
plot(ddvi, main="ΔDVI", col=viridis::inferno(100)) # Visualizzazione della differenza DVI pre e post incendio 
dev.off()

# Indice NDVI (Normalized Difference Vegetation Index)
# (NIR - RED) / (NIR + RED)
# Misura la salute della vegetazione: valori vicini a 1 indicano vegetazione sana
ndvi_pre=(pre[["B8"]] - pre[["B4"]]) / (pre[["B8"]] + pre[["B4"]]) # Calcolo NDVI pre-incendio 
ndvi_post=(post[["B8"]] - post[["B4"]]) / (post[["B8"]] + post[["B4"]]) # Calcolo NDVI post-incendio 
dndvi=ndvi_pre - ndvi_post #differeza NDVI

im.multiframe(1,3)  #  Visualizzare un pannello grafico con 1 righe e 3 colonne
plot(ndvi_pre, main="NDVI Pre", col=viridis::viridis(100))   #  Visualizzazione NDVI prima dell'incendio
plot(ndvi_post, main="NDVI Post", col=viridis::viridis(100)) # Visualizzazione NDVI dopo l'incendio
plot(dndvi, main="ΔNDVI", col=viridis::inferno(100))        # Visualizzazione differenza NDVI (impatto incendio)
dev.off() # Chiudere il pannello di visualizzazione delle immagini

# Analisi Multitemporale 

# Classificazione NDVI
classi_pre=classify(ndvi_pre,  rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post=classify(ndvi_post, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))


