{-# LANGUAGE BangPatterns #-}
module Main (main) where
import Data.List
fib 0 _ !b = b
fib !n a b = fib (n - 1) b (a + b)
fiba = fib 500000 0 1
main = do putStrLn $ show fiba