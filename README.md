hastache-aeson
==============

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

BSD3 License
------------

```
Copyright (c) 2013 Vladimir Kirillov

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the author nor the names of his contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTORS ``AS IS'' AND ANY EXPRESS
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
```
