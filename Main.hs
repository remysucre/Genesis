{--
 - Example for GA package
 - see http://hackage.haskell.org/package/GA
 -
 - Evolve the string "Hello World!"
--}

{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
import Criterion.Measurement
import Criterion.Main
import Criterion.Types (measCpuTime)
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
import Numeric (showHex, showIntAtBase)

--
-- GA TYPE CLASS IMPLEMENTATION
--

type BangVec = Int
type Time = Double
type Score = Double

instance Entity BangVec Score Time BangVec IO where
 
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
  score _ _ = return $ Just (0.0 :: Score)
  -- score baseTime e = do -- 1 / seconds faster
  -- rewrite program, recompile & run
      

  -- whether or not a scored entity is perfect
  isPerfect (_,s) = s == 0.0 -- Never


main :: IO() 
main = do
        print "Please provide project path"; [projDir] <- getArgs
  -- get base time and pool. for the future, check out criterion `measure`
  -- obtain base time: compile & run
        system $ "cd " ++ projDir ++ "; cabal build"
        let runProj = system $ "cd " ++ projDir ++ "; cabal run > /dev/null"
        (m, _) <- measure (whnfIO runProj) 4 -- TODO change 4 to runs
        let baseTime = measCpuTime m
        putStr "Basetime is: "; print baseTime
  -- pool: largest bit vector of length (placesToStrict)
        prog <- readFile $ projDir ++ "/Main.hs"
        let vecSize = placesToStrict (projDir ++ "/Main.hs") prog --TODO assuming only one file named Main
            vecPool = bit vecSize - 1 :: BangVec 
        -- putStrLn $ showIntAtBase 2 intToDigit vecPool "" 
        -- print vecSize

  -- Run Genetic Algorithm
            cfg = GAConfig 
                    1000 -- population size
                    55 -- archive size (best entities to keep track of)
                    350 -- maximum number of generations
                    0.8 -- crossover rate (% of entities by crossover)
                    0.2 -- mutation rate (% of entities by mutation)
                    0.0 -- parameter for crossover (not used here)
                    0.2 -- parameter for mutation (% of flipped letters)
                    False -- whether or not to use checkpointing
                    False -- don't rescore archive in each generation

            g = mkStdGen 0 -- random generator

            -- pool to pick from:
            -- vecPool = undefined -- largest bit vector of length(placesToStrict)
            -- baseTime = undefined -- base runtime
            -- baseTime = 1.2 :: Time -- base runtime

        -- Do the evolution!
        -- Note: if either of the last two arguments is unused, just use () as a value
        es <- evolveVerbose g cfg vecPool baseTime
        let e = snd $ head es :: BangVec
        
        putStrLn $ "best entity (GA): " ++ (show e)
