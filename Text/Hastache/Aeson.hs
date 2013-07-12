{-# LANGUAGE OverloadedStrings #-}
-- Module:      Text.Hastache.Aeson
-- Copyright:   Vladimir Kirillov (c) 2013
-- License:     BSD3
-- Maintainer:  Vladimir Kirillov <proger@hackndev.com>
-- Stability:   experimental
-- Portability: portable

module Text.Hastache.Aeson (
      jsonValueContext
    ) where

import qualified Data.ByteString.Char8 as BS
import qualified Data.Text as T

import Control.Monad
import Control.Applicative
import qualified Data.Foldable as Foldable

import qualified Data.Map as Map
import qualified Data.Vector as V
import qualified Data.HashMap.Strict as HM
import Data.Attoparsec.Number (Number(I, D))

import Data.Aeson.Types

import Text.Hastache 
import Text.Hastache.Context 

jsonValueContext :: Monad m => Value -> MuContext m
jsonValueContext v = buildMapContext $ valueMap v

valueMap v = buildMap "" Map.empty v

buildMap name m (Object obj) =
    Map.insert (encodeStr name)
      (MuList [buildMapContext $ HM.foldlWithKey' (foldObject "") Map.empty obj])
      (HM.foldlWithKey' (foldObject name) m obj)
buildMap name m value = Map.insert (encodeStr name) muValue m
    where
        muValue = case value of
                      Array arr -> MuList . V.toList $ fmap jsonValueContext arr
                      Number (D float) -> MuVariable float
                      Number (I int) -> MuVariable int
                      String s -> MuVariable s
                      Bool b -> MuBool b
                      Null -> MuNothing
                      t -> MuVariable $ show t

buildName name newName
    | length name > 0 = concat [name, ".", newName]
    | otherwise = newName

foldObject name m k v = buildMap (buildName name (T.unpack k)) m v

buildMapContext m a = return $ case Map.lookup a m of
    Nothing ->
        case a == BS.pack "." of
            True -> maybe MuNothing id $ Map.lookup BS.empty m
            _ -> MuNothing
    Just a -> a
