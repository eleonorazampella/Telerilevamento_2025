# ANALISI DELLA VEGETAZIONE PRE E POST INCENDIO NELLA SIERRA DE LA CULEBRA AVVENUTO NEL 2022 
### Eleonora Zampella 

# 1. Introduzione

Nell'estate del 2022 la Spagna è stata colpita da un enorme incendio che colpì principalemnte la zona montuosa di Sierra de la culebra in provincia di Zamora. L'estensione del rogo è stato uno dei peggiori e ha distrutto più di 30000 ettari di terreno.
Questo progetto si propone di analizzare l'impatto di questo evento sulla copertura vegetale pre e post incedio attraverso le immagini satellitari.
Queste ultime sono relativea tre momenti temporali:
- Pre-incendio: Maggio 2022
- Post-incendio: Agosto 2022
- Un anno dopo: Agosto 2023
  
Gli indici vegetazionali calcolati sono:
- NDVI (Normalized Difference Vegetation Index) – salute della vegetazione
- DVI (Difference Vegetation Index) – quantità assoluta di vegetazione
- NBR (Normalized Burn Ratio) – evidenzia aree bruciate
  
# 2. Obbiettivo del progetto 

L'obbiettivo del progetto è quello di monitorare i cambiamenti della vegetazione nel tempo, quantificare l’impatto dell’incendio e osservare il recupero vegetazionale un anno dopo, attraverso il calcolo di indici spettrali e analisi multitemporale.

# 3. Metodologia 

## Raccolta delle immagini 

Le immagini satellitari provengono da [**Google Earth Engine**](https://earthengine.google.com/) selezionando l'area dell'incendio e le date indicate.
> [!NOTE]
> Il codice JavaScript utilizzato è quello fornito durante il corso ed è disponibile nel file Codice.js

## Importazione e visualizzazione delle immagini 
Una volta ottenute le immagini satellitari le carichiamo su R impostando una working directory:

````r
setwd("~/Desktop/TELERILEVAMENTO_R")
````
Successivamente sono stati presi installati i seguenti pacchetti in R

````r
library(terra)  
library(imageRy)  
library(viridis)  
library(ggplot2)  
library(patchwork)  
library(reshape2)
````

A questo punto impostiamo i raster Sentinel-2 : 

````r
pre=rast("PreIncendio_Maggio2022.tif") # Importazione della prima immagine e la nominazione
plot(pre) # Per visulaizzare l'immagine importata
````

<p align="center">
  <img src="img/pre-bande.png" width="600" height/>
</p>

> Questa rappresenta l'immagine prima dell'incendio nelle 5 bande

````r
post=rast("PostIncendio_Agosto2022.tif") #Importazione della seconda immagine e la nominazione 
plot(post) # Per visulizzare la seconda immagine
````
<p align="center">
  <img src="img/post-bande.png" width="600"/>
</p>

> Questa rappresenta l'immagine dopo l'incendio nelle 5 bande

# Visualizzazione delle quattro bande separate per entrambe le immagini (RGB + NIR)

## Confronto tra immagini pre e post incendio

````r
im.multiframe(1,2) # Visualizzare un pannello grafico con 1 riga e 2 colonne 
plot(pre, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100)) 
plot(post, main=c("B4-Red", "B3-Green", "B2-Blue", "B8-NIR"), col=magma(100))
dev.off() # Chiudo il pannello grafico dopo aver salvato l'immagine in .png
````

## Visualizzazione delle immagini in RGB

````r
im.multiframe(1,2) # Visualizzare un pannello grafico con 1 riga e 2 colonne 
im.plotRGB(pre, r = 1, g = 2, b = 3, title = "Pre-incendio")  # Visualizzare l'immagine a veri colori 
im.plotRGB(post, r = 1, g = 2, b = 3, title = "Post-incendio") # Visualizzare l'immagine a veri colori 
dev.off() # Chiudere il pannello di Visualizzazione delle immagini
````
<p align="center">
  <img src="img/PrePost_RGB.png" width="600"/>
</p>

> Dalle immagini è visibile la differenza tra il prima e il dopo l'incendio 

## Visualizzazione delle singole bande con dettaglio
 Viene specificata la banda, il colore e il titolo

