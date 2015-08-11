import System.Environment
import Text.ParserCombinators.Parsec.Number
import Text.ParserCombinators.Parsec

-- A Log file contains 0 or more runs, each bracketed by start and end
-- 
logFile :: GenParser Char st [(Int, Int, Int, Float, [([String], String)], String, String)]
logFile = 
    do result <- manyTill run eof
       eof
       return result

run :: GenParser Char st (Int, Int, Int, Float, [([String], String)], String, String)
run =
    do start
       result <- runContent
       end
       return result

end :: GenParser Char st String
end = string ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>\n"

start :: GenParser Char st String
start = string ">>>>>>>>>>>>>>>START OPTIMIZATION>>>>>>>>>>>>>>>\n"

runContent :: GenParser Char st (Int, Int, Int, Float, [([String], String)], String, String)
runContent =
    do p  <- pop
       g  <- maxg
       a  <- arch
       b  <- base
       gs <- manyTill gen (try (string ">>>>>>>"))
       w  <- winner
       o  <- out
       return (p, g, a, b, gs, w, o) --TODO 

pop :: GenParser Char st Int
pop = 
    do n <- int
       s <- string " pop\n"
       return n

maxg :: GenParser Char st Int
maxg = 
    do n <- int
       s <- string " gens\n"
       return n

arch :: GenParser Char st Int
arch = 
    do n <- int
       s <- string " arch\n"
       return n

base :: GenParser Char st Float
base = 
    do s <- string "Basetime is: "
       f <- floating
       nl <- newline
       return f

gen :: GenParser Char st ([String], String)
gen = 
    do ss <- manyTill strand (try (string "best"))
       b  <- best
       return (ss, b)

strand :: GenParser Char st String
strand = 
    do string "bits "
       ds <- many digit
       newline
       return ds

best :: GenParser Char st String
best = 
    do manyTill anyChar newline -- TODO

winner :: GenParser Char st String
winner = 
    do string "done evolving!\n"
       string "best entity (GA): "
       ds <- many digit
       newline
       return ds

out :: GenParser Char st String
out = many anyChar

main = 
    do [fp] <- getArgs
       fc <- readFile fp
       print $ parse logFile "uk" fc

-- main = do print $ parse gen "(uk)" "bits 1010101001\nbits 1010101001\nasdfasdf\n"

-- parseLog input = parse logFile "(unknown)" input
