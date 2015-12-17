{-# LANGUAGE BangPatterns #-}

-- length with accum. param.
f :: [a] -> Int -> Int
f [] c = c
f (x : xs) !c = f xs (c + 1)

main = print (f [1 .. 4000000] (0 :: Int))
