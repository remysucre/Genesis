{-# LANGUAGE BangPatterns #-}
module Main (main) where
import Harness
main = print (f [1 .. 4000000] (0 :: Int))
f [] c = c
f (x : xs) c = f xs (c + 1)