````r
im.multiframe(2,4) # Visualizzare un pannello grafico con 2 righe e 4 colonne
plot(pre[[1]], col = magma(100), main = "Pre - Red") 
plot(pre[[2]], col = magma(100), main = "Pre - Green")
plot(pre[[3]], col = magma(100), main = "Pre - Blue")
plot(pre[[4]], col = magma(100), main = "Pre - NIR")

plot(post[[1]], col = magma(100), main = "Post - Red")
plot(post[[2]], col = magma(100), main = "Post - Green")
plot(post[[3]], col = magma(100), main = "Post - Blue")
plot(post[[4]], col = magma(100), main = "Post - NIR")
dev.off() # Chiudere il pannello di visualizzazione delle immagini
````
<p align="center">
  <img src="img/PrePost_Bande.png" width="1000"/>
</p>

# Calcolo degli indici vegetazionali

## Indice NBR (Normalized Burn Ratio)
- L'indice sfrutta la banda NIR (B8) e la banda SWIR2 (B12)
- L'indice serve a visualizzare le aree bruciate: valori più bassi indicano vegetazione compromessa

````r
nbr_pre = (pre[["B8"]] - pre[["B12"]]) / (pre[["B8"]] + pre[["B12"]]) # Calcolo NBR pre-incendio
nbr_post = (post[["B8"]] - post[["B12"]]) / (post[["B8"]] + post[["B12"]]) # Calcolo NBR post-incendio
dnbr = nbr_pre - nbr_post # Differenza NBR (dNBR)
````

````r
im.multiframe(1,3)  #  Visualizzazione di un pannello grafico con 1 righe e 3 colonne
plot(nbr_pre, main="NBR Pre", col=viridis::viridis(100)) # Visualizzazione NBR pre-incendio
plot(nbr_post, main="NBR Post", col=viridis::viridis(100)) # Visualizzazione NBR post-incendio
plot(dnbr, main="dNBR", col=viridis::inferno(100)) # Visualizzazione della differenza NBR-Evidenzia l'impatto dell'incendio: valori positivi indicano perdita di vegetazione
dev.off()  # Chiudere il pannello di visualizzazione delle immagini
````
<p align="center">
  <img src="img/NBR.png" width="1000"/>
</p>

## Indice DVI ((Difference Vegetation Index))
-  NIR - RED
- Misura la quantità assoluta di vegetazione senza normalizzazione

````r
dvi_pre = pre[["B8"]] - pre[["B4"]] # Calcolo DVI pre-incendio
dvi_post = post[["B8"]] - post[["B4"]] # Calcolo DVI post-incendio
ddvi =dvi_pre - dvi_post # Differenza DVI
````

````r
im.multiframe(1,3)
plot(dvi_pre, main = "DVI Pre", col=viridis::viridis(100)) # Visualizzazione DVI pre-incendio 
plot(dvi_post, main = "DVI Post", col=viridis::viridis(100)) # Visualizzazione DVI post-incendio 
plot(ddvi, main = "ΔDVI", col=viridis::inferno(100)) # Visualizzazione della differenza DVI pre e post incendio 
dev.off()
````
<p align="center">
  <img src="img/DVI.png" width="1000"/>
</p>

# Indice NDVI (Normalized Difference Vegetation Index)
- (NIR - RED) / (NIR + RED)
- Misura la salute della vegetazione: valori vicini a 1 indicano vegetazione sana

````r
ndvi_pre = (pre[["B8"]] - pre[["B4"]]) / (pre[["B8"]] + pre[["B4"]]) # Calcolo NDVI pre-incendio 
ndvi_post = (post[["B8"]] - post[["B4"]]) / (post[["B8"]] + post[["B4"]]) # Calcolo NDVI post-incendio 
dndvi = ndvi_pre - ndvi_post #differeza NDVI
````
````r
im.multiframe(1,3)  #  Visualizzazione di un pannello grafico con 1 righa e 3 colonne
plot(ndvi_pre, main="NDVI Pre", col=viridis::viridis(100))   #  Visualizzazione NDVI prima dell'incendio
plot(ndvi_post, main="NDVI Post", col=viridis::viridis(100)) # Visualizzazione NDVI dopo l'incendio
plot(dndvi, main="ΔNDVI", col=viridis::inferno(100))        # Visualizzazione differenza NDVI (impatto incendio)
dev.off() # Chiudere il pannello di visualizzazione delle immagini
````
<p align="center">
  <img src="img/NDVI.png" width="1000"/>
