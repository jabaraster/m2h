{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson
import Data.ByteString
import Data.Text
import GHC.Generics
import Network.HTTP.Conduit

main = undefined

data PostData = PostData { text::ByteString, mode::Maybe Mode, context::Maybe ByteString }
                         deriving (Show, Eq, Generic)
data Mode = Markdown | Gfm
            deriving (Show, Eq, Generic)

instance ToJSON PostData
instance ToJSON Mode

markDownToHtml :: Text -> IO Text
markDownToHtml = undefined
