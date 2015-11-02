module Haha where

lol = do
  print $ fib 990000 0 1

fib :: Int -> Integer -> Integer -> Integer
fib 0 _ b = b
fib n a b = fib (n - 1) b (a + b)
