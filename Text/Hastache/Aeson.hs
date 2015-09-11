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
import Data.Maybe (fromMaybe)

import qualified Data.Map as Map
import qualified Data.Vector as V
import qualified Data.HashMap.Strict as HM
import Data.Scientific

import Data.Aeson.Types

import Text.Hastache
import Text.Hastache.Context

jsonValueContext :: Monad m => Value -> MuContext m
jsonValueContext = buildMapContext . valueMap

valueMap :: Monad m => Value -> Map.Map T.Text (MuType m)
valueMap v = buildMap "" Map.empty v

buildMap
  :: Monad m =>
     String
     -> Map.Map T.Text (MuType m)
     -> Value
     -> Map.Map T.Text (MuType m)
buildMap name m (Object obj) =
    Map.insert (encodeStr name)
      (MuList [buildMapContext $ HM.foldlWithKey' (foldObject "") Map.empty obj])
      (HM.foldlWithKey' (foldObject name) m obj)
buildMap name m value = Map.insert (encodeStr name) muValue m
    where
        muValue = case value of
                      Array arr -> MuList . V.toList $ fmap jsonValueContext arr
                      Number n -> case floatingOrInteger n of
                                    Left d  -> MuVariable (d :: Double)
                                    Right i -> MuVariable (i :: Integer)
                      String s -> MuVariable s
                      Bool b -> MuBool b
                      Null -> MuNothing
                      t -> MuVariable $ show t

buildName :: String -> String -> String
buildName   "" newName = newName
buildName name newName = name ++ "." ++ newName

foldObject ::
  Monad m =>
     String
     -> Map.Map T.Text (MuType m)
     -> T.Text
     -> Value
     -> Map.Map T.Text (MuType m)
foldObject name m k v = buildMap (buildName name (T.unpack k)) m v

buildMapContext :: Monad m => Map.Map T.Text (MuType m) -> MuContext m
buildMapContext m a = return $ fromMaybe
    (if a == T.pack "." then maybe MuNothing id $ Map.lookup T.empty m else MuNothing)
    (Map.lookup a m)
