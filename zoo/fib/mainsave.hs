{-# LANGUAGE BangPatterns #-}
module Main (main) where
 
fib :: Int -> Integer -> Integer -> Integer
fib 0 _ b = b
fib n d c = fib (n - 1) c (d + c)
main = print $ fib 300000 0 1
