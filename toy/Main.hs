{-# LANGUAGE BangPatterns #-}

x = x + 1

me (a, !b) = a

main = print $ me (1, x)
