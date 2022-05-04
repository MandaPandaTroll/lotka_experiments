#tabacwoman May 2022


rm(list=ls())


library(ggplot2)
library(tidyverse)
#Optional, for audio file out:
#install.packages("seewave")
#library(seewave)




#CONSTANTS
# a = intrinsic growth rate (prey)
# b = predation and other population loss coefficient (prey)
# k = density dependent growth coefficient (prey)

# c = other population loss coefficient (predator)
# d = intrinsic growth rate (predator)
# q = predation coefficient (predator)

# m = intrinsic growth rate (apex predator)
# w = population loss coefficient (apex predator)

# VARIABLES
# x = prey population
# y = predator population
# z = apex predator population


#Simulation setup
{
  preyEq <- function(a, b, k, x, y, dt) return(x+ (a*x - (b*x*y + k*(x^2))/dt)+sample(stochast,1))
  predEq <- function(d, c, q, x, y, z, dt) return(y+ (d*x*y -(( c*y +q*z))/dt)+sample(stochast,1))
  apexEq <- function(m, w, z, y, dt) return(z+ ((m*z*y - w*z)/dt)+sample(stochast,1))
  
  
  stochast <- unlist(lapply( rnorm(10000,mean = 0, sd = 0.5), round),use.names = FALSE)  
  
  
cycles <- 4.41e4 # number of time steps

#initial population sizes
x <- 500
y <- 200
z <- 100

Pops <- data.frame(prey = c(x,x,x), predator = c(y,y,y), apex = c(z,z,z))

Pops[0,1] <- x
Pops[1,1] <- x
Pops[0,2] <- y
Pops[1,2] <- y
Pops[0,3] <- z
Pops[1,3] <- z
}

#Run simulation
for (i in 2:cycles){
  
  if(Pops[i-1,1] > 0){x <- Pops[i-1,1]}else{x <- 0}
  if(Pops[i-1,2] > 0){y <- Pops[i-1,2]}else{y <- 0}
  if(Pops[i-1,3] > 0){z <- Pops[i-1,3]}else{z <- 0}
               
  if(x < 0){x <- 0}
  if(y < 0){y <- 0} 
  if(z < 0){z <- 0}
    
    Pops[i,1] <-  preyEq(1e-2, 3e-5, 1e-5, x, y,1.0 ) +sample(stochast,1)
    Pops[i,2] <-  predEq(7e-7, 2e-4, 1.7e-4, x, y, z, 1.0 ) +sample(stochast,1)
    Pops[i,3] <-  apexEq(2e-7, 1e-4, z, y,1.0 ) +sample(stochast,1)
    
    
    
}




  

  
  
  
  

#Plot of population sizes
{
  Pops_gathered <- Pops%>%mutate(t = seq(1:length(Pops$prey)))

Pops_gathered <- Pops_gathered %>%
  select(t, prey, predator, apex) %>%
  gather(key = "species", value = "individuals", -t)


ggplot(Pops_gathered, aes(x = t, y = individuals)) + 
  geom_line(aes(color = species))+
  scale_color_manual(values = c("red", "blue","forestgreen"))+theme_bw()
}


#scaled plot of population sizes [-1,1], can be used to convert the data into audio files.
{
normpops <- Pops
normpops$prey <- 2*normpops$prey/max(normpops$prey) -1
normpops$predator <- 2*normpops$predator/max(normpops$predator) -1
normpops$apex <- 2*normpops$apex/max(normpops$apex) -1

normpops_gathered <- normpops%>%mutate(t = seq(1:length(normpops$prey)))

normpops_gathered <- normpops_gathered %>%
  select(t, prey, predator, apex) %>%
  gather(key = "species", value = "individuals", -t)


ggplot(normpops_gathered, aes(x = t, y = individuals)) + 
  geom_line(aes(color = species))+
  scale_color_manual(values = c("red", "blue","forestgreen"))+theme_bw()}









#Optional audio file stuff  
  
{
mixedwave <- data.frame(amplitude = (normpops$prey + normpops$predator + normpops$apex))
  mixedwave$amplitude <- 2*mixedwave$amplitude / max(mixedwave$amplitude) -1
  
  plot(mixedwave$amplitude, type = "l")
}
savewav(normpops$prey*0.75, f=44100)
savewav(normpops$predator*0.75, f=44100)
savewav(normpops$apex*0.75, f=44100)
savewav(mixedwave$amplitude*0.75, f=44100)


  

