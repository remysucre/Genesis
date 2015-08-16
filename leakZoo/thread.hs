{-# LANGUAGE BangPatterns #-}

import Control.Concurrent
import Control.Monad

main = do
    mv <- newMVar [1..1000]
    upgraderThread mv 100000

upgraderThread :: MVar [Int] -> Int -> IO ()
upgraderThread chanMVar 0 = do
  ns <- readMVar chanMVar
  print ns
upgraderThread chanMVar n = do job
    where
        job = do
            vlist <- takeMVar chanMVar
            let reslist = strictList $ map id vlist
            -- let !reslist = strictList $ map id vlist
            putMVar chanMVar reslist
            upgraderThread chanMVar (n - 1)

        strictList xs = if all p xs then xs else []
            where p x = x `seq` True
