{--
 - Example for GA package
 - see http://hackage.haskell.org/package/GA
 -
 - Evolve the string "Hello World!"
--}

{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE BangPatterns #-}
import Criterion.Measurement
import Criterion.Main
import Criterion.Types (measCpuTime, measTime)
import System.Process
import System.Environment
import Data.Char (chr,ord)
import Data.List (foldl')
import System.Random (mkStdGen, random, randoms)
import System.IO(IOMode(..), hClose, hGetContents, openFile)
import GA (Entity(..), GAConfig(..), 
           evolveVerbose, randomSearch)
import Rewrite (placesToStrict, editBangs)
import Data.Bits
import Data.Char (intToDigit)
import Data.Functor
import Control.Applicative
import qualified Data.Text.IO as T
import Data.Text (unpack, pack)
import Numeric (showHex, showIntAtBase)
import Control.DeepSeq
import System.IO.Unsafe
import Debug.Trace

-- 
-- BUILD AND RUN PROGRAM
-- 

-- build a cabal project. project must be configured with cabal. projDir is in the current dir
-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
buildProj projDir = system $ "cd " ++ projDir ++ "; cabal build"
benchmark projDir runs = {-trace (unsafePerformIO runProj)-} measure (nfIO runProj) runs -- TODO change 4 to runs
    where
        -- runProj = callCommand $ "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir ++ "> /dev/null"
        runProj = readProcess ("./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir) [] ""
        

--
-- GA TYPE CLASS IMPLEMENTATION
--

type BangVec = Int
type Time = Double
type Score = Double

instance Entity BangVec Score (Time, FilePath) BangVec IO where
 
  -- generate a random bang vector
  -- invariant: pool is the vector with all bangs on
  genRandom pool seed = return $! e
    where
        g = mkStdGen seed
        e = (fst $ random g) `mod` (pool + 1)

  -- crossover operator: merge from two vectors, randomly picking bangs
  crossover _ _ _ e _ = return $! Just e
  {- crossover _ _ seed e1 e2 = return $! Just e
    where
      g = mkStdGen seed
      s = random g -- random sieve to select bits from e1 e2
      e1' = s .&. e1
      e2' = ~s .&. e2
      e = e1' .|. e2' -}

  -- mutation operator: 
  mutation _ _ _ e = return $! Just e
  {- mutation pool p seed e = return $! Just e
    where
      g = mkStdGen seed
      f = round (s / p) :: Int -- bang flips for each mutation
        where s = undefined -- length of pool
      is = -- complement bit -}

  -- score: improvement on base time
  -- NOTE: lower is better
  -- score _ _ = return $ Just (0.0 :: Score)
  score (baseTime, projDir) bangVec = do -- 1 / seconds faster
  -- rewrite program, recompile & run
  -- TODO currently overwrite original
    let mainPath = projDir ++ "/Main.hs"
    prog <- unpack <$> T.readFile mainPath
    let prog' = editBangs mainPath prog bangVec -- TODO unsafeperformIO hidden! 
    T.writeFile mainPath (pack prog')
    buildProj projDir
    (m, _) <- benchmark projDir 4 -- TODO change 4 to runs
    let newTime = measTime m
    return $! Just (newTime / baseTime) -- TODO make sure time is right

  -- whether or not a scored entity is perfect
  isPerfect (_,s) = s == 0.0 -- Never


main :: IO() 
main = do
        print "Please provide project path"; [projDir] <- getArgs
  -- get base time and pool. for the future, check out criterion `measure`
  -- obtain base time: compile & run
        buildProj projDir
        -- (m, _) <- measure (whnfIO $ runProj projDir) 4 -- TODO change 4 to runs
        (m, _) <- benchmark projDir 4 -- TODO change 4 to runs
        let baseTime = measTime m
            mainPath = projDir ++ "/Main.hs" -- TODO assuming only one file per project
        putStr "Basetime is: "; print baseTime
  -- pool: bit vector representing places to strict w/ all bits on
        prog <- readFile mainPath
        let vecSize = placesToStrict mainPath prog 
            vecPool = bit vecSize - 1 :: BangVec 
        -- putStrLn $ showIntAtBase 2 intToDigit vecPool "" 
        -- print vecSize

  -- Run Genetic Algorithm
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

        -- Do the evolution!
        -- Note: if either of the last two arguments is unused, just use () as a value
        es <- evolveVerbose g cfg vecPool (baseTime, projDir)
        let e = snd $ head es :: BangVec
            prog' = editBangs mainPath prog e -- TODO unsafeperformIO hidden! 
        
        putStrLn $ "best entity (GA): " ++ (show e)
        T.writeFile mainPath (pack prog')
