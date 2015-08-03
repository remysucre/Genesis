{-# LANGUAGE BangPatterns #-}

import Data.Data
import Data.Generics.Uniplate.Data
import Control.Monad
import Language.Haskell.Exts

findPats :: Data a => a -> [Pat]
findPats = universeBi

test = do
  content <- readFile "Simple.hs"
  case parseModule content of
    ParseFailed _ e -> error e
    ParseOk a       -> do
      forM_ (findPats a) $ \p -> do
        putStrLn $ "got a pat: " ++ prettyPrint p
main = test
