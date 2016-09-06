{-# LANGUAGE BangPatterns, OverloadedStrings, ExtendedDefaultRules #-}

import qualified Data.Text.Lazy as L
import Text.Html
import Data.BitVector (BV)

makeLink :: HTML a => a -> Html
makeLink b = (anchor $ toHtml b) ! [href "./results/Main.hs"]

makeTableEntry :: HTML a => a -> Html
makeTableEntry a = td $ toHtml a

makeTableRow :: (HTML a, HTML b) => (a,b) -> Html
makeTableRow (a,b) = tr $ makeTableEntry (makeLink a) +++ makeTableEntry b

makeTable :: (HTML a, HTML b) => [(a,b)] -> Html
makeTable as = table . concatHtml $ map makeTableRow as

tableHeader :: Html
tableHeader = (th $ toHtml "Chromosome") +++ (th $ toHtml "Performance")

g :: (BV, Float) -> FilePath -> Html
g (bv, score) fp = noHtml

f :: [(BV, Float)] -> FilePath -> Html
f chroms fp = concatHtml $ map g chroms

main :: IO ()
main = putStr $ renderHtml . body . makeTable $ [("a", "b"), ("c", "d")]