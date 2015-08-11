import Text.ParserCombinators.Parsec.Number
import Text.ParserCombinators.Parsec

-- A Log file contains 0 or more runs, each bracketed by start and end
-- 
logFile = 
    do result <- many run
       eof
       return result

run =
    do content <- between start end
       result  <- runContent content
       return result

start = string ">>>>>>>>>>>>>>FINISH OPTIMIZATION>>>>>>>>>>>>>>>\n"

end   = string ">>>>>>>>>>>>>>>START OPTIMIZATION>>>>>>>>>>>>>>>\n"

runContent =
    do p  <- pop
       g  <- maxg
       a  <- arch
       b  <- base
       gs <- many gen
       w  <- winner
       o  <- out
       return (p, g, a, b, gs, w, o) --TODO 

pop = 
    do n <- int
       s <- string " pop\n"
       return n
maxg = 
    do n <- int
       s <- string " gens\n"
       return n

arch = 
    do n <- int
       s <- string " arch\n"
       return n


base = 
    do s <- string "Basetime is: "
       f <- floating
       nl <- newline
       return f
gen = 
    do ss <- many strand
       b  <- best
       return (ss, b)
strand = 
    do string "bits "
       ds <- many digit
       newline
       return ds


best = 
    do manyTill anyChar newline -- TODO
winner = 
    do string "done evolving!\n"
       string "best entity (GA): "
       ds <- many digit
       newline
       return ds



out = many anyChar

main = do print $ parse logFile "uk" "2 arch\n"

-- main = do print $ parse gen "(uk)" "bits 1010101001\nbits 1010101001\nasdfasdf\n"

-- parseLog input = parse logFile "(unknown)" input











{-
-- Each line contains 1 or more cells, separated by a comma
line :: GenParser Char st [String]
line = 
    do result <- cells
       eol                       -- end of line
       return result
       
-- Build up a list of cells.  Try to parse the first cell, then figure out 
-- what ends the cell.
cells :: GenParser Char st [String]
cells = 
    do first <- cellContent
       next <- remainingCells
       return (first : next)

-- The cell either ends with a comma, indicating that 1 or more cells follow,
-- or it doesn't, indicating that we're at the end of the cells for this line
remainingCells :: GenParser Char st [String]
remainingCells =
    (char ',' >> cells)            -- Found comma?  More cells coming
    <|> (return [])                -- No comma?  Return [], no more cells

-- Each cell contains 0 or more characters, which must not be a comma or
-- EOL
cellContent :: GenParser Char st String
cellContent = 
    many (noneOf ",\n")
       

-- The end of line character is \n
eol :: GenParser Char st Char
eol = char '\n'
parseCSV :: String -> Either ParseError [[String]]
parseCSV input = parse csvFile "(unknown)" input
-}
