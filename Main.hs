import Rewrite      -- Rewrite Haskell code
import GeneAlg      -- Genetic Algorithm
import Hacks        -- Dirty hacks
import Profiling    -- Building & Profiling Projects
import Types

import System.Random
import Control.Monad
import System.Environment (getArgs)
import Language.Haskell.Exts
import GA 

--Cyrus says: This is a tiny population, and genetic algorithms are vulnerable to small populations.  I would increase the population size and the number of generations.
-- Configurations for genetic algorithm
cfg = GAConfig 
    5 -- population size
    3 -- archive size (best entities to keep track of)
    5 -- maximum number of generations
    0.8 -- crossover rate (% of entities by crossover)
    0.2 -- mutation rate (% of entities by mutation)
    0.0 -- parameter for crossover (not used here)
    0.2 -- parameter for mutation (% of flipped letters)
    False -- whether or not to use checkpointing
    False -- don't rescore archive in each generation

g = mkStdGen 0 -- random generator
runs = 5       -- runs for each fitness test

main :: IO()
main = do
    [projDir] <- getArgs
  -- TODO assuming only one file per project
    let mainPath = projDir ++ "/Main.hs" 

  -- Random seed; credit to Cyrus Cousins
    randomSeed <- (getStdRandom random)
  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  -- Also parse options for genetic algorithm?
    let (useCliSeed, cliSeed) = (False, 0 :: Int)
        seed = if useCliSeed then cliSeed else randomSeed
    print seed

  -- Obtain base time.
    buildProj projDir
    m <- benchmark projDir runs
    let baseTime :: Time
        baseTime = measTime m
    putStr "Basetime is: "; print baseTime

  -- Do the evolution!
    es <- evolveVerbose g cfg undefined (baseTime, projDir)
    let e :: Gene
        e = snd $ head es

  -- Write result
    putStrLn $ "best entity (GA): " ++ show e
    let prog' = editBangs mainPath e
    writeFile mainPath prog'
