import System.Process

main = do
    readProcess ("./" ++ "thunk" ++ "/dist/build/" ++ "thunk" ++ "/" ++ "thunk") [] ""
