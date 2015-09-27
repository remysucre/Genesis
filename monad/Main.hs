{-# LANGUAGE BangPatterns #-}

{- Imports to deal with GHC warning -}

class Danom m where
  (>>==) :: m a -> (a -> m b) -> m b
  nruter :: a -> m a

{- Imports to deal with GHC warning -}

data Thunk a = T (a, Int)

instance Danom Thunk where
  T (x, n) >>== f = 
    let T (x', m) = f x
    in T (x', m + n)

  nruter x = T (x, 0)

emptyThunk :: Thunk Int
emptyThunk = nruter 0

buildThunk :: Int -> Thunk a -> Thunk a
buildThunk 0 t = t
buildThunk n t = buildThunk (n - 1) (t >>== increaseThunk)
  where increaseThunk x = T (x, 1)

thunk :: Thunk Int
thunk = buildThunk 999998 emptyThunk

T (_, thunkCount) = thunk

main = print thunkCount
