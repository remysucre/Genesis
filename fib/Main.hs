{-# LANGUAGE BangPatterns #-}

-- Fibonnacci sequence with accum. param.
fib :: Int -> Integer -> Integer -> Integer
fib 0 _ b = b
fib n d c = fib (n - 1) c (d + c)

main = print $ fib 300000 0 1
