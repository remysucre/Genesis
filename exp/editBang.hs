{-# LANGUAGE BangPatterns #-}

import Control.Monad
import Control.Monad
import Data.Data
import Data.Generics.Uniplate.Data
import Language.Haskell.Exts
import Text.Show.Pretty (ppShow)
import Control.Monad.State.Strict

placesToStrict :: String -> IO Int
placesToStrict fp = do
  content <- readFile fp
  case parseModule content of
    ParseFailed _ e -> error e
    ParseOk a       -> return $ length $ findPats a 

findPats :: Data a => a -> [Pat]
findPats = universeBi

editBangs :: String -> [Bool] -> IO String
editBangs path vec = do
  content <- readFile path
  let mode = ParseMode path Haskell2010 [EnableExtension BangPatterns] False False Nothing
  case parseModuleWithMode mode content of
    ParseFailed _ e -> error $ path ++ ": " ++ e
    ParseOk a       -> return $ prettyPrint $ stripTop $ fst $ changeBangs vec a

changeBangs :: [Bool] -> Module -> (Module, [Bool])
changeBangs bools x = runState (transformBiM go x) bools
  where go pb@(PBangPat p) = do
           (b:bs) <- get
           put bs
           if b
             then return (PBangPat p)
             else return pb
        go pp = do
           (b:bs) <- get
           put bs
           if b
             then return (PParen (PBangPat pp))
             else return pp

stripTop :: Module -> Module
stripTop (Module a b c d e f decls) = Module a b c d e f (map rmBang decls)
    where rmBang (PatBind x (PParen (PBangPat pb)) y z) = PatBind x pb y z
          rmBang x = x

main = do
    s <- editBangs "Simple.hs" (repeat True)
    putStrLn s
