import Data.Bits.Bitwise
import Data.BitVector

main = do 
    let bv = fromBits [False, False,False,False,False,    True, False]
    putStrLn $ showBin bv
