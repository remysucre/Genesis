{-# LANGUAGE BangPatterns #-}
module Main (main) where
main
  = do let (!x) = 1
       let w = 1
       print 5