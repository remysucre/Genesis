{-# LANGUAGE BangPatterns #-}

{- Imports to deal with GHC warning -}

import Control.Applicative (Applicative(..))
import Control.Monad       (liftM, ap)

instance Functor Thunk where
  fmap = liftM

instance Applicative Thunk where
  !pure  = return
  (<*>) = ap

{- Imports to deal with GHC warning -}

data Thunk a = T (a, Int)

instance Monad Thunk where
  T (x, n) >>= f = 
    let T (x', m) = f x
    in T (x', m + n)

  return x = T (x, 0)

emptyThunk :: Thunk Int
emptyThunk = return 0

buildThunk :: Int -> Thunk a -> Thunk a
buildThunk 0 t = t
buildThunk n t = buildThunk (n - 1) (t >>= increaseThunk)
  where increaseThunk x = T (x, 1)

thunk :: Thunk Int
thunk = buildThunk 1999998 emptyThunk

T (_, thunkCount) = thunk

main = print thunkCount