</p>

# Analisi Multitemporale 

## Classificazione NDVI

````r
soglia = 0.3 # Soglia NDVI per distinguere vegetazione/non vegetazione
classi_pre=classify(ndvi_pre,  rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post=classify(ndvi_post, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
````

# Visualizzazione delle classi 

````r
im.multiframe(1,2)
plot(classi_pre,  main="Classi NDVI Pre",  col=c("red","darkgreen"))
plot(classi_post, main="Classi NDVI Post", col=c("red","darkgreen"))
dev.off()
````
<p align="center">
  <img src="img/classiNDVI.png" width="900" height/>
</p>

# Calcolo frequenze percentuali 
Per quantificare quanto terreno è coperto da vegetazione e non-vegetazione

````r
freq_pre = freq(classi_pre)   # conta i pixel per ogni classe NDVI pre
freq_post = freq(classi_post)  # conta i pixel per ogni classe NDVI post
````

````r
perc_pre = freq_pre$count  * 100 / ncell(classi_pre)
perc_post = freq_post$count * 100 / ncell(classi_post)
````

## Creazione tabella riassuntiva
````r
NDVI_classi = c("Non vegetazione", "Vegetazione")
tabella = data.frame(
  Classe = NDVI_classi,
  Pre_incendio  = round(perc_pre, 2),
  Post_incendio = round(perc_post, 2)
)

print(tabella)  # visualizzazione tabella
````
 Classe Pre_incendio Post_incendio
1 Non vegetazione         7.00         46.36
2     Vegetazione        92.96         53.59

## Grafico comparativo

````r
df_long = melt(tabella, id.vars = "Classe",
                variable.name = "Periodo",
                value.name = "Percentuale")


ggplot(df_long, aes(x=Classe, y=Percentuale, fill=Periodo)) +
  geom_bar(stat="identity", position="dodge") +
  geom_text(aes(label=round(Percentuale,1)),
            position=position_dodge(width=0.9),
            vjust=-0.25, size=3) +
  scale_fill_viridis_d() +
  ylim(0,100) +
  labs(title="Copertura vegetazione (NDVI > 0.3)",
       subtitle="Percentuale di vegetazione e non vegetazione prima e dopo l'incendio",
       y="Percentuale (%)", x="Classe NDVI") +
  theme_minimal()
````
<p align="center">
  <img src="img/Veg-noVeg.png" width="900" height/>
</p>

# Per osservare lo stato della vegetazione un anno dopo è stata scaricata un'immagine satellitare attraverso il codice JavaScript utilizzato in precedenza su GEE
E' stata cambiata la data aggiornandola a quella del 2023 (dal 5/08/2023 al 10/08/23)
Sono stati eseguiti gli stessi passaggi usati in precedenza

````r
setwd("~/Desktop/TELERILEVAMENTO_R") # Per impostare la working directory
post2023=rast("PostIncendio_Agosto2023.tif") # Ho impostato l'immagine e nominata
plot(post2023) # Ho scaricato l'immagine 
````
<p align="center">
  <img src="img/Post2023.png" width="600"/>
</p>

## Calcolo gli indici (DVI e NDVI) anche per l'anno 2023 
````r
dvi_post2023 = post2023[["B8"]] - post2023[["B4"]]
ndvi_post2023 = (post2023[["B8"]] - post2023[["B4"]]) / (post2023[["B8"]] + post2023[["B4"]])
im.multiframe(1,2)
plot(dvi_post2023,main = "DVI Post-incendio 2023",col = inferno(100),axes = TRUE)
plot(ndvi_post2023,main = "NDVI Post-incendio 2023",col = inferno(100),axes = TRUE)
dev.off()
````
<p align="center">
  <img src="img/DVI_NDVI2023.png" width="900"/>
</p>


## Allineamento raster (con resample() sulla griglia pre-incendio, per garantire che ogni pixel corrisponda esattamente alla stessa area geografica.)
````r
ndvi_post2023_aligned = resample(ndvi_post2023, ndvi_post, method="bilinear")
dvi_post2023_aligned = resample(dvi_post2023, dvi_post, method="bilinear")
````

## Calcolo differenze
````r
ddvi_2022 = dvi_pre - dvi_post
ddvi_2023 = dvi_post - dvi_post2023_aligned
dndvi_2022 = ndvi_pre - ndvi_post          # Pre vs post incendio 2022
dndvi_2023 = ndvi_post - ndvi_post2023_aligned  # Post 2022 vs post 2023
````

## Visualizzazione affiancata
````r
im.multiframe(2,3)  # 2 righe x 3 colonne
````
## DVI
````r
plot(dvi_pre, main="DVI Pre-incendio 2022", col=viridis(100))
plot(dvi_post, main="DVI Post-incendio 2022", col=viridis(100))
plot(dvi_post2023_aligned, main="DVI Post 2023", col=viridis(100))
plot(ddvi_2022, main="ΔDVI Pre vs Post 2022", col=inferno(100))
plot(ddvi_2023, main="ΔDVI Post 2022 vs 2023", col=inferno(100))
dev.off()
````

## NDVI
````r
plot(ndvi_pre, main="NDVI Pre-incendio 2022", col=viridis(100))
plot(ndvi_post, main="NDVI Post-incendio 2022", col=viridis(100))
plot(ndvi_post2023_aligned, main="NDVI Post 2023", col=viridis(100))
plot(dndvi_2022, main="ΔNDVI Pre vs Post 2022", col=inferno(100))
plot(dndvi_2023, main="ΔNDVI Post 2022 vs 2023", col=inferno(100))
````

## Analisi classificazione NDVI 
````r
soglia = 0.3
classi_pre = classify(ndvi_pre,  rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post = classify(ndvi_post, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
classi_post2023 = classify(ndvi_post2023_aligned, rcl=matrix(c(-Inf,soglia,0, soglia,Inf,1), ncol=3, byrow=TRUE))
````

## Frequenze percentuali
````r
freq_pre = freq(classi_pre, useNA="no")  # Utilizzo il useNA perchè non voglio contare i pixel che hanno valore mancante NA (mi interessano solo classi 0 senza vegetaioni e 1 con vegetazione)
freq_post = freq(classi_post, useNA="no")
freq_post2023 = freq(classi_post2023, useNA="no")

perc_pre = freq_pre$count  * 100 / ncell(classi_pre)
perc_post = freq_post$count * 100 / ncell(classi_post)
perc_post2023 = freq_post2023$count * 100 / ncell(classi_post2023)
````

## Percentuale di copertura vegetale e non vegetale nelle diverse date considerate: pre-incendio (maggio 2022), post-incendio (agosto 2022) e un anno dopo (agosto 2023)

````r
tabella = data.frame(
  Classe = c("Non vegetazione", "Vegetazione"),
  Pre_incendio = round(perc_pre,2),
  Post_incendio = round(perc_post,2),
  Post_2023 = round(perc_post2023,2)
)  
print(tabella) # Per la visualizzazione della tabella
````

## Grafico comparativo con ggplot2

````r
df_long = melt(tabella, id.vars="Classe",
                variable.name="Periodo",
                value.name="Percentuale")

ggplot(df_long, aes(x=Classe, y=Percentuale, fill=Periodo)) +
  geom_bar(stat="identity", position="dodge") +            # barre affiaancate 
  geom_text(aes(label=round(Percentuale,1)),               # aggiunge i numeri
            position=position_dodge(width=0.9),            # allinea il testo sulle barre affiancate
            vjust=-0.25,                                   # sposta leggermente sopra le barre
            size=3) +                                      # dimensione testo
  scale_fill_viridis_d() +                                 # palette viridis
  ylim(0,100) +                                            # asse y da 0 a 100
  labs(title="Copertura vegetazione (NDVI > 0.3)",         # titoli
       y="Percentuale (%)", x="Classe NDVI") +
  theme_minimal()                                          # tema pulito
````

# Conclusioni 
In conclusione possiamo affermare che l'incendio del 2022 ha ridotto significativamente la vegetazione nella Sierra de la Culebra. Nel 2023 si osserva un leggero recupero, ma alcune aree restano degradate. L’analisi multitemporale e gli indici NDVI, DVI e NBR evidenziano chiaramente l’impatto e le zone più colpite.

# Grazie per l'attenzione!
