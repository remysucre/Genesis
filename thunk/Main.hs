{-# LANGUAGE BangPatterns #-}
module Main (main) where
import Data.List
fib1 0 _ !b = b
fib1 n !a !b = fib1 (n - 1) b (a + b)
fiba = fib1 300000 0 1
fib2 0 _ !b = b
fib2 n a b = fib2 (n - 1) b (a + b)
fibb = fib2 300000 0 1
fib3 0 _ !b = b
fib3 n a !b = fib3 (n - 1) b (a + b)
fibc = fib3 300000 0 1
fib4 0 _ !b = b
fib4 !n !a !b = fib4 (n - 1) b (a + b)
fibd = fib4 300000 0 1
main = do putStrLn $ show (fiba + fibb + fibc + fibd)