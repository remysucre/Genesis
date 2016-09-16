module Config where

import GA
import System.Random
import Data.Int

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

-- Thanks to Matthew Ahrens for the Parsec boilerplate
-- Thanks to Karl Cronburg for the help with Parsec rules

data MetricType = ALLOC | GC | RUNTIME

data CfgAST = BUDGET Integer
            | CONFIDENCE Integer
            | SRCS [String]
            | METRIC MetricType
            | INPUTS [String]
            | FITRUNS Int
            | FILE [CfgAST]
            
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
               <||> targetMetricRule

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
---- Lexer ----

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

