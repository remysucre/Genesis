{-# LANGUAGE BangPatterns, OverloadedStrings, ExtendedDefaultRules #-}

import qualified Data.Text.Lazy as L
import Text.Html
import Data.BitVector (BV, bitVec)
import GA

linkToCss :: String
linkToCss = "http://www.eecs.tufts.edu/~dan/ids/style.css"

resultPageStyle :: Html
resultPageStyle = (thelink noHtml) ! [rel "stylesheet", thetype "text/css", href linkToCss]

programName :: FilePath -> Maybe String -> String
programName fp Nothing = fp
programName fp (Just name) = name

pageTitle :: String -> String
pageTitle name = "Autobahn: " ++ name ++ "'s results"

genResultPageHeader name = header $ titleTag +++ resultPageStyle
                              where
                              titleTag = thetitle $ toHtml $ pageTitle name

makeLink :: HTML a => a -> String -> Html
makeLink b ref = (anchor $ toHtml b) ! [href ref]

makeTableEntry :: HTML a => a -> Html
makeTableEntry a = td . strong $ toHtml a

makeTableRowLink :: (HTML a, HTML b) => (a,b) -> FilePath -> Html
makeTableRowLink (a,b) ref = tr $ makeTableEntry (makeLink a ref) +++ makeTableEntry b

makeTableRow :: (HTML a, HTML b) => (a,b) -> Html
makeTableRow (a,b) = tr $ makeTableEntry a +++ makeTableEntry b

makeTable :: (HTML a, HTML b) => [(a,b)] -> Html
makeTable as = table . concatHtml $ map makeTableRow as

tableHeader :: Html
tableHeader = tr $ (th $ toHtml "Chromosome") +++ (th $ toHtml "Performance")

genResultTableEntry :: (Int, Float) -> FilePath -> Html
genResultTableEntry (bv, score) fp = makeTableRowLink (show bv, show score) fp

genResultTable :: [(BV, Float)] -> FilePath -> Html
genResultTable chroms fp = (p $ toHtml $ "Top " ++ n ++ " chromosomes: Higher is better") +++ resultTable
                           where
                           n = show $ length chroms
                           resultTable = table $ tableEntries
                           tableEntries = tableHeader +++ tableData
                           tableData = concatHtml $ tableDataList
                           tableDataList = map (uncurry genResultTableEntry) (zip chroms' $ repeat fp)
                           chroms' = map (\(n, (bv, score)) -> (n, score)) $ zip [1..] chroms

genParamTable :: GAConfig -> Float -> Int -> String -> Html
genParamTable cfg diversity fitnessRuns progName = (p $ toHtml $ "Autobahn run for " ++ progName ++ " with the following configuration") +++ paramTable
                                          where
                                          paramTable = table $ diversityEntry +++ generationEntry +++
                                                       popSizeEntry +++ archiveEntry +++ mutateRateEntry
                                                       +++ mutateProbEntry +++ crossoverRateEntry +++
                                                       fitnessEntry
                                          diversityEntry = makeTableRow ("diversityRate", show diversity)
                                          generationEntry = makeTableRow ("numGenerations", show $ getMaxGenerations cfg)
                                          popSizeEntry = makeTableRow ("populationSize", show $ getPopSize cfg)
                                          archiveEntry = makeTableRow ("archiveSize", show $ getArchiveSize cfg)
                                          mutateRateEntry = makeTableRow ("mutateRate", show $ getMutationRate cfg)
                                          mutateProbEntry = makeTableRow ("mutateProb", show $ getMutationParam cfg)
                                          crossoverRateEntry = makeTableRow ("crossRate", show $ getCrossoverRate cfg)
                                          fitnessEntry = makeTableRow ("numFitnessRuns", show fitnessRuns)

genResultPage :: [(BV, Float)] -> FilePath -> Maybe String -> GAConfig -> Float -> Int -> String
genResultPage chroms fp name cfg diversity fitnessRuns = renderHtml $ headHtml +++ bodyHtml
                                                    where bodyHtml = body $ pageTitleHtml +++ (genParamTable cfg diversity fitnessRuns progName) +++ genResultTable chroms fp
                                                          pageTitleHtml = h1 $ toHtml $ pageTitle progName
                                                          headHtml = genResultPageHeader progName
                                                          progName = programName fp name

main :: IO ()
main = putStr $ genResultPage [(bitVec 4 3, 1.2)] "./Main.hs" (Just "tick") (GAConfig 1 1 1 1 1 1 1 False False) 0.2 1