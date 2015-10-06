import Criterion.Main
import System.Process
import Profiling

projDir = "monad"

runProj = "./" ++ projDir ++ "/dist/build/" ++ projDir ++ "/" ++ projDir ++ "> /dev/null"

main = defaultMain [
         bgroup "thing" [ bench "haha" $ system runProj 
                      ]]
