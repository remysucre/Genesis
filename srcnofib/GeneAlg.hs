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
import Control.Monad
import Config

--
-- GA TYPE CLASS IMPLEMENTATION
--

type BangVec = BV 
type Time = Double
type Score = Double
type FitnessRun = [BangVec] -> IO Score
instance Read BangVec -- TODO is this ok?
instance Bits [BV] where
  (a : as) .&. (b : bs) = (a .&. b) : (as .&. bs) 
  (a : as) .|. (b : bs) = (a .|. b) : (as .|. bs) 
  (a : as) `xor` (b : bs) = (a `xor` b) : (as `xor` bs) 
  complement as = map complement as

printBits :: [Bool] -> String
printBits = concatMap (\b -> if b then "1" else "0")

instance Entity [BangVec] Score (Time, FitnessRun) [BangVec] IO where
 
  -- Generate a random bang vector
  -- Invariant: pool is the vector with all bangs on
  genRandom pool seed = do {Just e <- mutation pool 0.4 seed pool; return e} -- TODO hardcode mutation rate
  {-genRandom pool seed = do 
    print "genRandom"
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
  -- TODO PICK UP HERE
  crossover pool _ seed e1 e2 = do 
    let lens = map size pool
        g = mkStdGen seed 
        fss = map (\l -> take l $ randoms g) lens :: [[Float]]
        bss = map (\fs -> map (< 0.5) fs) fss
        ss = map fromBits bss
        e1' = zipWith (.&.) ss e1 :: [BV]
        e2' = zipWith (.&.) (complement ss) e2 :: [BV]
        e' = zipWith (.|.) e1' e2'
    putStrLn $ "cross " ++ concat (map (printBits . toBits) e1) ++ " " ++ concat (map (printBits . toBits) e2) ++ "->" ++ concat (map (printBits . toBits) e')
    return $! Just e'

  {- crossover pool _ seed e1 e2 = do 
    let len = size pool
        g = mkStdGen seed 
        fs = take len $ randoms g :: [Float]
        bs = map (< 0.5) fs
        s = fromBits bs `xor` pool
        e1' = s .&. e1
        e2' = complement s .&. e2
        e' = e1' .|. e2'
    -- putStrLn $ "cross " ++ printBits (toBits e1) ++ " " ++ printBits (toBits e2) -- ++ "->" ++ printBits (toBits e')
    return $! Just e' -}

  -- Mutation operator 
  mutation pool p seed e = do 
    putStrLn $ "mutate " ++ concat (map (printBits . toBits) e) ++ "->" ++ concat (map (printBits . toBits) e')
    print fss
    print bss
    map size e `seq` return $! Just e'
    where
      lens = map size e
      g = mkStdGen seed
      fss = map (\l -> take l $ randoms g) lens
      bss = map (map (< p)) fss
      e' = zipWith xor e (map fromBits bss)

  -- Improvement on base time
  -- NOTE: lower is better
  score (baseTime, fitRun) bangVec = do 
    newTime <- fitRun bangVec
    let score = (newTime / baseTime)
    putStrLn $ "bits: " ++ concat (map (printBits . toBits) bangVec)
    return $! Just score

  showGeneration _ (_,archive) = "best: " ++ (show fit)
    where
      (Just fit, _) = head archive
