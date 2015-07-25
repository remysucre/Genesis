{--
 - Example for GA package
 - see http://hackage.haskell.org/package/GA
 -
 - Evolve the string "Hello World!"
--}

{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}

import Data.Char (chr,ord)
import Data.List (foldl')
import System.Random (mkStdGen, random, randoms)
import System.IO(IOMode(..), hClose, hGetContents, openFile)

import GA (Entity(..), GAConfig(..), 
           evolveVerbose, randomSearch)

--
-- GA TYPE CLASS IMPLEMENTATION
--

type Sentence = String
type Target = String
type Letter = Char

instance Entity Sentence Double Target [Letter] IO where
 
  -- generate a random entity, i.e. a random string
  -- assumption: max. 100 chars, only 'printable' ASCII (first 128)
  genRandom pool seed = return $! e
    where
        g = mkStdGen seed
        e = random g `mod` pool

  -- crossover operator: mix (and trim to shortest entity)
  crossover _ _ seed e1 e2 = return $! Just e
    where
      g = mkStdGen seed
      s = random g -- random sieve to select bits from e1 e2
      e1' = s .&. e1
      e2' = ~s .&. e2
      e = e1' .|. e2'

  -- mutation operator: use next or previous letter randomly and add random characters (max. 9)
  mutation pool p seed e = return $! Just e
    where
      g = mkStdGen seed
      f = round (s / p) :: Int -- bang flips for each mutation
        where s = undefined -- length of pool
      is = -- complement bit

  -- score: improvement on base time
  -- NOTE: lower is better
  score fn e =  undefined -- 1 / seconds faster

  -- whether or not a scored entity is perfect
  isPerfect (_,s) = s == 0.0 -- Never


main :: IO() 
main = do
  -- Obtain basetime and pool

  -- Run Genetic Algorithm
        let cfg = GAConfig 
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
            vecPool = undefined -- largest bit vector of length(placesToStrict)
            baseTime = undefined -- base runtime

        -- Do the evolution!
        -- Note: if either of the last two arguments is unused, just use () as a value
        es <- evolveVerbose g cfg vecPool baseTime
        let e = snd $ head es :: String
        
        putStrLn $ "best entity (GA): " ++ (show e)
