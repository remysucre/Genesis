module Config where

import GA
import System.Random

--
-- CONFIG FOR FITNESS RUN
--

runs :: Int
runs = 1

-- 
-- CONFIG FOR GENETIC ALG
-- 

cfg = GAConfig 
        15 -- population size
        3 -- archive size (best entities to keep track of)
        5 -- maximum number of generations
        0.8 -- crossover rate (% of entities by crossover)
        0.2 -- mutation rate (% of entities by mutation)
        0.0 -- parameter for crossover (not used here)
        0.2 -- parameter for mutation (% of flipped letters)
        False -- whether or not to use checkpointing
        False -- don't rescore archive in each generation

g = mkStdGen 0 -- random generator
