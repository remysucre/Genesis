{-# LANGUAGE BangPatterns #-}
import Rewrite (placesToStrict, editBangs)
import Profiling
import GeneAlg

import GA
import Data.BitVector (BV, fromBits, toBits, size, ones)
import System.Environment

fitness :: FilePath -> BangVec -> IO Time
fitness projDir bangVec = do
    let mainPath = projDir ++ "/Main.hs"
    prog  <- readFile mainPath
    prog' <- editBangs mainPath (toBits bangVec) 
    length prog' `seq` writeFile mainPath prog'
    buildProj projDir
    newTime <- benchmark projDir 4 -- TODO change 4 to runs
    putStrLn prog'
    writeFile mainPath prog
    return $! newTime

    {-
  -- Random seed; credit to Cyrus Cousins
    randomSeed <- (getStdRandom random)
  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  -- Also parse options for genetic algorithm?
    let (useCliSeed, cliSeed) = (False, 0 :: Int)
        seed = if useCliSeed then cliSeed else randomSeed-}

main :: IO() 
main = do 

    [projDir] <- getArgs

  -- get base time and pool. for the future, check out criterion `measure`
  -- obtain base time: compile & run
    buildProj projDir
    baseTime <- benchmark projDir 4 -- TODO change 4 to runs
    let mainPath = projDir ++ "/Main.hs" -- TODO assuming only one file per project
    putStr "Basetime is: "; print baseTime

  -- pool: bit vector representing places to strict w/ all bits on
    prog <- readFile mainPath
    let vecSize = placesToStrict mainPath prog 
        vecPool = ones vecSize 

  -- Do the evolution!
  -- Note: if either of the last two arguments is unused, just use () as a value
    es <- evolveVerbose g cfg vecPool (baseTime, fitness projDir)
    let e = snd $ head es :: BangVec
    prog' <- editBangs mainPath (toBits e)

  -- Write result
    putStrLn $ "best entity (GA): " ++ (printBits $ toBits e)
    putStrLn prog'
    writeFile mainPath prog
