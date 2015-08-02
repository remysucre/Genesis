{-# OPTIONS -Wall -Werror -fno-warn-name-shadowing -XBangPatterns #-}

{--
    Genetic - Everything regarding the genetic algorithm
--}
    
module Genetic
where

import Rewrite (flipBang, placesToStrict, bangVector)
import System.Process (system)
import System.Exit (ExitCode(..))
import System.FilePath.Posix (splitPath, splitFileName, dropExtension)
import System.IO.Unsafe (unsafePerformIO)
import Data.Bits (testBit, (.|.))
import Data.List (sort, find)
import System.Random (getStdRandom, randomR)
import System.IO.Temp (createTempDirectory)
import System.Directory (createDirectoryIfMissing, getCurrentDirectory, setCurrentDirectory)
import Data.Foldable(foldl', foldr')

import Debug.Trace
{------ General gene class for Genetic Algorithms ------}

class Gene d where
   mutate :: d -> d
   merge :: d -> d -> d
   fitness :: Int -> Float -> d -> IO Float

{- 
   Mutate a gene a certain number of times
   Return: a gene mutated n times
-}
mutateRounds :: Gene d => d -> Int -> d
mutateRounds gene 0 = gene
mutateRounds gene n = mutateRounds (mutate gene) (n-1)

{- 
   Mutate a single gene to multiple genes
   Return: a list of genes each mutated at least once
-}
massMutate :: Gene d => d -> Int -> [d]
massMutate g i = [g] ++ (take i $ map mutate $ repeat g)

{------ Gene for this Genetic Algorithm ------}

{- Component of the main Gene for the algorithm  -}

data Strand = Strand { path :: FilePath    -- filePath to program
               , prog :: String      -- program itself
               , vec  :: Integer     -- set of bits corresponding to places to insert strictness
               , n    :: Int         -- upper limit on size of the set of bits
               }

instance Show Strand where
   show d = "path: " ++ show (path d) ++ " vec: " ++ show (vec d)

instance Gene Strand where
   mutate = mutateStrand
   fitness = fitnessStrand
   merge = mergeStrand

{- 
   Two strands are equal iff 
     1) the paths to the files are equal up to temporary directory names
     2) the programs are equal
     3) the bit vectors are equal
-}
instance Eq Strand where
   (Strand fp1 program1 bits1 _) == (Strand fp2 program2 bits2 _) = (fp1' == fp2') && 
                                                                    (program1 == program2) &&
                                                                    (bits1 == bits2)
                               where
                                   removeFront p = let fpList = splitPath p
                                                   in case ("files/" `elem` fpList) of
                                                        True  -> (concat . tail $ tail fpList)
                                                        False -> p
                                   fp1' = removeFront fp1
                                   fp2' = removeFront fp2

{- 
   Mutate a single Strand
   Return: new piece of Strand that has been mutated
-}

mutateStrand :: Strand -> Strand
mutateStrand d@(Strand fp program _ _) = mutateStrandWithSet bits' size d
                                             where
                                                 size = placesToStrict fp program
                                                 range = (0, 2 ^ (toInteger size + 1) - 1)
                                                 bits' = unsafePerformIO $ getStdRandom (randomR range)
                                                 {- TODO range should be 2 ^ (size + 1) - 1 -}

{- 
   Mutate Strand according to a set of bits of a given size
   Return: new piece of Strand mutated according to bits
-}
mutateStrandWithSet :: Integer -> Int -> Strand -> Strand
mutateStrandWithSet !bits size d = mutateStrandWithSetH d bits size 0

{- 
   Helper function: Goes through the bits and mutates Strand accordingly
-}
mutateStrandWithSetH :: Strand -> Integer -> Int -> Int -> Strand
mutateStrandWithSetH d@(Strand fp prog oldBits np) !bits numPlaces i = if i == (numPlaces)
                                                               then writeStrandToDisk $ Strand fp prog bits numPlaces
                                                               else mutateStrandWithSetH d' bits numPlaces (i+1)
                                                               where
                                                                  d' = if not $ (testBit bits i) == (testBit oldBits i)
                                                                       then Strand fp (flipBang fp prog i) oldBits np
                                                                       else d

{- 
   Merge two parents to create a single child
   Return: new piece of Strand that results from both parents
-}
mergeStrand :: Strand -> Strand -> Strand
mergeStrand (Strand fp program bits np) (Strand _ _ bits' np') = mutateStrandWithSet bits'' np'' d'
                                                                       where
                                                                           bits'' = bits .|. bits'
                                                                           np'' = max np np'
                                                                           d' = Strand fp program bits'' np''

{- 
   Helper function: Writes a program in Strand to a temp file and updates Strand
   Return: Strand updated to point to file just written on disk
-}
writeStrandToDisk :: Strand -> Strand
writeStrandToDisk !(Strand fp program bits numPlaces) = Strand fp' program bits numPlaces
                                                 where
                                                     (dir, _) = splitFileName fp
                                                     action = do
                                                                createDirectoryIfMissing True dir
                                                                writeFile (fp ++ ".hs") program
                                                                return fp
                                                     fp' = dropExtension $ unsafePerformIO action

