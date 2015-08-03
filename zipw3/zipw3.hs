{-# LANGUAGE BangPatterns #-}
import System.Environment (getArgs)

u = (0 :: Int, 1 :: Int):go u
    where
    go ((a,b):abs) = (b + 2 * a, b - 3 * a) : go abs
main = do
    print $ u !! 1999999

{- eval path
-> u !! 9
-> 0:go u !! 9
-> go u !! 8
-> go (0:go u) !! 8
-> (0 + 1) : go (go u) !! 8
-> go (go u) !! 7
-> go (go (0:go u)) !! 7
-> go (0 + 1:go (go u)) !! 7
-> (0 + 1 + 1:go (go (go u))) !! 7
-> (go (go (go u))) !! 6
...
-> go (go ... go u) !! 0
-> head (go (go ... go u))
-> head (go (go ... go 0:go u))
-> head (go .. (0 + 1):go (go u))
...
-> head (0 + 1 + 1 + 1 .. + 1): go .. go u
-> (0 + 1 + 1 + .. + 1)
-> glorious victory

-}

{- `go a = a + 1` creates thunk. This is the first example that causes leak
not in the pattern of accumulating parameter. Another example, sequence causes
leak in a similar fashion, and they both define recursive values. -}
