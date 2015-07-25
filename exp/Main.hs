import Criterion.Measurement
import Criterion.Main
import Criterion.Types (measCpuTime)
import System.Process

main = do
    (m, t) <- measure (whnfIO $ system "runhaskell mulatg.hs a b") 4
    print $ measCpuTime m
