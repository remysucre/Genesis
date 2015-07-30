{-# LANGUAGE BangPatterns #-}
module Main (main) where
import Data.List
foo !a !b c = a + b + c
fib 0 _ b = b
fib !n !a !b = fib (n - 1) b (a + b)
fiba = fib 500000 0 1
fo a !b c = a + b + c
main = do putStrLn $ show fiba