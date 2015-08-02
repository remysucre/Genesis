{-# LANGUAGE BangPatterns #-}
module Profiling
where
import Types
import System.Process
import System.Exit
import Language.Haskell.Exts

buildProj :: String -> IO ExitCode
buildProj projDir = system $ "cd " ++ projDir ++ "; cabal build -v0"

benchmark :: FilePath -> Int -> IO Measurement
benchmark projDir runs = do
    let runProj = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir 
    exit <- system $ "bash timer.sh " ++ runProj ++ " " ++ "4" ++ " " ++ "50" ++ "s " ++ "test.txt"
    case exit of
         ExitSuccess ->  do {contents <- readFile "test.txt";
                             times <- return $ map (read) $ lines contents;
                             let meanTime = avg times
                             in return meanTime}
         ExitFailure _ -> error $ "Failed to run" ++ projDir

fitnessRun :: Module -> IO Measurement
fitnessRun = undefined

avg :: [Double] -> Double
avg [] = -1
avg !diffs = if average == 0 then (-1.0) else average
            where
                diffs' = filter ((/=) $ (-1.0)) diffs
                num = length diffs'
                sum = foldr (+) 0 diffs'
                average = if num == 0 then 0
                          else sum / (fromInteger $ toInteger num)