{-
   Compile a program and return the exit code. Also deletes all temporary files.
-}
compile :: FilePath -> IO ExitCode
compile fp = do
               oldDir <- getCurrentDirectory
               (dir, name) <- return $ splitFileName fp
               setCurrentDirectory dir
               --exit <- system $ "ghc --make -XBangPatterns -funbox-strict-fields -outputdir temp/ -O0 " ++ name ++ " " ++ name ++ ".hs > /dev/null"
               exit <- system $ "ghc --make -XBangPatterns -funbox-strict-fields -outputdir temp/ -O0 " ++ name ++ ".hs > /dev/null"
               _ <- system $ "rm -rf temp"
               setCurrentDirectory oldDir
               return exit
               -- TODO: compile with cabal instead of ghc

{-
   Test fitness of Strand 
   Returns: -1.0 if every run timed out or failed
            average run time of the executable otherwise
-}

fitnessStrand :: Int -> Float -> Strand -> IO Float
fitnessStrand reps base (Strand fp prog vec _) = do
                                         _ <- compile fp -- Compile all the programs
                                         let interv = round base :: Int 
                                         print $ "bash timer.sh " ++ "./" ++ fp ++ " " ++ (show reps) ++ " " ++ (show interv) ++ "s " ++ "test.txt"
                                         exit <- system $ "bash timer.sh " ++ "./" ++ fp ++ " " ++ (show reps) ++ " " ++ (show interv) ++ "s " ++ "test.txt"
                                         case exit of
                                              ExitSuccess ->  do {contents <- readFile "test.txt";
                                                                  times <- return $ map (read) $ lines contents;
                                                                  let meanTime = avg times;
                                                                      geneTimeMap = show (bangVector fp prog) ++ " takes " ++ show meanTime ++ " vec: " ++ show vec ++ "\n";
                                                                  in do {appendFile "geneTimeMap.txt" geneTimeMap; 
                                                                         return meanTime}}
                                              ExitFailure _ -> error $ "Failed to run" ++ fp
                                              
avg :: [Float] -> Float
avg [] = -1
avg !diffs = if average == 0 then (-1.0) else average
            where
                diffs' = filter ((/=) $ (-1.0)) diffs
                num = length diffs'
                sum = foldr' (+) 0 diffs'
                average = if num == 0 then 0
                          else sum / (fromInteger $ toInteger num)

{-
   Create a new strand of Strand using a file path and a program
-}
-- TODO : go through program and build the bit vector
createStrand :: String -> String -> Strand
createStrand fp program = Strand fp program 0 $ placesToStrict fp program

{-
   The main item manipulated in the algorithm. Represents multiple file programs.
-}
data Genes = Genes { getStrand :: [Strand] } deriving Show

{-
   Mutate a program
-}
mutateG :: Genes -> Genes
mutateG g = Genes ds''
                      where 
                          !ds' = getStrand $ writeGeneToDisk g
                          ds'' = map mutate ds'

{-
   Merge two programs together
-}
mergeG :: Genes -> Genes -> Genes
mergeG g1 g2 = Genes $ map (uncurry merge) $ zip ds ds'
               where
                   !g1' = writeGeneToDisk g1
                   ds = getStrand g1'
                   ds' = getStrand g2

{-
   Measure the fitness fo a program
-}
fitnessG :: Int -> Float -> Genes -> IO Float
fitnessG reps base (Genes ds) = fitness reps (base + base * 1) $ head ds

instance Gene Genes where
    mutate = mutateG
    merge = mergeG
    fitness = fitnessG

instance Eq Genes where
   gr == hr = (getStrand gr) == (getStrand hr)

createGene :: [(String, String)] -> Genes
createGene progs = Genes $ map (uncurry createStrand) progs

createGeneFromFile :: FilePath -> IO Genes
createGeneFromFile fp = do
                          content <- readFile fp
                          filePaths <- return $ lines content
                          fileContents <- sequence $ map readFile filePaths
                          return $ createGene $ zip (map dropExtension filePaths) fileContents

writeGeneToDisk :: Genes -> Genes
writeGeneToDisk g = Genes ds'
                    where
                        ds = getStrand g
                        fp = unsafePerformIO $ createTempDirectory "files/" "tmp"
                        ds' = map (writeStrandToDisk . replacePath fp) ds
                        
{- Replace the file path of a strand with a new file path to a temporary directory -}
replacePath :: FilePath -> Strand -> Strand
replacePath tempPath (Strand fp prog bits size) = Strand fp' prog bits size
                                             where
                                                 fpList = splitPath fp
                                                 fp' = case ("files/" `elem` fpList) of
                                                            True  -> tempPath ++ "/" ++ (concat . tail $ tail fpList)
                                                            False -> tempPath ++ "/" ++ fp



{------ Main algorithm ------}


