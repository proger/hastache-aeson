{-# LANGUAGE OverloadedStrings #-}

module Main where

import Test.Tasty
import Test.Tasty.HUnit
import Text.Hastache
import Text.Hastache.Aeson
import Text.Hastache.Context

import Data.Maybe (fromJust)
import Data.Aeson

import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as LBS

import Data.Text as T
import Data.Text.Lazy as LT

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Integration Tests" [
  testCase "Nested JSON" $
    assertTemplate
      "Hello, John Doe!"
      "{ \"user\" : { \"first_name\": \"John\" , \"last_name\": \"Doe\" } }"
      "Hello, {{user.first_name}} {{user.last_name}}!"

  , testCase "Boolean" $
    assertTemplate
      "one-two"
      "{ \"t\" : true, \"f\": false }"
      "{{#t}}one{{/t}}-{{^f}}two{{/f}}"

  , testCase "List and numbers" $
    assertTemplate
      " 1  1.5  2 "
      "{ \"scores\" : [1, 1.5, 2] }"
      "{{#scores}} {{.}} {{/scores}}"
  ]

assertTemplate :: LT.Text -> LBS.ByteString -> T.Text -> Assertion
assertTemplate expectedResult json template =
  assertEqual "Unexpected rendering result" expectedResult =<< render json template

render json template =
  let value = fromJust $ decode json
  in hastacheStr defaultConfig template $ jsonValueContext value
