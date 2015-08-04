{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
module GeneAlg 
where
import System.Random (mkStdGen, random, randoms)
import GA (Entity(..), GAConfig(..), 
           evolveVerbose, randomSearch)
import Data.BitVector (BV, fromBits, toBits, size, ones)
import Data.Bits.Bitwise (fromListLE, fromListBE, toListBE)
import Data.Bits

--
-- GA TYPE CLASS IMPLEMENTATION
--

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


printBits bs = reverse . concat $ map (\b -> if b then "1" else "0") bs

type BangVec = BV -- TODO BangVec of arbitrary length
type Time = Double
type Score = Double
type FitnessRun = BangVec -> IO Score

instance Read BangVec -- TODO is this ok?
instance Entity BangVec Score (Time, FitnessRun) BangVec IO where
 
  -- generate a random bang vector
  -- invariant: pool is the vector with all bangs on
  genRandom pool seed = do 
    return $! e
    where
        len = size pool
        g = mkStdGen seed -- TODO random bv of arbitrary len
        fs = take len $ randoms g :: [Float]
        bs = map (< 0.5) fs
        e = fromBits bs

  -- crossover operator: merge from two vectors, randomly picking bangs
  crossover p _ seed e1 e2 = do 
    s <- genRandom p seed -- random sieve to select bits from e1 e2
    let e1' = s .&. e1
        e2' = complement s .&. e2
        e = e1' .|. e2'
    return $! Just e

  -- mutation operator: 
  mutation pool p seed e = do 
    return $! Just e'
    where
        len = size e
        g = mkStdGen seed -- TODO random bv of arbitrary len
        fs = take len $ randoms g
        bs = map (< p) fs
        e' = e `xor` fromBits bs

  -- score: improvement on base time
  -- NOTE: lower is better
  -- score _ _ = return $ Just (0.0 :: Score)
  score (baseTime, fitRun) bangVec = do -- 1 / seconds faster
    newTime <- fitRun bangVec
    putStrLn $ printBits (toBits bangVec) ++ ": " ++ show (newTime / baseTime)
    return $! Just (newTime / baseTime)

  -- whether or not a scored entity is perfect
  isPerfect (_,s) = s == 0.0 -- Never

  showGeneration gi g = "gen" ++ show gi -- ++ "\n" ++ intercalate "\n" (map (reverse . printBits) $ fst g)