{-
   Randomly choose 2 genes and merge them into a new gene and do so n times
   Return: List of genes that are the given genes and all new children made
-}
mergeRand :: Gene d => [d] -> Int -> [d]
mergeRand dnas 0 = dnas
mergeRand [dna] _ = [dna]
mergeRand dnas n = [merge (dnas !! i) (dnas !! j)] ++ mergeRand dnas (n-1)
                   where
                       range = (0, (length dnas) - 1)
                       i = unsafePerformIO $ getStdRandom $ randomR range
                       j = unsafePerformIO $ getStdRandom $ randomR range

{-
   Datatype use to hold genes and times together
-}
data GeneRecord = GR { gene :: Genes, time :: Float } deriving Show

instance Eq GeneRecord where
   dr1 == dr2 = (time dr1) == time dr2

instance Ord GeneRecord where
   dr1 <= dr2 = (time dr1) <= time dr2

createGeneRecords :: Genes -> Float -> GeneRecord
createGeneRecords g t = GR g t

{- Gene Dictionary for caching -}
type GeneDict = [GeneRecord]

emptyGeneDict :: GeneDict
emptyGeneDict = []

findTimeForGene :: GeneDict -> Genes -> Maybe Float
findTimeForGene dict g = case findGene dict g of
                              Nothing -> Nothing
                              Just gr -> Just $ time gr

addGeneRecord :: GeneDict -> GeneRecord -> GeneDict
addGeneRecord dict gr = case findGene dict (gene gr) of
                             Nothing -> (gr:dict)
                             Just _ -> dict

findGene :: GeneDict -> Genes -> Maybe GeneRecord
findGene dict g = find (\gr -> (gene gr) == g) dict

{-
   fitness wrapper for caching 
-}
fitnessWrap :: GeneDict -> Int -> Float -> Genes -> IO Float
fitnessWrap dict reps base g = case findTimeForGene dict g of
                                    Nothing -> fitness reps base g
                                    Just time -> print ("Found in cache with time: " ++ (show time)) >> return time
                
{-
   Take a list of genes and create a new list of genes
   Return: List of genes that include the following
           - all genes given as input
           - if more than one gene is given, a set of children born at random
           - mutaions of all genes given and children (if applicable)
-}

{- TODO should keep regeneration in one place. selection happens in 'main' geneticAlg function -}

buildGeneration :: Gene d => [d] -> [d]
buildGeneration dnas = gen'
                       where
                           gen = if (length dnas) > 1
                                 then mergeRand dnas 5
                                 else dnas
                           gen' = concat $ map ((flip massMutate) 5) gen

{-

-}
runGeneration :: [Genes] -> Float -> Int -> Int -> GeneDict -> IO ([GeneRecord], GeneDict)
runGeneration (!genes) time repeats poolSize dict = do
                                       trace (show genes) $ print "Running fitness on all programs"
                                       times <- sequence $ map (fitnessWrap dict repeats time) genes
                                       print "Cleaning executables"
                                       paths <- return $ map (((++) "rm -f ") . path. head . getStrand) genes
                                       _ <- sequence $ map system paths
                                       print "Calculating scores"
                                       records <- return $ sort $ map (uncurry createGeneRecords) $ zip genes times
                                       dict' <- return $ foldl' (addGeneRecord) dict records
                                       return $ (take poolSize records, dict')


geneticAlg :: [Genes] -> Int -> Float -> Int -> Int -> (GeneRecord, Int) -> GeneDict -> IO [Genes]
geneticAlg genes 0 _ _ _ _ _ = (print $ head genes) >> (return genes)
geneticAlg _ _ _ _ _ (gr, 10) _ = (print $ gene gr) >> (return $ [gene gr])
geneticAlg genes runs base repeats poolSize (gr, failCount) dict = do
                                                         print $ (show runs) ++ " generations left"
                                                         !genes' <- return $ buildGeneration genes
                                                         (records', dict') <- runGeneration (genes') base repeats poolSize dict
                                                         records <- return $ filter (\gr -> (time gr) /= (-1.0)) records'
                                                         print $ map time records
                                                         diff' <- return $ time gr
                                                         fast <- if (null records) then return $ diff' else return $ time $ head records
                                                         print $ "Fastest gene: " ++ (if (null records) then "" else show $ gene $ head records)
                                                         print $ "Fastest time so far: " ++ (show fast) ++ " sec"
                                                         print $ (show $ diff' - fast) ++ " sec faster"
                                                         if ((length records) == 0) then print ("All timeout" ) >> geneticAlg genes (runs-1) base repeats poolSize (gr, failCount + 1) dict'
                                                         else if (diff' - fast < 0) then print ("Made all slower") >> geneticAlg (map gene records) (runs-1) base repeats poolSize (gr, failCount + 1) dict'
                                                         else if (diff' - fast < 5.0) then print ("Not fast enough") >> geneticAlg (map gene records) (runs-1) fast repeats poolSize (head records, failCount + 1) dict'
                                                         else geneticAlg (map gene records) (runs-1) fast repeats poolSize (head records, 0) dict'
