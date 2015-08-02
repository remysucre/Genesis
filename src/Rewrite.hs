module Rewrite 
where 
import Types
import Language.Haskell.Exts

strictPts _ _ _ _ _ _ _ decls = foldr (+) 0 strictPts decls 

{- PatBind Match Lambda Proc Generator Alt PatField -}

editBangs = undefined
getModule :: FilePath -> IO Module
getModule filePath = do 
    let bangPatternsExt = parseExtension "BangPatterns"
        mode = ParseMode filePath Haskell2010 [bangPatternsExt] True True Nothing
    program <- readFile filePath
    return $! fromParseResult $ parseFileContentsWithMode mode program
