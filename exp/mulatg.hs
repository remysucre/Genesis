import System.Environment

main = do
    [a, b] <- getArgs
    print $ a++b
