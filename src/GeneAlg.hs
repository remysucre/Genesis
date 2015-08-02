{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}

module GeneAlg
where
import GA
import Types
import Language.Haskell.Exts
import Data.BitVector

type FitnessRun = Module -> IO Measurement
instance Entity Gene Score (Time, FitnessRun) Gene IO where
 
  -- generate a random bang vector
  -- invariant: pool is the vector with all bangs on
  genRandom = undefined
  {- genRandom pool seed = do 
    --putStr "genRandom "
    --print e
    return $! e
    where
        g = mkStdGen seed
        e = (fst $ random g) `mod` (pool + 1)
-}
  -- crossover operator: merge from two vectors, randomly picking bangs
  -- crossover _ _ _ e _ = return $! Just e
  crossover = undefined {-
  crossover _ _ seed e1 e2 = do 
    --print "cross"
    --putStrLn $ showIntAtBase 2 intToDigit e "" 
    return $! Just e
        where
            g = mkStdGen seed
            s = fst $ random g -- random sieve to select bits from e1 e2
            e1' = s .&. e1
            e2' = complement s .&. e2
            e = e1' .|. e2'
-}
  -- mutation operator: 
  -- mutation _ _ _ e = return $! Just e
  mutation = undefined {-
  mutation pool p seed e = do 
    --print "mutate"
    --print fs
    --print bs
    --putStrLn $ showIntAtBase 2 intToDigit e' "" 
    return $! Just e'
        where
            {- g = mkStdGen seed
            fs = randoms g
            bs = map (< p) fs
            el = toListBE e
            e' = fromListBE $ zipWith xor el bs -}
            len = bitLen e
            g = mkStdGen seed
            fs = take len $ randoms g
            bs = map (< p) fs
            e' = e `xor` fromListLE bs
-}
  -- score: improvement on base time
  -- NOTE: lower is better
  -- score _ _ = return $ Just (0.0 :: Score)
  score = undefined {-
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
    length prog `seq` writeFile mainPath prog'
    --T.writeFile mainPath (pack prog')
    buildProj projDir
    (m, _) <- benchmark projDir 4 -- TODO change 4 to runs
    let newTime = measTime m
    return $! Just (newTime / baseTime) -- TODO make sure time is right
-}
  -- whether or not a scored entity is perfect
  isPerfect = undefined


  showGeneration = undefined
--  showGeneration gi g = "gen" ++ show gi ++ "\n" ++ intercalate "\n" (map (reverse . printBits) $ fst g)
