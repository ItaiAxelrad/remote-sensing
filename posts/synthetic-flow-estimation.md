---
title: Synthetic Flow Estimation
---
Synthetic flow estimation is the generation of a very long record of synthetic river flow data, from which the flow duration curve (FDC) is subsequently estimated.

The procedure is articulated in the following steps:

- A generation model is identified, calibrated, and validated.
- The long record is generated.
- The FDC is estimated.

This example uses the river Po, which runs through the city of Piacenza, Italy.

```r
po=scan(“piacenza.txt”, skip=3) 
po1=log(po)
po2=array(po1, dim=c(365,86))
mu=rep(0, 365)
sigma=rep(0, 365)
#
for (i in 1:365)
	mu[i]=mean(po2[i,])
for (i in 1:365)
	sigma[i]=sd(po2[i,])
#
po3=(po1-rep(mu,86))/rep(sigma,86)
phi1=acf(po3, lag.max=730) $ acf[2]
epsilon=rep(0,86*365)
for (i in 2:(86*365))
	epsilon[i]=po3[i]-phi1*po3[i-1]
acf(epsilon,lag.max=365)
pr2=ar(po3,order.max=2)
acf(pr2 $ resid[3:(86*336)]
pr3=ar(po3 $ resid[4:(86*365)]
acf(pr3 $ resid[4:(86*336)]
epsilon1=rnorm(365000,0,sd(epsilon))
pos1=rep(0,365000)
for (i in 2:365000)
	pos1[i]=phi*pos1[i-1]+epsilon[i] 
acf(pos1[1:3650],lag.max=365)
pos2=pos1*rep(sigma,1000)+rep(mu,1000)
acf(pos2[1:3650],lag.max=365)
pos3=exp(pos2)
#
mean(po)-mean(pos3)
sd(po)-sd(pos3)
max(po)-max(pos3)
min(po)-min(pos3)
#
plot(density(po), type=”l”)
lines(density(pos3),col=”red”,lwd=2)
pr1=acf(pos3,lag.max=365) $ acf
acf(po,lag.max=365)
lines(pr1,col=”red”,lwd=2)
```