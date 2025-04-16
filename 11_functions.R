# R code for genereting new function

# dobbiamo dare un nome alla funzione, poi function con gli argomenti della funzione e poi le parerntesi graffe che hanno bisogno di uno spazio prima: 


somma <- function(x,y) { 
  z=x+y
  return(z)
  }

somma(2,3)
[1] 5

differenza <- function(x,y) { 
  z=x-y
  return(z)
  }

differenza(2,3)

# parentesi graffe le fai con shift, option e parentesi qaudre

# multiframe 

pannellone <- function(x,y) {
  par(mfrow=c(x,y))
  }


mf <- function(nrow,ncol) {
  par(mfrow=c(nrow,ncol))
  }

# funzione che ci dice se un numero è positivo o no, ultilizzo if che è una funzione condizionale, print è una funzione utilizzata come messaggio, inserisco else if per dire che se x è minore di zero allora il numero è negativo, e alla fine anche else 
perchè devo considerare anche lo zero visto che ho detto maggiore di zero è positivo e minore è negativo, else inoltre non ha argomenti 
positivo <- function(x) {
  if(x>0) {
    print("Questo numero è positivo, non lo sai?")
    }
  else if(x<0) {
    print("Questo numero è negativo, studia!") 
    }
  else {
    print("Lo zero è zero.")}
  }
 
# fa flip variabile e poi il plot 

flipint <- function(x) {
  x = flip(x)
  plot(x)
}


