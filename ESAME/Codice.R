# PROGETTO ESAME - ANALISI DELL'IMPATTO DEGLI INCENDI ESTIVI 2025 SULLA VEGETAZIONE E SULL'AMBIENTE URBANO NELLE REGIONI DELLA GALIZIA E DELLA CASTIGLIA Y LEON
# Telerilevamento Geo-ecologico in R
# Eleonora Zampella 

# CODICE IN R PER L'ELABORAZIONE DELLE IMMAGINI 

# Le immagini sono scaricate da Google Earth Engine attraverso il codice di Rocio Beatriz Cortes Lobos e sono relative agli incendi avventuti in Galizia e Castiglia y Leon. 

# La prima immagine riguarda il periodo pre-incendio(20-24 Maggio 2025), per cui è stata calcolata la mediana
# Le aree di interessa sono la Galizia e Castiglia y Leon, indicate con Aoi, con mascheramento delle nuvole utilizzando la banda QA60



// ==============================================
// Sentinel-2 - Pre-incendio (20-24 maggio 2025)
// Galicia + Castilla y León
// Bande RGB + NIR
// ==============================================

function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}

// AOI
var GAUL_L1 = ee.FeatureCollection("FAO/GAUL/2015/level1");
var galicia = GAUL_L1.filter(ee.Filter.eq('ADM1_NAME', 'Galicia'));
var castillaLeon = GAUL_L1.filter(ee.Filter.eq('ADM1_NAME', 'Castilla y León'));
var aoi = galicia.geometry().union(castillaLeon.geometry());

Map.centerObject(aoi, 6);
Map.addLayer(aoi, {color: 'red'}, 'AOI');

// Collezione Sentinel-2 Pre-incendio
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(aoi)
                   .filterDate('2025-05-20', '2025-05-24')  // 5 giorni pre-incendio
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);

print('Numero immagini pre-incendio:', collection.size());

// Composite mediano
var composite = collection.median().clip(aoi);

// Visualizzazione (solo RGB)
Map.addLayer(composite, {
  bands: ['B4','B3','B2'],
  min: 0,
  max: 0.3
}, 'Pre-fire Median Composite');

// Export su Google Drive (RGB + NIR)
Export.image.toDrive({
  image: composite.select(['B4','B3','B2','B8']),
  description: 'Sentinel2_Pre_5Giorni_Maggio2025',
  folder: 'GEE_exports',
  fileNamePrefix: 'sentinel2_pre_5giorni_maggio2025',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

#La seconda immagine presenta il periodo post-incendio(1-5 settembre 2025)

// ==============================================
// Sentinel-2 - Post-incendio (1-5 settembre 2025)
// Galicia + Castilla y León
// Bande RGB + NIR
// ==============================================

function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}

// AOI
var GAUL_L1 = ee.FeatureCollection("FAO/GAUL/2015/level1");
var galicia = GAUL_L1.filter(ee.Filter.eq('ADM1_NAME', 'Galicia'));
var castillaLeon = GAUL_L1.filter(ee.Filter.eq('ADM1_NAME', 'Castilla y León'));
var aoi = galicia.geometry().union(castillaLeon.geometry());

Map.centerObject(aoi, 6);
Map.addLayer(aoi, {color: 'red'}, 'AOI');

// Collezione Sentinel-2 Post-incendio
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(aoi)
                   .filterDate('2025-09-01', '2025-09-05')  // 5 giorni post-incendio
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);

print('Numero immagini post-incendio:', collection.size());

// Composite mediano
var composite = collection.median().clip(aoi);

// Visualizzazione (solo RGB)
Map.addLayer(composite, {
  bands: ['B4','B3','B2'],
  min: 0,
  max: 0.3
}, 'Post-fire Median Composite');

// Export su Google Drive (RGB + NIR)
Export.image.toDrive({
  image: composite.select(['B4','B3','B2','B8']),
  description: 'Sentinel2_Post_5Giorni_Settembre2025',
  folder: 'GEE_exports',
  fileNamePrefix: 'sentinel2_post_5giorni_settembre2025',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

# Pacchetti Utilizzati 

library(terra) # Pacchetto per l'analisi spaziale dei dati con vettori e dati raster
library(imageRy) # Pacchetto per manipolare, visualizzare ed esportare immagini raster in R
library(viridis) # Pacchetto per cambiare le palette di colori 
library(ggplot2) # Pacchetto per creare grafici ggplot
library(patchwork) # Pacchetto per comporre più grafici ggplot insieme

grafici e analisi multitemporale 


// Definisci area di interesse: 
var CampoImp = ee.Geometry.Rectangle([13.2, 42.2, 13.8, 42.7]);

// Finestra temporale più ampia: da luglio a settembre 2025
var startDate = ee.Date('2025-05-20');
var endDate = ee.Date('2025-05-24');

// Collezione Sentinel‑2 TOA (L1C)
var s2col = ee.ImageCollection('COPERNICUS/S2')
  .filterBounds(geometry)
  .filterDate(startDate, endDate)
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10))  // poco tollerante
  .sort('CLOUDY_PIXEL_PERCENTAGE');

print('Numero immagini trovate 2025:', s2col.size());

// Prendi la prima immagine disponibile
var image2025 = ee.Image(s2col.first());

print('Immagine selezionata 2025:', image2025);

// Controllo: se non trova, vuol dire che non ci sono immagini con questi criteri
// (ciao a image2025 come null)

// Se c'è immagine, seleziona le bande B2, B3, B4, B8
var bands = ['B2', 'B3', 'B4', 'B8'];

var selected2025 = image2025.select(bands);

// Visualizza RGB (natural) su mappa
Map.centerObject(geometry, 10);
Map.addLayer(selected2025, {bands: ['B4','B3','B2'], min: 0, max: 3000}, 'RGB 2025 CampoImp');

// Esporta l’immagine su Google Drive se esiste
Export.image.toDrive({
  image: selected2025,
  description: 'CampoImp2025',
  folder: 'GEE_Export',
  fileNamePrefix: 'CampoImp2025',
  region: geometry,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

