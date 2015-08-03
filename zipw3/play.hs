{-# LANGUAGE BangPatterns #-}
import System.Environment (getArgs)

u = 0:map (+ 1) u
main = do
    print $ u !! 1999999

{- `go a = a + 1` creates thunk. This is the first example that causes leak
not in the pattern of accumulating parameter. Another example, sequence causes
leak in a similar fashion, and they both use mutual recursion. -}
