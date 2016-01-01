{-# LANGUAGE BangPatterns #-}
module Main (main) where
me (a, b) = a
main = print $ me (1, undefined)