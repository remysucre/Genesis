btn :: [Bool] -> [Int]
btn bs = btn_ (length bs - 1) bs

btn_ :: Int -> [Bool] -> [Int]
btn_ i [b] = if b then [i] else []
btn_ i (b:bs) = if b then i:btn_ (i - 1) bs else btn_ (i - 1) bs 
