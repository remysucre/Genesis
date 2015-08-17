{-# LANGUAGE BangPatterns #-}

data Thunk a = T (a, Int)
instance Monad Thunk where
  return x = T (x, 0)
  T (x, !n) >>= f = let T (x', m) = f x
  -- T (x, n) >>= f = let T (x', m) = f x
                    in T (x', m + n)

emptyThunk :: Thunk Int
emptyThunk = return 0

increaseThunk :: a -> Thunk a
increaseThunk x = T (x, 1)

buildThunk 0 t = t
buildThunk n !t = buildThunk (n - 1) (t >>= increaseThunk)
-- buildThunk n t = buildThunk (n - 1) (t >>= increaseThunk)

thunk = buildThunk 999998 emptyThunk

T (_, thunkCount) = thunk

main = print thunkCount
