{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE CPP #-}

import Data.Aeson.Parser.Internal
import Data.Aeson.Types.Instances (fromJSON)
import Criterion

myDecode = decodeWith jsonEOF' fromJSON

main = do
  let res = myDecode "[1,2,3]" :: Maybe [Integer]
  print res
