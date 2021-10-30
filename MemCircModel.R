library(deSolve)
library(tidyverse)
library(SciViews )


MemCirFun <- function(times, y, parms){
  s =parms[1]
  b=parms[2]
  n=parms[3]
  K=parms[4]
  A  = parms[5]
  td<-112
  #td equals to the team for a cell division/doubling time  in Sacccharomyces cervisiae 
  odemem <- rep(0,2)
  ##!! try to incorporate a differentail for the hug1 conc instead of using a stable parameter 
  odemem[1]<-(s * b* A^n)/(K^n+A^n)-ln(2)/td *y[1]
  #X[1] comprises the first variable of the ode system. In our case, it constitutes the trigger concentration 
  odemem[2] <- (s * b* (y[2] + y[1])^n)/(K^n+(y[2] + y[1])^n)-ln(2)/td *y[2]
  #X[2] comprises the second variable of the ode system. In our case, it constitutes the memory loop's autoactivator concentration
  return(list(odemem))
}
p=c(0.23,2.7,3.6,13,100)
y0=c(0,1)
t <- seq(0, 1000, 1)
testresult <- ode(y=y0 ,times = t ,func =  MemCirFun ,parms= p) 
plot(t,testresult[,3],type = "l", xlab ="Time period in min", ylab = "Concetration" ,lwd= 3, col= "red")
lines(t,testresult[,2], col= "green", lwd=3)
legend("bottomright", legend=c("Memory Autoactivator", "Trigger"),
       col=c("red", "green"), lty=1:2, cex=0.8)
