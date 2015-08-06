import Rewrite

main = do
    prog <- readFile "thunk.hs"
    flipBang "thunk.hs" prog 0
