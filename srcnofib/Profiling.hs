{-# LANGUAGE BangPatterns #-}

module Profiling where

import Control.DeepSeq
import Data.Int
import System.Process
import System.Exit
import System.Timeout
import System.Directory
import GHC.Stats
-- import Criterion.Main
-- import Criterion.Measurement
-- import Criterion.Types (measTime, measAllocated, fromInt)

worstScore :: Double
worstScore = 9999999

pathToNoFib :: String
pathToNoFib = "~"

-- 
-- PROFILING EXTERNAL PROJECT
--

-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
-- Build a cabal project. Project must be configured with cabal. `projDir` is in the current dir
buildProj :: FilePath -> IO ExitCode
-- buildProj projDir = system $ "cd " ++ projDir ++ "; cabal configure -v0; cabal build -v0"
buildProj projDir = do 
  setCurrentDirectory projDir
  system "make clean -s; make boot -s"

-- TODO use current working dir and save compile command in config.hs

-- Time a project
instance NFData ExitCode
  where 
    rnf ExitSuccess = ()
    rnf (ExitFailure _) = ()

runProj :: FilePath -> Int64 -> IO Double
runProj projDir runs = do

  -- result is (Maybe ExitCode)
  --  result <- timeout 17000000 $ system "make -k mode=slow > nofib-gen 2>&1 "
  result <- timeout 17000000 $ system "make -k mode=slow &> nofib-gen "   

  case result of
       Nothing -> return worstScore
       Just (ExitFailure _) -> return worstScore
       Just ExitSuccess ->  do {
       	    		       system $ pathToNoFib ++ "/nofib/nofib-analyse/nofib-analyse --csv=Allocs nofib-gen nofib-gen > temp.prof"; -- TODO heuristcs hardcoded
			       
       	    		       -- TODO dirty hack here! anusing nofib-analyse
			       fc <- readFile "temp.prof";
			       let wcs = words $ map (\c -> if c == ',' then ' ' else c) fc
			       -- system "rm nofib-gen; rm temp.prof"
			       in return . read $ wcs !! 1
                               }

benchmark :: FilePath -> Int64 -> IO Double
benchmark projDir runs =  do
  --  setCurrentDirectory projDir
  exitCode <- buildProj projDir
  case exitCode of
       ExitFailure _ -> return worstScore 
       ExitSuccess   -> runProj projDir runs

{-

  result <- timeout 17000000 $ system "make -k mode=slow > nofib-gen 2>&1 "

  system "~/nofib/nofib-analyse/nofib-analyse --csv=Allocs nofib-gen nofib-gen > temp.prof" -- TODO heuristcs hardcoded

  -- TODO dirty hack here! anusing nofib-analyse
  fc <- readFile "temp.prof"
  let wcs = words $ map (\c -> if c == ',' then ' ' else c) fc
  -- system "rm nofib-gen; rm temp.prof"
  return . read $ wcs !! 1
-}
