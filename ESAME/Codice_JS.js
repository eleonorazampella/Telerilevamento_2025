// ESAME - ANALISI 
// Telerilevamento geologico in R
// Eleonora Zampella

// CODICE IN JAVA SCRIPT PER SCARICARE LE IMMAGINI DI SENTINEL-2 DA GOOGLE EARTH ENGINE
// Le immagini riguardano la zona di in Sierra della Culebra a Zamora,Spagna
// Ho utilizzato il codice di Rocio Beatriz Cortes Lobos modificando le bande, l'area di interesse (indicata attraverso un poligono) e il periodo da me preso in considerazione. 
// Le immagini prese sono quelle con una copertura nuvolosa inferiore al 20 % 

// Immagine Pre incendio (dal 25/05/2022 al 30/05/2022) 
// Nell'immagine è stata calcolata  la mediana 



// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
// Funzione per mascherare le nuvole Sentinel-2
// Funzione per mascherare le nuvole Sentinel-2
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Area di interesse
// ==============================================
var aoi = ee.Geometry.Rectangle([-6.5, 41.8, -6.1, 42.1]);
Map.centerObject(aoi, 11);
Map.addLayer(aoi, {color: 'red'}, 'AOI Sierra de la Culebra');

// ==============================================
// Caricamento Image Collection post-incendio
// ==============================================
var collection_pre = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate('2022-05-25', '2022-05-30')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);


// Numero di immagini disponibili
print('Number of images in post-fire collection:', collection_pre.size());

// ==============================================
// Creazione median composite
// ==============================================
var composite_pre = collection_pre.median().clip(aoi);

// ==============================================
// Visualizzazione sulla mappa (solo 3 bande per RGB)
// ==============================================
Map.centerObject(aoi, 10);

// Prima immagine RGB
Map.addLayer(collection_pre.first(), {
  bands: ['B4','B3','B2'],   // Solo RGB per visualizzazione
  min: 0,
  max: 0.3
}, 'First post-fire image RGB');

// Composite mediano RGB
Map.addLayer(composite_pre, {
  bands: ['B4','B3','B2'],   // Solo RGB per visualizzazione
  min: 0,
  max: 0.3
}, 'Median post-fire composite RGB');

// ==============================================
// Export su Google Drive (senza B12)
// ==============================================
Export.image.toDrive({
  image: composite_pre.select(['B2','B3','B4','B8','B12']),  // Ora include anche B12
  description: 'SierraCulebra_PreIncendio_Maggio2022',
  folder: 'GEE_exports',
  fileNamePrefix: 'PreIncendio_Maggio2022',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});


// Immagine Post incendio (dal 05/08/2022 al 10/08/2022)
// Nell'immagine è stata calcolata  la mediana 


// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
// Funzione per mascherare le nuvole Sentinel-2
// Funzione per mascherare le nuvole Sentinel-2
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;

  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));

  return image.updateMask(mask).divide(10000);
}

// ==============================================
// Area di interesse
// ==============================================
var aoi = ee.Geometry.Rectangle([-6.5, 41.8, -6.1, 42.1]);
Map.centerObject(aoi, 11);
Map.addLayer(aoi, {color: 'red'}, 'AOI Sierra de la Culebra');

// ==============================================
// Caricamento Image Collection post-incendio
// ==============================================
var collection_post = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate('2022-08-05', '2022-08-10')       // Periodo post-incendio
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);

// Numero di immagini disponibili
print('Number of images in post-fire collection:', collection_post.size());

// ==============================================
// Creazione median composite
// ==============================================
var composite_post = collection_post.median().clip(aoi);

// ==============================================
// Visualizzazione sulla mappa (solo 3 bande per RGB)
// ==============================================
Map.centerObject(aoi, 10);

// Prima immagine RGB
Map.addLayer(collection_post.first(), {
  bands: ['B4','B3','B2'],   // Solo RGB per visualizzazione
  min: 0,
  max: 0.3
}, 'First post-fire image RGB');

// Composite mediano RGB
Map.addLayer(composite_post, {
  bands: ['B4','B3','B2'],   // Solo RGB per visualizzazione
  min: 0,
  max: 0.3
}, 'Median post-fire composite RGB');

// ==============================================
// Export su Google Drive (senza B12)
// ==============================================
Export.image.toDrive({
  image: composite_post.select(['B2','B3','B4','B8','B12']),  // Ora include anche B12
  description: 'SierraCulebra_PostIncendio_Agosto2022',
  folder: 'GEE_exports',
  fileNamePrefix: 'PostIncendio_Agosto2022',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

// Entrambi i file sono state esportati su google drive e successivamente salvati sul computer e caricati in R
