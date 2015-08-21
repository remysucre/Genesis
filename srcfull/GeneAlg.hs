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
import Control.DeepSeq
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
  genRandom pool _ = return $! pool
  {-genRandom pool seed = do 
    putStrLn $ printBits (toBits e)
    return $! e
    where
      len = size pool
      g = mkStdGen seed 
      fs = take len $ randoms g :: [Float]
      bs = map (< 0.5) fs
      e = fromBits bs `xor` pool-}

  -- Crossover operator 
  -- Merge from two vectors, randomly picking bangs
  crossover pool _ seed e1 e2 = do 
    let len = size pool
        g = mkStdGen seed 
        fs = take len $ randoms g :: [Float]
        bs = map (< 0.5) fs
        s = fromBits bs `xor` pool
        e1' = s .&. e1
        e2' = complement s .&. e2
        e' = e1' .|. e2'
    -- putStrLn $ "cross " ++ printBits (toBits e1) ++ " " ++ printBits (toBits e2) -- ++ "->" ++ printBits (toBits e')
    return $! Just e'

  -- Mutation operator 
  mutation pool p seed e = return $! Just (e + 1)
    -- putStrLn $ "mutate " ++ printBits (toBits e)-- ++ "->" ++ printBits (toBits e')

  -- Improvement on base time
  -- NOTE: lower is better
  score (baseTime, fitRun) bangVec = do 
    newTime <- fitRun bangVec
    let score = (newTime / baseTime)
    putStrLn $ "bits: " ++ printBits (toBits bangVec)
    return $! Just score

  showGeneration _ (_,archive) = "best: " ++ (show fit)
    where
      (Just fit, _) = head archive
