import Control.Monad
import Data.Generics.Uniplate.Data
import Language.Haskell.Exts
import Text.Show.Pretty (ppShow)
import Control.Monad.State.Strict

parseHaskell path = do
  content <- readFile path
  let mode = ParseMode path Haskell2010 [EnableExtension BangPatterns] False False Nothing
  case parseModuleWithMode mode content of
    ParseFailed _ e -> error $ path ++ ": " ++ e
    ParseOk a       -> return a

changeBangs bools x = runState (transformBiM go x) bools
  where go pp@(PBangPat p) = do
           (b:bs) <- get
           put bs
           if b
             then return p
             else return pp
        go x = return x

test = do
  a <- parseHaskell "Simple.hs"
  -- putStrLn $ unlines . map ("before: " ++) . lines $ ppShow a
  putStrLn $ prettyPrint a
  let a' = changeBangs [False, False, False, False] a
  putStrLn $ prettyPrint $ fst a'
  -- putStrLn $ unlines . map ("after : " ++) . lines $ ppShow a'

main = test
