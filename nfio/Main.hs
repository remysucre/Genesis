import Criterion.Main
import System.Process
import System.Exit
import Control.DeepSeq

instance NFData ExitCode
  where 
    rnf ExitSuccess = ()
    rnf (ExitFailure _) = ()

main = defaultMain [
    bench "fib" $ nfIO (system "./fibfix")
      ]
