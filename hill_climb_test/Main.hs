{-# LANGUAGE BangPatterns #-}

main :: IO ()
main = do
  let strings = map show [1..200000]
  print $ show $ myFoldl (\(s1:s1s) (s2:s2s) -> [s1,s2]) "ab" strings
  print $ show $ myStrictFoldl (\(s1:s1s) (s2:s2s) -> [s1,s2]) "ab" strings
  

-- A non-strict foldl, should produce a giant expression,
-- unless autobahn is smart enough to put a ! in.
myFoldl f z [] = z
myFoldl f z (x:xs)  = myFoldl f (f z x) xs


-- A stict foldl, hillclimbing should not remove the bang on z
myStrictFoldl f !z [] = z
myStrictFoldl f !z (x:xs) = myStrictFoldl f (f z x) xs
