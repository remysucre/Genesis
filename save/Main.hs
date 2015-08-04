{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE BangPatterns #-}
import System.Process
import System.Environment
import Data.Char (chr,ord)
import Data.List (foldl')
import Data.BitVector (BV, fromBits, toBits, size, ones)
-- import Data.Int (Int64)
import System.Random (mkStdGen, random, randoms)
import System.IO(IOMode(..), hClose, hGetContents, openFile)
import GA (Entity(..), GAConfig(..), 
           evolveVerbose, randomSearch)
import Rewrite (placesToStrict, editBangs)
import Data.Bits.Bitwise (fromListLE, fromListBE, toListBE)
import Data.Bits
import Data.Char (intToDigit)
import Data.Functor
import Data.List
import Control.Applicative
import qualified Data.Text.IO as T
import qualified System.IO.Strict as S
import Data.Text (unpack, pack)
import Numeric (showHex, showIntAtBase)
import Control.DeepSeq
import System.IO.Unsafe
import Debug.Trace
import System.Exit

-- 
-- BUILD AND RUN PROGRAM
-- 

-- build a cabal project. project must be configured with cabal. projDir is in the current dir
-- TODO assuming only one file Main.hs; assuming proj doesn't take input. 
buildProj projDir = system $ "cd " ++ projDir ++ "; cabal build > /dev/null"

benchmark :: FilePath -> Int -> IO (Double, Int)
benchmark projDir _ = {-return (0.0, 0)-} do -- take average $ read file $ write
    let runProj = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir 
    exit <- system $ "bash timer.sh " ++ runProj ++ " " ++ "4" ++ " " ++ "17" ++ "s " ++ "test.txt"
    case exit of
         ExitSuccess ->  do {contents <- readFile "test.txt";
                             times <- return $ map (read) $ lines contents;
                             print times;
                             let meanTime = avg times
                             in return (meanTime, 0)}
         ExitFailure _ -> error $ "Failed to run" ++ projDir
 
--
-- TODO dirty hacks 
--

measTime = id
avg :: [Double] -> Double
avg [] = -1
avg diffs = if average == 0 then (-1.0) else average
            where
                diffs' = filter ((/=) $ (-1.0)) diffs
                num = length diffs'
                sum = foldr (+) 0 diffs'
                average = if num == 0 then 0
                          else sum / (fromInteger $ toInteger num)

bitLen :: Int -> Int
bitLen 1 = 1
bitLen 0 = 0
bitLen !n = 1 + bitLen (n `shiftR` 1)

printBits bs = reverse . concat $ map (\b -> if b then "1" else "0") bs

--
-- GA TYPE CLASS IMPLEMENTATION
--

type BangVec = BV -- TODO BangVec of arbitrary length
type Time = Double
type Score = Double

instance Read BangVec -- TODO is this ok?
instance Entity BangVec Score (Time, FilePath) BangVec IO where
 
  -- generate a random bang vector
  -- invariant: pool is the vector with all bangs on
  genRandom pool seed = do 
    return $! e
    where
        len = size pool
        g = mkStdGen seed -- TODO random bv of arbitrary len
        fs = take len $ randoms g :: [Float]
        bs = map (< 0.5) fs
        e = fromBits bs

  -- crossover operator: merge from two vectors, randomly picking bangs
  crossover p _ seed e1 e2 = do 
    s <- genRandom p seed -- random sieve to select bits from e1 e2
    let e1' = s .&. e1
        e2' = complement s .&. e2
        e = e1' .|. e2'
    return $! Just e

  -- mutation operator: 
  mutation pool p seed e = do 
    return $! Just e'
    where
        len = size e
        g = mkStdGen seed -- TODO random bv of arbitrary len
        fs = take len $ randoms g
        bs = map (< p) fs
        e' = e `xor` fromBits bs

  -- score: improvement on base time
  -- NOTE: lower is better
  -- score _ _ = return $ Just (0.0 :: Score)
  score (baseTime, projDir) bangVec = do -- 1 / seconds faster
  -- rewrite program, recompile & run
  -- TODO currently overwrite original
    let mainPath = projDir ++ "/Main.hs"
    --prog <- unpack <$> T.readFile mainPath
    prog <- readFile mainPath
    --print bangVec
    --print "rewriting prog"
    let prog' = editBangs mainPath prog bangVec -- TODO unsafeperformIO hidden! 
    --putStrLn prog'
    length prog' `seq` writeFile mainPath prog'
    --T.writeFile mainPath (pack prog')
    buildProj projDir
    (m, _) <- benchmark projDir 4 -- TODO change 4 to runs
    let newTime = measTime m
    putStrLn $ printBits (toBits bangVec) ++ ": " ++ show (newTime / baseTime)
    putStrLn prog'
    writeFile mainPath prog
    -- putStrLn prog'
    return $! Just (newTime / baseTime) -- TODO make sure time is right

  -- whether or not a scored entity is perfect
  isPerfect (_,s) = s == 0.0 -- Never


  showGeneration gi g = "gen" ++ show gi -- ++ "\n" ++ intercalate "\n" (map (reverse . printBits) $ fst g)

main :: IO() 
main = do {-
    [projDir] <- getArgs
    let mainPath = projDir ++ "/Main.hs" -- TODO assuming only one file per project
    prog <- readFile mainPath
    let prog' = editBangs mainPath prog 1 -- TODO unsafeperformIO hidden! 
    putStrLn prog'-}
    {-
  -- Random seed; credit to Cyrus Cousins
    randomSeed <- (getStdRandom random)
  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  -- Also parse options for genetic algorithm?
    let (useCliSeed, cliSeed) = (False, 0 :: Int)
        seed = if useCliSeed then cliSeed else randomSeed
-}
        [projDir] <- getArgs
  -- get base time and pool. for the future, check out criterion `measure`
  -- obtain base time: compile & run
        buildProj projDir
        -- (m, _) <- measure (whnfIO $ runProj projDir) 4 -- TODO change 4 to runs
        (m, _) <- benchmark projDir 4 -- TODO change 4 to runs
        let baseTime = measTime m
            mainPath = projDir ++ "/Main.hs" -- TODO assuming only one file per project
        putStr "Basetime is: "; print baseTime
  -- pool: bit vector representing places to strict w/ all bits on
        prog <- readFile mainPath
        let vecSize = placesToStrict mainPath prog 
            vecPool = ones vecSize 
        -- putStrLn $ showIntAtBase 2 intToDigit vecPool "" 
        -- print vecSize

  -- Run Genetic Algorithm
            cfg = GAConfig 
                    5 -- population size
                    3 -- archive size (best entities to keep track of)
                    5 -- maximum number of generations
                    0.8 -- crossover rate (% of entities by crossover)
                    0.2 -- mutation rate (% of entities by mutation)
                    0.0 -- parameter for crossover (not used here)
                    0.2 -- parameter for mutation (% of flipped letters)
                    False -- whether or not to use checkpointing
                    False -- don't rescore archive in each generation

            g = mkStdGen 0 -- random generator

        -- Do the evolution!
        -- Note: if either of the last two arguments is unused, just use () as a value
        es <- evolveVerbose g cfg vecPool (baseTime, projDir)
        let e = snd $ head es :: BangVec
            prog' = editBangs mainPath prog e -- TODO unsafeperformIO hidden! 
        
        putStrLn $ "best entity (GA): " ++ (printBits $ toBits e)
        putStrLn prog'
        writeFile mainPath prog
        --T.writeFile mainPath (pack prog')
