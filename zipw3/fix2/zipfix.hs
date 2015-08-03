{-# LANGUAGE BangPatterns #-}
import System.Environment (getArgs)

u = 0:go u
    where
    go ((!a):as) = a + 1 : go as
main = do
    print $ u !! 1999999

{- `go a = a + 1` creates thunk -}
