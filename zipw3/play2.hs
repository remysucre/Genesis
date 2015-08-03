{-# LANGUAGE BangPatterns #-}
u = 7:go u
    where
       go ((a):as) = a:go as

main = do
    print $ u !! 99999999
