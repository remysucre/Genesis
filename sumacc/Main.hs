{-# LANGUAGE BangPatterns #-}

ns = [1..9999999]

sum' :: [Integer] -> Integer -> Integer
sum' [] n = n
sum' (x:xs) n = sum' xs (x + n)

ans = sum' ns 0

main = do
    putStrLn $ show ans

{- This sample leaks space because the accumulating parameter `n` in `sum'` 
builds up thunks. To fix, BangPattern `n`. -}
