{-# LANGUAGE BangPatterns #-}

sum' :: [Integer] -> Integer -> Integer
sum' [] n = n
sum' (!x:xs) !n = sum' xs (x + n)

ns = [1..9999999]

ans = sum' ns 0

main = do
    putStrLn $ show ans
