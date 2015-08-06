module Main (main) where
b = 1

main = do
  let args = "aa"
  case args of
    [] -> error "blah"
    [x] -> putStrLn "one"
    x : xs -> putStrLn "many"
