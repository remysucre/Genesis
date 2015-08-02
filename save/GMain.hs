{-# OPTIONS -Wall -Werror -fno-warn-name-shadowing -XBangPatterns -fno-warn-unused-do-bind #-}

module Main
where

import Genetic
import System.Directory (createDirectoryIfMissing)
import Debug.Trace

{- TODO: 
* Clean codes
* Put parameters in a config file -}

main :: IO ()
main = do 
          createDirectoryIfMissing True "files"
          gene0 <- createGeneFromFile filePath {- create initial gene, which contains original source and no Bang flipped. -}
          compile $ path $ head $ getStrand gene0
          print "Obtaining base time of program"
          !time' <- fitness fitnessRuns 100 gene0
          let time = if time' < 0.0 then 100 else time'
          print $ "Base time is " ++ (show time)
          dnas <- trace (show time) $ geneticAlg [gene0] runs time fitnessRuns poolSize ((GR gene0 time), 0) emptyGeneDict
          -- TRACE IS IMPURE
          print $ "Best found: " ++ (show $ getStrand $ head dnas)
        where
           filePath = "files.txt"
           runs = 50
           fitnessRuns = 5
           poolSize = 5
