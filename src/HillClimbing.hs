{-# LANGUAGE BangPatterns #-}

module HillClimbing (hillClimb) where

import Data.Set as Set
import Data.List as List
import Types
import Rewrite
import Control.Monad

type Score = Double
epsilon::Score
epsilon = 0.1

hillClimb::BangVec->(BangVec->IO Score)->IO BangVec
hillClimb bangVec scoreFunc = hillClimbSub bangVec scoreFunc Set.empty


hillClimbSub::BangVec->(BangVec->IO Score)->Set BangVec->IO BangVec
hillClimbSub bangVec scoreFunc alreadySeen = 
  do
    scores_children <- liftScore $ List.map (\x -> (scoreFunc x, x)) $ List.filter hasNotBeenSeen children
    currentScore <- scoreFunc bangVec
    let (minScore, minChild) = List.minimumBy scoreCompare scores_children

    if minScore > (currentScore - epsilon) then
       hillClimbSub minChild scoreFunc (bangVec `Set.insert` alreadySeen)
    else
       return bangVec
  where
    hasNotBeenSeen bv = not $ Set.member bv alreadySeen
    scoreCompare (score1, _) (score2, _) = compare score1 score2
    children =  [flipIth i bangVec | i <- [0..length bangVec]]


liftScore::[(IO Score, BangVec)]->IO [(Score, BangVec)]
liftScore (ioscore_bv:ioscore_bvs) = 
  do 
    score <- fst ioscore_bv
    let bang_vec = snd ioscore_bv
    sub_call <- liftScore ioscore_bvs
    
    return $ (score, bang_vec):sub_call                           


flipIth::Int->BangVec->BangVec
flipIth i bangVec = flipIthSub i 0 bangVec
  where
    flipIthSub i cursor (b:bs)  = if cursor == i then
                                      (not b):bs  
                                    else
                                      b:(flipIthSub i (cursor+1) bs)

    filIth i cursor [] = error "i greater than length of list"


-- main = do
--   args <- getArgs
--   bangs <- readBangs $ args !! 1
