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

// Area di interesse: Sierra de la Culebra, Zamora, Spagna
var aoi = ee.Geometry.Rectangle([-6.5, 41.8, -6.1, 42.1]);
Map.centerObject(aoi, 11);
Map.addLayer(aoi, {color: 'red'}, 'AOI Sierra de la Culebra');

// Collezione Sentinel-2 PRE-incendio
var collection_pre = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate('2022-05-25', '2022-05-30')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);

print('Numero immagini pre-incendio:', collection_pre.size());

// Composito mediano pre-incendio
var composite_pre = collection_pre.median().clip(aoi);

// Visualizzazioni pre-incendio
Map.addLayer(composite_pre, {bands: ['B4','B3','B2'], min:0, max:0.3}, 'RGB naturale PRE');
Map.addLayer(composite_pre, {bands: ['B8','B4','B3'], min:0, max:0.3}, 'Falso colore PRE');
Map.addLayer(composite_pre, {bands: ['B12','B8','B4'], min:0, max:0.3}, 'SWIR PRE');

// Export pre-incendio
Export.image.toDrive({
  image: composite_pre.select(['B2','B3','B4','B8','B12']),
  description: 'SierraCulebra_PreIncendio_Maggio2022',
  folder: 'GEE_exports',
  fileNamePrefix: 'PreIncendio_Maggio2022',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});



// Immagine Post incendio (dal 01/08/2022 al 05/08/2022)
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

// Area di interesse: Sierra de la Culebra, Zamora, Spagna
var aoi = ee.Geometry.Rectangle([-6.5, 41.8, -6.1, 42.1]);
Map.centerObject(aoi, 11);
Map.addLayer(aoi, {color: 'red'}, 'AOI Sierra de la Culebra');

// Collezione Sentinel-2 POST-incendio
var collection_post = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(aoi)
  .filterDate('2022-08-01', '2022-08-05')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);

print('Numero immagini post-incendio:', collection_post.size());

// Composito mediano post-incendio
var composite_post = collection_post.median().clip(aoi);

// Visualizzazioni post-incendio
Map.addLayer(composite_post, {bands: ['B4','B3','B2'], min:0, max:0.3}, 'RGB naturale POST');
Map.addLayer(composite_post, {bands: ['B8','B4','B3'], min:0, max:0.3}, 'Falso colore POST');
Map.addLayer(composite_post, {bands: ['B12','B8','B4'], min:0, max:0.3}, 'SWIR POST');

// Export post-incendio
Export.image.toDrive({
  image: composite_post.select(['B2','B3','B4','B8','B12']),
  description: 'SierraCulebra_PostIncendio_Agosto2022',
  folder: 'GEE_exports',
  fileNamePrefix: 'PostIncendio_Agosto2022',
  region: aoi,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
               
// Entrambi i file sono state esportati su google drive e successivamente salvati sul computer e caricati in R


