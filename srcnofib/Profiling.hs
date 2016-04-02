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

worstScore :: Double -> Double
worstScore = (*) 2

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
  system "make clean -s; make boot -s &> /dev/null"

-- TODO use current working dir and save compile command in config.hs

-- Time a project
instance NFData ExitCode
  where 
    rnf ExitSuccess = ()
    rnf (ExitFailure _) = ()

runProj :: FilePath -> Int64 -> Double -> Double -> IO Double
runProj projDir runs baseTime timeLimit = do

  -- result is ExitCode
  --  result <- timeout 17000000 $ system "make -k mode=slow > nofib-gen 2>&1 "
  putStrLn $ "runproj limit: " ++ show timeLimit
  -- result <- system $ "timeout " ++ (show . ceiling) (4 * timeLimit) ++ " make -k mode=norm &> nofib-gen "   
  result <- system $ "make > nofib-gen 2>&1"   

  case result of
       -- Nothing -> return worstScore
       ExitFailure _ -> do {print "timed out"; return $ worstScore baseTime}
       ExitSuccess ->  do {
       	    		       system $ pathToNoFib ++ "/nofib/nofib-analyse/nofib-analyse --csv=TotalMem nofib-gen nofib-gen > temp.prof"; -- TODO heuristcs hardcoded
			       
       	    		       -- TODO dirty hack here! anusing nofib-analyse
			       fc <- readFile "temp.prof";
			       let wcs = words $ map (\c -> if c == ',' then ' ' else c) fc
			       -- system "rm nofib-gen; rm temp.prof"
			       in return . read $ wcs !! 1
                               }

benchmark :: FilePath -> Int64 -> Double -> Double -> IO Double
benchmark projDir runs baseTime timeLimit =  do
  --  setCurrentDirectory projDir
  exitCode <- buildProj projDir
  case exitCode of
       ExitFailure _ -> do {print "build failed"; return $ worstScore baseTime}
       ExitSuccess   -> runProj projDir runs baseTime timeLimit

runProj' :: FilePath -> Int64 -> Double -> IO Double
runProj' projDir runs _ = do

  -- result is ExitCode
  --  result <- timeout 17000000 $ system "make -k mode=slow > nofib-gen 2>&1 "
  result <- system $ "make -k mode=norm > nofib-gen 2>&1"   

  case result of
       -- Nothing -> return worstScore
       ExitFailure _ -> return $ -1
       ExitSuccess ->  do {
       	    		       system $ pathToNoFib ++ "/nofib/nofib-analyse/nofib-analyse --csv=Runtime nofib-gen nofib-gen > temp.prof"; -- TODO heuristcs hardcoded
			       
       	    		       -- TODO dirty hack here! anusing nofib-analyse
			       fc <- readFile "temp.prof";
			       let wcs = words $ map (\c -> if c == ',' then ' ' else c) fc
			       -- system "rm nofib-gen; rm temp.prof"
			       in return . read $ wcs !! 1
                               }

benchmark' :: FilePath -> Int64 -> Double -> IO Double
benchmark' projDir runs _ =  do
  --  setCurrentDirectory projDir
  exitCode <- buildProj projDir
  case exitCode of
       ExitFailure _ -> return $ -1
       ExitSuccess   -> runProj' projDir runs $ -1
{-

  result <- timeout 17000000 $ system "make -k mode=slow > nofib-gen 2>&1 "

  system "~/nofib/nofib-analyse/nofib-analyse --csv=Runtime nofib-gen nofib-gen > temp.prof" -- TODO heuristcs hardcoded

  -- TODO dirty hack here! anusing nofib-analyse
  fc <- readFile "temp.prof"
  let wcs = words $ map (\c -> if c == ',' then ' ' else c) fc
  -- system "rm nofib-gen; rm temp.prof"
  return . read $ wcs !! 1
-}
