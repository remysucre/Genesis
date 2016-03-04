import System.Environment

main = do 
  [fn] <- getArgs
  fc <- readFile fn
  putStrLn $ oneline fc

oneline ps = concat $ map (\s -> if s == "" then "\n" else s) ls
  where ls = lines ps
