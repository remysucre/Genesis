{-# LANGUAGE BangPatterns #-}

import Rewrite
import Profiling
import GeneAlg
import Config
------
import GA
import Data.BitVector (BV, fromBits, toBits, size, ones)
import Data.Int
import System.Environment
import System.Process
import Control.DeepSeq


main :: IO () 
main = do 
  (projDir:confg) <- getArgs
  let [pop, gens, arch] = map read confg

  putStrLn ">>>>>>>>>>>>>>>START OPTIMIZATION>>>>>>>>>>>>>>>"
  putStrLn $ "pop: " ++ show pop 
  putStrLn $ "gens: " ++ show gens
  putStrLn $ "arch: " ++ show arch 
  -- Configurations
  let cfg = GAConfig pop arch gens 
                     crossRate 
                     muteRate 
                     crossParam 
                     muteParam 
                     checkpoint 
                     rescoreArc

  -- Get base time and pool. 
  let baseTime = 23
  baseTime <- benchmark projDir runs
  putStr "Basetime is: "; print baseTime

  -- Pool: bit vector representing places to strict w/ all bits on
  let mainPath = projDir ++ "/Main.hs"
  bs <- readBangs mainPath
  let vecPool = fromBits bs

  -- Do the evolution!
    -- Note: if either of the last two arguments is unused, just use () as a value
  es <- evolveVerbose g cfg vecPool (baseTime, fitness projDir)

  -- Write result
  let e = snd $ head es :: BangVec
  putStrLn $ "best entity (GA): " ++ (printBits $ toBits e)
  putStrLn ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>"
 
fitness :: FilePath -> BangVec -> IO Time
fitness projDir bangVec = do
    return 4

{-
randomSeed = do
  -- Random seed; credit to Cyrus Cousins
    randomSeed <- (getStdRandom random)
  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  -- Also parse options for genetic algorithm?
    let (useCliSeed, cliSeed) = (False, 0 :: Int)
        seed = if useCliSeed then cliSeed else randomSeed

emain :: IO ()
emain = do
  system "git rev-parse --short HEAD"
  putStr "^git hash\n"
  [projDir, maxPopS, maxGenS, maxArchS] <- getArgs
  let [maxPop, maxGen, maxArch] = map read [maxPopS, maxGenS, maxArchS]
  let cfgs :: [(Int, Int, Int)]
      cfgs = [(pop, gen, arch) | pop <- [1..maxPop], gen <- [1..maxGen], arch <- [maxArch]]
  sequence_ $ map (gmain projDir) cfgs
-}
