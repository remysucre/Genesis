{-# LANGUAGE BangPatterns #-}
module Main (main) where
import Data.List
fib1 0 _ b = b
fib1 n a b = fib1 (n - 1) b (a + b)
fiba = fib1 300000 0 1
main = do putStrLn $ show fiba
