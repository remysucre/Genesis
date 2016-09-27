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

import Debug.Trace

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

main :: IO () 
main = do 
  [projDir, pop, gen, arch] <- getArgs
  gmain projDir (read pop, read gen, read arch)

gmain :: Cfg -> IO ()
gmain autobahnCfg = do
    let projDir = projectDir autobahnCfg
        cfg = createGAConfig autobahnCfg
        metric = fitnessMetric autobahnCfg
        files = coverage autobahnCfg
        fitnessReps = fitnessRuns autobahnCfg
        args = inputArgs autobahnCfg
        baseTime  = getBaseTime autobahnCfg
        baseMetric  = getBaseMetric autobahnCfg
    putStrLn $ "Optimizing " ++ projDir
    putStrLn $ ">>>>>>>>>>>>>>>START OPTIMIZATION>>>>>>>>>>>>>>>"
    putStrLn $ "pop: " ++ (show $ pop autobahnCfg)
    putStrLn $ "gens: " ++ (show $ gen autobahnCfg)
    putStrLn $ "arch: " ++ (show $ arch autobahnCfg)
  -- Configurations
    -- [projDir, popS, gensS, archS] <- getArgs
    -- let [pop, gens, arch] = map read [popS, gensS, archS]
    
  -- TODO for the future, check out criterion `measure`
  -- Get base time and pool. 

    checkBaseProgram baseTime baseMetric
    
    let absPaths = map (\x -> projDir ++ "/" ++ x) files
        fitnessTimeLimit = deriveFitnessTimeLimit baseTime
    -- putStr "Basetime is: "; print baseTime
    putStr "Basetime is: "; print baseTime

  -- Pool: bit vector representing original progam
    progs <- sequence $ map readFile absPaths
    -- vecSize <- rnf prog `seq` placesToStrict mainPath
    bs <- sequence $ map readBangs absPaths
    let !vecPool = rnf progs `seq` map B.fromBits bs

  -- Do the evolution!
  -- Note: if either of the last two arguments is unused, just use () as a value
    es <- evolveVerbose g cfg vecPool (baseMetric,
                                       fitness projDir args fitnessTimeLimit fitnessReps metric files)
    let e = snd $ head es :: [BangVec]
    progs' <- sequence $ map (uncurry editBangs) $ zip absPaths (map B.toBits e)

  -- Write result
    putStrLn $ "best entity (GA): " ++ (unlines $ (map (printBits . B.toBits) e))
    --putStrLn prog'
    newPath <- return $ projDir ++ "/" ++ "autobahn-survivor"
    code <- system $ "mkdir -p " ++ newPath
    
    let survivorPaths = map (\x -> projDir ++ "/" ++ "autobahn-survivor/" ++ x) files
    sequence $ map (uncurry writeFile) $ zip survivorPaths progs'
    putStrLn ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>"

      -- Write result page
    es' <- return $ filter (\x -> fst x /= Nothing) es
    bangs <- return $ (map snd es') :: IO [[BangVec]]
    newFps <- createResultDirForAll projDir absPaths bangs
    f <- return $ map fst es'
    scores <- return $ map getScore f
    genResultPage projDir scores newFps projDir Nothing cfg 0.0 1

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

    prog' <- editBangs mainPath bangVec

    -- Write result
    putStrLn $ "best entity (GA): " ++ (printBits bangVec)
    --putStrLn prog'
    let survivorPath = projDir ++ "Survivor.hs"
    writeFile survivorPath prog'
   

    return ()
