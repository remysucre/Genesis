module Config where

import GA
import System.Random
import Data.Int

--
-- CONFIG FOR FITNESS RUN
--

runs :: Int64
runs = 1

-- 
-- CONFIG FOR GENETIC ALG
-- 

crossRate  = 0.8 :: Float
muteRate   = 0.2 :: Float
crossParam = 0.0 :: Float
muteParam  = 0.2 :: Float
checkpoint = False :: Bool
rescoreArc = False :: Bool

{-
cfg = GAConfig 
        15 -- population size
        1 -- archive size (best entities to keep track of)
        5 -- maximum number of generations
        0.8 -- crossover rate (% of entities by crossover)
        0.2 -- mutation rate (% of entities by mutation)
        0.0 -- parameter for crossover (not used here)
        0.2 -- parameter for mutation (% of flipped letters)
        False -- whether or not to use checkpointing
        False -- don't rescore archive in each generation
-}

g = mkStdGen 0 -- random generator
