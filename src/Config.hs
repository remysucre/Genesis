module Config where

import GA
import System.Random
import Data.Int
import Profiling

import Text.ParserCombinators.Parsec
import qualified Text.Parsec.String as PS
import qualified Text.Parsec.Prim as PP
import qualified Text.Parsec.Token as PT
import qualified Text.Parsec.Expr as PE
import qualified Text.Parsec.Combinator as PC
import Text.ParserCombinators.Parsec.Language (haskellStyle, reservedOpNames, reservedNames)
import Text.ParserCombinators.Parsec.Pos (newPos)
--
-- CONFIG FOR FITNESS RUN
--

runs :: Int64
runs = 1

-- 
-- CONFIG FOR GENETIC ALG
-- 

crossRate  = 0.6 :: Float
muteRate   = 0.4 :: Float
crossParam = 0.0 :: Float
muteParam  = 0.3 :: Float
checkpoint = False :: Bool
rescoreArc = False :: Bool

{-
cfg = GAConfig 
        15 -- population size
        1 -- archive size (best entities to keep track of)
        5 -- maximum number of generations
        0.8 -- crossover rate (% of entities by crossover)
        0.2 -- mutation rate (% of entities by mutation)
        0.0 -- parameter for crossover (not used here)
        0.2 -- parameter for mutation (% of flipped letters)
        False -- whether or not to use checkpointing
        False -- don't rescore archive in each generation
-}

g = mkStdGen 0 -- random generator

type Cfg = (FilePath, Int, Int, Int) -- projDir, pop, gen, arch

defaultProjDir :: FilePath
defaultProjDir = "."

defaultTimeLimit :: Integer
defaultTimeLimit = toInteger $ 3 * 60 * 60

defaultConfidence :: Integer
defaultConfidence = toInteger 0

defaultCoverage :: [String]
defaultCoverage = ["Main.hs"]

defaultMetric :: MetricType
defaultMetric = RUNTIME

defaultInput :: [String]
defaultInput = []

defaultFitRuns :: Integer
defaultFitRuns = toInteger 1

heuristic :: String -> Double -> Double -> Cfg
heuristic projDir baseTime timeLimit = if n > 2 
                                       then (projDir, n+1, n-1, n-2)
                                       else (projDir, n, n, (n-1))
                                       where
                                       n = (round $ timeLimit /  2 * (2 * baseTime)) :: Int
                                           
fromTimeToCfg :: String -> Int -> IO Cfg
fromTimeToCfg projDir timeLimit = do
                          buildProj projDir
                          baseTime <- benchmark projDir runs
                          -- Coerce from Int to Double
                          timeLimit' <- (return $ fromInteger $ toInteger timeLimit) :: IO Double
                          -- Determine the configuration from the time limit and the base time
                          return $ heuristic projDir baseTime timeLimit'


-- Thanks to Matthew Ahrens for the Parsec boilerplate
-- Thanks to Karl Cronburg for the help with Parsec rules

data MetricType = ALLOC | GC | RUNTIME

instance Show MetricType where
    show ALLOC = "alloc"
    show GC = "gc"
    show RUNTIME = "runtime"

data CfgAST = BUDGET Integer
            | CONFIDENCE Integer
            | DIR String
            | SRCS [String]
            | METRIC MetricType
            | INPUTS [String]
            | FITRUNS Integer
            | FILE [CfgAST] deriving Show

foo :: [CfgAST] -> IO Cfg
foo ast = fromTimeToCfg projDir timeLimit
          where
          timeLimit = (fromInteger $ getBudget ast) :: Int
          projDir = getProjDir ast
          
getBudget :: [CfgAST] -> Integer
getBudget ast = foldl f defaultTimeLimit ast
                where
                f base x = case x of
                              BUDGET n -> n
                              otherwise -> base

getProjDir :: [CfgAST] -> String
getProjDir ast = foldl f defaultProjDir ast
                 where
                 f dir x = case x of
                              DIR fp -> fp
                              otherwise -> dir

parseCfgFile :: SourceName -> Line -> Column -> String -> Either ParseError [CfgAST]
parseCfgFile fileName ln col text = 
  PP.parse cfgDefs fileName text
  where
    cfgDefs = do {
      setPosition (newPos fileName ln col)
    ; whiteSpace
    ; x <- configAllOptions
    ; whiteSpace
    ; eof <|> errorParse
    ; return x
    }

    -- Eats remaining tokens and raises unexpected error
    errorParse = do {
      rest <- manyTill anyToken eof
    ; unexpected rest
    }

----------- Parser --------------

(<||>) a b = try a <|> try b

configAllOptions :: PS.Parser [CfgAST]
configAllOptions = many configOption

configOption :: PS.Parser CfgAST
configOption = do {
               whiteSpace
               ; x <- configTopLevel
               ; whiteSpace
               ; return x
               }

configTopLevel :: PS.Parser CfgAST
configTopLevel = budgetRule <||> confidenceRule <||> coverageRule
               <||> targetMetricRule <||> inputArgRule <||> fitnessRunRule

budgetRule :: PS.Parser CfgAST
budgetRule = do {
             reserved "budgetTime"
             ; reservedOp "="
             ; x <- natural
             ; symbol "h"
             ; return $ BUDGET x
             }

confidenceRule :: PS.Parser CfgAST
confidenceRule = do {
                 reserved "confidence"
                 ; reservedOp "="
                 ; x <- natural
                 ; return $ CONFIDENCE x
                 }

coverageRule :: PS.Parser CfgAST
coverageRule = do {
               reserved "coverage"
               ; reservedOp "="
               ; xs <- stringLiteral `sepBy` (symbol ",")
               ; return $ SRCS xs
               }

projDirRule :: PS.Parser CfgAST
projDirRule = do {
               reserved "projectDirectory"
               ; reservedOp "="
               ; fp <- stringLiteral
               ; return $ DIR fp
               }

targetMetricRule :: PS.Parser CfgAST
targetMetricRule = do {
                   reserved "targetMetric"
                   ; reservedOp "=" 
                   ; x <- parseMetric
                   ; return $ METRIC x
                   }

parseMetric :: PS.Parser MetricType
parseMetric = do {
              x <- stringLiteral
              ; case x of
                  "peakAlloc" -> return $ ALLOC
                  "runtime"   -> return $ RUNTIME
                  "gc"        -> return $ GC
              }

inputArgRule :: PS.Parser CfgAST
inputArgRule = do {
               reserved "inputArg"
               ; reservedOp "="
               ; xs <- many stringLiteral
               ; return $ INPUTS xs
               }

fitnessRunRule :: PS.Parser CfgAST
fitnessRunRule = do {
                 reserved "fitnessRuns"
                 ; reservedOp "="
                 ; x <- natural
                 ; return $ FITRUNS x
                 }

---- Lexer ----(

lexer :: PT.TokenParser ()
lexer = PT.makeTokenParser $ haskellStyle
  { reservedOpNames = ["="]
    , reservedNames = ["budgetTime", "confidence", "coverage",
                       "targetMetric", "inputArg", "fitnessRuns"]
  }

whiteSpace = PT.whiteSpace  lexer
identifier = PT.identifier lexer
charLiteral = PT.charLiteral lexer
stringLiteral = PT.stringLiteral lexer
naturalOrFloat = PT.naturalOrFloat lexer
natural = PT.natural lexer
reserved = PT.reserved lexer
reservedOp = PT.reservedOp lexer
symbol = PT.symbol lexer
-- Do the rest

