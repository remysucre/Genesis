{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson.Internal
import Data.Aeson (fromJSON)

myDecode = decodeWith jsonEOF fromJSON

main = do
  print $ myDecode "[1,2,3]" :: Maybe [Integer]
