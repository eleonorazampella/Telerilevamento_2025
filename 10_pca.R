# R code for perfoming Principal Component Analysis 

library(imageRy)
library(terra)


im.list()

sent = im.import("sentinel.png")
sent = flip(sent)          # perchè era storta 
plot(sent)


sent = c(sent[[1]],sent[[2]],sent[[3]])
plot(sent)

# NIR = band 1
# red = band 2
# green = band 3

# se metto ?im.pca= per chiedere a R com'è la PCA

# la pca non viene fatta su tutti i pixel ma estrapolando un campione 

sentpca = im.pca(sent, n_samples=100000)
tot = 77.139371+ 53.593412 + 5.710349

# 72 : 137 = x : 100

72 * 100 / tot

sdpc1 = focal(sentpca[[1]], w=c(3,3), fun="sd")   #qua abbiamo preso la componente che ha più informazioni di tutti 
plot(sdpc1)     

pairs(sent) # per vedere tutte le correlazioni 
