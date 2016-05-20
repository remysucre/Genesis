import Language.Haskell.Exts
import System.Environment

main = do
     [path] <- getArgs
     content <- readFile path
     let mode = ParseMode path Haskell2010 [EnableExtension BangPatterns] False False Nothing False
     case parseModuleWithMode mode content of
       ParseFailed _ e -> error e
       ParseOk a       -> print a
