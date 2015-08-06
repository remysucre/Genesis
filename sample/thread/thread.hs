{-# LANGUAGE BangPatterns #-}

import Control.Concurrent
import Control.Monad

main = do
    mv <- newMVar [1..1000]
    upgraderThread mv

upgraderThread :: MVar [Int] -> IO ()
upgraderThread chanMVar = forever job
    where
        job = do
            vlist <- takeMVar chanMVar
            let reslist = strictList $ map id vlist
            -- fix: let !reslist = strictList $ map id vlist
            putMVar chanMVar reslist

        strictList xs = if all p xs then xs else []
            where p x = x `seq` True
