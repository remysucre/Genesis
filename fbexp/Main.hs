import Rewrite

main = do
    prog <- readFile "thunk.hs"
    putStrLn $ editBangs "thunk.hs" prog 31
