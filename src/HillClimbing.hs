import Data.Set as Set
import Data.List as List

type BangVec = [Bool]
type Score = Float 
epsilon = 0.1

hillClimb::BangVec->(BangVec->Score)->BangVec
hillClimb bangVec scoreFunc = hillClimbSub bangVec scoreFunc Set.empty


hillClimbSub::BangVec->(BangVec->Score)->Set BangVec->BangVec
hillClimbSub bangVec scoreFunc alreadySeen = if minScore > currentScore - epsilon then
                                               hillClimbSub minChild scoreFunc (bangVec `Set.insert` alreadySeen)
                                             else
                                               bangVec
  where
    currentScore = scoreFunc bangVec
    scores_children = List.map (\x -> (scoreFunc x, x)) $ List.filter hasNotBeenSeen  children
    hasNotBeenSeen bv = not $ Set.member bv alreadySeen
    (minScore, minChild) = List.minimumBy scoreCompare scores_children
    scoreCompare (score1, _) (score2, _) = compare score1 score2
    children::[BangVec]
    children =  [flipIth i bangVec | i <- [0..length bangVec]]



flipIth::Int->BangVec->BangVec
flipIth i bangVec = flipIthSub i 0 bangVec
  where
    flipIthSub i cursor (b:bs)  = if cursor == i then
                                      (not b):bs  
                                    else
                                      b:(flipIthSub i (cursor+1) bs)

    filIth i cursor [] = error "i greater than length of list"


main = do
   print $ flipIth 2 [False, True, False] 


