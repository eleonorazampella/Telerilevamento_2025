// ESAME - ANALISI 
// Telerilevamento geologico in R
// Eleonora Zampella

// CODICE IN JAVA SCRIPT PER SCARICARE LE IMMAGINI DI SENTINEL-2 DA GOOGLE EARTH ENGINE
// Le immagini riguardano la zona di Chandrexa de Queixa (Ourense) in Galizia,Spagna
// Ho utilizzato il codice di Rocio Beatriz Cortes Lobos modificando le bande, l'area di interesse (indicata attraverso un poligono) e il periodo da me preso in considerazione. 
// Le immagini prese sono quelle con una copertura nuvolosa inferiore al 20 % 

// Immagine Pre incendio (dal 25/06/2025 al 30/06/2025) 
// Nell'immagine è stata calcolata  la mediana 

``` JavaScript
// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
// Funzione per mascherare le nuvole Sentinel-2
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}

// Area di interesse: Ourense (Galizia, Spagna)
var geometry = ee.Geometry.Rectangle([-7.25, 42.25, -7.05, 42.40]);
Map.centerObject(geometry, 12);
Map.addLayer(geometry, {color: 'red'}, 'AOI Ourense');

// Collezione Sentinel-2 pre-incendio
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(geometry)
                   .filterDate('2025-06-25', '2025-06-30')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);

print('Numero immagini pre-incendio:', collection.size());

// Composito mediano
var composite = collection.median().clip(geometry);

// Visualizzazioni
Map.addLayer(composite, {bands: ['B4','B3','B2'], min:0, max:0.3},   // RGB naturale');
Map.addLayer(composite, {bands: ['B8','B4','B3'], min:0, max:0.3},   // Falso colore');
Map.addLayer(composite, {bands: ['B12','B8','B4'], min:0, max:0.3},  // SWIR-NIR-R');
Map.addLayer(composite, {bands: ['B12'], min:0, max:0.3, palette:['black','white']}, // Banda SWIR');

// Export con 5 bande
Export.image.toDrive({
  image: composite.select(['B2','B3','B4','B8','B12']),
  description: 'Ourense_PreIncendio_Giugno2025',
  folder: 'GEE_exports',
  fileNamePrefix: 'PreIncendio_Giugno2025',
  region: geometry,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

// Immagine Post incendio (dal 05/09/2025 al 10/09/2025)
// Nell'immagine è stata calcolata  la mediana 

// ==============================================
// Function to mask clouds using the QA60 band
// Bits 10 and 11 correspond to opaque clouds and cirrus
// ==============================================
// Funzione per mascherare le nuvole Sentinel-2
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}

// Area di interesse: Ourense (Galizia, Spagna)
var geometry = ee.Geometry.Rectangle([-7.25, 42.25, -7.05, 42.40]);
Map.centerObject(geometry, 12);
Map.addLayer(geometry, {color: 'red'}, 'AOI Ourense');

// Collezione Sentinel-2 post-incendio
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(geometry)
                   .filterDate('2025-09-05', '2025-09-10')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);

print('Numero immagini post-incendio:', collection.size());

// Composito mediano
var composite = collection.median().clip(geometry);

// Visualizzazioni
Map.addLayer(composite, {bands: ['B4','B3','B2'], min:0, max:0.3}, // RGB naturale');
Map.addLayer(composite, {bands: ['B8','B4','B3'], min:0, max:0.3},  // Falso colore');
Map.addLayer(composite, {bands: ['B12','B8','B4'], min:0, max:0.3},  // SWIR-NIR-R');
Map.addLayer(composite, {bands: ['B12'], min:0, max:0.3, palette:['black','white']},  // Banda SWIR');

// Export con 5 bande
Export.image.toDrive({
  image: composite.select(['B2','B3','B4','B8','B12']),
  description: 'Ourense_PostIncendio_Settembre2025',
  folder: 'GEE_exports',
  fileNamePrefix: 'PostIncendio_Settembre2025',
  region: geometry,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

                  



// Entrambi i file sono state esportati su google drive e successivamente salvati sul computer e caricati in R


