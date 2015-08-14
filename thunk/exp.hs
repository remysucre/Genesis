{-# LANGUAGE BangPatterns #-}
f :: Integer -> Int
f x = if x >= 0 then f (x + 1) else 0

fun !n = 0

main = print $ fun $ f 0
