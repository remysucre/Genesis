{-# LANGUAGE BangPatterns #-}

module Profiling where

import Control.DeepSeq
import Data.Int
import System.Process
import System.Exit
import System.Timeout
import Criterion.Main
import Criterion.Measurement
import Criterion.Types (measTime, measAllocated, fromInt)

-- 
-- PROFILING EXTERNAL PROJECT
--

-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
-- Build a cabal project. Project must be configured with cabal. `projDir` is in the current dir
buildProj :: FilePath -> IO ExitCode
buildProj projDir = system $ "cd " ++ projDir ++ "; cabal configure -v0; cabal build -v0"

-- TODO use current working dir and save compile command in config.hs

-- Time a project
instance NFData ExitCode
  where 
    rnf ExitSuccess = ()
    rnf (ExitFailure _) = ()


benchmark :: FilePath -> Int64 -> IO Double
benchmark projDir runs =  do
  let runProj = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir ++ "> /dev/null"
  exit <- timeout 170000000 $ system runProj -- TODO hardcode timeout
  case exit of
       Just ExitSuccess     -> do {(m, _) <- measure (nfIO $ system runProj) runs; 
                                  -- return $! measTime m}
                                  let Just aloc = fromInt (measAllocated m) in return $! fromIntegral aloc }
       Just (ExitFailure _) -> return 100
       Nothing              -> return 100

benchmark :: FilePath -> Int64 -> IO Double
benchmark projDir runs =  do
  let runProj = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir ++ "> /dev/null"
      cleanProj = "rm timing.temp"
  exit <- timeout 170000000 $ system runProj -- TODO hardcode timeout
  case 
