main = do 
  fc <- readFile "bads.log"
  let ws = unwords . lines $ fc
  writeFile "temp" ws
