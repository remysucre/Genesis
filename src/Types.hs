{-# LANGUAGE TypeSynonymInstances #-}

module Types
where
import Language.Haskell.Exts
import Data.BitVector

type Time = Double
type Measurement = Time
type Gene = BitVector
instance Read Gene
type Score = Double
