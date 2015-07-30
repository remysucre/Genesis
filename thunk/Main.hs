{-# LANGUAGE BangPatterns #-}
module Main (main) where
import Data.List
fib 0 _ b = b
fib n a b = fib (n - 1) b (a + b)
fiba = fib 500000 0 1
fo a !b c = a + b + c
foo !a !b !c = a + b + c
f1o !a !b !c = a + b + c
f2o !a !b !c = a + b + c
f3o !a !b !c = a + b + c
f4o !a !b !c = a + b + c
fao !a !b !c = a + b + c
fso !a !b !c = a + b + c
fdo !a !b !c = a + b + c
fro !a !b !c = a + b + c
fto !a !b !c = a + b + c
f5o !a !b !c = a + b + c
f6o !a !b !c = a + b + c
f7o !a !b !c = a + b + c
main = do putStrLn $ show fiba
