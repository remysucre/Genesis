{-# LANGUAGE BangPatterns #-}

import Rewrite
import Profiling
import GeneAlg
import Config
------
import GA
import qualified Data.BitVector as B
import Data.Bits
import Data.Int
import Debug.Trace
import System.Environment
import System.Process
import Control.DeepSeq
import HillClimbing 

reps :: Int64
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

data Search = Genetic 
            | HillClimbing

main :: IO () 
main = do 
  [projDir, pop, gen, arch] <- getArgs

  let search = "hillclimb"

  if search == "Genetic" then
    gmain projDir (read pop, read gen, read arch)
  else 
    hillClimbMain projDir

emain :: IO ()
emain = do
  system "git rev-parse --short HEAD"
  putStr "^git hash\n"
  [projDir, maxPopS, maxGenS, maxArchS] <- getArgs
  let [maxPop, maxGen, maxArch] = map read [maxPopS, maxGenS, maxArchS]
  let cfgs :: [(Int, Int, Int)]
      cfgs = [(pop, gen, arch) | pop <- [1..maxPop], gen <- [1..maxGen], arch <- [maxArch]]
  sequence_ $ map (gmain projDir) cfgs


gmain :: String -> (Int, Int, Int) -> IO ()
gmain projDir (pop, gens, arch) = do 
    putStrLn $ "Optimizing " ++ projDir
    putStrLn $ ">>>>>>>>>>>>>>>START OPTIMIZATION>>>>>>>>>>>>>>>"
    putStrLn $ "pop: " ++ show pop 
    putStrLn $ "gens: " ++ show gens
    putStrLn $ "arch: " ++ show arch 
  -- Configurations
    -- [projDir, popS, gensS, archS] <- getArgs
    -- let [pop, gens, arch] = map read [popS, gensS, archS]
    let  cfg = GAConfig pop arch gens crossRate muteRate crossParam muteParam checkpoint rescoreArc

  -- TODO for the future, check out criterion `measure`
  -- Get base time and pool. 
  -- Obtain base time: compile & run
    buildProj projDir
    baseTime <- benchmark projDir reps
    let mainPath = projDir ++ "/Main.hs" -- TODO assuming only one file per project
    -- putStr "Basetime is: "; print baseTime
    putStr "Basetime is: "; print baseTime

  -- Pool: bit vector representing original progam
    prog <- readFile mainPath
    -- vecSize <- rnf prog `seq` placesToStrict mainPath
    bs <- readBangs mainPath
    let !vecPool = rnf prog `seq` B.fromBits bs

  -- Do the evolution!
  -- Note: if either of the last two arguments is unused, just use () as a value
    es <- evolveVerbose g cfg vecPool (baseTime, fitness projDir)
    let e = snd $ head es :: BangVec
    prog' <- editBangs mainPath (B.toBits e)

  -- Write result
    putStrLn $ "best entity (GA): " ++ (printBits $ B.toBits e)
    --putStrLn prog'
    let survivorPath = projDir ++ "Survivor.hs"
    writeFile survivorPath prog'
    putStrLn ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>"


hillClimbMain :: String -> IO ()
hillClimbMain projDir = do
    trace ("Building project " ++ show projDir) $ buildProj projDir
    let mainPath = projDir ++ "/Main.hs" -- TODO assuming only one file per project

    prog <- readFile mainPath
    bs <- readBangs mainPath

    bangVec  <- trace "Begining hill climbing" $ hillClimb bs (\bits -> fitness projDir (B.fromBits bits))


    -- Note, we need to make a program' first
    putStrLn ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>"
    putStrLn $ "Resulting bang vector: " ++ show bangVec


    return ()
