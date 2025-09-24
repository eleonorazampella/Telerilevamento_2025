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
library(reshape2) # Trasformazione dati 

# Impostazione della working directory 
setwd("~/Desktop/TELERILEVAMENTO_R")

pre=rast("PreIncendio_Maggio2022.tif") # Importazione della prima immagine e la nominazione
plot(pre) # Per visulaizzare l'immagine importata

post=rast("PostIncendio_Agosto2022.tif") #Importazione della seconda immagine e la nominazione 
plot(post) # Per visulizzare la seconda immagine

# Tutte le immagini sono state salvate in png tipo png("img/pre-bande.png", width = 2000, height = 1500, res = 300)

# Visualizzazione delle immagini in RGB
im.multiframe(1,2) # Visualizzare un pannello grafico con 1 riga e 2 colonne 
im.plotRGB(pre, r = 1, g = 2, b = 3, title = "Pre-incendio")  # Visualizzare l'immagine a veri colori 
im.plotRGB(post, r = 1, g = 2, b = 3, title = "Post-incendio") # Visualizzare l'immagine a veri colori 
dev.off() # Chiudere il pannello di Visualizzazione delle immagini

# Visualizzazione delle delle quattro bande separate per entrambe le immagini (RGB + NIR)
# Viene specificata la banda, il colore e il titolo
im.multiframe(2,4) # Visualizzare un pannello grafico con 2 righe e 4 colonne
plot(pre[[1]], col = magma(100), main = "Pre - Red") 
plot(pre[[2]], col = magma(100), main = "Pre - Green")
plot(pre[[3]], col = magma(100), main = "Pre - Blue")
plot(pre[[4]], col = magma(100), main = "Pre - NIR")

plot(post[[1]], col = magma(100), main = "Post - Red")
plot(post[[2]], col = magma(100), main = "Post - Green")
plot(post[[3]], col = magma(100), main = "Post - Blue")
plot(post[[4]], col = magma(100), main = "Post - NIR")
dev.off() # Chiudere il pannello di visualizzazione delle immagini dopo aver salvato le immagini in png.

# Calcolo degli indici vegetazionali

# Indice NBR (Normalized Burn Ratio)
# L'indice sfrutta la banda NIR (B8) e la banda SWIR2 (B12)
# L'indice serve a visualizzare le aree bruciate: valori più bassi indicano vegetazione compromessa
nbr_pre = (pre[["B8"]] - pre[["B12"]]) / (pre[["B8"]] + pre[["B12"]]) # Calcolo NBR pre-incendio
nbr_post = (post[["B8"]] - post[["B12"]]) / (post[["B8"]] + post[["B12"]]) # Calcolo NBR post-incendio
dnbr = nbr_pre - nbr_post # Differenza NBR (dNBR)

im.multiframe(1,3)  #  Visualizzazione di un pannello grafico con 1 righe e 3 colonne
plot(nbr_pre, main="NBR Pre", col=viridis::viridis(100)) # Visualizzazione NBR pre-incendio
plot(nbr_post, main="NBR Post", col=viridis::viridis(100)) # Visualizzazione NBR post-incendio
plot(dnbr, main="dNBR", col=viridis::inferno(100)) # Visualizzazione della differenza NBR-Evidenzia l'impatto dell'incendio: valori positivi indicano perdita di vegetazione
dev.off()  # Chiudere il pannello di visualizzazione delle immagini

# Indice DVI ((Difference Vegetation Index))
# NIR - RED
# Misura la quantità assoluta di vegetazione senza normalizzazione
dvi_pre = pre[["B8"]] - pre[["B4"]] # Calcolo DVI pre-incendio
dvi_post = post[["B8"]] - post[["B4"]] # Calcolo DVI post-incendio
ddvi =dvi_pre - dvi_post # Differenza DVI

im.multiframe(1,3)
plot(dvi_pre, main = "DVI Pre", col=viridis::viridis(100)) # Visualizzazione DVI pre-incendio 
plot(dvi_post, main = "DVI Post", col=viridis::viridis(100)) # Visualizzazione DVI post-incendio 
plot(ddvi, main = "ΔDVI", col=viridis::inferno(100)) # Visualizzazione della differenza DVI pre e post incendio 
dev.off()

# Indice NDVI (Normalized Difference Vegetation Index)
# (NIR - RED) / (NIR + RED)
# Misura la salute della vegetazione: valori vicini a 1 indicano vegetazione sana
ndvi_pre = (pre[["B8"]] - pre[["B4"]]) / (pre[["B8"]] + pre[["B4"]]) # Calcolo NDVI pre-incendio 
ndvi_post = (post[["B8"]] - post[["B4"]]) / (post[["B8"]] + post[["B4"]]) # Calcolo NDVI post-incendio 
dndvi = ndvi_pre - ndvi_post #differeza NDVI

