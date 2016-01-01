{-# LANGUAGE BangPatterns #-}

module Profiling where

import Control.DeepSeq
import Data.Int
import Control.DeepSeq
import System.Process
import System.Exit
import System.Timeout
import Criterion.Main
import Criterion.Measurement
import Criterion.Types (measTime)

-- 
-- PROFILING EXTERNAL PROJECT
--

-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
-- Build a cabal project. Project must be configured with cabal. `projDir` is in the current dir
buildProj :: FilePath -> IO ExitCode
buildProj projDir = system $ "cd " ++ projDir ++ "; cabal sandbox init -v0; cabal configure -v0; cabal build -v0"

-- Time a project
instance NFData ExitCode
  where 
    rnf ExitSuccess = ()
    rnf (ExitFailure _) = ()


benchmark :: FilePath -> Int64 -> IO Double
benchmark projDir runs =  do
  let runProj  = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir ++ "> /dev/null"
  m <- timeout 100 $! (measure (nfIO $ system runProj) runs)
  case m of
    Just (measured, _) -> return $ measTime measured
    Nothing -> return 100
{-
  exit <- timeout 100 $ system runProj -- TODO hardcode timeout
  case exit of
       Just ExitSuccess     -> do {(m, _) <- measure (nfIO $ system runProj) runs; 
                                  return $! measTime m}
       Just (ExitFailure _) -> return 100
       Nothing              -> return 100
-}
