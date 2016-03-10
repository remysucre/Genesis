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
import Data.List
import System.Directory
import System.Environment
import System.Process
import Control.DeepSeq
import Control.Monad

reps :: Int64
reps = runs

fitness :: FilePath -> [FilePath] -> Time -> [BangVec] -> IO Time
fitness projDir srcs baseTime bangVecs = do
  -- Read original
    !progs  <- sequence $ map readFile srcs
  -- Rewrite according to gene
  -- DEBUG --  print "bangvecis"
  -- DEBUG -- putStrLn $ concat srcs
    !progs' <- sequence $ zipWith editBangs srcs (map B.toBits bangVecs) 
    rnf progs `seq` sequence $ zipWith writeFile srcs progs'
    -- print prog'
  -- Benchmark new
  -- buildProj projDir
    !newTime <- benchmark projDir reps baseTime
  -- Recover original
    !_ <- sequence $ zipWith writeFile srcs progs
    putStrLn $ (concat $ intersperse "," $ map (printBits . B.toBits) bangVecs) ++ " " ++ show newTime
    return newTime

    {-
  -- Random seed; credit to Cyrus Cousins
    randomSeed <- (getStdRandom random)
  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  -- Also parse options for genetic algorithm?
    let (useCliSeed, cliSeed) = (False, 0 :: Int)
        seed = if useCliSeed then cliSeed else randomSeed-}

main :: IO () 
main = do 
  [projDir, pop, gen, arch] <- getArgs
  gmain projDir (read pop, read gen, read arch)

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
    baseTime <- benchmark projDir reps (0 - 1)
    -- let mainPath = projDir ++ "/Main.hs" -- MULTI TODO assuming only one file per project
    files <- getDirectoryContents projDir
    let srcPaths = filter (isSuffixOf ".hs") files
    --let srcPaths = [mainsrcs]
    -- putStr "Basetime is: "; print baseTime
    putStr "Basetime is: "; print baseTime

  -- Pool: bit vector representing original progam
    progs <- sequence $ map readFile srcPaths 
    -- vecSize <- rnf prog `seq` placesToStrict mainPath
    bs <- sequence $ map readBangs srcPaths
    let !vecPool = rnf progs `seq` map B.fromBits bs :: [B.BV]
    -- DEBUG -- print $ map B.toBits vecPool

  -- Do the evolution!
  -- Note: if either of the last two arguments is unused, just use () as a value
    es <- evolveVerbose g cfg vecPool (baseTime, fitness projDir srcPaths baseTime)
    let e = snd $ head es 
    prog' <- sequence $ map (\(src, bangs) -> editBangs src (B.toBits bangs)) (zip srcPaths e)

  -- Write result
    -- putStrLn $ "best entity (GA): " ++ (printBits $ B.toBits e)
    --putStrLn prog'
    -- let survivorPath = projDir ++ "/geneticSurvivor"
    -- writeFile survivorPath prog'
    -- writeFile mainPath prog
    putStrLn ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>"