im.multiframe(1,3)  #  Visualizzazione di un pannello grafico con 1 righa e 3 colonne
plot(ndvi_pre, main="NDVI Pre", col=viridis::viridis(100))   #  Visualizzazione NDVI prima dell'incendio
plot(ndvi_post, main="NDVI Post", col=viridis::viridis(100)) # Visualizzazione NDVI dopo l'incendio
plot(dndvi, main="ΔNDVI", col=viridis::inferno(100))        # Visualizzazione differenza NDVI (impatto incendio)
dev.off() # Chiudere il pannello di visualizzazione delle immagini

# Analisi Multitemporale 

# Classificazione NDVI
soglia = 0.3 # Soglia NDVI per distinguere vegetazione/non vegetazione
classi_pre=classify(ndvi_pre,  rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post=classify(ndvi_post, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
# Ho scelto la soglia NDVI = 0.3 per distinguere vegetazione e non-vegetazione, in quanto valori inferiori a 0.3 indicano generalmente suolo nudo o aree degradate, mentre valori superiori corrispondono a vegetazione attiva e sana.

# Visualizzazione delle classi 
im.multiframe(1,2)
plot(classi_pre,  main="Classi NDVI Pre",  col=c("red","darkgreen"))
plot(classi_post, main="Classi NDVI Post", col=c("red","darkgreen"))
dev.off()

# Calcolo frequenze percentuali 
# Per quantificare quanto terreno è coperto da vegetazione e non-vegetazione
freq_pre = freq(classi_pre)   # conta i pixel per ogni classe NDVI pre 
freq_post = freq(classi_post)  # conta i pixel per ogni classe NDVI post

perc_pre = freq_pre$count  * 100 / ncell(classi_pre)
perc_post = freq_post$count * 100 / ncell(classi_post)

# Creazione tabella riassuntiva
NDVI_classi = c("Non vegetazione", "Vegetazione")
tabella = data.frame(
  Classe = NDVI_classi,
  Pre_incendio  = round(perc_pre, 2),
  Post_incendio = round(perc_post, 2)
)

print(tabella)  # visualizzazione tabella

 Classe Pre_incendio Post_incendio
1 Non vegetazione         7.00         46.36
2     Vegetazione        92.96         53.59


# Grafico comparativo

df_long = melt(tabella, id.vars = "Classe",
                variable.name = "Periodo",
                value.name = "Percentuale")


ggplot(df_long, aes(x=Classe, y=Percentuale, fill=Periodo)) +                               # Crea Grafico assegnando X, Y e colore
  geom_bar(stat="identity", position="dodge") +                                             # Barre affiaancate per confrontare i periodi
  geom_text(aes(label=round(Percentuale,1)),                                                # Aggiunge i valori sulle barre 
            position=position_dodge(width=0.9),                                             # Allinea il testo sulle barre affiancate
            vjust=-0.25, size=3) +                                                          # Sposta leggermente sopra le barre, dimensione testo
  scale_fill_viridis_d() +                                                                  # Applica la palette di colori 'viridis'
  ylim(0,100) +                                                                             # Limiti asse Y 0-100%
  labs(title="Copertura vegetazione (NDVI > 0.3)",                                          # Titoli ed etichette
       subtitle="Percentuale di vegetazione e non vegetazione prima e dopo l'incendio",
       y="Percentuale (%)", x="Classe NDVI") +
  theme_minimal()                                                                           # Tema pulito


# Per osservare lo stato della vegetazione un anno dopo è stata scaricata un'immagine satellitare attraverso il codice JavaScript utilizzato in precedenza su GEE
# E' stata cambiata la data aggiornandola a quella del 2023 (dal 5/08/2023 al 10/08/23)
# Sono stati eseguiti gli stessi passaggi usati in precedenza
setwd("~/Desktop/TELERILEVAMENTO_R") # Per impostare la working directory
post2023=rast("PostIncendio_Agosto2023.tif") # Ho impostato l'immagine e nominata
plot(post2023) # Ho scaricato l'immagine 

# Calcolo gli indici (DVI e NDVI) anche per l'anno 2023 
dvi_post2023 = post2023[["B8"]] - post2023[["B4"]]
ndvi_post2023 = (post2023[["B8"]] - post2023[["B4"]]) / (post2023[["B8"]] + post2023[["B4"]])
im.multiframe(1,2)
plot(dvi_post2023,main = "DVI Post-incendio 2023",col = inferno(100),axes = TRUE)
plot(ndvi_post2023,main = "NDVI Post-incendio 2023",col = inferno(100),axes = TRUE)
dev.off()

# Allineamento raster (con resample() sulla griglia pre-incendio, per garantire che ogni pixel corrisponda esattamente alla stessa area geografica.)
ndvi_post2023_aligned = resample(ndvi_post2023, ndvi_post, method="bilinear")
dvi_post2023_aligned = resample(dvi_post2023, dvi_post, method="bilinear")

# Calcolo differenze
ddvi_2022 = dvi_pre - dvi_post
ddvi_2023 = dvi_post - dvi_post2023_aligned
dndvi_2022 = ndvi_pre - ndvi_post          # Pre vs post incendio 2022
dndvi_2023 = ndvi_post - ndvi_post2023_aligned  # Post 2022 vs post 2023

# Visualizzazione affiancata

# DVI
im.multiframe(2,3)  # 2 righe x 3 colonne
plot(dvi_pre, main="DVI Pre-incendio 2022", col=viridis(100))
plot(dvi_post, main="DVI Post-incendio 2022", col=viridis(100))
plot(dvi_post2023_aligned, main="DVI Post 2023", col=viridis(100))
plot(ddvi_2022, main="ΔDVI Pre vs Post 2022", col=inferno(100))
plot(ddvi_2023, main="ΔDVI Post 2022 vs 2023", col=inferno(100))
dev.off()

# NDVI
im.multiframe(2,3) 
plot(ndvi_pre, main="NDVI Pre-incendio 2022", col=viridis(100))
plot(ndvi_post, main="NDVI Post-incendio 2022", col=viridis(100))
plot(ndvi_post2023_aligned, main="NDVI Post 2023", col=viridis(100))
plot(dndvi_2022, main="ΔNDVI Pre vs Post 2022", col=inferno(100))
plot(dndvi_2023, main="ΔNDVI Post 2022 vs 2023", col=inferno(100))
dev.off()

# Analisi classificazione NDVI 
soglia = 0.3
classi_pre = classify(ndvi_pre,  rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post = classify(ndvi_post, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post2023 = classify(ndvi_post2023_aligned, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))

# Frequenze percentuali
freq_pre = freq(classi_pre)  
freq_post = freq(classi_post)
freq_post2023 = freq(classi_post2023)

perc_pre = freq_pre$count  * 100 / ncell(classi_pre)
perc_post = freq_post$count * 100 / ncell(classi_post)
perc_post2023 = freq_post2023$count * 100 / ncell(classi_post2023)

# Percentuale di copertura vegetale e non vegetale nelle diverse date considerate: pre-incendio (maggio 2022), post-incendio (agosto 2022) e un anno dopo (agosto 2023)
tabella = data.frame(
  Classe = c("Non vegetazione", "Vegetazione"),
  Pre_incendio = round(perc_pre,2),
  Post_incendio = round(perc_post,2),
  Post_2023 = round(perc_post2023,2)
)  
print(tabella) # Per la visualizzazione della tabella

           Classe   Pre_incendio Post_incendio Post_2023
1 Non vegetazione         7.00         46.36     31.10
2     Vegetazione        92.96         53.59     68.85


# Grafico comparativo con ggplot2

df_long = melt(tabella, id.vars="Classe",
                variable.name="Periodo",
                value.name="Percentuale")

                                
ggplot(df_long, aes(x=Classe, y=Percentuale, fill=Periodo)) +   # Crea Grafico assegnando X, Y e colore
  geom_bar(stat="identity", position="dodge") +                 # Barre affiaancate per confrontare i periodi
  geom_text(aes(label=round(Percentuale,1)),                    # Aggiunge i valori sulle barre
            position=position_dodge(width=0.9),                 # Allinea il testo sulle barre affiancate
            vjust=-0.25,                                        # Sposta leggermente sopra le barre
            size=3) +                                           # Dimensione testo
  scale_fill_manual(values = c("Pre_incendio" = "darkorchid4",  # Colori distinti per i periodi
                               "Post_incendio" = "yellow",
                               "Post_2023" = "orange"))                                       
  ylim(0,100) +                                                 # Limiti asse Y 0-100%
  labs(title="Copertura vegetazione (NDVI > 0.3)",              # Titoli ed etichette
       y="Percentuale (%)", x="Classe NDVI") +
  theme_minimal()                                               # Tema pulito

