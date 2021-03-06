{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Boris.Http.Resource.Dashboard (
    dashboard
  ) where


import           Airship (Resource (..), defaultResource)

import           Boris.Http.Airship
import qualified Boris.Http.Html.Template as T
import           Boris.Queue (BuildQueue (..))
import qualified Boris.Queue as Q

import           Mismi (runAWS, renderError)
import           Mismi.Amazonka (Env)

import qualified Network.HTTP.Types as HTTP

import           P

import           System.IO (IO)


dashboard :: Env -> BuildQueue -> Resource IO
dashboard env q =
  defaultResource {
      allowedMethods = pure [HTTP.methodGet]

    , contentTypesProvided = return [
          (,) "text/html" $ do
             s <- webT renderError . runAWS env $ Q.size q
             T.render $ T.dashboard s
        ]
    }
