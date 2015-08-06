{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}

module GeneAlg where

import System.Random (mkStdGen, random, randoms)
import GA (Entity(..), GAConfig(..), evolveVerbose, randomSearch)
import Data.BitVector (BV, fromBits, toBits, size, ones)
import Data.Bits.Bitwise (fromListLE, fromListBE, toListBE)
import Data.Bits
import Data.List
import Config

--
-- GA TYPE CLASS IMPLEMENTATION
--

type BangVec = BV 
type Time = Double
type Score = Double
type FitnessRun = BangVec -> IO Score
instance Read BangVec -- TODO is this ok?

printBits :: [Bool] -> String
printBits = concatMap (\b -> if b then "1" else "0")

instance Entity BangVec Score (Time, FitnessRun) BangVec IO where
 
  -- Generate a random bang vector
  -- Invariant: pool is the vector with all bangs on
  genRandom pool seed = do 
    putStrLn $ printBits (toBits e)
    return $! e
    where
      len = size pool
      g = mkStdGen seed 
      fs = take len $ randoms g :: [Float]
      bs = map (< 0.5) fs
      e = fromBits bs `xor` pool

  -- Crossover operator 
  -- Merge from two vectors, randomly picking bangs
  crossover p _ seed e1 e2 = do 
    s <- genRandom p seed 
    let e1' = s .&. e1
        e2' = complement s .&. e2
        e' = e1' .|. e2'
    putStrLn $ "cross" ++ printBits (toBits e1) ++ " " ++ printBits (toBits e2) ++ "->" ++ printBits (toBits e')
    return $! Just e'

  -- Mutation operator 
  mutation pool p seed e = do 
    putStrLn $ "mutate" ++ printBits (toBits e) ++ "->" ++ printBits (toBits e')
    return $! Just e'
    where
      len = size e
      g = mkStdGen seed
      fs = take len $ randoms g
      bs = map (< p) fs
      e' = e `xor` fromBits bs

  -- Improvement on base time
  -- NOTE: lower is better
  score (baseTime, fitRun) bangVec = do 
    newTime <- fitRun bangVec
    let score = (newTime / baseTime)
    putStrLn $ printBits (toBits bangVec) ++ ": " ++ show score
    return $! Just score
