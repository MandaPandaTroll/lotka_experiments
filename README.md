# lotka_experiments

A population dynamics model built upon the lotka-volterra equations, with the addition of stochasticity from a normal distribution, a third trophic level, density dependent growth for autotrophs and a few more constants to modulate the interactions between the primary and secondary consumers.

tabacwoman May 2022

CONSTANTS
 a = intrinsic growth rate (prey)
 b = predation and other population loss coefficient (prey)
 k = density dependent growth coefficient (prey)

 c = other population loss coefficient (predator)
 d = intrinsic growth rate (predator)
 q = predation coefficient (predator)

 m = intrinsic growth rate (apex predator)
 w = population loss coefficient (apex predator)

 VARIABLES
 x = prey population
 y = predator population
 z = apex predator population
dt = delta time
 
 
 EQUATIONS:
 
 dx/dt = ax - (bxy + k(x^2))
 
=> x(t) = x(t-1) + (dx/dt)
 
 
 
 dy/dt = dxy - (cy + qz)
 
=> y(t) = y(t-1) + (dy/dt)
  
  
  
 dz/dt = mzy - wz
 
=> z(t) = z(t-1) + (dz/dt)