{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE CPP #-}

import Data.Aeson.Internal
import Data.Aeson.Types.Instances (fromJSON)

myDecode = decodeWith jsonEOF fromJSON

main = do
  print $ myDecode "[1,2,3]" :: Maybe [Integer]
