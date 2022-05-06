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
  e = exp(1)
  stochast_prey <- unlist(lapply( rnorm(10000,mean = 0, sd = e*2), round),use.names = FALSE)  
  
  stochast_predator <- unlist(lapply( rnorm(10000,mean = 0, sd = 0.5), round),use.names = FALSE) 
  
  stochast_apex <- unlist(lapply( rnorm(10000,mean = 0, sd = 0.5), round),use.names = FALSE)  
  
  
  #Density dependent growth:
  # dN/dt = r*N(1-aN)
  # where r = intrinsic growth rate
  # a = 1/k
  # and k = carrying capacity
  preyEq <- function(r, b, k, x, y){
    
    s <- sample(stochast_prey,1)
    a <- 1/k
    D <- (r*x)*(1 - (a*x))
    L <- 0 - (b*x*y)
    x <- (x + D + L + s)
    
    if(x < 0){x <- 0}
    return(x)
  }
  
  predEq <- function(r, c, q, x, y, z){
    s <- sample(stochast_predator,1)
    L <- 0 - (c*y)
    P <- 0 - (q*z)
    G <- 0 + (r*x*y)
    y <- (y + L + P + G + s)
    if(y < 0){y <- 0}
    return(y)
  }
    
  
  apexEq <- function(r, w, z, y) {
    s <- sample(stochast_apex,1)
    L <- 0 - (w*z)
    G <- 0 + (r*y*z)
    z <- (z + L + G + s)
   if(z < 0){z <- 0}
   return(z)
  }
    
  
  

  
  
cycles <- 4.41e5 # number of time steps

#initial population sizes
x <- 1000
y <- 500
z <- 150


prey = c(x,x,x)
predator = c(y,y,y)
apex = c(z,z,z)
}



#Run simulation
for (i in 2:cycles){
  
  #if(Pops[i-1,1] > 0){x <- Pops[i-1,1]}else{x <- 0}
  #if(Pops[i-1,2] > 0){y <- Pops[i-1,2]}else{y <- 0}
  #if(Pops[i-1,3] > 0){z <- Pops[i-1,3]}else{z <- 0}
  
  x <- prey[i-1]
  y <- predator[i-1]
  z <- apex[i-1]
               
  
    prey[i]     <- preyEq(5e-3, 6e-6, 1e4, x, y ) 
    
    predator[i] <- predEq(1e-6, 1e-3, 9e-4, x, y, z ) 
      
    apex[i]     <- apexEq(1.5e-6,1.1e-3, z, y )
      
    
    #Pops[i,1] <-  preyEq(1e-2, 3e-5, 1e-5, x, y,1.0 ) +sample(stochast,1)
    #Pops[i,2] <-  predEq(7e-7, 2e-4, 1.7e-4, x, y, z, 1.0 ) +sample(stochast,1)
    #Pops[i,3] <-  apexEq(2e-7, 1e-4, z, y,1.0 ) +sample(stochast,1)
    
    
    
}





#Plot of population sizes
{
  Pops <- data.frame(prey, predator, apex)
  Pops_gathered <- Pops%>%mutate(t = seq(1:length(Pops$prey)))

Pops_gathered <- Pops_gathered %>%
  select(t, prey, predator, apex) %>%
  gather(key = "species", value = "individuals", -t)


ggplot(Pops_gathered, aes(x = t, y =individuals)) + 
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


  

