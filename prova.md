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
