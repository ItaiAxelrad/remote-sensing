n=100*365*24*5*2 # 100 yrs of data
rain=scan("rainnew.txt")
rain1=array(rain, dim=c(5, n))
mean(rain1)
rain2=rep(0, n)
mean(rain2)
max(rain2)
min(rain2)
for (i in 1:n)
  rain2[i]=mean(rain1[, i])
pr1=0
for (i in 1:100)
  (
    pr1=c(pr1,rep(i, n)) 
  )
pr1=pr1[2:length(pr1)] 
rain3=tapply(rain2, pr1, sum)
sum(rain2) 
sum(rain3)
# QQ plot
plot(density(rain3), type="l")
rain4=qqnorm(rain3) $ x
plot(density(rain4), type="l")
plot(rain4, type="l")