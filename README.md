# lotka_experiments

A population dynamics model built upon the lotka-volterra equations, with the addition of stochasticity from a normal distribution, a third trophic level, density dependent growth for autotrophs and a few more constants to modulate the interactions between the primary and secondary consumers. It also contains some code to scale the values to the range[-1,1] so that the data can be written to an audio file ;)

tabacwoman May 2022  
  
CONSTANTS
 r = intrinsic growth rate 
 b = predation and other population loss coefficient (prey)
 k = carrying capacity

 c = other population loss coefficient (predator)
 q = predation coefficient (predator)

 w = population loss coefficient (apex predator)

 VARIABLES
 x = prey population
 y = predator population
 z = apex predator population  
  
 ENVIRONMENT PARAMETERS:  
 cycles = number of time steps before halting the simulation.  

 EQUATIONS: 
  s = normally distributed value with mean = 0 and varying sd.
  a = 1/k
  
  dx/dt = rx(1-ax) - bxy + s
  
=> x(t) = x(t-1) + (dx/dt)  
  
  
  
 dy/dt = rxy - (cy + qz) + s
  
=> y(t) = y(t-1) + (dy/dt)  
   
   
   
 dz/dt = ryz - wz + s
   
=> z(t) = z(t-1) + (dz/dt)  