import Data.Bits

ans = filter (\x -> popCount x == 3) ([1..10] :: [Int])
