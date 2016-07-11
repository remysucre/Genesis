{-# LANGUAGE BangPatterns #-}

module Fitness (fitness) where
import Rewrite
import Profiling
import Config
import Types
------
import qualified Data.BitVector as B
import System.Process
import Control.DeepSeq


reps = runs

fitness :: FilePath -> BangVec -> IO Time
fitness projDir bangVec = do
  -- Read original
    let mainPath = projDir ++ "/Main.hs"
    !prog  <- readFile mainPath
  -- Rewrite according to gene
    !prog' <- editBangs mainPath (B.toBits bangVec) 
    rnf prog `seq` writeFile mainPath prog'
    -- print prog'
  -- Benchmark new
    buildProj projDir
    !newTime <- benchmark projDir reps
  -- Recover original
    !_ <- writeFile mainPath prog
    return newTime

    {-
  -- Random seed; credit to Cyrus Cousins
    randomSeed <- (getStdRandom random)
  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  -- Also parse options for genetic algorithm?
    let (useCliSeed, cliSeed) = (False, 0 :: Int)
        seed = if useCliSeed then cliSeed else randomSeed-}


