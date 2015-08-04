{-# LANGUAGE BangPatterns #-}

module Profiling where

import System.Process
import System.Exit

-- 
-- PROFILING EXTERNAL PROJECT
--

-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
-- Build a cabal project. Project must be configured with cabal. `projDir` is in the current dir
buildProj :: FilePath -> IO ExitCode
buildProj projDir = system $ "cd " ++ projDir ++ "; cabal build > /dev/null"

-- TODO this is a hack
avg :: [Double] -> Double
avg [] = -1
avg diffs = if average == 0 then (-1.0) else average
  where
    diffs' = filter ((/=) $ (-1.0)) diffs
    num = length diffs'
    sum = foldr (+) 0 diffs'
    average = if num == 0 then 0
              else sum / (fromInteger $ toInteger num)

-- TODO potentially use criterion and do space profile
-- Time a project
benchmark :: FilePath -> Int -> IO Double
benchmark projDir _ =  do
  let runProj = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir 
  exit <- system $ "bash timer.sh " ++ runProj ++ " " ++ "4" ++ " " ++ "17" ++ "s " ++ "test.txt"
  case exit of
    ExitSuccess -> do {!contents <- readFile "test.txt";
                       !times <- return $ map (read) $ lines contents;
                       let meanTime = avg times
                       in return $! meanTime}
    ExitFailure _ -> error $ "Failed to run" ++ projDir
