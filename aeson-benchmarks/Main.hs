{-# LANGUAGE BangPatterns, CPP, OverloadedStrings #-}



import Control.DeepSeq
import Control.Monad.IO.Class (liftIO)
import Data.Aeson.Types.Internal (IResult(..), JSONPath, Result(..), Value(..))
--import Data.Aeson.Types.Instances (fromJSON)
import Data.Attoparsec.ByteString.Char8 (Parser, char, endOfInput, scientific,
                                         skipSpace, string)
import Data.Bits ((.|.), shiftL)
import Data.ByteString.Internal (ByteString(..))
import Data.Char (chr)
import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8')
import Data.Text.Internal.Encoding.Utf8 (ord2, ord3, ord4)
import Data.Text.Internal.Unsafe.Char (ord)
import Data.Vector as Vector (Vector, empty, fromList, reverse)
import Data.Word (Word8)
import Foreign.ForeignPtr (withForeignPtr)
import Foreign.Ptr (Ptr, plusPtr)
import Foreign.Ptr (minusPtr)
import Foreign.Storable (poke)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Attoparsec.ByteString as A
import qualified Data.Attoparsec.Lazy as L
import qualified Data.Attoparsec.Zepto as Z
import qualified Data.ByteString as B
import qualified Data.ByteString.Internal as B
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Unsafe as B
import qualified Data.HashMap.Strict as H

import Control.Monad
import Control.Exception
-- import Criterion.Main
import System.Environment
import System.IO
import Data.Attoparsec.ByteString (parseWith)
import Data.Time.Clock


import Control.Applicative ((*>), (<$>), (<*), pure)


-- | Parse a top-level JSON value.
--
-- The conversion of a parsed value to a Haskell value is deferred
-- until the Haskell value is needed. This may improve performance if
-- only a subset of the results of conversions are needed, but at a
-- cost in thunk allocation.
--
-- This function is an alias for 'value'. In aeson 0.8 and earlier, it
-- parsed only object or array types, in conformance with the
-- now-obsolete RFC 4627.
json :: Parser Value
json = value

-- | Parse a top-level JSON value.
--
-- This is a strict version of 'json' which avoids building up thunks
-- during parsing; it performs all conversions immediately. Prefer
-- this version if most of the JSON data needs to be accessed.
--
-- This function is an alias for 'value''. In aeson 0.8 and earlier, it
-- parsed only object or array types, in conformance with the
-- now-obsolete RFC 4627.
json' :: Parser Value
json' = value'

object_ :: Parser Value
object_ = {-# SCC "object_" #-} Object <$> objectValues jstring value


object_' :: Parser Value
object_' = {-# SCC "object_'" #-} do
  vals <- objectValues jstring' value'
  return (Object vals)
 where
  jstring' = do
    s <- jstring
    return s

objectValues :: Parser Text -> Parser Value -> Parser (H.HashMap Text Value)
objectValues str val = do
  skipSpace
  w <- A.peekWord8'
  if w == 125
    then A.anyWord8 >> return H.empty
    else loop H.empty
 where
  loop m0 = do
    k <- str <* skipSpace <* char ':'
    v <- val <* skipSpace

    let !m = H.insert k v m0



    ch <- A.satisfy $ \w -> w == 44 || w == 125
    if ch == 44
      then skipSpace >> loop m
      else return m

array_ :: Parser Value
array_ = {-# SCC "array_" #-} Array <$> arrayValues value

array_' :: Parser Value
array_' = {-# SCC "array_'" #-} do

  !vals <- arrayValues value'



  return (Array vals)


arrayValues :: Parser Value -> Parser (Vector Value)
arrayValues val = do
  skipSpace
  w <- A.peekWord8'
  if w == 93
    then A.anyWord8 >> return Vector.empty
    else loop []
  where
    loop acc = do
      v <- val <* skipSpace
      ch <- A.satisfy $ \w -> w == 44 || w == 93
      if ch == 44
        then skipSpace >> loop (v:acc)
        else return (Vector.reverse (Vector.fromList (v:acc)))
{-# INLINE arrayValues #-}

-- | Parse any JSON value. You should usually 'json' in preference to
-- this function, as this function relaxes the object-or-array
-- requirement of RFC 4627.
--
-- In particular, be careful in using this function if you think your
-- code might interoperate with Javascript. A na&#xef;ve Javascript
-- library that parses JSON data using @eval@ is vulnerable to attack
-- unless the encoded data represents an object or an array. JSON
-- implementations in other languages conform to that same restriction
-- to preserve interoperability and security.
value :: Parser Value
value = do
  skipSpace
  w <- A.peekWord8'
  case w of
    34 -> A.anyWord8 *> (String <$> jstring_)
    123 -> A.anyWord8 *> object_
    91 -> A.anyWord8 *> array_
    102 -> string "false" *> pure (Bool False)
    116 -> string "true" *> pure (Bool True)
    110 -> string "null" *> pure Null
    _ | w >= 48 && w <= 57 || w == 45
                  -> Number <$> scientific
      | otherwise -> fail "not a valid json value"

-- | Strict version of 'value'. See also 'json''.


value' :: Parser Value
value' = do
  skipSpace
  w <- A.peekWord8'
  case w of
    34 -> do

                     !s <- A.anyWord8 *> jstring_



                     return (String s)
    123 -> A.anyWord8 *> object_'
    91 -> A.anyWord8 *> array_'
    102 -> string "false" *> pure (Bool False)
    116 -> string "true" *> pure (Bool True)
    110 -> string "null" *> pure Null
    _ | w >= 48 && w <= 57 || w == 45
                  -> do

                     !n <- scientific



                     return (Number n)
      | otherwise -> fail "not a valid json value"


-- | Parse a quoted JSON string.
jstring :: Parser Text
jstring = A.word8 34 *> jstring_

-- | Parse a string without a leading quote.
jstring_ :: Parser Text
{-# INLINE jstring_ #-}
jstring_ = {-# SCC "jstring_" #-} do
  (s, fin) <- A.runScanner startState go
  _ <- A.anyWord8
  s1 <- if isEscaped fin
        then case unescape s of
               Right r -> return r
               Left err -> fail err
        else return s
  case decodeUtf8' s1 of
    Right r -> return r
    Left err -> fail $ show err
 where
    isEscaped (S _ escaped) = escaped
    startState = S False False
    go (S a b) c
      | a = Just (S False b)
      | c == 34 = Nothing
      | otherwise = let a' = c == backslash
                    in Just (S a' (a' || b))
      where backslash = 92

data S = S Bool Bool


unescape :: ByteString -> Either String ByteString
unescape s = unsafePerformIO $ do
  let len = B.length s
  fp <- B.mallocByteString len
  -- We perform no bounds checking when writing to the destination
  -- string, as unescaping always makes it shorter than the source.
  withForeignPtr fp $ \ptr -> do
    ret <- Z.parseT (go ptr) s
    case ret of
      Left err -> return (Left err)
      Right p -> do
        let newlen = p `minusPtr` ptr
            slop = len - newlen
        Right <$> if slop >= 128 && slop >= len `quot` 4
                  then B.create newlen $ \np -> B.memcpy np ptr newlen
                  else return (PS fp 0 newlen)
 where
  go ptr = do
    h <- Z.takeWhile (/=92)
    let rest = do
          start <- Z.take 2




          let slash = B.unsafeHead start
              t = B.unsafeIndex start 1

              escape = case B.elemIndex t "\"\\/ntbrfu" of
                         Just i -> i
                         _ -> 255
          if slash /= 92 || escape == 255
            then fail "invalid JSON escape sequence"
            else
            if t /= 117 -- 'u'
              then copy h ptr >>= word8 (B.unsafeIndex mapping escape) >>= go
              else do
                   a <- hexQuad
                   if a < 0xd800 || a > 0xdfff
                     then copy h ptr >>= charUtf8 (chr a) >>= go
                     else do
                       b <- Z.string "\\u" *> hexQuad
                       if a <= 0xdbff && b >= 0xdc00 && b <= 0xdfff



                         then let c = ((a - 0xd800) `shiftL` 10) +

                                       (b - 0xdc00) + 0x10000
                              in copy h ptr >>= charUtf8 (chr c) >>= go
                         else fail "invalid UTF-16 surrogates"
    done <- Z.atEnd
    if done
      then copy h ptr
      else rest
  mapping = "\"\\/\n\t\b\r\f"

hexQuad :: Z.ZeptoT IO Int
hexQuad = do
  s <- Z.take 4
  let hex n | w >= 48 && w <= 57 = w - 48
            | w >= 97 && w <= 102 = w - 87
            | w >= 65 && w <= 70 = w - 55
            | otherwise = 255
        where w = fromIntegral $ B.unsafeIndex s n
      a = hex 0; b = hex 1; c = hex 2; d = hex 3
  if (a .|. b .|. c .|. d) /= 255
    then return $! d .|. (c `shiftL` 4) .|. (b `shiftL` 8) .|. (a `shiftL` 12)
    else fail "invalid hex escape"

decodeWith :: Parser Value -> (Value -> Result a) -> L.ByteString -> Maybe a
decodeWith p to s =
    case L.parse p s of
      L.Done _ v -> case to v of
                      Success a -> Just a
                      _ -> Nothing
      _ -> Nothing
{-# INLINE decodeWith #-}

decodeStrictWith :: Parser Value -> (Value -> Result a) -> B.ByteString
                 -> Maybe a
decodeStrictWith p to s =
    case either Error to (A.parseOnly p s) of
      Success a -> Just a
      _ -> Nothing
{-# INLINE decodeStrictWith #-}

eitherDecodeWith :: Parser Value -> (Value -> IResult a) -> L.ByteString
                 -> Either (JSONPath, String) a
eitherDecodeWith p to s =
    case L.parse p s of
      L.Done _ v -> case to v of
                          ISuccess a -> Right a
                          IError path msg -> Left (path, msg)
      L.Fail _ _ msg -> Left ([], msg)
{-# INLINE eitherDecodeWith #-}

eitherDecodeStrictWith :: Parser Value -> (Value -> IResult a) -> B.ByteString
                       -> Either (JSONPath, String) a
eitherDecodeStrictWith p to s =
    case either (IError []) to (A.parseOnly p s) of
      ISuccess a -> Right a
      IError path msg -> Left (path, msg)
{-# INLINE eitherDecodeStrictWith #-}

-- $lazy
--
-- The 'json' and 'value' parsers decouple identification from
-- conversion. Identification occurs immediately (so that an invalid
-- JSON document can be rejected as early as possible), but conversion
-- to a Haskell value is deferred until that value is needed.
--
-- This decoupling can be time-efficient if only a smallish subset of
-- elements in a JSON value need to be inspected, since the cost of
-- conversion is zero for uninspected elements. The trade off is an
-- increase in memory usage, due to allocation of thunks for values
-- that have not yet been converted.

-- $strict
--
-- The 'json'' and 'value'' parsers combine identification with
-- conversion. They consume more CPU cycles up front, but have a
-- smaller memory footprint.

-- | Parse a top-level JSON value followed by optional whitespace and
-- end-of-input. See also: 'json'.
jsonEOF :: Parser Value
jsonEOF = json <* skipSpace <* endOfInput

-- | Parse a top-level JSON value followed by optional whitespace and
-- end-of-input. See also: 'json''.
jsonEOF' :: Parser Value
jsonEOF' = json' <* skipSpace <* endOfInput

word8 :: Word8 -> Ptr Word8 -> Z.ZeptoT IO (Ptr Word8)
word8 w ptr = do
  liftIO $ poke ptr w
  return $! ptr `plusPtr` 1

copy :: ByteString -> Ptr Word8 -> Z.ZeptoT IO (Ptr Word8)
copy (PS fp off len) ptr =
  liftIO . withForeignPtr fp $ \src -> do
    B.memcpy ptr (src `plusPtr` off) len
    return $! ptr `plusPtr` len

charUtf8 :: Char -> Ptr Word8 -> Z.ZeptoT IO (Ptr Word8)
charUtf8 ch ptr
  | ch < '\x80' = liftIO $ do
                       poke ptr (fromIntegral (ord ch))
                       return $! ptr `plusPtr` 1
  | ch < '\x800' = liftIO $ do
                       let (a,b) = ord2 ch
                       poke ptr a
                       poke (ptr `plusPtr` 1) b
                       return $! ptr `plusPtr` 2
  | ch < '\xffff' = liftIO $ do
                       let (a,b,c) = ord3 ch
                       poke ptr a
                       poke (ptr `plusPtr` 1) b
                       poke (ptr `plusPtr` 2) c
                       return $! ptr `plusPtr` 3
  | otherwise = liftIO $ do
                       let (a,b,c,d) = ord4 ch
                       poke ptr a
                       poke (ptr `plusPtr` 1) b
                       poke (ptr `plusPtr` 2) c
                       poke (ptr `plusPtr` 3) d
                       return $! ptr `plusPtr` 4

-- ======================
-- ===== START HERE =====
-- ======================




main :: IO ()
main = do
  -- (bs:cnt:args) <- getArgs
  let count = 700
      blkSize = 65536
      args = ["./json-data/jp100.json"]
  forM_ args $ \arg -> bracket (openFile arg ReadMode) hClose $ \h -> do
    putStrLn $ arg ++ ":"
    start <- getCurrentTime
    let loop !good !bad
            | good+bad >= count = return (good, bad)
            | otherwise = do
          hSeek h AbsoluteSeek 0
          let refill = B.hGet h blkSize
          result <- parseWith refill json' =<< refill
          case result of
            -- A.Done _ r -> do evaluate $ rnf r
            A.Done _ _ -> loop (good+1) bad
            _ -> loop good (bad+1)
    (good, _) <- loop 0 0
    delta <- flip diffUTCTime start `fmap` getCurrentTime
    putStrLn $ "  " ++ show good ++ " good, " ++ show delta
    let rate = fromIntegral count / realToFrac delta :: Double
    putStrLn $ "  " ++ show (round rate :: Int) ++ " per second"
