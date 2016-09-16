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
import System.Environment
import System.IO
import System.Process
import System.Directory
import Text.Read
import Control.DeepSeq

reps :: Int64
reps = runs

cfgFile :: FilePath
cfgFile = "config.atb"

type Cfg = (FilePath, Int, Int, Int) -- projDir, pop, gen, arch

readLnWDefault :: Read a => a -> IO a
readLnWDefault def = do
  cont <- getLine
  case readMaybe cont 
    of Nothing -> return def
       Just res -> return res

fitness :: FilePath -> BangVec -> IO Time
fitness projDir bangVec = do
  -- Read original
    let mainPath = projDir ++ "/Main.hs"
    !prog  <- readFile mainPath
  -- Rewrite from gene
    !prog' <- editBangs mainPath (B.toBits bangVec) 
    rnf prog `seq` writeFile mainPath prog'
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

heuristic :: String -> Double -> Double -> Cfg
heuristic projDir baseTime timeLimit = if n > 2 
                                       then (projDir, n+1, n-1, n-2)
                                       else (projDir, n, n, (n-1))
                                       where
                                       n = (round $ timeLimit /  2 * (2 * baseTime)) :: Int
                                           
fromTimeToCfg :: String -> Int -> IO Cfg
fromTimeToCfg projDir timeLimit = do
                          buildProj projDir
                          baseTime <- benchmark projDir reps
                          -- Coerce from Int to Double
                          timeLimit' <- (return $ fromInteger $ toInteger timeLimit) :: IO Double
                          -- Determine the configuration from the time limit and the base time
                          return $ heuristic projDir baseTime timeLimit'

cliCfg :: IO Cfg
cliCfg = do 
  putStrLn "No config.atb file found, please specify parameters as prompted"
  putStrLn "<Enter> to use [defaults]"
  putStr "Time alloted for Autobahn [3h]:" -- TODO add macros for defaults
  timeLimit <- readLnWDefault "3h"
  putStr "Estimated bangs to change (add/remove) [3]:"
  numBangs <- readLnWDefault 3
  putStr "File(s) to add/remove bangs in [\"Main.hs\"]:"
  srcs <- readLnWDefault ["Main.hs"]
  putStr "Performance metric to optimize [\"runtime\"]:"
  metric <- readLnWDefault "runtime"
  putStr "Representative input data & arguments [no input/arguments]:"
  args <- readLnWDefault ([] :: [String])
  putStr "Times to run program for fitness measurement [1]:"
  nRuns <- readLnWDefault 1
  return undefined

readCfg :: FilePath -> IO Cfg
readCfg = undefined

main :: IO () 
main = do 
  hSetBuffering stdout LineBuffering
  print "Configure optimization..."
  cfgExist <- doesFileExist cfgFile
  cfg <- if cfgExist then readCfg cfgFile else cliCfg
  putStrLn "Setting up optimization process..." -- TODO run project to determine GA config
  putStrLn "Starting optimization process..."
  [projDir, pop, gen, arch] <- getArgs
  gmain projDir (read pop, read gen, read arch)
  putStrLn $ "Optimization finished, please inspect and select candidate changes "
        ++ "(found in AutobahnResults under project root)"


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

-- Experiments to tune Genetic Algorithm parameters
--
emain :: IO ()
emain = do
  system "git rev-parse --short HEAD"
  putStr "^git hash\n"
  [projDir, maxPopS, maxGenS, maxArchS] <- getArgs
  let [maxPop, maxGen, maxArch] = map read [maxPopS, maxGenS, maxArchS]
  let cfgs :: [(Int, Int, Int)]
      cfgs = [(pop, gen, arch) | pop <- [1..maxPop], gen <- [1..maxGen], arch <- [maxArch]]
  sequence_ $ map (gmain projDir) cfgs
