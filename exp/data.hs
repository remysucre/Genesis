module Thing where

data Lo = Lo {-# Unpack #-} !Int
        | Ha !Int
