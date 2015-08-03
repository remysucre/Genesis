main = do
  case args of
    !![] -> error "blah"
    [x] -> putStrLn "one"
    x : (!!xs) -> putStrLn "many"
