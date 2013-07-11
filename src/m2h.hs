{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as BLC
import qualified Data.Text as T
import GHC.Generics
import Network.HTTP.Conduit
import Network.HTTP.Types.Method

main = getContents >>= markdownToHtml . T.pack >>= putStrLn . BLC.unpack

entryPoint :: String
entryPoint = "https://api.github.com/markdown"

data PostData = PostData { text::T.Text }
                         deriving (Show, Eq, Generic)

data PostData2 = PostData2 { text2::String }
                         deriving (Show, Eq, Generic)

instance ToJSON PostData where
  toJSON pd = object [ "text" .= (T.unpack $ text pd) ]

instance ToJSON PostData2 where
  toJSON pd = object [ "text" .= text2 pd ]

f :: PostData -> BL.ByteString
f pd = BLC.pack ( "{\"text\":\"" ++ (T.unpack $ text pd) ++ "\"}" )

g text = "{\"text\":\"" ++ (T.unpack text) ++ "\"}"

markdownToHtml :: T.Text -> IO BL.ByteString
markdownToHtml text = do
--       body <- return $ encode $ PostData text
       body <- return $ BLC.pack ( "{\"text\":\"" ++ (T.unpack text) ++ "\"}" )
       req  <- parseUrl entryPoint
               >>= \req -> return $ req { method = methodPost, requestBody = RequestBodyLBS body }
       res  <- withManager (\manager -> httpLbs req manager)
       return $ responseBody res
