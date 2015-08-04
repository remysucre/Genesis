{-# OPTIONS -Wall -Werror -fno-warn-name-shadowing #-}

{--
    Rewrite - Used for changing the strictness in a Haskell program
--}

module Rewrite (
    flipBang
    , flipRandomBang
    , placesToStrict
    , bangVector
    , editBangs
) where

import System.Random
import System.IO.Unsafe
import Language.Haskell.Exts
import Data.BitVector (BV, toBits)
--import Data.Int (Int64)

{-- Set of functions for adding and removing items from syntax tree --}

{- Places a list of declarations into a module -}
setDecl :: Module -> [Decl] -> Module
setDecl (Module src name prags warn exp imp _) ds = Module src name prags warn exp imp ds

{- Retrieves a list of declarations from a module -}
getDecl :: Module -> [Decl]
getDecl (Module _ _ _ _ _ _ d) = d

{- Put a list of patterns into a Match node -}
setPat :: Match -> [Pat] -> Match
setPat (Match loc n _ ty rhs bind) p = Match loc n p ty rhs bind

{- Get a list of patterns from a Match node -}
getPat :: Match -> [Pat]
getPat (Match _ _ p _ _ _) = p

{- Set of functions to count the number of places strictness can be added/removed -}
countBangVar :: [Pat] -> Int
countBangVar [] = 0
countBangVar (p:ps) = case p of
                         PBangPat _ -> 1 + countBangVar ps
                         PVar _     -> 1 + countBangVar ps
                         _  ->     countBangVar ps

bangVarVec :: [Pat] -> [Int]
bangVarVec [] = []
bangVarVec (p:ps) = case p of
                         PBangPat _ -> 1:bangVarVec ps
                         PVar _     -> 0:bangVarVec ps
                         _  ->     bangVarVec ps

countBangMatch :: [Match] -> Int
countBangMatch [] = 0
countBangMatch (m:ms) = (countBangVar $ getPat m) + countBangMatch ms

bangMatchVec :: [Match] -> [Int]
bangMatchVec [] = []
bangMatchVec (m:ms) = (bangVarVec $ getPat m) ++ bangMatchVec ms

countBangDecl :: [Decl] -> Int
countBangDecl [] = 0
countBangDecl (d:ds) = case d of
                            FunBind ms -> countBangMatch ms + countBangDecl ds
                            _  -> countBangDecl ds

bangDeclVec :: [Decl] -> [Int]
bangDeclVec [] = []
bangDeclVec (d:ds) = case d of
                          FunBind ms -> bangMatchVec ms ++ bangDeclVec ds
                          _  -> bangDeclVec ds

{- 
   Set of functions that given an integer i, either adds strictness at 
   the i^th location it can or removes it
-}
flipBangPat :: Int -> [Pat] -> (Int, [Pat])
flipBangPat x [] = (x, [])
flipBangPat 0 (p:ps) = case p of
                            PBangPat pat -> (-1, pat:ps)
                            PVar n       -> (-1, (PBangPat (PVar n)):ps)
                            _    -> let (x, ps') = flipBangPat 0 ps
                                            in (x, p:ps')
flipBangPat x (p:ps) = (y, p:ps')
                       where
                           (y, ps') = case p of
                                           PBangPat _ -> flipBangPat (x-1) ps
                                           PVar _ -> flipBangPat (x-1) ps
                                           _ -> flipBangPat x ps

flipBangMatch :: Int -> [Match] -> (Int, [Match])
flipBangMatch x [] = (x, [])
flipBangMatch (-1) ms = (-1, ms)
flipBangMatch x (m:ms) = (z, m':ms')
                         where
                             (y, ps) = flipBangPat x $ getPat m
                             m' = setPat m ps
                             (z, ms') = flipBangMatch y ms
                             


flipBangDecl :: Int -> [Decl] -> [Decl]
flipBangDecl (-1) ds = ds
flipBangDecl _ [] = error "Not enough Decl to Bang"
flipBangDecl x (d:ds) = case d of
                             FunBind ms -> let (y, ms') = flipBangMatch x ms
                                           in (FunBind $ ms'):(flipBangDecl y ds)
                             _ -> [d] ++ flipBangDecl x ds                          

btn :: [Bool] -> [Int]
btn bs = btn_ (length bs - 1) bs

btn_ :: Int -> [Bool] -> [Int]
btn_ _ [] = []
btn_ i [b] = if b then [i] else []
btn_ i (b:bs) = if b then i:btn_ (i - 1) bs else btn_ (i - 1) bs 

editBangs :: String -> String -> BV -> String
editBangs fp prog vec = program'
    where 
        bools = toBits vec
        nums = btn bools
        flipBang' = flipBang fp
        program' = foldl flipBang' prog nums


{- Either add or remove stricntess from the i^th possible place -}
flipBang :: String -> String -> Int -> String
flipBang filePath program num = program'
                       where
                           mod = getModule filePath program
                           decl' = flipBangDecl num $ getDecl mod
                           program' = prettyPrint $ setDecl mod decl'

{- Either add or remove stricntess from a random possible place -}
flipRandomBang :: String -> String -> (Int, String)
flipRandomBang filePath program = (num + 1, flipBang filePath program num)
                                  where
                                      range = (0, placesToStrict filePath program)
                                      num = (unsafePerformIO $ getStdRandom (randomR range)) - 1

{- Return how many places one can add or remove strictness  -}
placesToStrict :: String -> String -> Int
placesToStrict filePath program = num
                                  where
                                      mod = getModule filePath program
                                      num = countBangDecl $ getDecl mod
bangVector :: FilePath -> String -> [Int]
bangVector fp prog = vec
                     where
                        mod = getModule fp prog
                        vec = bangDeclVec $ getDecl mod

{- Get the module from a program -}
getModule :: String -> String -> Module
getModule filePath program = fromParseResult $ parseFileContentsWithMode mode program
                             where
                                      bangPatternsExt = parseExtension "BangPatterns"
                                      mode = ParseMode filePath Haskell2010 [bangPatternsExt] True True Nothing

{- Functions to print out parts of the syntax tree -}
                                      
{-
-- Print lists as an IO action
showList' :: Show a => Int -> [a] -> IO ()
showList' _ [] = return ()
showList' i (x:xs) = putStrLn ((show i) ++ ": " ++ (show x)) >> showList' (i+1) xs
-}

{- Two functions to print all patterns in a program -}
{-
showMatches :: Int -> [Match] -> IO ()
showMatches _ [] = return ()
showMatches i (m:_) = showList' (10 * i) (getPat m)


showFunBinds :: Int -> [Decl] -> IO ()
showFunBinds _ [] = return ()
showFunBinds i (x:xs) = case x of
                             FunBind ls -> showMatches (10 * i) ls >> showFunBinds (i+1) xs
                             _ -> showFunBinds i xs
-}

{- main used for testing the Rewrite module -}
{-
main :: IO ()
main = writeFile tempPath $ snd $ flipRandomBang filePath fileContents
       where
         filePath = "B.hs"
         fileContents = unsafePerformIO $ readFile filePath
         tempPath = "temp.hs"
-}
