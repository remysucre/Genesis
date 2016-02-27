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

-- 
-- PROFILING EXTERNAL PROJECT
--

-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
-- Build a cabal project. Project must be configured with cabal. `projDir` is in the current dir
buildProj :: FilePath -> IO ExitCode
-- buildProj projDir = system $ "cd " ++ projDir ++ "; cabal configure -v0; cabal build -v0"
buildProj projDir = do 
  setCurrentDirectory projDir
  system "make clean -q; make boot"

-- TODO use current working dir and save compile command in config.hs

-- Time a project
instance NFData ExitCode
  where 
    rnf ExitSuccess = ()
    rnf (ExitFailure _) = ()

benchmark :: FilePath -> Int64 -> IO Double
benchmark projDir runs =  do
  setCurrentDirectory projDir
  system "make > nofib-gen 2>&1 "
  system "~/nofib/nofib-analyse/nofib-analyse --csv=Runtime nofib-gen nofib-gen > temp.prof"
  -- TODO dirty hack here! anusing nofib-analyse
  fc <- readFile "temp.prof"
  let wcs = words $ map (\c -> if c == ',' then ' ' else c) fc
  -- system "rm nofib-gen; rm temp.prof"
  return . read $ wcs !! 1
