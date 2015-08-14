import System.Environment
import Text.ParserCombinators.Parsec.Number
import Text.ParserCombinators.Parsec
import Data.List
import Data.Set (fromList, size)

--
-- PROCESSOR
--

type Blob = ([Int], [([String],Float)])

getStrands blob = ss
  where ss = concatMap fst sfs
        sfs = snd blob

getScore :: Blob -> Float
getScore blob = avg ss
  where ss = map snd sfs
        sfs = snd blob

avg :: [Float] -> Float
avg ns = sum ns / fromIntegral (length ns)

coverage :: [String] -> Int
coverage strands = size (fromList strands) 

process :: Blob -> ([Int], Int, Float)
process blob = (fst blob, coverage $ getStrands blob, getScore blob)

blb = ([1,1,5],[(["0000010010000100010010000100000010010","0000010010000100010010000100000010010"],0.4417549 :: Float),(["0000010010000100010010000100000010010","0000010010000100010010000100000010010"],0.4417549 :: Float)])

blbs = [([1,1,5],[(["0000010010000100010010000100000010010","0000010010000100010010000100000010010"],0.4417549),(["0000010010000100010010000100000010010","0000010010000100010010000100000010010"],0.4417549)]),([1,1,5],[(["0000010010000100010010000100000010010","0000010010000100010010000100000010010"],0.4417549),(["0000010010000100010010000100000010010","0000010010000100010010000100000010010"],0.4417549)])]


-- main = print $ process blb

--
-- PARSER
--

run = 
  do between start end runCont

runCont =
  do b <- base
     gs <- many gen
     return (b, gs)

gen :: GenParser Char st ([String], Float)
gen = 
  do bs <- manyTill bits (try $ lookAhead best)
     b <- best
     return (bs, b)

best :: GenParser Char st Float
best = 
  do string "best: "
     f <- floating
     newline
     return f

bits :: GenParser Char st String
bits =
  do string "bits: "
     manyTill digit newline

testbits = many bits

base :: GenParser Char st [Int]
base = do
  p <- pop
  g <- gens
  a <- arch
  return [p, g, a]

testbase = between start end base

keyValue :: String -> GenParser Char st Int
keyValue k = 
  do string k
     n <- int
     newline
     return n

pop :: GenParser Char st Int
pop = keyValue "pop: "

gens :: GenParser Char st Int
gens = keyValue "gens: "

arch :: GenParser Char st Int
arch = keyValue "arch: "

testpop = pop

end :: GenParser Char st String
end = string "done evolving!\n>>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>\n"

start :: GenParser Char st String
start = string ">>>>>>>>>>>>>>>START OPTIMIZATION>>>>>>>>>>>>>>>\n"

testse = do {start; end}

popGenCover ([pop,gen,_],cover,_) = putStrLn $ show pop ++ " " ++ show gen ++ " " ++ show cover
popGenScore ([pop,gen,_],_,score) = putStrLn $ show pop ++ " " ++ show gen ++ " " ++ show (1 / score)

main = do 
  parsed <- testParse $ many run
  let ped = map process parsed
  sequence_ $ map popGenScore ped

testParse p = 
  do [fp] <- getArgs
     fc <- readFile fp
     let (Right pa) = parse p "uk" fc
     return pa
