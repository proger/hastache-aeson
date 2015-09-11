hastache-aeson
==============

[![Build Status](https://travis-ci.org/proger/hastache-aeson.svg?branch=master)](https://travis-ci.org/proger/hastache-aeson)

* Lets you pass [aeson](http://hackage.haskell.org/package/aeson) `Value` as `MuContext` to [hastache](http://hackage.haskell.org/package/hastache)
* Since [yaml](http://hackage.haskell.org/package/yaml) is API-compatible to `aeson`, you can also render `yaml` `Value`s.

Example
-------

```haskell
{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as LBS

import Control.Monad
import Data.Maybe (fromJust)

import Data.Yaml
import Text.Hastache
import Text.Hastache.Aeson (jsonValueContext)

event = BS.readFile "event.yaml"
template = BS.readFile "index.mustache"

render template value = hastacheStr defaultConfig template (jsonValueContext value)

main = do
    value <- liftM (fromJust . decode) event :: IO Value
    template' <- template
    render template' value >>= LBS.putStrLn
```


Contributors
------------

- Viktar Basharymau
- Vladimir Kirillov
